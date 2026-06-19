# restart-comfyui.ps1 — stop, wait, start
param(
    [switch]$Force,
    [switch]$NoVRAMCheck,
    [switch]$LowVram,
    [switch]$UnloadLMStudio
)

$ErrorActionPreference = 'Stop'
$modulePath = Join-Path $PSScriptRoot 'lib\comfyui-state.psm1'
Import-Module $modulePath -Force

Write-ComfyUiLog -Action 'RESTART' -Detail 'begin'
& (Join-Path $PSScriptRoot 'stop-comfyui.ps1')
Start-Sleep -Seconds 2

$params = @{}
if ($Force) { $params.Force = $true }
if ($NoVRAMCheck) { $params.NoVRAMCheck = $true }
if ($LowVram) { $params.LowVram = $true }
if ($UnloadLMStudio) { $params.UnloadLMStudio = $true }

& (Join-Path $PSScriptRoot 'start-comfyui.ps1') @params
$code = $LASTEXITCODE
Write-ComfyUiLog -Action 'RESTART' -Detail "exit=$code"
exit $code
