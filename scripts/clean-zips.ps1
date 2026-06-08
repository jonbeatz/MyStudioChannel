# scripts/clean-zips.ps1
# Retains only the N most recent .zip files in zips/ (reproducible deploy archives).

param(
  [int]$Keep = 3,
  [switch]$Force,
  [switch]$DryRun
)

$isDryRun = $DryRun -or ($args -contains '--dry-run')
$isForce = $Force -or ($args -contains '--force') -or ($args -contains '-Force')

$RepoRoot = Split-Path -Parent $PSScriptRoot
$ZipsDir = Join-Path $RepoRoot 'zips'

Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '   Deploy Zip Retention (zips/)' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan

if (-not (Test-Path $ZipsDir)) {
  Write-Host 'zips/ does not exist - nothing to clean.' -ForegroundColor Gray
  exit 0
}

$allZips = Get-ChildItem -Path $ZipsDir -File -Filter '*.zip' |
  Sort-Object LastWriteTime -Descending

Write-Host "Scanned $ZipsDir" -ForegroundColor Gray
Write-Host ('Found {0} zip file(s). Keeping {1} most recent.' -f $allZips.Count, $Keep) -ForegroundColor Gray

if ($allZips.Count -le $Keep) {
  Write-Host ('Retention rule met (<= {0} zips). No cleanup required!' -f $Keep) -ForegroundColor Green
  exit 0
}

$zipsToKeep = $allZips | Select-Object -First $Keep
$zipsToDelete = $allZips | Select-Object -Skip $Keep

Write-Host ''
Write-Host ('Zips to KEEP ({0} most recent):' -f $Keep) -ForegroundColor Green
foreach ($z in $zipsToKeep) {
  $mb = [math]::Round($z.Length / 1MB, 1)
  Write-Host ('   [KEEP] {0} ({1} MB, {2})' -f $z.Name, $mb, $z.LastWriteTime) -ForegroundColor Gray
}

Write-Host ''
Write-Host 'Zips identified for DELETION:' -ForegroundColor Yellow
foreach ($z in $zipsToDelete) {
  $mb = [math]::Round($z.Length / 1MB, 1)
  Write-Host ('   [DELETE] {0} ({1} MB, {2})' -f $z.Name, $mb, $z.LastWriteTime) -ForegroundColor DarkYellow
}

if ($isDryRun) {
  Write-Host ''
  Write-Host ('[DRY RUN] Would delete {0} zip(s). No files were changed.' -f $zipsToDelete.Count) -ForegroundColor Cyan
  exit 0
}

$confirmed = $isForce
if (-not $confirmed) {
  $reply = Read-Host ('Confirm deletion of these {0} zip(s)? (y/N)' -f $zipsToDelete.Count)
  if ($reply -eq 'y' -or $reply -eq 'Y') {
    $confirmed = $true
  }
}

if (-not $confirmed) {
  Write-Host ''
  Write-Host 'Cleanup cancelled. No zips were deleted.' -ForegroundColor Red
  exit 0
}

Write-Host ''
Write-Host ('Deleting {0} zip(s)...' -f $zipsToDelete.Count) -ForegroundColor Yellow
foreach ($z in $zipsToDelete) {
  try {
    Write-Host ('   Removing {0}...' -f $z.Name) -ForegroundColor Gray
    Remove-Item -Path $z.FullName -Force -ErrorAction Stop
  } catch {
    Write-Host ('   Error removing {0}: {1}' -f $z.Name, $_.Exception.Message) -ForegroundColor Red
  }
}

Write-Host ''
Write-Host 'Deploy zip cleanup complete.' -ForegroundColor Green
