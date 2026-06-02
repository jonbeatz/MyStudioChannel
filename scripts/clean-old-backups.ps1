# scripts/clean-old-backups.ps1
# Deletes old MyStudioChannel backups, retaining only the 10 most recent ones.

param(
  [switch]$Force,
  [switch]$DryRun
)

# Support double-dash or custom cli arg parsing as fallback
$isDryRun = $DryRun -or ($args -contains "--dry-run") -or ($args -contains "-dry-run")
$isForce = $Force -or ($args -contains "--force") -or ($args -contains "-Force") -or ($args -contains "-force")

$BackupRoot = "G:\Cursor_Project_BackUpz\MyStudioChannel"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "   Backup Retention Manager" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

if (-not (Test-Path $BackupRoot)) {
  Write-Host "Backup directory does not exist: $BackupRoot" -ForegroundColor Gray
  exit 0
}

# Scan directories
$allBackups = Get-ChildItem -Path $BackupRoot -Directory | 
              Sort-Object LastWriteTime -Descending

Write-Host "Scanned $BackupRoot" -ForegroundColor Gray
Write-Host "Found $($allBackups.Count) total backup folder(s)." -ForegroundColor Gray

if ($allBackups.Count -le 10) {
  Write-Host "Retention rule met (<= 10 backups). No cleanup required!" -ForegroundColor Green
  exit 0
}

$backupsToKeep = $allBackups | Select-Object -First 10
$backupsToDelete = $allBackups | Select-Object -Skip 10

Write-Host ""
Write-Host "Backups to KEEP (10 most recent):" -ForegroundColor Green
foreach ($b in $backupsToKeep) {
  Write-Host "   [KEEP] $($b.Name) (Last Modified: $($b.LastWriteTime))" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Backups identified for DELETION (older than 10):" -ForegroundColor Yellow
foreach ($b in $backupsToDelete) {
  Write-Host "   [DELETE] $($b.Name) (Last Modified: $($b.LastWriteTime))" -ForegroundColor DarkYellow
}

if ($isDryRun) {
  Write-Host ""
  Write-Host "[DRY RUN] Would delete $($backupsToDelete.Count) older backup(s). No files were changed." -ForegroundColor Cyan
  exit 0
}

# Confirmation
$confirmed = $isForce
if (-not $confirmed) {
  $reply = Read-Host "Confirm deletion of these $($backupsToDelete.Count) old backup(s)? (y/N)"
  if ($reply -eq 'y' -or $reply -eq 'Y') {
    $confirmed = $true
  }
}

if (-not $confirmed) {
  Write-Host ""
  Write-Host "Cleanup cancelled. No backups were deleted." -ForegroundColor Red
  exit 0
}

Write-Host ""
Write-Host "Deleting $($backupsToDelete.Count) old backup(s)..." -ForegroundColor Yellow
foreach ($b in $backupsToDelete) {
  try {
    Write-Host "   Removing $($b.Name)..." -ForegroundColor Gray
    Remove-Item -Path $b.FullName -Recurse -Force -ErrorAction Stop
  } catch {
    Write-Host "   Error removing $($b.Name): $_" -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "Cleanup complete!" -ForegroundColor Green
