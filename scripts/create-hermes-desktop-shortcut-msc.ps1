# Ensure Desktop shortcut exists with Hermes icon (idempotent)
$ErrorActionPreference = 'Stop'

$MscRoot = 'D:\Cursor_Projectz\MyStudioChannel'
$Launcher = Join-Path $MscRoot 'scripts\start-hermes-desktop-msc.ps1'
$desktop = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktop 'Hermes - MyStudioChannel.lnk'
$HermesExe = Join-Path $env:LOCALAPPDATA 'hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe'

$shell = New-Object -ComObject WScript.Shell
$lnk = $shell.CreateShortcut($shortcutPath)
$lnk.TargetPath = 'powershell.exe'
$lnk.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$Launcher`""
$lnk.WorkingDirectory = $MscRoot
$lnk.Description = 'Hermes Desktop — MyStudioChannel (msc profile)'
if (Test-Path $HermesExe) {
    $lnk.IconLocation = "$HermesExe,0"
}
$lnk.Save()

Write-Host "[MSC] Desktop shortcut ready: $shortcutPath" -ForegroundColor Green
