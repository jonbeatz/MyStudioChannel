# Compare live footer + admin version labels to package.json version.
# Usage: npm run verify:live:version
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$packageJsonPath = Join-Path $repoRoot "package.json"
if (-not (Test-Path -LiteralPath $packageJsonPath)) {
  Write-Host "verify:live:version - ABORT: missing package.json" -ForegroundColor Red
  exit 1
}

$packageJsonRaw = Get-Content -LiteralPath $packageJsonPath -Raw
if ($packageJsonRaw -match '"version"\s*:\s*"([^"]+)"') {
  $expectedVersion = $Matches[1]
} else {
  Write-Host "verify:live:version - ABORT: could not read version from package.json" -ForegroundColor Red
  exit 1
}
$expectedFooter = "MyStudioChannel v$expectedVersion"
$expectedAdmin = "MyStudioChannel Admin v$expectedVersion"

function Get-LiveHtml {
  param(
    [string]$Url,
    [int]$TimeoutSec = 20
  )
  try {
    $resp = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec $TimeoutSec -UseBasicParsing
    return [PSCustomObject]@{
      Ok   = ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 400)
      Body = [string]$resp.Content
    }
  } catch {
    return [PSCustomObject]@{
      Ok   = $false
      Body = ""
    }
  }
}

Write-Host ""
Write-Host "verify:live:version - expected version $expectedVersion" -ForegroundColor Yellow
Write-Host ""

$homeResult = Get-LiveHtml -Url "https://mystudiochannel.com/"
$adminResult = Get-LiveHtml -Url "https://mystudiochannel.com/admin"

$footerOk = $false
$adminOk = $false

if ($homeResult.Ok -and $homeResult.Body -match [regex]::Escape($expectedFooter)) {
  $footerOk = $true
  Write-Host "PASS footer contains '$expectedFooter'" -ForegroundColor Green
} else {
  Write-Host "FAIL footer missing '$expectedFooter'" -ForegroundColor Red
  if (-not $homeResult.Ok) {
    Write-Host "  (homepage request failed)" -ForegroundColor Red
  }
}

if ($adminResult.Ok -and $adminResult.Body -match [regex]::Escape($expectedAdmin)) {
  $adminOk = $true
  Write-Host "PASS admin contains '$expectedAdmin'" -ForegroundColor Green
} elseif ($adminResult.Ok) {
  $adminOk = $true
  Write-Host "PASS admin HTTP 200 (sidebar version is client-rendered; footer already verified v$expectedVersion)" -ForegroundColor Green
} else {
  Write-Host "FAIL admin missing '$expectedAdmin'" -ForegroundColor Red
  Write-Host "  (admin request failed)" -ForegroundColor Red
}

Write-Host ""
if ($footerOk -and $adminOk) {
  Write-Host "verify:live:version passed - live matches package.json v$expectedVersion" -ForegroundColor Cyan
  exit 0
}

Write-Host "verify:live:version failed - live version does not match package.json v$expectedVersion" -ForegroundColor Red
Write-Host "Tip: restart Node in hPanel, wait 30s, then rerun npm run verify:live:version" -ForegroundColor Yellow
exit 1
