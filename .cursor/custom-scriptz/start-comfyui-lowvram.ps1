# Start ComfyUI with --lowvram (optional, for OOM recovery)
$comfyRoot = "D:\AI_Models\ComfyUI"
$python = Join-Path $comfyRoot "python_embeded\python.exe"
$main = Join-Path $comfyRoot "ComfyUI\main.py"

if (-not (Test-Path $python)) {
    Write-Host "[FAIL] ComfyUI python not found at $python" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Starting ComfyUI with --lowvram..." -ForegroundColor Cyan
Start-Process -FilePath $python `
    -ArgumentList "-s", $main, "--windows-standalone-build", "--lowvram" `
    -WorkingDirectory $comfyRoot `
    -WindowStyle Minimized
