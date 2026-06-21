# Delegates to portable Hermes google-api home (LiteLLM + ngrok only)
$HermesStop = 'D:\Hermes\custom-scriptz\google-api\scripts\stop-google-api-desktop.ps1'
if (-not (Test-Path $HermesStop)) {
    throw "Hermes google-api not found. Run: D:\Hermes\custom-scriptz\google-api\install-from-msc.ps1"
}
& $HermesStop @args
