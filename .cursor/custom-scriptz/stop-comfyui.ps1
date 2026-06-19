# stop-comfyui.ps1 — ComfyUI-only stop (does not kill LM Studio)
param(
    [switch]$Force,
    [switch]$Json,
    [switch]$DryRun
)

$ErrorActionPreference = 'SilentlyContinue'
$modulePath = Join-Path $PSScriptRoot 'lib\comfyui-state.psm1'
Import-Module $modulePath -Force

$targets = Get-ComfyUiKillTargets
$vramBefore = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()

if ($targets.Count -eq 0) {
    $msg = 'No ComfyUI processes detected.'
    Write-Host "[OK] $msg" -ForegroundColor Green
    Write-ComfyUiLog -Action 'STOP_SKIP' -Detail $msg
    if ($Json) {
        @{ status = 'noop'; message = $msg; killed = @() } | ConvertTo-Json -Compress
    }
    exit 0
}

$killList = @($targets | ForEach-Object { $_.pid })

if ($DryRun) {
    Write-Host '[DRYRUN] Would kill ComfyUI PIDs:' ($killList -join ', ') -ForegroundColor Yellow
    Write-ComfyUiLog -Action 'DRYRUN' -Detail "PIDs: $($killList -join ', ')"
    if ($Json) {
        @{ status = 'dryrun'; wouldKill = $killList } | ConvertTo-Json -Compress
    }
    exit 0
}

foreach ($procId in $killList) {
    if (-not $Json) {
        Write-Host "   Stopping PID $procId..." -ForegroundColor Yellow
    }
    Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 3

$vramAfter = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()
$totalRaw = (nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits).Trim()
$pct = if ($totalRaw) { [math]::Round(([double]$vramAfter / [double]$totalRaw) * 100, 1) } else { 0 }

$result = @{
    status     = 'stopped'
    killed     = $killList
    vramBefore = $vramBefore
    vramAfter  = $vramAfter
    percent    = $pct
}

Write-ComfyUiLog -Action 'STOP' -Detail "killed=$($killList -join ',') before=${vramBefore}MB after=${vramAfter}MB"

if ($Json) {
    $result | ConvertTo-Json -Compress
} else {
    Write-Host "[OK] ComfyUI stopped. VRAM: $vramAfter MB ($pct%)" -ForegroundColor Green
    if ($pct -gt 65) {
        Write-Host '[WARN] VRAM still elevated. LM Studio may still hold GPU memory — try lms unload --all or vram-cleanup.ps1' -ForegroundColor Yellow
    }
}

exit 0
