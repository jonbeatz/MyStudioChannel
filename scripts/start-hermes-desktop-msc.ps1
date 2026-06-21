# Launch Hermes Desktop with MyStudioChannel as the project root (one-click)
$ErrorActionPreference = 'Stop'

$MscRoot = 'D:\Cursor_Projectz\MyStudioChannel'
$ProfileName = 'msc'
$HermesExe = Join-Path $env:LOCALAPPDATA 'hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe'
$HermesAppData = Join-Path $env:APPDATA 'Hermes'

if (-not (Test-Path $MscRoot)) {
    Write-Error "MyStudioChannel path not found: $MscRoot"
}

if (-not (Test-Path $HermesExe)) {
    Write-Error "Hermes Desktop not found: $HermesExe"
}

# Sync profile config from repo templates into Hermes profile home
$syncScript = Join-Path $MscRoot 'scripts\sync-hermes-msc-profile.ps1'
if (Test-Path $syncScript) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $syncScript
}

New-Item -ItemType Directory -Path $HermesAppData -Force | Out-Null

# Desktop backend: project working directory
$projectDirFile = Join-Path $HermesAppData 'project-dir.json'
@{ dir = $MscRoot } | ConvertTo-Json | Set-Content -Path $projectDirFile -Encoding utf8

# Desktop backend: Hermes CLI profile (isolated from default/jonbeatz)
$activeProfileFile = Join-Path $HermesAppData 'active-profile.json'
@{ profile = $ProfileName } | ConvertTo-Json | Set-Content -Path $activeProfileFile -Encoding utf8

Write-Host "[MSC] project-dir  -> $MscRoot" -ForegroundColor Cyan
Write-Host "[MSC] active-profile -> $ProfileName" -ForegroundColor Cyan
Write-Host "[MSC] Launching Hermes Desktop..." -ForegroundColor Green

$env:HERMES_DESKTOP_CWD = $MscRoot
Start-Process -FilePath $HermesExe -WorkingDirectory $MscRoot
