# MyStudioChannel — unified session cold-start (Start Project)
# Boots LiteLLM + ngrok + Hermes gateway, then Visual Kanban stack (hidden background).
# Does NOT start Next.js dev (port 3000) — operator or agent starts that when coding.

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path $PSScriptRoot -Parent

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  J.A.R.V.I.S. Session Stack — Cold Start" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

Write-Host "[Session] Step 1/2 — LiteLLM + ngrok + Hermes gateway..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'scripts\start-hermes-api.ps1')
if ($LASTEXITCODE -ne 0) {
    Write-Host "[Session] LiteLLM startup failed (exit $LASTEXITCODE)." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "[Session] Step 2/2 — Visual Kanban stack (3001, 3005, 9119 — hidden)..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -File (Join-Path $RepoRoot 'scripts\start-kanban-stack.ps1')
if ($LASTEXITCODE -ne 0) {
    Write-Host "[Session] Kanban stack warning (exit $LASTEXITCODE)." -ForegroundColor Yellow
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Session stack online. Next dev (3000) not started — run npm run dev when coding." -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
