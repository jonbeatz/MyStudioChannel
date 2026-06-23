# Delegates to portable Hermes deepseek-api home (D:\Hermes\projects\_core-scripts\deepseek-api)
$HermesStop = 'D:\Hermes\projects\_core-scripts\deepseek-api\scripts\stop-deepseek.ps1'
if (-not (Test-Path $HermesStop)) {
    throw "deepseek-api not found."
}
& powershell -NoProfile -ExecutionPolicy Bypass -File $HermesStop @args
