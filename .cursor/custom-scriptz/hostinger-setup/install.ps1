# hostinger-setup — portable installer (MyStudioChannel deploy stack)
param(
  [string]$ProjectRoot,
  [switch]$WhatIf,
  [switch]$SkipVerify,
  [switch]$Force
)

$ErrorActionPreference = "Stop"
$ModuleRoot = $PSScriptRoot
$LibPath = Join-Path (Split-Path $ModuleRoot -Parent) "_lib\Msc-ModuleInstall.ps1"
. $LibPath

function Copy-MscModuleTree {
  param(
    [string]$SourceDir,
    [string]$DestDir,
    [switch]$WhatIf
  )
  if (-not (Test-Path $SourceDir)) { return }
  Get-ChildItem -Path $SourceDir -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($SourceDir.Length).TrimStart('\', '/')
    $target = Join-Path $DestDir $rel
    if ($WhatIf) {
      Write-Host "[WhatIf] $target"
      return
    }
    $parent = Split-Path $target -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Copy-Item $_.FullName $target -Force
  }
}

function Install-MscCursorAsset {
  param(
    [string]$RepoRoot,
    [string]$Source,
    [string]$DestRelative,
    [switch]$WhatIf,
    [switch]$Force
  )
  if (-not (Test-Path $Source)) { return }
  $dest = Join-Path $RepoRoot $DestRelative
  if ((Test-Path $dest) -and -not $Force) {
    Write-Host "  Skip (exists): $DestRelative"
    return
  }
  if ($WhatIf) {
    Write-Host "[WhatIf] $DestRelative"
    return
  }
  $parent = Split-Path $dest -Parent
  if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  Copy-Item $Source $dest -Force
  Write-Host "  Installed $DestRelative"
}

Write-Host ""
Write-Host "Hostinger Setup Module Installer" -ForegroundColor Cyan
Write-Host "--------------------------------" -ForegroundColor Cyan

$RepoRoot = Resolve-MscRepoRoot -ModuleRoot $ModuleRoot -ProjectRoot $ProjectRoot
Write-Host "Target: $RepoRoot"
Write-Host ""

Write-Host "[0] Prerequisites..." -ForegroundColor Yellow
$prereqRoot = Join-Path (Split-Path $ModuleRoot -Parent) "google-api-proxy\prerequisites"
if (Test-Path $prereqRoot) {
  Install-MscPrerequisites -RepoRoot $RepoRoot -PrereqRoot $prereqRoot -WhatIf:$WhatIf
}

Write-Host "[1] scripts/ (deploy + SSH)..." -ForegroundColor Yellow
$scriptsSrc = Join-Path $ModuleRoot "scripts"
$scriptsDest = Join-Path $RepoRoot "scripts"
if ($WhatIf) {
  Write-Host "[WhatIf] Copy scripts tree from module"
} else {
  Copy-MscModuleTree -SourceDir $scriptsSrc -DestDir $scriptsDest
  Write-Host "  Copied hostinger-setup scripts into scripts/"
}

Write-Host "[2] .env.example..." -ForegroundColor Yellow
Merge-MscEnvFragment -RepoRoot $RepoRoot -ModuleRoot $ModuleRoot -MarkerKey "HOSTINGER_SSH_HOST" -WhatIf:$WhatIf

Write-Host "[3] package.json..." -ForegroundColor Yellow
Merge-MscPackageJson -RepoRoot $RepoRoot -MergeFilePath (Join-Path $ModuleRoot "package-scripts.json") -WhatIf:$WhatIf

Write-Host "[4] Cursor rules..." -ForegroundColor Yellow
Install-MscCursorAsset -RepoRoot $RepoRoot `
  -Source (Join-Path $ModuleRoot "rules\deploy-safety-hostinger.mdc") `
  -DestRelative ".cursor\rules\deploy-safety-hostinger.mdc" `
  -WhatIf:$WhatIf -Force:$Force
Install-MscCursorAsset -RepoRoot $RepoRoot `
  -Source (Join-Path $ModuleRoot "rules\jon-operator-hpanel.mdc.fragment") `
  -DestRelative ".cursor\rules\jon-operator-hpanel.mdc" `
  -WhatIf:$WhatIf -Force:$Force

Write-Host "[5] Agent prompts + docs..." -ForegroundColor Yellow
Install-MscCursorAsset -RepoRoot $RepoRoot `
  -Source (Join-Path $ModuleRoot "prompts\Push-Website-Live.md") `
  -DestRelative ".cursor\prompts\Push-Website-Live.md" `
  -WhatIf:$WhatIf -Force:$Force
Install-MscCursorAsset -RepoRoot $RepoRoot `
  -Source (Join-Path $ModuleRoot "docs\HOSTINGER-MODULE.md") `
  -DestRelative ".cursor\docs\HOSTINGER-MODULE.md" `
  -WhatIf:$WhatIf -Force:$Force
Install-MscCursorAsset -RepoRoot $RepoRoot `
  -Source (Join-Path $ModuleRoot "docs\PITFALLS-HOSTINGER.md") `
  -DestRelative ".cursor\docs\PITFALLS-HOSTINGER.md" `
  -WhatIf:$WhatIf -Force:$Force
Install-MscCursorAsset -RepoRoot $RepoRoot `
  -Source (Join-Path $ModuleRoot "docs\NEW-PROJECT-CHECKLIST.md") `
  -DestRelative ".cursor\docs\NEW-PROJECT-CHECKLIST.md" `
  -WhatIf:$WhatIf -Force:$Force

Write-Host ""
Write-Host "Verify" -ForegroundColor Cyan
$probe = Join-Path $RepoRoot "scripts\msc-hostinger-sync-app-ssh.mjs"
if (Test-Path $probe) {
  Write-Host "  OK scripts/msc-hostinger-sync-app-ssh.mjs" -ForegroundColor Green
} else {
  Write-Host "  FAIL scripts/msc-hostinger-sync-app-ssh.mjs" -ForegroundColor Red
  exit 1
}

Write-Host ""
Write-Host "Installation complete." -ForegroundColor Green
Write-Host "1. Fill FTP + SSH + HOSTINGER_API_TOKEN in .env.local"
Write-Host "2. npm run msc:test:hostinger-ftp"
Write-Host "3. Merge global.mdc.fragment into .cursor/rules/global.mdc (push it live shortcuts)"
Write-Host "4. Agent playbook: .cursor/custom-scriptz/hostinger-setup/CURSOR.md"
Write-Host ""
