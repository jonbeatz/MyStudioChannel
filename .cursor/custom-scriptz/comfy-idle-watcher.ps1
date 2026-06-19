# comfy-idle-watcher.ps1 — opt-in idle suggestion (never auto-kills)
param(
    [switch]$Daemon,
    [int]$IdleMinutes = 15
)

$ErrorActionPreference = 'SilentlyContinue'
$modulePath = Join-Path $PSScriptRoot 'lib\comfyui-state.psm1'
Import-Module $modulePath -Force

$idleLimitSeconds = $IdleMinutes * 60
$idleSince = $null
$notified = $false

function Test-ComfyIdle {
    $state = Get-ComfyUiState
    if ($state.comfyui.state -eq 'stopped') {
        return @{ idle = $false; state = 'stopped' }
    }
    if ($state.comfyui.state -eq 'generating') {
        return @{ idle = $false; state = 'generating' }
    }
    if ($state.comfyui.state -in @('idle', 'unknown')) {
        $running = if ($null -ne $state.comfyui.queueRunning) { $state.comfyui.queueRunning } else { 0 }
        $pending = if ($null -ne $state.comfyui.queuePending) { $state.comfyui.queuePending } else { 0 }
        if ($running -eq 0 -and $pending -eq 0) {
            return @{ idle = $true; state = $state.comfyui.state }
        }
    }
    return @{ idle = $false; state = $state.comfyui.state }
}

function Send-IdleNotice {
    Write-Host "[ComfyUI Idle Watcher] ComfyUI idle ${IdleMinutes}+ min — consider: npm run msc:comfy:stop" -ForegroundColor Yellow
    Write-ComfyUiLog -Action 'IDLE_NOTICE' -Detail "${IdleMinutes}min idle"
}

if (-not $Daemon) {
    $check = Test-ComfyIdle
    Write-Host "[ComfyUI Idle Watcher] state=$($check.state) idle=$($check.idle)" -ForegroundColor Cyan
    exit 0
}

Write-Host "[ComfyUI Idle Watcher] Daemon started (${IdleMinutes}m threshold)" -ForegroundColor Green
Write-ComfyUiLog -Action 'IDLE_DAEMON' -Detail 'started'

while ($true) {
    $check = Test-ComfyIdle
    if ($check.state -eq 'stopped') {
        $idleSince = $null
        $notified = $false
    } elseif ($check.idle) {
        if (-not $idleSince) { $idleSince = Get-Date }
        $elapsed = ((Get-Date) - $idleSince).TotalSeconds
        if ($elapsed -ge $idleLimitSeconds -and -not $notified) {
            Send-IdleNotice
            $notified = $true
        }
    } else {
        $idleSince = $null
        $notified = $false
    }
    Start-Sleep -Seconds 60
}
