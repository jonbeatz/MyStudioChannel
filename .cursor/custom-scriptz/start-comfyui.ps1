# start-comfyui.ps1 — explicit ComfyUI launch with VRAM guards
param(
    [switch]$Force,
    [switch]$NoVRAMCheck,
    [switch]$LowVram,
    [switch]$UnloadLMStudio
)

$ErrorActionPreference = 'Stop'
$modulePath = Join-Path $PSScriptRoot 'lib\comfyui-state.psm1'
Import-Module $modulePath -Force

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$vramCheck = Join-Path $PSScriptRoot 'vram-check.ps1'
$comfyBat = 'H:\AI_Models\ComfyUI\run_nvidia_gpu.bat'
$lowVramScript = Join-Path $PSScriptRoot 'start-comfyui-lowvram.ps1'

if ($LowVram) {
    if ($UnloadLMStudio) {
        Write-Host '[ComfyUI] Unloading LM Studio models...' -ForegroundColor Yellow
        $ErrorActionPreference = 'SilentlyContinue'
        lms unload --all 2>&1 | Out-Null
        $ErrorActionPreference = 'Stop'
        Start-Sleep -Seconds 2
        Write-ComfyUiLog -Action 'UNLOAD_LMS' -Detail 'before lowvram start'
    }
    Write-ComfyUiLog -Action 'START_LOWVRAM' -Detail 'delegating to start-comfyui-lowvram.ps1'
    & $lowVramScript
    exit $LASTEXITCODE
}

$state = Get-ComfyUiState
if ($state.comfyui.portListening) {
    Write-Host "[OK] ComfyUI already running (state: $($state.comfyui.state))" -ForegroundColor Green
    Write-ComfyUiLog -Action 'START_SKIP' -Detail "already running state=$($state.comfyui.state)"
    exit 0
}

if ($UnloadLMStudio) {
    Write-Host '[ComfyUI] Unloading LM Studio models...' -ForegroundColor Yellow
    $ErrorActionPreference = 'SilentlyContinue'
    lms unload --all 2>&1 | Out-Null
    $ErrorActionPreference = 'Stop'
    Start-Sleep -Seconds 2
    Write-ComfyUiLog -Action 'UNLOAD_LMS' -Detail 'before start'
}

if (-not $NoVRAMCheck) {
    & $vramCheck
    if ($LASTEXITCODE -ne 0 -and -not $Force) {
        Write-Host '[FAIL] VRAM check failed. Use -Force or -NoVRAMCheck to override.' -ForegroundColor Red
        Write-ComfyUiLog -Action 'START_ABORT' -Detail 'vram-check failed'
        exit 1
    }
}

if (-not (Test-Path $comfyBat)) {
    Write-Host "[FAIL] ComfyUI batch not found: $comfyBat" -ForegroundColor Red
    exit 1
}

Write-Host '[ComfyUI] Starting via run_nvidia_gpu.bat...' -ForegroundColor Cyan
Write-ComfyUiLog -Action 'START' -Detail "Force=$Force NoVRAMCheck=$NoVRAMCheck"

Start-Process -FilePath $comfyBat -WorkingDirectory 'H:\AI_Models\ComfyUI' -WindowStyle Minimized

$timeout = 60
$elapsed = 0
$finalState = $null
while ($elapsed -lt $timeout) {
    Start-Sleep -Seconds 2
    $elapsed += 2
    $finalState = Get-ComfyUiState
    if ($finalState.comfyui.portListening -and $finalState.comfyui.state -ne 'unknown') {
        break
    }
}

if (-not $finalState) { $finalState = Get-ComfyUiState }

if ($finalState.comfyui.portListening) {
    $pidsStr = $finalState.comfyui.pids -join ','
    Write-Host "[OK] ComfyUI started - state: $($finalState.comfyui.state)" -ForegroundColor Green
    Write-ComfyUiLog -Action 'START_OK' -Detail "state=$($finalState.comfyui.state) pids=$pidsStr"
    exit 0
}

Write-Host '[FAIL] ComfyUI did not respond on port 8188 within timeout.' -ForegroundColor Red
Write-ComfyUiLog -Action 'START_FAIL' -Detail 'port timeout'
exit 1
