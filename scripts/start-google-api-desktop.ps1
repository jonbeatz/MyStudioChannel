# Delegates to portable Hermes google-api home (D:\Hermes\custom-scriptz\google-api)
$HermesStart = 'D:\Hermes\custom-scriptz\google-api\scripts\start-google-api-desktop.ps1'
if (-not (Test-Path $HermesStart)) {
    throw "Hermes google-api not found. Run: D:\Hermes\custom-scriptz\google-api\install-from-msc.ps1"
}
& $HermesStart @args
