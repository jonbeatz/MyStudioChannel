# Local smoke checks before deploy.
# Usage: npm run verify:local
$ErrorActionPreference = "Stop"

function Test-Url {
  param(
    [string]$Url,
    [int]$TimeoutSec = 12
  )

  try {
    $resp = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec $TimeoutSec -UseBasicParsing
    return [PSCustomObject]@{
      Url       = $Url
      Ok        = ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 400)
      Status    = $resp.StatusCode
      ErrorText = ""
    }
  } catch {
    $status = 0
    if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
      $status = [int]$_.Exception.Response.StatusCode
    }
    return [PSCustomObject]@{
      Url       = $Url
      Ok        = $false
      Status    = $status
      ErrorText = $_.Exception.Message
    }
  }
}

function Test-PlaywrightAvailable {
  $prev = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  npx playwright --version 2>$null | Out-Null
  $ok = ($LASTEXITCODE -eq 0)
  $ErrorActionPreference = $prev
  return $ok
}

$checks = @(
  "http://localhost:3000/",
  "http://localhost:3000/admin",
  "http://localhost:3000/admin/globals/homepage",
  "http://localhost:3000/api/globals/projects-home?depth=1"
)

Write-Host ""
Write-Host "verify:local - running smoke checks..." -ForegroundColor Yellow
Write-Host ""

$results = @()
foreach ($url in $checks) {
  $results += Test-Url -Url $url
}

$failed = $results | Where-Object { -not $_.Ok }

foreach ($r in $results) {
  if ($r.Ok) {
    Write-Host ("PASS {0} [{1}]" -f $r.Url, $r.Status) -ForegroundColor Green
  } else {
    Write-Host ("FAIL {0} [{1}] {2}" -f $r.Url, $r.Status, $r.ErrorText) -ForegroundColor Red
  }
}

Write-Host ""
if ($failed.Count -gt 0) {
  Write-Host ("verify:local failed ({0} checks failed)." -f $failed.Count) -ForegroundColor Red
  Write-Host "Tip: run npm run dev:fresh, then rerun npm run verify:local." -ForegroundColor Yellow
  exit 1
}

$playwrightAvailable = Test-PlaywrightAvailable

if (-not $playwrightAvailable) {
  Write-Host "Playwright not found. Install now? (y/n)" -ForegroundColor Yellow
  $answer = Read-Host
  if ($answer -match '^[Yy]') {
    Write-Host "Installing @playwright/test and Playwright browsers..." -ForegroundColor Yellow
    npm install -D @playwright/test
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    npx playwright install
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    $playwrightAvailable = Test-PlaywrightAvailable
  } else {
    Write-Host "WARN: Skipping Playwright smoke tests (Playwright not installed)." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "verify:local passed (HTTP checks only). Safe to proceed with deploy flow." -ForegroundColor Cyan
    exit 0
  }
}

if (-not $playwrightAvailable) {
  Write-Host "WARN: Playwright still unavailable after install attempt; skipping smoke tests." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "verify:local passed (HTTP checks only). Safe to proceed with deploy flow." -ForegroundColor Cyan
  exit 0
}

Write-Host ""
Write-Host "Running Playwright smoke tests..." -ForegroundColor Yellow
npx playwright test tests/smoke.spec.ts
if ($LASTEXITCODE -ne 0) {
  Write-Host "verify:local failed (Playwright smoke tests)." -ForegroundColor Red
  exit $LASTEXITCODE
}

Write-Host ""
Write-Host "verify:local passed. Safe to proceed with deploy flow." -ForegroundColor Cyan
exit 0
