# Tier 2b - Fast deploy: zip .next (single FTPS file) + SSH unzip + sync-app.
# Run from repo root: npm run pushit:live:fast
#
# Flags: -SkipBuild -WithDb -WithMedia -DryRun
# Fallback: if zip/unzip fails, runs pushitup -- .next (slower, reliable).
param(
  [switch]$SkipBuild,
  [switch]$WithDb,
  [switch]$WithMedia,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$totalSteps = 9
$zipPath = Join-Path $repoRoot "zips\deploy-next.zip"
$zipUploadLocal = Join-Path $repoRoot "deploy-next.zip"
$zipUploadArg = "deploy-next.zip"

function Write-Step {
  param([int]$N, [int]$Total, [string]$Message)
  Write-Host ""
  Write-Host "[$N/$Total] $Message" -ForegroundColor Cyan
}

function Invoke-DryNote {
  param([string]$Command)
  if ($DryRun) {
    Write-Host "  DRY-RUN would run: $Command" -ForegroundColor DarkGray
    return $true
  }
  return $false
}

function Invoke-ProdBuild {
  $pushitSavedNextPublic = $env:NEXT_PUBLIC_SERVER_URL
  $prodPublicUrl = "https://mystudiochannel.com"
  if ($env:MSC_CANONICAL_SITE_ORIGIN -and $env:MSC_CANONICAL_SITE_ORIGIN.Trim().Length -gt 0) {
    $prodPublicUrl = $env:MSC_CANONICAL_SITE_ORIGIN.Trim().TrimEnd("/")
  }
  $env:NEXT_PUBLIC_SERVER_URL = $prodPublicUrl
  try {
    npm run build
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  } finally {
    if ($null -ne $pushitSavedNextPublic -and $pushitSavedNextPublic.Length -gt 0) {
      $env:NEXT_PUBLIC_SERVER_URL = $pushitSavedNextPublic
    } else {
      Remove-Item Env:\NEXT_PUBLIC_SERVER_URL -ErrorAction SilentlyContinue
    }
  }
}

function Invoke-NextUploadFallback {
  Write-Host "  WARN: zip path failed - falling back to full .next FTPS upload." -ForegroundColor Yellow
  if (Invoke-DryNote "npm run pushitup -- .next") { return $true }
  npm run pushitup -- .next
  if ($LASTEXITCODE -ne 0) {
    Write-Host "pushit:live:fast - ABORT: fallback .next FTPS upload failed." -ForegroundColor Red
    exit 1
  }
  return $true
}

function Invoke-DeployNextZipPath {
  $nextPath = Join-Path $repoRoot ".next"
  if (-not (Test-Path -LiteralPath $nextPath)) {
    Write-Host "  missing .next - cannot zip" -ForegroundColor Yellow
    return $false
  }

  $zipsDir = Join-Path $repoRoot "zips"
  if (-not (Test-Path -LiteralPath $zipsDir)) {
    if ($DryRun) {
      Write-Host "  DRY-RUN would create: $zipsDir" -ForegroundColor DarkGray
    } else {
      New-Item -ItemType Directory -Path $zipsDir -Force | Out-Null
    }
  }

  if ($DryRun) {
    Write-Host "  DRY-RUN would zip .next -> $zipPath" -ForegroundColor DarkGray
    Write-Host "  DRY-RUN would copy zip to repo root and run: npm run pushitup -- $zipUploadArg" -ForegroundColor DarkGray
    Write-Host "  DRY-RUN would run: npm run msc:hostinger:unzip-deploy-next" -ForegroundColor DarkGray
    return $true
  }

  try {
    if (Test-Path -LiteralPath $zipPath) {
      Remove-Item -LiteralPath $zipPath -Force
    }
    Compress-Archive -Path $nextPath -DestinationPath $zipPath -CompressionLevel Fastest -Force
    if (-not (Test-Path -LiteralPath $zipPath) -or (Get-Item -LiteralPath $zipPath).Length -eq 0) {
      Write-Host "  zip missing or empty after Compress-Archive" -ForegroundColor Yellow
      return $false
    }
    $zipMb = [math]::Round((Get-Item -LiteralPath $zipPath).Length / 1MB, 2)
    Write-Host ("  Created {0} ({1} MB)" -f $zipPath, $zipMb) -ForegroundColor Gray
  } catch {
    Write-Host "  Compress-Archive failed: $($_.Exception.Message)" -ForegroundColor Yellow
    return $false
  }

  try {
    Copy-Item -LiteralPath $zipPath -Destination $zipUploadLocal -Force
    npm run pushitup -- $zipUploadArg
    if ($LASTEXITCODE -ne 0) {
      Write-Host "  FTPS upload of deploy-next.zip failed" -ForegroundColor Yellow
      return $false
    }
  } finally {
    if (Test-Path -LiteralPath $zipUploadLocal) {
      Remove-Item -LiteralPath $zipUploadLocal -Force -ErrorAction SilentlyContinue
    }
  }

  npm run msc:hostinger:unzip-deploy-next
  if ($LASTEXITCODE -ne 0) {
    Write-Host "  SSH unzip or BUILD_ID verify failed" -ForegroundColor Yellow
    return $false
  }

  return $true
}

function Invoke-WithDbUpload {
  $dbFile = Join-Path $repoRoot "payload.sqlite"
  $tempDbFile = Join-Path $repoRoot "payload.sqlite.temp"
  $backupDbFile = Join-Path $repoRoot "payload.sqlite.live.bak"

  if (-not (Test-Path -LiteralPath $dbFile)) {
    Write-Host "pushit:live:fast - ABORT: -WithDb requires payload.sqlite" -ForegroundColor Red
    exit 1
  }

  $assertScript = Join-Path $repoRoot "scripts/assert-payload-sqlite-deploy.ps1"
  if (-not $DryRun) {
    & powershell -ExecutionPolicy Bypass -File $assertScript
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  }

  $copyDbScript = Join-Path $repoRoot "scripts/copy-db-for-deploy.ps1"
  if (Invoke-DryNote "copy-db-for-deploy.ps1 + pushitup payload.sqlite + msc:hostinger:sync-db") { return }

  & powershell -ExecutionPolicy Bypass -File $copyDbScript
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

  if (Test-Path -LiteralPath $backupDbFile) {
    Remove-Item -LiteralPath $backupDbFile -Force -ErrorAction SilentlyContinue
  }

  $dbUploadExitCode = 0
  try {
    Move-Item -LiteralPath $dbFile -Destination $backupDbFile -Force
    Move-Item -LiteralPath $tempDbFile -Destination $dbFile -Force
    npm run pushitup -- payload.sqlite
    $dbUploadExitCode = $LASTEXITCODE
  } finally {
    if (Test-Path -LiteralPath $backupDbFile) {
      Move-Item -LiteralPath $backupDbFile -Destination $dbFile -Force
    }
    if (Test-Path -LiteralPath $tempDbFile) {
      Remove-Item -LiteralPath $tempDbFile -Force -ErrorAction SilentlyContinue
    }
  }
  if ($dbUploadExitCode -ne 0) { exit $dbUploadExitCode }

  npm run msc:hostinger:sync-db
  if ($LASTEXITCODE -ne 0) {
    Write-Host "pushit:live:fast - ABORT: sync-db failed" -ForegroundColor Red
    exit 1
  }
}

Write-Host ""
Write-Host "=== pushit:live:fast ===" -ForegroundColor Green
Write-Host "  SkipBuild: $SkipBuild  WithDb: $WithDb  WithMedia: $WithMedia  DryRun: $DryRun" -ForegroundColor Gray

Write-Step 1 $totalSteps "Stopping Node on host..."
if (-not (Invoke-DryNote "npm run msc:hostinger:stop-node")) {
  npm run msc:hostinger:stop-node
  if ($LASTEXITCODE -ne 0) {
    Write-Host "  WARN: stop-node exit $LASTEXITCODE (continuing)" -ForegroundColor Yellow
  }
}

Write-Step 2 $totalSteps "Killing local dev port..."
if (-not (Invoke-DryNote "npm run msc:kill-dev-port")) {
  npm run msc:kill-dev-port
  if ($LASTEXITCODE -ne 0) {
    Write-Host "  WARN: kill-dev-port exit $LASTEXITCODE" -ForegroundColor Yellow
  }
}

if (-not $SkipBuild) {
  try {
    $changed = git diff --name-only HEAD~1 2>$null | Select-String -Pattern '^(app|components|lib|collections|globals)/|next\.config\.mjs|payload\.config\.ts|middleware\.ts'
    if ($null -eq $changed -or $changed.Count -eq 0) {
      Write-Host "  HINT: No matching source changes in last commit. Consider -SkipBuild for admin-ui-only deploy." -ForegroundColor DarkYellow
    }
  } catch {
    # ignore shallow history
  }
}

if (-not $SkipBuild) {
  Write-Step 3 $totalSteps "Building Next.js..."
  if (-not (Invoke-DryNote "npm run build (live NEXT_PUBLIC_SERVER_URL)")) {
    Invoke-ProdBuild
  }
} else {
  Write-Step 3 $totalSteps "Building Next.js... (skipped -SkipBuild)"
}

Write-Step 4 $totalSteps "Uploading admin-ui..."
if (-not (Invoke-DryNote "npm run msc:pushitup:admin-ui")) {
  npm run msc:pushitup:admin-ui
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if (-not $SkipBuild) {
  Write-Step 5 $totalSteps "Zipping .next to deploy-next.zip..."
  Write-Step 6 $totalSteps "Uploading deploy-next.zip (single file)..."
  Write-Step 7 $totalSteps "Unzipping on host (BUILD_ID verify)..."
  if ($DryRun) {
    Invoke-DeployNextZipPath | Out-Null
  } else {
    Write-Host "  (steps 5-7: zip, upload, unzip)" -ForegroundColor Gray
    $zipOk = Invoke-DeployNextZipPath
    if ($zipOk -ne $true) {
      Write-Host "  Zip path did not complete - running fallback." -ForegroundColor Yellow
      Invoke-NextUploadFallback | Out-Null
    }
  }
} else {
  Write-Step 5 $totalSteps "Zipping .next... (skipped -SkipBuild)"
  Write-Step 6 $totalSteps "Uploading deploy-next.zip... (skipped -SkipBuild)"
  Write-Step 7 $totalSteps "Unzipping on host... (skipped -SkipBuild)"
}

if ($WithDb) {
  Write-Host ""
  Write-Host "  [-WithDb] Uploading payload.sqlite + sync-db..." -ForegroundColor Yellow
  Invoke-WithDbUpload
}

if ($WithMedia) {
  Write-Host ""
  Write-Host "  [-WithMedia] Uploading public/media..." -ForegroundColor Yellow
  if (-not (Invoke-DryNote "npm run pushitup -- public/media")) {
    npm run pushitup -- public/media
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  }
}

Write-Step 8 $totalSteps "Syncing to app root (msc:hostinger:sync-app)..."
$syncAppCmd = if ($WithDb) { "npm run msc:hostinger:sync-app" } else { "npm run msc:hostinger:sync-app -- --skip-db" }
if (-not (Invoke-DryNote $syncAppCmd)) {
  if ($WithDb) {
    npm run msc:hostinger:sync-app
  } else {
    npm run msc:hostinger:sync-app -- --skip-db
  }
  if ($LASTEXITCODE -ne 0) {
    Write-Host "pushit:live:fast - ABORT: sync-app failed" -ForegroundColor Red
    exit 1
  }
}

Write-Step 9 $totalSteps "Done. Restart Node in hPanel."
$restartScript = Join-Path $repoRoot "scripts/print-hostinger-restart-reminder.ps1"
if ($DryRun) {
  Write-Host "  DRY-RUN complete - no remote changes made." -ForegroundColor Green
} elseif (Test-Path -LiteralPath $restartScript) {
  & powershell -ExecutionPolicy Bypass -File $restartScript -Status success
}
Write-Host "  Then run: npm run msc:verify:live" -ForegroundColor Cyan
Write-Host "            npm run msc:verify:live:version" -ForegroundColor Cyan
Write-Host ""
