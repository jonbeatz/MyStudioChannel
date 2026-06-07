# Unified "push website live" - MCP zip deploy (default) or FTPS fallback.
#
# Usage:
#   npm run push:website:live              # Phase 0 + zip (MCP deploy is done by Cursor agent)
#   npm run push:website:live -- --dry-run  # Preflight only (kill dev, build, no zip)
#   npm run push:website:live -- --ftps     # FTPS fallback (pushit:live + live verify)
#
# MCP (agent): hosting_deployJsApplication with zip from zips/MyStudioChannel-deploy-*.zip
# Deployment zips: zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$dryRun = $false
$useFtps = $false
foreach ($arg in $args) {
  if ($arg -eq "--dry-run" -or $arg -eq "-DryRun") { $dryRun = $true }
  if ($arg -eq "--ftps" -or $arg -eq "-Ftps") { $useFtps = $true }
}

$domain = "mystudiochannel.com"
$hpanelUrl = "https://hpanel.hostinger.com/websites/mystudiochannel.com"
$hostingerAppRoot = "/home/u942711528/domains/mystudiochannel.com/nodejs"
$zipsDir = Join-Path $repoRoot "zips"
$sftpConfigPath = Join-Path $repoRoot ".vscode/sftp.json"
$restartScript = Join-Path $repoRoot "scripts/print-hostinger-restart-reminder.ps1"

function Write-PhaseHeader {
  param([string]$Title)
  Write-Host ""
  Write-Host "=== $Title ===" -ForegroundColor Cyan
}

function Test-FtpsConfigured {
  return (Test-Path -LiteralPath $sftpConfigPath)
}

function Assert-PayloadSqliteDeployReady {
  $assertScript = Join-Path $repoRoot "scripts/assert-payload-sqlite-deploy.ps1"
  if (-not (Test-Path -LiteralPath $assertScript)) {
    Write-Host "ABORT: missing $assertScript" -ForegroundColor Red
    exit 1
  }
  & powershell -ExecutionPolicy Bypass -File $assertScript
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Invoke-SafeDbCopyCheck {
  $copyScript = Join-Path $repoRoot "scripts/copy-db-for-deploy.ps1"
  $tempDbFile = Join-Path $repoRoot "payload.sqlite.temp"
  if (-not (Test-Path -LiteralPath $copyScript)) {
    Write-Host "ABORT: missing $copyScript" -ForegroundColor Red
    exit 1
  }

  # No --force here by design: if dev is running, operator must confirm/stop it.
  & powershell -ExecutionPolicy Bypass -File $copyScript -Quiet
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  if (Test-Path -LiteralPath $tempDbFile) {
    Remove-Item -LiteralPath $tempDbFile -Force -ErrorAction SilentlyContinue
  }
}

function Test-GitUncommitted {
  $status = git status --porcelain 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "WARN: git status unavailable - skipping uncommitted check" -ForegroundColor Yellow
    return
  }
  $lines = @($status | Where-Object { $_.Trim().Length -gt 0 })
  if ($lines.Count -gt 0) {
    Write-Host "WARN: uncommitted changes ($($lines.Count) file(s)) - live ships current working tree." -ForegroundColor Yellow
    $lines | Select-Object -First 8 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
  } else {
    Write-Host "Git working tree clean." -ForegroundColor Green
  }
}

function Invoke-ProductionBuild {
  $pushitSaved = $env:NEXT_PUBLIC_SERVER_URL
  $prodPublicUrl = "https://$domain"
  if ($env:MSC_CANONICAL_SITE_ORIGIN -and $env:MSC_CANONICAL_SITE_ORIGIN.Trim().Length -gt 0) {
    $prodPublicUrl = $env:MSC_CANONICAL_SITE_ORIGIN.Trim().TrimEnd("/")
  }
  $env:NEXT_PUBLIC_SERVER_URL = $prodPublicUrl
  try {
    Write-Host "Building with NEXT_PUBLIC_SERVER_URL=$prodPublicUrl" -ForegroundColor Gray
    npm run build
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  } finally {
    if ($null -ne $pushitSaved -and $pushitSaved.Length -gt 0) {
      $env:NEXT_PUBLIC_SERVER_URL = $pushitSaved
    } else {
      Remove-Item Env:\NEXT_PUBLIC_SERVER_URL -ErrorAction SilentlyContinue
    }
  }
}

function Wait-ForLiveHealthy {
  param([int]$MaxAttempts = 12, [int]$IntervalSec = 15)
  for ($i = 1; $i -le $MaxAttempts; $i++) {
    Write-Host "verify:live attempt $i/$MaxAttempts..." -ForegroundColor Gray
    npm run msc:verify:live 2>&1 | Out-Host
    if ($LASTEXITCODE -eq 0) { return $true }
    if ($i -lt $MaxAttempts) {
      Write-Host "Waiting ${IntervalSec}s (restart Node in hPanel if not done)..." -ForegroundColor Yellow
      Start-Sleep -Seconds $IntervalSec
    }
  }
  return $false
}

function Join-FtpPath {
  param([string]$Left, [string]$Right)
  $leftClean = ($Left -replace "\\", "/").TrimEnd("/")
  $rightClean = ($Right -replace "\\", "/").TrimStart("/")
  if ([string]::IsNullOrWhiteSpace($leftClean)) { return "/$rightClean" }
  if ([string]::IsNullOrWhiteSpace($rightClean)) { return $leftClean }
  return "$leftClean/$rightClean"
}

function Escape-FtpPath {
  param([string]$PathText)
  $parts = ($PathText -replace "\\", "/").Split("/", [System.StringSplitOptions]::RemoveEmptyEntries)
  $encoded = $parts | ForEach-Object {
    $seg = $_
    if ($seg.StartsWith("@")) {
      "@" + [System.Uri]::EscapeDataString($seg.Substring(1))
    } else {
      [System.Uri]::EscapeDataString($seg)
    }
  }
  return ($encoded -join "/")
}

function New-FtpRequest {
  param(
    [string]$Uri,
    [string]$Method,
    [System.Net.NetworkCredential]$Credential,
    [bool]$UseSsl,
    [bool]$UsePassive
  )
  $request = [System.Net.FtpWebRequest]::Create($Uri)
  $request.Credentials = $Credential
  $request.EnableSsl = $UseSsl
  $request.UsePassive = $UsePassive
  $request.UseBinary = $true
  $request.KeepAlive = $false
  $request.Timeout = 30000
  $request.ReadWriteTimeout = 30000
  $request.Method = $Method
  return $request
}

function Remove-FtpFile {
  param(
    [string]$BaseFtpUrl,
    [string]$RemoteFilePath,
    [System.Net.NetworkCredential]$Credential,
    [bool]$UseSsl,
    [bool]$UsePassive
  )
  $uri = "$BaseFtpUrl/$(Escape-FtpPath -PathText $RemoteFilePath)"
  try {
    $request = New-FtpRequest -Uri $uri -Method ([System.Net.WebRequestMethods+Ftp]::DeleteFile) -Credential $Credential -UseSsl $UseSsl -UsePassive $UsePassive
    $response = $request.GetResponse()
    $response.Close()
    return $true
  } catch {
    $resp = $_.Exception.Response
    if ($null -ne $resp) {
      $code = [int]$resp.StatusCode
      $resp.Close()
      if ($code -eq 550) { return $false }
    }
    return $false
  }
}

function Get-FtpFileSize {
  param(
    [string]$BaseFtpUrl,
    [string]$RemoteFilePath,
    [System.Net.NetworkCredential]$Credential,
    [bool]$UseSsl,
    [bool]$UsePassive
  )
  $uri = "$BaseFtpUrl/$(Escape-FtpPath -PathText $RemoteFilePath)"
  try {
    $request = New-FtpRequest -Uri $uri -Method ([System.Net.WebRequestMethods+Ftp]::GetFileSize) -Credential $Credential -UseSsl $UseSsl -UsePassive $UsePassive
    $response = $request.GetResponse()
    $size = $response.ContentLength
    $response.Close()
    return $size
  } catch {
    return -1
  }
}

function Rename-FtpFile {
  param(
    [string]$BaseFtpUrl,
    [string]$RemoteFilePath,
    [string]$NewFileName,
    [System.Net.NetworkCredential]$Credential,
    [bool]$UseSsl,
    [bool]$UsePassive
  )
  $uri = "$BaseFtpUrl/$(Escape-FtpPath -PathText $RemoteFilePath)"
  try {
    $request = New-FtpRequest -Uri $uri -Method ([System.Net.WebRequestMethods+Ftp]::Rename) -Credential $Credential -UseSsl $UseSsl -UsePassive $UsePassive
    $request.RenameTo = $NewFileName
    $response = $request.GetResponse()
    $response.Close()
    return $true
  } catch {
    Write-Host "Rename FTP file failed: $_" -ForegroundColor Red
    return $false
  }
}

Write-Host ""
Write-Host "push:website:live -> $domain" -ForegroundColor Cyan
if ($dryRun) { Write-Host "DRY RUN - no zip / no upload" -ForegroundColor Magenta }
elseif ($useFtps) { Write-Host "Mode: FTPS (pushit:live)" -ForegroundColor Yellow }
else { Write-Host "Mode: MCP zip (default) - agent runs Hostinger MCP after this script" -ForegroundColor Yellow }

if (-not (Test-Path -LiteralPath $zipsDir)) {
  New-Item -ItemType Directory -Path $zipsDir -Force | Out-Null
}

# --- Phase 0: Preflight ---
Write-PhaseHeader "Phase 0 - Preflight"
$branch = (git rev-parse --abbrev-ref HEAD 2>$null)
if ($LASTEXITCODE -eq 0) {
  Write-Host "Branch: $branch" -ForegroundColor Gray
}
$packageJsonRaw = Get-Content (Join-Path $repoRoot "package.json") -Raw
$pkgVersion = "unknown"
if ($packageJsonRaw -match '"version"\s*:\s*"([^"]+)"') { $pkgVersion = $Matches[1] }
Write-Host "package.json version: $pkgVersion" -ForegroundColor Gray
Test-GitUncommitted

Write-Host ""
Write-Host "Database gate (payload.sqlite must be full CMS DB, not empty stub)..." -ForegroundColor Yellow
Assert-PayloadSqliteDeployReady
Invoke-SafeDbCopyCheck

Write-Host ""
Write-Host "Stopping local dev on port 3000 (if any)..." -ForegroundColor Yellow
npm run msc:kill-dev-port
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne 2) {
  Write-Host "WARN: kill-dev-port exit $LASTEXITCODE" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Production build gate (npm run build)..." -ForegroundColor Yellow
Invoke-ProductionBuild

if (-not (Test-Path -LiteralPath (Join-Path $repoRoot ".next/BUILD_ID"))) {
  Write-Host "ABORT: .next/BUILD_ID missing after build." -ForegroundColor Red
  exit 1
}

if ($dryRun) {
  Write-PhaseHeader "Dry run complete"
  Write-Host "Database size check: PASS (payload.sqlite >= 500000 bytes)" -ForegroundColor Green
  Write-Host "Would create: zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip (includes payload.sqlite)" -ForegroundColor Magenta
  if ($useFtps) {
    Write-Host "Would run: npm run pushit:live (FTPS uploads payload.sqlite -> /nodejs/)" -ForegroundColor Magenta
  } else {
    Write-Host "Would run: npm run msc:deploy:zip then Hostinger MCP hosting_deployJsApplication" -ForegroundColor Magenta
  }
  & powershell -ExecutionPolicy Bypass -File $restartScript -Status pending
  exit 0
}

# --- Phase 1: Deploy ---
if ($useFtps) {
  Write-PhaseHeader "Phase 1 - Deploy (FTPS fallback)"
  if (-not (Test-FtpsConfigured)) {
    Write-Host "ABORT: .vscode/sftp.json missing. Run: npm run sync:sftp-env" -ForegroundColor Red
    exit 1
  }

  Write-Host "Parsing FTPS configuration..." -ForegroundColor Yellow
  $config = Get-Content -Raw -Path $sftpConfigPath | ConvertFrom-Json
  $ignoreCert = $true
  if ($null -ne $config.ignoreCertificateErrors) {
    $ignoreCert = [bool]$config.ignoreCertificateErrors
  }
  if ($ignoreCert) {
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
  }
  $ftpServer = [string]$config.host
  $ftpPort = if ($null -ne $config.port) { [int]$config.port } else { 21 }
  $useSsl = if ($null -ne $config.secure) { [bool]$config.secure } else { $true }
  $usePassive = if ($null -ne $config.passive) { [bool]$config.passive } else { $true }
  $username = [string]$config.username
  $password = [string]$config.password
  $remoteBase = [string]$config.remotePath

  $baseFtpUrl = "ftp://$ftpServer`:$ftpPort"
  $credential = New-Object System.Net.NetworkCredential($username, $password)

  Write-Host "verify:ftp-smoke..." -ForegroundColor Yellow
  npm run msc:verify:ftp-smoke
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

  # Remote Database Auto-Backup
  $remoteDbPath = Join-FtpPath -Left $remoteBase -Right "payload.sqlite"
  $dbSize = Get-FtpFileSize -BaseFtpUrl $baseFtpUrl -RemoteFilePath $remoteDbPath -Credential $credential -UseSsl $useSsl -UsePassive $usePassive
  if ($dbSize -ge 0) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupFileName = "payload.sqlite.bak-$timestamp"
    Write-Host "📦 Backing up remote database..." -ForegroundColor Yellow
    $backupSuccess = Rename-FtpFile -BaseFtpUrl $baseFtpUrl -RemoteFilePath $remoteDbPath -NewFileName $backupFileName -Credential $credential -UseSsl $useSsl -UsePassive $usePassive
    if ($backupSuccess) {
      Write-Host "✅ Backup saved on server: $backupFileName" -ForegroundColor Green
    } else {
      Write-Host "❌ ABORT: Remote database backup failed. Overwrite prevented." -ForegroundColor Red
      exit 1
    }
  } else {
    Write-Host "ℹ️ No existing payload.sqlite found on remote server. Skipping backup." -ForegroundColor Gray
  }

  Write-Host ""
  Write-Host "Stopping live Node via SSH (Option B — no hPanel Stop button required)..." -ForegroundColor Yellow
  npm run msc:hostinger:stop-node
  if ($LASTEXITCODE -ne 0) {
    Write-Host "WARN: SSH stop-node failed — continue only if Node is not holding DB open." -ForegroundColor Yellow
  }

  npm run pushit:live
  if ($LASTEXITCODE -ne 0) {
    Write-Host "FTPS deploy failed at pushit:live." -ForegroundColor Red
    exit $LASTEXITCODE
  }

  # Automatic WAL Cleanup and DB Size Verification
  Write-Host ""
  Write-Host "Verifying database upload size..." -ForegroundColor Yellow
  $dbSize = Get-FtpFileSize -BaseFtpUrl $baseFtpUrl -RemoteFilePath $remoteDbPath -Credential $credential -UseSsl $useSsl -UsePassive $usePassive
  if ($dbSize -gt 0) {
    $dbSizeKb = [Math]::Round($dbSize / 1024, 1)
    if ($dbSize -lt 500000) {
      Write-Host "⚠️ WARNING: Remote database size is only $dbSizeKb KB (expected ~528 KB). Please check." -ForegroundColor Yellow
    } else {
      Write-Host "✅ Verified remote database size: $dbSizeKb KB" -ForegroundColor Green
    }
  } else {
    Write-Host "⚠️ WARNING: Could not verify remote database size over FTPS." -ForegroundColor Yellow
  }

  Write-Host ""
  Write-Host "Cleaning up SQLite WAL / SHM files on server..." -ForegroundColor Yellow
  $walPath = Join-FtpPath -Left $remoteBase -Right "payload.sqlite-wal"
  $shmPath = Join-FtpPath -Left $remoteBase -Right "payload.sqlite-shm"
  
  $deletedWal = Remove-FtpFile -BaseFtpUrl $baseFtpUrl -RemoteFilePath $walPath -Credential $credential -UseSsl $useSsl -UsePassive $usePassive
  $deletedShm = Remove-FtpFile -BaseFtpUrl $baseFtpUrl -RemoteFilePath $shmPath -Credential $credential -UseSsl $useSsl -UsePassive $usePassive

  if ($deletedWal) { Write-Host "  🧹 Deleted remote payload.sqlite-wal" -ForegroundColor Gray }
  if ($deletedShm) { Write-Host "  🧹 Deleted remote payload.sqlite-shm" -ForegroundColor Gray }

  Write-Host ""
  Write-Host "Syncing payload.sqlite from FTPS landing zone into live app root (SSH)..." -ForegroundColor Yellow
  npm run msc:hostinger:sync-db
  if ($LASTEXITCODE -ne 0) {
    Write-Host "ABORT: SSH DB sync failed — FTPS may have landed under public_html/nodejs." -ForegroundColor Red
    exit 1
  }

  Write-Host ""
  Write-Host "✅ Database synced to live app root (domains/.../nodejs/payload.sqlite)" -ForegroundColor Green
  Write-Host "🧹 WAL files cleaned up on server" -ForegroundColor Green
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host "🔄 NEXT STEP (Manual):" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "Go to $hpanelUrl" -ForegroundColor Cyan
  Write-Host "Click Node.js → Restart" -ForegroundColor Yellow
  Write-Host "Wait 30 seconds" -ForegroundColor Yellow
  Write-Host "Run: npm run verify:live" -ForegroundColor Cyan
  Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
  Write-Host ""

  Write-PhaseHeader "Phase 2 - Restart + live verify"
  & powershell -ExecutionPolicy Bypass -File $restartScript -Status success
  Write-Host "Optional Terminal (media URLs):" -ForegroundColor Gray
  Write-Host "  cd $hostingerAppRoot" -ForegroundColor Gray
  Write-Host '  sqlite3 ./payload.sqlite "UPDATE media SET url = ''/media/'' || filename;"' -ForegroundColor Gray

  $liveOk = Wait-ForLiveHealthy
  if ($liveOk) {
    npm run msc:verify:live:version
    if ($LASTEXITCODE -eq 0) {
      Write-Host ""
      Write-Host "push:website:live (FTPS) - ALL CHECKS PASSED." -ForegroundColor Green
      exit 0
    }
  }
  Write-Host "push:website:live (FTPS) - restart Node in hPanel, then: npm run verify:live" -ForegroundColor Red
  exit 1
}

# --- Default: MCP zip path (script stops after zip; agent calls MCP) ---
Write-PhaseHeader "Phase 1 - Create deployment zip (MCP)"
npm run msc:deploy:zip
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$zipPath = $null
$lastZipFile = Join-Path $zipsDir ".last-deploy-zip.txt"
if (Test-Path -LiteralPath $lastZipFile) {
  $zipPath = (Get-Content -LiteralPath $lastZipFile -Raw).Trim()
}

Write-PhaseHeader "Phase 2 - MCP deploy (Cursor agent)"
Write-Host "Zip ready for Hostinger MCP:" -ForegroundColor Green
if ($zipPath) { Write-Host "  $zipPath" -ForegroundColor Cyan }
Write-Host ""
Write-Host "Agent steps:" -ForegroundColor Yellow
Write-Host "  1. CallMcpTool user-hostinger-hosting hosting_deployJsApplication" -ForegroundColor Gray
Write-Host "     domain=$domain archivePath=<zip above> removeArchive=false" -ForegroundColor Gray
Write-Host "  2. hosting_listJsDeployments until completed or failed" -ForegroundColor Gray
Write-Host "  3. On failure: hosting_showJsDeploymentLogs + offer --ftps fallback" -ForegroundColor Gray
Write-Host ""
Write-Host "If MCP fails, rerun:" -ForegroundColor Yellow
Write-Host "  npm run push:website:live -- --ftps" -ForegroundColor Cyan
Write-Host ""

& powershell -ExecutionPolicy Bypass -File $restartScript -Status pending

Write-Host "After MCP build completes, run the restart reminder again (success)." -ForegroundColor Gray
Write-Host "Then: npm run verify:live" -ForegroundColor Gray
Write-Host ""
Write-Host "push:website:live (MCP zip) - preflight + zip PASSED. Awaiting MCP upload in Cursor." -ForegroundColor Green
exit 0
