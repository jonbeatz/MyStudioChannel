# Create a source-only deployment zip for Hostinger MCP / hPanel zip deploy.
# Excludes: node_modules, .next, .git, zips, .pushitupzips, *.zip, SQLite WAL/SHM.
# Output: zips/MyStudioChannel-deploy-YYYYMMDD-HHmmss.zip
#
# Usage: npm run deploy:zip
#        powershell -File scripts/create-deploy-zip.ps1 [-BranchName MSC-Website-v4]
param(
  [string]$BranchName = "MSC-Website-v4"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$zipsDir = Join-Path $repoRoot "zips"
if (-not (Test-Path -LiteralPath $zipsDir)) {
  New-Item -ItemType Directory -Path $zipsDir -Force | Out-Null
}

$branch = (git rev-parse --abbrev-ref HEAD 2>$null)
if ($LASTEXITCODE -eq 0 -and $branch -and $branch -ne $BranchName) {
  Write-Host "WARN: current branch is '$branch' (expected '$BranchName'). Zip will still use working tree." -ForegroundColor Yellow
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$zipName = "MyStudioChannel-deploy-$timestamp.zip"
$zipPath = Join-Path $zipsDir $zipName
$staging = Join-Path $env:TEMP "msc-deploy-staging-$timestamp"

if (Test-Path -LiteralPath $staging) {
  Remove-Item -LiteralPath $staging -Recurse -Force
}
New-Item -ItemType Directory -Path $staging -Force | Out-Null

Write-Host "Staging deploy bundle (robocopy)..." -ForegroundColor Yellow
Write-Host "  From: $repoRoot" -ForegroundColor Gray
Write-Host "  To:   $staging" -ForegroundColor Gray

$robocopyArgs = @(
  $repoRoot,
  $staging,
  "/MIR",
  "/XD", "node_modules", ".next", ".git", "zips", ".pushitupzips",
  "/XF", "*.zip", "payload.sqlite-wal", "payload.sqlite-shm",
  "/NFL", "/NDL", "/NJH", "/NJS", "/nc", "/ns", "/np"
)
& robocopy @robocopyArgs | Out-Null
$robExit = $LASTEXITCODE
if ($robExit -ge 8) {
  Write-Host "robocopy failed with exit code $robExit" -ForegroundColor Red
  exit $robExit
}

if (Test-Path -LiteralPath $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}

Write-Host "Compressing archive..." -ForegroundColor Yellow
Compress-Archive -Path (Join-Path $staging "*") -DestinationPath $zipPath -CompressionLevel Optimal

Remove-Item -LiteralPath $staging -Recurse -Force

$sizeMb = [math]::Round((Get-Item -LiteralPath $zipPath).Length / 1MB, 2)
$lastZipFile = Join-Path $zipsDir ".last-deploy-zip.txt"
Set-Content -LiteralPath $lastZipFile -Value $zipPath -Encoding UTF8

Write-Host ""
Write-Host "deploy:zip OK" -ForegroundColor Green
Write-Host "  Archive: $zipPath" -ForegroundColor Gray
Write-Host "  Size:    ${sizeMb} MB" -ForegroundColor Gray
if ($sizeMb -gt 200) {
  Write-Host "  WARN: zip is over ~200 MB — check that node_modules/.next were excluded." -ForegroundColor Yellow
}

# Machine-readable line for agents/scripts
Write-Host "DEPLOY_ZIP_PATH=$zipPath"

exit 0
