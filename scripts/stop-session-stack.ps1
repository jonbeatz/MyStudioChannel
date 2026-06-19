# MyStudioChannel — unified session teardown (End Project)
# Stops Kanban stack, Next dev (3000), LiteLLM (4000), ngrok (4040).
# Use -KeepGateway to leave Hermes Telegram bot responsive overnight.

param(
    [switch]$KeepGateway
)

$ErrorActionPreference = 'Continue'
$RepoRoot = Split-Path $PSScriptRoot -Parent

Write-Host "================================================================" -ForegroundColor Red
Write-Host "  J.A.R.V.I.S. Session Stack - Shutdown" -ForegroundColor Red
if ($KeepGateway) {
    Write-Host '  (Telegram gateway will stay running)' -ForegroundColor Yellow
}
Write-Host "================================================================" -ForegroundColor Red

# 1. Kanban stack (3001, 3005, 9119)
Write-Host "[Session] Stopping Visual Kanban stack..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'scripts\stop-kanban-stack.ps1')

# 2. Orphan cleanup — hidden cmd trees and stale WT tabs from old launches
Write-Host "[Session] Clearing orphan TaskBoard / Hermes shell windows..." -ForegroundColor Yellow
Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object {
    $cl = $_.CommandLine
    $cl -and (
        ($cl -match 'D:\\Hermes\\TaskBoardAI' -and $_.Name -in @('cmd.exe', 'powershell.exe')) -or
        ($cl -match 'D:\\Hermes\\hermes-workspace' -and $_.Name -in @('cmd.exe', 'powershell.exe')) -or
        ($cl -match 'wt\.exe' -and $cl -match 'TaskBoardAI|hermes-workspace')
    )
} | ForEach-Object {
    Write-Host "  Stopping orphan $($_.Name) PID $($_.ProcessId)" -ForegroundColor Gray
    Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

# 3. Next.js dev (3000)
Write-Host "[Session] Clearing Next dev port 3000..." -ForegroundColor Yellow
Push-Location $RepoRoot
node (Join-Path $RepoRoot 'scripts\msc-kill-dev-port.mjs') 3000
Pop-Location

# 4. LiteLLM + ngrok (+ optional gateway stop)
Write-Host "[Session] Stopping LiteLLM + ngrok (4000, 4040)..." -ForegroundColor Yellow
Push-Location $RepoRoot
if ($KeepGateway) {
    node (Join-Path $RepoRoot 'scripts\msc-litellm-stop.mjs') --keep-gateway
} else {
    node (Join-Path $RepoRoot 'scripts\msc-litellm-stop.mjs')
}
Pop-Location

Write-Host "================================================================" -ForegroundColor Red
Write-Host "  Session stack stopped." -ForegroundColor Green
Write-Host "  Postiz (4007) runs in Docker - stop separately if needed: cd D:\Hermes\postiz; docker compose down" -ForegroundColor Gray
Write-Host "================================================================" -ForegroundColor Red
