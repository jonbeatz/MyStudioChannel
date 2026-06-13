# hermes-system — portable installer (personal dev profile)
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
Write-Host "J.A.R.V.I.S. / Hermes System Module Installer" -ForegroundColor Cyan
Write-Host "----------------------------------------------" -ForegroundColor Cyan

$RepoRoot = Resolve-MscRepoRoot -ModuleRoot $ModuleRoot -ProjectRoot $ProjectRoot
Write-Host "Target Project: $RepoRoot"
Write-Host ""

# Copying J.A.R.V.I.S. Core scripts
Write-Host "[1] Copying scripts to target repository..." -ForegroundColor Yellow
$srcDir = Join-Path $ModuleRoot "scripts"
$destDir = Join-Path $RepoRoot "scripts"

$scripts = @(
    "payload-types-sync.ps1",
    "vram-idle-manager.ps1",
    "msc-build-and-dev.ps1",
    "generate-image.py",
    "mem0_integration.py",
    "mem0-chat.ps1",
    "start-hermes-api.ps1",
    "generate-payload-types.mjs"
)

if (-not $WhatIf) {
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }
}

foreach ($s in $scripts) {
    $src = Join-Path $srcDir $s
    $dest = Join-Path $destDir $s
    if ($WhatIf) {
        Write-Host "[WhatIf] Copy: $dest"
    } else {
        Copy-Item $src $dest -Force
        Write-Host "  Copied scripts/$s"
    }
}

Write-Host ""
Write-Host "[2] Merging package-scripts.json into package.json..." -ForegroundColor Yellow
Merge-MscPackageJson -RepoRoot $RepoRoot -MergeFilePath (Join-Path $ModuleRoot "package-scripts.json") -WhatIf:$WhatIf

Write-Host ""
Write-Host "[3] Merging env fragment into .env.example..." -ForegroundColor Yellow
Merge-MscEnvFragment -RepoRoot $RepoRoot -ModuleRoot $ModuleRoot -MarkerKey "HF_TOKEN" -WhatIf:$WhatIf

Write-Host ""
Write-Host "Verifying installations..." -ForegroundColor Cyan
$failed = $false
foreach ($s in $scripts) {
    $fileCheck = Join-Path $destDir $s
    if (-not (Test-Path $fileCheck)) {
        Write-Host "  FAIL missing script: scripts/$s" -ForegroundColor Red
        $failed = $true
    } else {
        Write-Host "  OK scripts/$s" -ForegroundColor Green
    }
}

if ($failed) {
    Write-Host "❌ Verification FAILED. Please resolve missing script issues." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host "Prerequisites:" -ForegroundColor Yellow
Write-Host "  1. Add HF_TOKEN=hf_... to your new project .env.local file."
Write-Host "  2. Run: pip install huggingface_hub pillow python-dotenv mem0ai"
Write-Host "  3. Copy J.A.R.V.I.S. PowerShell profile commands to your system PowerShell Profile."
Write-Host "  4. Merge global.mdc.fragment into your project global.mdc file for Cursor Shortcuts."
Write-Host ""
