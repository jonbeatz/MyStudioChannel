# Jarvis Launcher — delegates to canonical repo script (no voice here)
# Canonical copy lives at repo scripts/start-hermes-api.ps1 — keep in sync.
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path (Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent) -Parent
$Launcher = Join-Path $RepoRoot "scripts\start-hermes-api.ps1"

if (-not (Test-Path $Launcher)) {
    Write-Error "Canonical launcher missing: $Launcher"
    exit 1
}

& powershell -ExecutionPolicy Bypass -File $Launcher
