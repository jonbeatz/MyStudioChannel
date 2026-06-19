# vram-diagnostics.ps1
# Returns JSON snapshot for /api/system/vram (stdout only)

$ErrorActionPreference = "SilentlyContinue"

$modulePath = Join-Path $PSScriptRoot 'lib\comfyui-state.psm1'
Import-Module $modulePath -Force

function Get-VramLevel {
    param([double]$Percent)
    if ($Percent -ge 90) { return "critical" }
    if ($Percent -ge 80) { return "high" }
    if ($Percent -ge 65) { return "warn" }
    return "healthy"
}

$usedRaw = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()
$totalRaw = (nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits).Trim()
$freeRaw = (nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits).Trim()

$usedMb = if ($usedRaw) { [double]$usedRaw } else { 0 }
$totalMb = if ($totalRaw) { [double]$totalRaw } else { 16311 }
$freeMb = if ($freeRaw) { [double]$freeRaw } else { ($totalMb - $usedMb) }
$percent = if ($totalMb -gt 0) { [math]::Round(($usedMb / $totalMb) * 100, 1) } else { 0 }
$level = Get-VramLevel -Percent $percent

$comfyState = Get-ComfyUiState

# WDDM often reports N/A per-process VRAM; list compute + known AI processes
$pmon = & nvidia-smi pmon -c 1 2>$null
$computePids = @()
if ($pmon) {
    foreach ($line in $pmon) {
        if ($line -match '^\s*\d+\s+(\d+)\s+\S+\s+.*\s+(python\.exe|LM Studio\.exe)\s*$') {
            $computePids += [int]$Matches[1]
        }
        if ($line -match '^\s*\d+\s+(\d+)\s+C\s+') {
            $procPid = [int]$Matches[1]
            $proc = Get-Process -Id $procPid -ErrorAction SilentlyContinue
            if ($proc -and ($proc.ProcessName -match 'python|LM Studio')) {
                if ($computePids -notcontains $procPid) { $computePids += $procPid }
            }
        }
    }
}

$processes = @()
foreach ($name in @('python', 'pythonw', 'LM Studio')) {
    Get-Process -Name $name -ErrorAction SilentlyContinue | ForEach-Object {
        $isCompute = $computePids -contains $_.Id
        $processes += [ordered]@{
            pid = $_.Id
            name = $_.ProcessName
            exe = $_.Path
            ramMb = [math]::Round($_.WorkingSet64 / 1MB, 1)
            gpuCompute = $isCompute
        }
    }
}

$lmStudioRunning = $comfyState.lmStudio.running
$comfyRunning = $comfyState.comfyui.state -ne 'stopped'

$recommendation = switch ($level) {
    'critical' { 'Stop LM Studio and ComfyUI, then run vram-cleanup.ps1 before starting image or LLM workloads.' }
    'high'     { 'Unload LM Studio model or stop ComfyUI server to free VRAM before heavy generation.' }
    'warn'     { 'VRAM elevated. Avoid loading a second large model until usage drops below 65%.' }
    default    { 'VRAM healthy for ComfyUI or LM Studio (one large workload at a time).' }
}

if ($comfyState.comfyui.state -eq 'idle' -and $level -in @('warn', 'high', 'critical')) {
    $recommendation = 'ComfyUI idle but holding VRAM. Run npm run msc:comfy:stop to free GPU memory.'
}

$out = [ordered]@{
    usedMb = $usedMb
    totalMb = $totalMb
    freeMb = $freeMb
    used = [math]::Round($usedMb / 1024, 1).ToString('0.0')
    total = [math]::Round($totalMb / 1024, 1).ToString('0.0')
    percent = [math]::Round($percent)
    level = $level
    lmStudioRunning = $lmStudioRunning
    comfyRunning = $comfyRunning
    comfyui = $comfyState.comfyui
    lmStudio = $comfyState.lmStudio
    processes = $processes
    recommendation = $recommendation
    wddmNote = 'Windows WDDM may hide per-process VRAM in nvidia-smi; total used MiB is authoritative. Process list shows CPU RAM not GPU VRAM.'
    status = 'success'
}

$out | ConvertTo-Json -Depth 6 -Compress
