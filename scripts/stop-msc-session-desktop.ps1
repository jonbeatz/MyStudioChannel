# Stop-MSC-Session — desktop shortcut: stop LiteLLM, ngrok, Hermes gateway, Next dev (3000)
$ErrorActionPreference = 'Continue'

$Tag = '[MSC Stop]'
$RepoRoot = Split-Path $PSScriptRoot -Parent

Set-Location $RepoRoot

Write-Host ''
Write-Host "$Tag Shutting down local MSC session services..." -ForegroundColor Cyan
Write-Host "$Tag   Next dev (port 3000)" -ForegroundColor DarkGray
Write-Host "$Tag   LiteLLM proxy (port 4000)" -ForegroundColor DarkGray
Write-Host "$Tag   ngrok + inspector (4040)" -ForegroundColor DarkGray
Write-Host "$Tag   Hermes Telegram gateway" -ForegroundColor DarkGray
Write-Host ''

npm run msc:session:stop

if ($LASTEXITCODE -eq 0) {
    Write-Host ''
    Write-Host "$Tag All session services stopped." -ForegroundColor Green
    Write-Host "$Tag Safe to close this window." -ForegroundColor DarkGray
} else {
    Write-Host ''
    Write-Host "$Tag Stop finished with warnings (exit $LASTEXITCODE)." -ForegroundColor Yellow
    Write-Host "$Tag Check output above; retry or close any leftover LiteLLM/ngrok windows." -ForegroundColor DarkGray
}

Write-Host ''
