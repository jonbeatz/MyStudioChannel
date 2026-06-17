# social-autopost — portable installer
param(
  [string]$ProjectRoot,
  [switch]$WhatIf,
  [switch]$SkipVerify
)

$ErrorActionPreference = "Stop"
$ModuleRoot = $PSScriptRoot
$LibPath = Join-Path (Split-Path $ModuleRoot -Parent) "_lib\Msc-ModuleInstall.ps1"
. $LibPath

Write-Host ""
Write-Host "Social Auto-Post Module Installer" -ForegroundColor Cyan
Write-Host "--------------------------------" -ForegroundColor Cyan

$RepoRoot = Resolve-MscRepoRoot -ModuleRoot $ModuleRoot -ProjectRoot $ProjectRoot
Write-Host "Target: $RepoRoot"
Write-Host ""

$copyPairs = @(
  @{ Src = "scripts\social\auto-post.mjs"; Dest = "scripts\social\auto-post.mjs" },
  @{ Src = "scripts\social\format-caption.mjs"; Dest = "scripts\social\format-caption.mjs" },
  @{ Src = "scripts\social\postiz-client.mjs"; Dest = "scripts\social\postiz-client.mjs" }
)

Write-Host "[1] scripts/social/*.mjs..." -ForegroundColor Yellow
foreach ($pair in $copyPairs) {
  $src = Join-Path $ModuleRoot $pair.Src
  $dest = Join-Path $RepoRoot $pair.Dest
  if (-not (Test-Path $src)) {
    $src = Join-Path $RepoRoot $pair.Dest
  }
  if ($WhatIf) {
    Write-Host "[WhatIf] $dest"
  } elseif (Test-Path $src) {
    New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
    Copy-Item $src $dest -Force
    Write-Host "  OK $($pair.Dest)"
  }
}

Write-Host "[2] specs/social-autopost/..." -ForegroundColor Yellow
$specSrc = Join-Path $ModuleRoot "..\..\..\specs\social-autopost"
$specDest = Join-Path $RepoRoot "specs\social-autopost"
if (Test-Path $specSrc) {
  if ($WhatIf) {
    Write-Host "[WhatIf] robocopy specs/social-autopost"
  } else {
    New-Item -ItemType Directory -Force -Path $specDest | Out-Null
    robocopy $specSrc $specDest /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    Write-Host "  OK specs/social-autopost"
  }
}

Write-Host "[3] .agents/skills/auto-post/..." -ForegroundColor Yellow
$skillSrc = Join-Path $RepoRoot ".agents\skills\auto-post\SKILL.md"
if (Test-Path $skillSrc) {
  Write-Host "  OK skill already in repo"
}

Write-Host "[4] .env.example..." -ForegroundColor Yellow
Merge-MscEnvFragment -RepoRoot $RepoRoot -ModuleRoot $ModuleRoot -MarkerKey "POSTIZ_API_URL" -WhatIf:$WhatIf

Write-Host "[5] package.json..." -ForegroundColor Yellow
Merge-MscPackageJson -RepoRoot $RepoRoot -MergeFilePath (Join-Path $ModuleRoot "package-scripts.json") -WhatIf:$WhatIf

if (-not $SkipVerify -and -not $WhatIf) {
  Write-Host ""
  Write-Host "Verify" -ForegroundColor Cyan
  Push-Location $RepoRoot
  npm run social:auto-post -- --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml
  if ($LASTEXITCODE -ne 0) { Pop-Location; exit 1 }
  Pop-Location
}

Write-Host ""
Write-Host "Installation complete." -ForegroundColor Green
Write-Host "Dry-run: npm run social:auto-post -- --dry-run --spec specs/social-autopost/examples/dry-run-campaign.yaml"
Write-Host "Phase 2: see POSTIZ-SETUP.md | Phase 3: COMPOSIO-MCP.md | Phase 4: SCHEDULING.md"
Write-Host ""
