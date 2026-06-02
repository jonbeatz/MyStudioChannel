# Abort deploy if payload.sqlite is missing or too small (empty ~4KB DB guard).
# Usage: powershell -File scripts/assert-payload-sqlite-deploy.ps1 [-MinBytes 500000] [-ZipPath <zip>]
param(
  [int]$MinBytes = 500000,
  [string]$ZipPath = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$dbFile = Join-Path $repoRoot "payload.sqlite"

if (-not (Test-Path -LiteralPath $dbFile)) {
  Write-Host "ERROR: Missing payload.sqlite at $dbFile" -ForegroundColor Red
  exit 1
}

$dbSize = (Get-Item -LiteralPath $dbFile).Length
$sizeKb = [math]::Round($dbSize / 1024, 1)
Write-Host "payload.sqlite: $dbSize bytes (~${sizeKb} KiB) at $dbFile" -ForegroundColor Gray

if ($dbSize -lt $MinBytes) {
  Write-Host "ERROR: Database too small ($dbSize bytes). Did you mean to deploy an empty database?" -ForegroundColor Red
  Write-Host "Expected at least $MinBytes bytes (~$([math]::Round($MinBytes/1024)) KiB). Restore or sync your local DB first." -ForegroundColor Yellow
  exit 1
}

if ($ZipPath -and (Test-Path -LiteralPath $ZipPath)) {
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zip = [System.IO.Compression.ZipFile]::OpenRead($ZipPath)
  try {
    $entry = $zip.Entries | Where-Object {
      $_.FullName -replace '\\', '/' -eq 'payload.sqlite' -or $_.Name -eq 'payload.sqlite'
    } | Select-Object -First 1
    if (-not $entry) {
      Write-Host "ERROR: payload.sqlite not found inside zip: $ZipPath" -ForegroundColor Red
      exit 1
    }
    if ($entry.Length -lt $MinBytes) {
      Write-Host "ERROR: Zip entry payload.sqlite too small ($($entry.Length) bytes uncompressed)." -ForegroundColor Red
      exit 1
    }
    $zipKb = [math]::Round($entry.Length / 1024, 1)
    Write-Host "OK: zip contains payload.sqlite (~${zipKb} KiB uncompressed)" -ForegroundColor Green
  } finally {
    $zip.Dispose()
  }
}

exit 0
