#!/usr/bin/env pwsh
# Safe database copy for deployment.
# Ensures dev server is stopped (or explicitly confirmed) before copying.

param(
  [switch]$Force,
  [switch]$Quiet
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$dbFile = Join-Path $repoRoot "payload.sqlite"
$tempFile = Join-Path $repoRoot "payload.sqlite.temp"

if (-not (Test-Path -LiteralPath $dbFile)) {
  Write-Host "ERROR: payload.sqlite not found!" -ForegroundColor Red
  exit 1
}

$portCheck = netstat -ano | findstr ":3000" | findstr "LISTENING"
if ($LASTEXITCODE -eq 0 -and -not $Force) {
  Write-Host ""
  Write-Host "WARNING: Development server is running on port 3000." -ForegroundColor Yellow
  Write-Host "Database may be locked. Stop npm run dev first for a clean copy." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "Aborted for safety. Stop dev first, then run npm run db:copy (or use npm run db:copy:force)." -ForegroundColor Red
  exit 1
}

try {
  Copy-Item -LiteralPath $dbFile -Destination $tempFile -Force
  $size = (Get-Item -LiteralPath $tempFile).Length
  $sizeKb = [math]::Round($size / 1KB, 0)
  Write-Host "Created clean copy: payload.sqlite.temp (${sizeKb} KB)" -ForegroundColor Green

  if (-not $Quiet) {
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Upload payload.sqlite.temp to Hostinger (File Manager or FTPS)" -ForegroundColor White
    Write-Host "  2. Rename it to payload.sqlite on the server" -ForegroundColor White
    Write-Host "  3. Delete payload.sqlite-wal and payload.sqlite-shm on the server" -ForegroundColor White
    Write-Host "  4. Restart Node app in hPanel" -ForegroundColor White
  }
} catch {
  Write-Host "ERROR: Failed to copy database: $_" -ForegroundColor Red
  exit 1
}

exit 0
