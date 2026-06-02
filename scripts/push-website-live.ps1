# Unified "push website live" - preflight, FTPS deploy, restart gate, live verification.
# Usage:
#   npm run push:website:live
#   npm run push:website:live -- --dry-run
#
# Deployment zips (MCP / manual): D:\Cursor_Projectz\MyStudioChannel\zips\
#   MyStudioChannel-v4-deploy-YYYYMMDD-HHmmss.zip
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$dryRun = $false
foreach ($arg in $args) {
  if ($arg -eq "--dry-run" -or $arg -eq "-DryRun") {
    $dryRun = $true
  }
}

$hostingerAppRoot = "/home/u942711528/domains/mystudiochannel.com/public_html"
$hpanelNodeUrl = "https://hpanel.hostinger.com/websites/mystudiochannel.com/nodejs"
$zipsDir = Join-Path $repoRoot "zips"
$sftpConfigPath = Join-Path $repoRoot ".vscode/sftp.json"

function Test-FtpsConfigured {
  return (Test-Path -LiteralPath $sftpConfigPath)
}

function Write-PhaseHeader {
  param([string]$Title)
  Write-Host ""
  Write-Host "=== $Title ===" -ForegroundColor Cyan
}

function Write-ServerPrepInstructions {
  Write-PhaseHeader "Phase 1 - Server prep (Live - hPanel + Terminal)"
  Write-Host "BEFORE upload - STOP Node app:" -ForegroundColor Yellow
  Write-Host "  $hpanelNodeUrl" -ForegroundColor Gray
  Write-Host ""
  Write-Host "Run in Hostinger Terminal:" -ForegroundColor Yellow
  Write-Host "  cd $hostingerAppRoot" -ForegroundColor Gray
  Write-Host "  rm -rf .next" -ForegroundColor Gray
  Write-Host "  rm -f payload.sqlite-wal payload.sqlite-shm" -ForegroundColor Gray
  Write-Host ""
}

function Test-GitUncommitted {
  $status = git status --porcelain 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "WARN: git status unavailable - skipping uncommitted check" -ForegroundColor Yellow
    return
  }
  $lines = @($status | Where-Object { $_.Trim().Length -gt 0 })
  if ($lines.Count -gt 0) {
    Write-Host ""
    Write-Host "WARN: uncommitted changes detected ($($lines.Count) file(s)):" -ForegroundColor Yellow
    $lines | Select-Object -First 12 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    if ($lines.Count -gt 12) {
      Write-Host "  ... and $($lines.Count - 12) more" -ForegroundColor Gray
    }
    Write-Host "  Live will ship whatever is in your working tree after build." -ForegroundColor Yellow
  } else {
    Write-Host "Git working tree clean." -ForegroundColor Green
  }
}

function Wait-ForLiveHealthy {
  param(
    [int]$MaxAttempts = 12,
    [int]$IntervalSec = 15
  )
  for ($i = 1; $i -le $MaxAttempts; $i++) {
    Write-Host "verify:live attempt $i/$MaxAttempts..." -ForegroundColor Gray
    npm run verify:live 2>&1 | Out-Host
    if ($LASTEXITCODE -eq 0) { return $true }
    if ($i -lt $MaxAttempts) {
      Write-Host "Waiting ${IntervalSec}s (restart Node in hPanel if not done yet)..." -ForegroundColor Yellow
      Start-Sleep -Seconds $IntervalSec
    }
  }
  return $false
}

Write-Host ""
Write-Host "push:website:live - unified deploy to mystudiochannel.com" -ForegroundColor Cyan
if ($dryRun) {
  Write-Host "DRY RUN - preflight only; no FTPS upload or live polling" -ForegroundColor Magenta
}

if (-not (Test-Path -LiteralPath $zipsDir)) {
  New-Item -ItemType Directory -Path $zipsDir -Force | Out-Null
  Write-Host "Created zips folder: $zipsDir" -ForegroundColor Gray
}

# Phase 0: Preflight
Write-PhaseHeader "Phase 0 - Preflight"
Test-GitUncommitted

Write-Host ""
Write-Host "push:website:live - verify:next:safe (build gate)" -ForegroundColor Yellow
npm run verify:next:safe
if ($LASTEXITCODE -ne 0) {
  Write-Host "Preflight failed at verify:next:safe. Aborting." -ForegroundColor Red
  exit $LASTEXITCODE
}

Write-Host ""
if (Test-FtpsConfigured) {
  Write-Host "push:website:live - verify:ftp-smoke (FTPS path sanity)" -ForegroundColor Yellow
  npm run verify:ftp-smoke
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Preflight failed at verify:ftp-smoke. Aborting." -ForegroundColor Red
    exit $LASTEXITCODE
  }
} elseif ($dryRun) {
  Write-Host "WARN: .vscode/sftp.json missing - skipping verify:ftp-smoke in dry-run." -ForegroundColor Yellow
  Write-Host "  Create sftp.json (HOSTINGER-DEPLOY.md) before full deploy, or use Hostinger MCP zip deploy." -ForegroundColor Yellow
} else {
  Write-Host "ABORT: .vscode/sftp.json missing - FTPS deploy requires local FTP credentials." -ForegroundColor Red
  Write-Host "  Create .vscode/sftp.json from HOSTINGER-DEPLOY.md, or use Hostinger MCP with a zip in zips/." -ForegroundColor Yellow
  exit 1
}

Write-ServerPrepInstructions

if ($dryRun) {
  Write-PhaseHeader "Dry run complete"
  Write-Host "Would run: npm run pushit:live" -ForegroundColor Magenta
  Write-Host "Would poll: npm run verify:live (after hPanel Node restart)" -ForegroundColor Magenta
  Write-Host "Would run: npm run verify:live:version" -ForegroundColor Magenta
  Write-Host ""
  Write-Host "Zip staging folder: $zipsDir" -ForegroundColor Gray
  Write-Host "Zip naming: MyStudioChannel-v4-deploy-YYYYMMDD-HHmmss.zip" -ForegroundColor Gray
  Write-Host ""
  Write-Host "PASS - dry run preflight succeeded." -ForegroundColor Green
  exit 0
}

# Phase 2: Deploy
Write-PhaseHeader "Phase 2 - Deploy (Local FTPS)"
Write-Host "Ensure Node app is STOPPED and server cleanup ran (Phase 1) before continuing." -ForegroundColor Yellow
Write-Host ""

npm run pushit:live
if ($LASTEXITCODE -ne 0) {
  Write-Host "Deploy failed at pushit:live. Aborting." -ForegroundColor Red
  exit $LASTEXITCODE
}

# Phase 3: Restart gate + live smoke
Write-PhaseHeader "Phase 3 - Restart gate + live smoke"
Write-Host "AFTER upload - Live (hPanel Terminal):" -ForegroundColor Yellow
Write-Host "  cd $hostingerAppRoot" -ForegroundColor Gray
$dquote = [char]34
$sqlReminderInner = "UPDATE media SET url = '/media/' || filename;"
Write-Host ('  sqlite3 ./payload.sqlite ' + $dquote + $sqlReminderInner + $dquote) -ForegroundColor Gray
Write-Host "  pkill -u `$(whoami) node" -ForegroundColor Gray
Write-Host ""
Write-Host "START Node app (wait 20-30 s):" -ForegroundColor Yellow
Write-Host "  $hpanelNodeUrl" -ForegroundColor Gray
Write-Host ""
Write-Host "Polling verify:live (up to ~3 min)..." -ForegroundColor Yellow

$liveOk = Wait-ForLiveHealthy -MaxAttempts 12 -IntervalSec 15

# Phase 4: Version parity
Write-PhaseHeader "Phase 4 - Version parity"
$versionOk = $false
if ($liveOk) {
  npm run verify:live:version
  $versionOk = ($LASTEXITCODE -eq 0)
} else {
  Write-Host "Skipping verify:live:version - verify:live did not pass." -ForegroundColor Yellow
}

# Summary
Write-PhaseHeader "Summary"
Write-Host "Preflight (verify:next:safe + verify:ftp-smoke): PASS" -ForegroundColor Green
Write-Host "FTPS upload (pushit:live): PASS" -ForegroundColor Green
if ($liveOk) {
  Write-Host "Live smoke (verify:live): PASS" -ForegroundColor Green
} else {
  Write-Host "Live smoke (verify:live): FAIL - restart Node in hPanel and run npm run verify:live" -ForegroundColor Red
}
if ($versionOk) {
  Write-Host "Version parity (verify:live:version): PASS" -ForegroundColor Green
} elseif ($liveOk) {
  Write-Host "Version parity (verify:live:version): FAIL" -ForegroundColor Red
} else {
  Write-Host "Version parity (verify:live:version): SKIPPED" -ForegroundColor Yellow
}

Write-Host ""
if ($liveOk -and $versionOk) {
  Write-Host "push:website:live - ALL CHECKS PASSED. Live site matches local production build." -ForegroundColor Cyan
  Write-Host "Optional: npm run dev:fresh to restore localhost dev server." -ForegroundColor Gray
  exit 0
}

Write-Host "push:website:live - INCOMPLETE. Fix hPanel restart or env vars, then rerun verify:live / verify:live:version." -ForegroundColor Red
exit 1
