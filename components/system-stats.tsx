"use client"

import { useEffect, useState } from "react"

interface SystemStatsData {
  used: string
  total: string
  percent: number
  services: Record<string, boolean>
  allNominal: boolean
  status: string
}

export function SystemStats() {
  const [stats, setStats] = useState<SystemStatsData | null>(null)
  const [isHovered, setIsHovered] = useState(false)
  const [isLocalhost, setIsLocalhost] = useState(false)

  useEffect(() => {
    // Only mount on local development/localhost
    if (typeof window !== "undefined") {
      const isLocal =
        window.location.hostname === "localhost" ||
        window.location.hostname === "127.0.0.1"
      setIsLocalhost(isLocal)
    }
  }, [])

  useEffect(() => {
    if (!isLocalhost) return

    const fetchStats = async () => {
      try {
        const res = await fetch("/api/system/vram")
        if (res.ok) {
          const data = await res.json()
          setStats(data)
        }
      } catch (err) {
        console.error("Failed to fetch system stats", err)
      }
    }

    fetchStats()
    const interval = setInterval(fetchStats, 15000) // Poll every 15 seconds
    return () => clearInterval(interval)
  }, [isLocalhost])

  if (!isLocalhost || !stats) return null

  // Format service name keys for humans
  const serviceLabels: Record<string, string> = {
    devApp: "Dev App (3000)",
    taskBoard: "TaskBoardAI (3001)",
    workspace: "Workspace (3005)",
    dashboard: "Dashboard (9119)",
    comfyUI: "ComfyUI (8188)",
    postiz: "Postiz (4007)",
  }

  const vramAlert = stats.percent > 65

  return (
    <div
      className="fixed bottom-4 left-4 z-50 transition-all duration-300 ease-out"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <div className="flex flex-col gap-2 rounded-xl border border-white/10 bg-background/80 p-3 shadow-xl backdrop-blur-md max-w-xs transition-all duration-300">
        {/* Core Status Summary */}
        <div className="flex items-center gap-3 text-xs font-semibold select-none">
          {/* VRAM summary */}
          <span className={`flex items-center gap-1.5 font-medium tabular-nums ${vramAlert ? 'text-[#F5B841]' : 'text-foreground'}`}>
            <span className="text-[14px]">🎮</span>
            <span>{stats.used} GB</span>
          </span>

          <span className="h-3 w-px bg-white/10" />

          {/* Sync indicator */}
          <span className="flex items-center gap-1.5 text-muted-foreground font-medium">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
            </span>
            <span>Synced</span>
          </span>

          <span className="h-3 w-px bg-white/10" />

          {/* System Nominal Indicator */}
          <span className="flex items-center gap-1.5 font-medium">
            <span className="text-[12px]">{stats.allNominal ? "⚡" : "❌"}</span>
            <span className={stats.allNominal ? "text-green-400" : "text-red-400"}>
              {stats.allNominal ? "Nominal" : "Degraded"}
            </span>
          </span>
        </div>

        {/* Expanded detail popover on Hover */}
        {isHovered && (
          <div className="mt-2 border-t border-white/5 pt-2 flex flex-col gap-1.5 text-[10px] text-muted-foreground animate-in fade-in slide-in-from-bottom-1 duration-200">
            <div className="font-bold uppercase tracking-wider text-foreground mb-1 text-[9px] text-[#F5B841]">
              Workstation Channels
            </div>
            {Object.entries(stats.services).map(([key, active]) => (
              <div key={key} className="flex items-center justify-between gap-4">
                <span className="font-medium">{serviceLabels[key] || key}</span>
                <span className={`flex h-1.5 w-1.5 rounded-full ${active ? 'bg-green-400' : 'bg-red-400'}`} />
              </div>
            ))}
            <div className="mt-1.5 text-[9px] border-t border-white/5 pt-1 flex justify-between select-none">
              <span>VRAM Used:</span>
              <span className="font-semibold text-foreground">{stats.percent}%</span>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
