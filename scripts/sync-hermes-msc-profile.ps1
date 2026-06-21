# Sync MSC Hermes profile templates from repo -> %LOCALAPPDATA%\hermes\profiles\msc
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path $PSScriptRoot -Parent
$TemplateDir = Join-Path $PSScriptRoot 'hermes-profile\msc'
$ProfileHome = Join-Path $env:LOCALAPPDATA 'hermes\profiles\msc'

if (-not (Test-Path $TemplateDir)) {
    Write-Error "MSC profile templates not found: $TemplateDir"
}

New-Item -ItemType Directory -Path $ProfileHome -Force | Out-Null

foreach ($file in @('config.yaml', 'SOUL.md')) {
    $src = Join-Path $TemplateDir $file
    $dst = Join-Path $ProfileHome $file
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "[MSC profile] synced $file" -ForegroundColor Green
    }
}

exit 0
