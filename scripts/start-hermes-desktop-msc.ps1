# Launch Hermes Desktop with MyStudioChannel as the project root
$ErrorActionPreference = 'Stop'

$MscRoot = 'D:\Cursor_Projectz\MyStudioChannel'
$HermesExe = Join-Path $env:LOCALAPPDATA 'hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe'

if (-not (Test-Path $MscRoot)) {
    Write-Error "MyStudioChannel path not found: $MscRoot"
}

if (-not (Test-Path $HermesExe)) {
    Write-Error "Hermes Desktop not found: $HermesExe"
}

# Desktop backend reads this file first (more reliable than config.yaml alone)
$projectDirFile = Join-Path $env:APPDATA 'Hermes\project-dir.json'
$payload = @{ dir = $MscRoot } | ConvertTo-Json
New-Item -ItemType Directory -Path (Split-Path $projectDirFile) -Force | Out-Null
Set-Content -Path $projectDirFile -Value $payload -Encoding utf8

$env:HERMES_DESKTOP_CWD = $MscRoot
Start-Process -FilePath $HermesExe -WorkingDirectory $MscRoot
