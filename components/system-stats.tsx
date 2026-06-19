"use client"

import { useCallback, useEffect, useMemo, useState } from "react"

interface GpuProcess {
  pid: number
  name: string
  exe?: string
  ramMb: number
  gpuCompute: boolean
}

type ComfyUiState = {
  portListening?: boolean
  processDetected?: boolean
  pids?: number[]
  state?: "stopped" | "idle" | "generating" | "unknown"
  queueRunning?: number | null
  queuePending?: number | null
  queueError?: boolean
}

type LmStudioState = {
  running?: boolean
  loadedModels?: string[]
  vramNote?: string
}

interface SystemStatsData {
  used: string
  total: string
  usedMb: number
  totalMb: number
  percent: number
  level: "healthy" | "warn" | "high" | "critical" | "unknown"
  vramHealthy: boolean
  lmStudioRunning: boolean
  comfyRunning: boolean
  comfyui?: ComfyUiState
  lmStudio?: LmStudioState
  processes: GpuProcess[]
  recommendation: string
  services: Record<string, boolean>
  allNominal: boolean
  status: string
}

type HistoryPoint = { t: number; percent: number }

const SERVICE_LABELS: Record<string, string> = {
  devApp: "Dev App (3000)",
  taskBoard: "TaskBoardAI (3001)",
  workspace: "Workspace (3005)",
  dashboard: "Dashboard (9119)",
  comfyUI: "ComfyUI (8188)",
  postiz: "Postiz (4007)",
}

const COMFY_STATE_TOOLTIPS: Record<string, string> = {
  stopped:
    "Server not running on port 8188. Safe to start when VRAM allows.",
  idle:
    "Server running with models loaded, no active generation. Click Stop to free VRAM.",
  generating:
    "Active workflow in queue. Do not stop until complete.",
  unknown:
    "Port up but queue API unavailable — may be booting or stuck. Try Restart.",
}

function levelColor(level: SystemStatsData["level"]): string {
  if (level === "critical" || level === "high") return "text-red-400"
  if (level === "warn") return "text-[#F5B841]"
  return "text-green-400"
}

function levelLabel(level: SystemStatsData["level"]): string {
  if (level === "critical") return "Critical"
  if (level === "high") return "High"
  if (level === "warn") return "Warn"
  return "OK"
}

function vramGbColor(percent: number): string {
  if (percent >= 80) return "text-red-400"
  if (percent >= 65) return "text-[#F5B841]"
  return "text-green-400"
}

function vramBadgeIcon(level: SystemStatsData["level"]): string {
  if (level === "critical" || level === "high") return "❌"
  if (level === "warn") return "⚠"
  return "✓"
}

function vramBadgeLabel(level: SystemStatsData["level"]): string {
  if (level === "critical" || level === "high") return "VRAM Hot"
  if (level === "warn") return "VRAM Warn"
  return "VRAM OK"
}

function comfyStateColor(state: string): string {
  if (state === "generating") return "text-green-400"
  if (state === "stopped") return "text-muted-foreground"
  // idle and unknown — gold/amber, not red (avoid panic)
  return "text-[#F5B841]"
}

function resolveComfyState(stats: SystemStatsData): ComfyUiState {
  return (
    stats.comfyui ?? {
      state: stats.comfyRunning ? "idle" : "stopped",
      portListening: stats.services?.comfyUI ?? false,
      queueRunning: null,
      queuePending: null,
      queueError: false,
    }
  )
}

export function SystemStats() {
  const [stats, setStats] = useState<SystemStatsData | null>(null)
  const [isHovered, setIsHovered] = useState(false)
  const [isLocalhost, setIsLocalhost] = useState(false)
  const [history, setHistory] = useState<HistoryPoint[]>([])
  const [cleaning, setCleaning] = useState(false)
  const [comfyBusy, setComfyBusy] = useState(false)
  const [cleanMsg, setCleanMsg] = useState<string | null>(null)
  const [comfyMsg, setComfyMsg] = useState<string | null>(null)

  useEffect(() => {
    if (typeof window !== "undefined") {
      const isLocal =
        window.location.hostname === "localhost" ||
        window.location.hostname === "127.0.0.1"
      setIsLocalhost(isLocal)
    }
  }, [])

  const fetchStats = useCallback(async () => {
    try {
      const res = await fetch("/api/system/vram")
      if (!res.ok) return
      const data = (await res.json()) as SystemStatsData
      setStats(data)
      setHistory((prev) => {
        const next = [...prev, { t: Date.now(), percent: data.percent }]
        return next.slice(-20)
      })
    } catch (err) {
      console.error("Failed to fetch system stats", err)
    }
  }, [])

  useEffect(() => {
    if (!isLocalhost) return
    fetchStats()
    const interval = setInterval(fetchStats, 15000)
    return () => clearInterval(interval)
  }, [isLocalhost, fetchStats])

  const runComfyAction = async (
    action: "start" | "stop" | "restart",
    body: Record<string, boolean> = {},
  ) => {
    if (comfyBusy || !stats) return
    const comfy = resolveComfyState(stats)

    if (action === "stop" || action === "restart") {
      if (comfy.state === "generating") {
        if (
          !window.confirm(
            "ComfyUI is generating. Stop anyway? This may corrupt the current job.",
          )
        ) {
          return
        }
      }
    }

    setComfyBusy(true)
    setComfyMsg(null)
    try {
      const res = await fetch(`/api/system/comfyui/${action}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      })
      const data = await res.json()
      setComfyMsg(
        res.ok
          ? `${action} finished. Refreshing...`
          : (data.message as string) ?? `${action} failed`,
      )
      await fetchStats()
    } catch {
      setComfyMsg(`${action} request failed.`)
    } finally {
      setComfyBusy(false)
    }
  }

  const runEmergencyCleanup = async () => {
    if (cleaning || !stats) return

    const pct = stats.percent
    let message: string

    if (pct < 65) {
      message =
        `VRAM is ${pct}% (healthy).\n\nEmergency cleanup is your GPU reset switch — it stops LM Studio and ComfyUI.\n\nOnly use if VRAM looks wrong or after a crash.\n\nDo NOT use during active generation.\n\nContinue anyway?`
    } else if (pct < 80) {
      message =
        `VRAM is ${pct}% (elevated).\n\nOK before heavy work (e.g. Flux) if nothing is generating.\n\nDo NOT use while a model is processing or mid-task.\n\nRun cleanup now?`
    } else {
      message =
        `VRAM is ${pct}% (high).\n\nThis reset switch will stop LM Studio and ComfyUI to free GPU memory.\n\nDo NOT run if a model is actively generating.\n\nContinue?`
    }

    if (!window.confirm(message)) return

    setCleaning(true)
    setCleanMsg(null)
    try {
      const res = await fetch("/api/system/emergency-vram-cleanup", {
        method: "POST",
      })
      const data = await res.json()
      setCleanMsg(
        res.ok ? "VRAM cleanup finished. Refreshing..." : data.message ?? "Cleanup failed",
      )
      await fetchStats()
    } catch {
      setCleanMsg("Cleanup request failed.")
    } finally {
      setCleaning(false)
    }
  }

  const sparkline = useMemo(() => {
    if (history.length < 2) return ""
    const w = 120
    const h = 24
    const max = Math.max(...history.map((p) => p.percent), 100)
    const min = Math.min(...history.map((p) => p.percent), 0)
    const range = Math.max(max - min, 1)
    const pts = history
      .map((p, i) => {
        const x = (i / (history.length - 1)) * w
        const y = h - ((p.percent - min) / range) * h
        return `${x},${y}`
      })
      .join(" ")
    return pts
  }, [history])

  if (!isLocalhost || !stats) return null

  const aiProcesses = stats.processes.filter(
    (p) => p.gpuCompute || p.name === "python" || p.name === "LM Studio",
  )

  const comfy = resolveComfyState(stats)
  const comfyState = comfy.state ?? "stopped"
  const queueRunning = comfy.queueRunning ?? "?"
  const queuePending = comfy.queuePending ?? "?"
  const lmModels = stats.lmStudio?.loadedModels?.join(", ") || "none"

  const comfyChannelActive = comfyState !== "stopped"

  return (
    <div
      className="fixed bottom-4 left-4 z-50 transition-all duration-300 ease-out"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <div className="flex flex-col gap-2 rounded-xl border border-white/10 bg-background/80 p-3 shadow-xl backdrop-blur-md max-w-sm transition-all duration-300">
        <div className="flex items-center gap-3 text-xs font-semibold select-none flex-wrap">
          <span
            className={`flex items-center gap-1.5 font-medium tabular-nums ${vramGbColor(stats.percent)}`}
          >
            <span className="text-[14px]">🎮</span>
            <span>
              {stats.used} / {stats.total} GB
            </span>
          </span>

          <span className={`text-[10px] uppercase ${levelColor(stats.level)}`}>
            {levelLabel(stats.level)} ({stats.percent}%)
          </span>

          <span className="h-3 w-px bg-white/10" />

          <span
            className={`flex items-center gap-1.5 font-medium ${levelColor(stats.level)}`}
          >
            <span className="text-[12px]">{vramBadgeIcon(stats.level)}</span>
            <span>{vramBadgeLabel(stats.level)}</span>
          </span>
        </div>

        {isHovered && (
          <div className="mt-1 flex flex-col gap-2 text-[10px] text-muted-foreground animate-in fade-in slide-in-from-bottom-1 duration-200">
            {sparkline && (
              <div>
                <div className="font-bold uppercase tracking-wider text-foreground mb-1 text-[9px] text-[#F5B841]">
                  VRAM trend (last {history.length} samples)
                </div>
                <svg width="120" height="24" className="text-[#F5B841]">
                  <polyline
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                    points={sparkline}
                  />
                </svg>
              </div>
            )}

            <div>
              <div className="font-bold uppercase tracking-wider text-foreground mb-1 text-[9px] text-[#F5B841]">
                AI processes (RAM — not VRAM)
              </div>
              {aiProcesses.length === 0 ? (
                <p className="text-[9px]">No LM Studio / ComfyUI processes detected.</p>
              ) : (
                aiProcesses.map((p) => (
                  <div key={p.pid} className="flex justify-between gap-2 py-0.5">
                    <span className="truncate">
                      {p.name} #{p.pid}
                      {p.gpuCompute ? " [GPU]" : ""}
                    </span>
                    <span className="tabular-nums shrink-0">{p.ramMb} MB</span>
                  </div>
                ))
              )}
              <p className="mt-1 text-[9px] italic opacity-80">
                LM Studio: {stats.lmStudioRunning ? "running" : "off"}
                {stats.lmStudioRunning && lmModels !== "none" ? ` (${lmModels})` : ""}
              </p>
              <p className="text-[9px] italic opacity-80">
                ComfyUI:{" "}
                <span
                  className={`font-semibold ${comfyStateColor(comfyState)}`}
                  title={COMFY_STATE_TOOLTIPS[comfyState] ?? comfyState}
                >
                  {comfyState}
                </span>
                {comfyState !== "stopped" && (
                  <span className="opacity-90">
                    {" "}
                    (running: {queueRunning}, pending: {queuePending})
                  </span>
                )}
                {comfy.queueError && (
                  <span className="text-[#F5B841]"> — queue unavailable (booting?)</span>
                )}
              </p>
              {comfy.portListening && !comfy.processDetected && (
                <p className="text-[9px] text-[#F5B841]/90">
                  Port 8188 up — ComfyUI likely running (WDDM path blind spot).
                </p>
              )}
            </div>

            <div className="flex flex-wrap gap-1">
              <button
                type="button"
                onClick={() => runComfyAction("start", { noVramCheck: stats.percent >= 65 })}
                disabled={
                  comfyBusy ||
                  (comfyState !== "stopped" && comfyState !== "unknown")
                }
                className="rounded-md border border-green-500/40 bg-green-500/10 px-2 py-1 text-[10px] font-semibold text-green-300 hover:bg-green-500/20 disabled:opacity-40 disabled:cursor-not-allowed"
              >
                {comfyBusy ? "..." : "Start ComfyUI"}
              </button>
              <button
                type="button"
                onClick={() => runComfyAction("stop")}
                disabled={comfyBusy || comfyState === "stopped"}
                className="rounded-md border border-[#F5B841]/40 bg-[#F5B841]/10 px-2 py-1 text-[10px] font-semibold text-[#F5B841] hover:bg-[#F5B841]/20 disabled:opacity-40 disabled:cursor-not-allowed"
              >
                Stop ComfyUI
              </button>
              <button
                type="button"
                onClick={() => runComfyAction("restart", { noVramCheck: true })}
                disabled={comfyBusy || comfyState === "stopped"}
                title="Stop, wait 2s, start — useful when stuck or unknown"
                className="rounded-md border border-white/20 bg-white/5 px-2 py-1 text-[10px] font-semibold text-foreground/90 hover:bg-white/10 disabled:opacity-40 disabled:cursor-not-allowed"
              >
                Restart
              </button>
            </div>
            {comfyMsg && <p className="text-[9px] text-green-400">{comfyMsg}</p>}

            <div>
              <div className="font-bold uppercase tracking-wider text-foreground mb-1 text-[9px] text-[#F5B841]">
                Workstation channels
              </div>
              {Object.entries(stats.services).map(([key, active]) => {
                const isComfy = key === "comfyUI"
                const dotOn = isComfy ? comfyChannelActive : active
                return (
                  <div key={key} className="flex items-center justify-between gap-4">
                    <span className="font-medium">
                      {SERVICE_LABELS[key] || key}
                      {isComfy && comfyState !== "stopped" ? ` · ${comfyState}` : ""}
                    </span>
                    <span
                      className={`flex h-1.5 w-1.5 rounded-full ${dotOn ? "bg-green-400" : "bg-red-400"}`}
                    />
                  </div>
                )
              })}
            </div>

            {stats.recommendation && (
              <p className="text-[9px] border-t border-white/5 pt-1 text-foreground/90">
                {stats.recommendation}
              </p>
            )}

            <p className="text-[9px] text-muted-foreground/90 leading-relaxed">
              Stop ComfyUI frees image VRAM only. Emergency cleanup stops LM Studio too.
            </p>

            <button
              type="button"
              onClick={runEmergencyCleanup}
              disabled={cleaning || stats.percent < 65}
              title={
                stats.percent < 65
                  ? "VRAM is healthy — use vram-check.ps1 instead"
                  : "Stops LM Studio and ComfyUI to free GPU memory"
              }
              className="mt-1 rounded-md border border-red-500/40 bg-red-500/10 px-2 py-1 text-[10px] font-semibold text-red-300 hover:bg-red-500/20 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              {cleaning ? "Cleaning VRAM..." : "Emergency VRAM cleanup"}
            </button>
            {stats.percent < 65 && (
              <p className="text-[9px] text-green-400/90">
                VRAM healthy — button disabled. Use after a crash via script if needed.
              </p>
            )}
            {cleanMsg && <p className="text-[9px] text-green-400">{cleanMsg}</p>}
          </div>
        )}
      </div>
    </div>
  )
}
