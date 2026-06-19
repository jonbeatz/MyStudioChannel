# vram-cleanup.ps1
# Programmatic J.A.R.V.I.S. Emergency VRAM Reclamation Suite

Write-Host "🚨 INITIATING EMERGENCY VRAM RECLAMATION..." -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Red

# Step 1: Forcefully terminate ComfyUI
Write-Host "`n[1/3] Terminating ComfyUI and Python environments..." -ForegroundColor Yellow
$pyProcs = Get-Process python, pythonw -ErrorAction SilentlyContinue
if ($pyProcs) {
    Write-Host "   Stopping $($pyProcs.Count) Python process(es)..." -ForegroundColor DarkYellow
    Stop-Process -Name python, pythonw -Force -ErrorAction SilentlyContinue
    Write-Host "   ✅ Python processes terminated." -ForegroundColor Green
} else {
    Write-Host "   (No active Python processes detected)." -ForegroundColor DarkGray
}

# Step 2: Forcefully terminate LM Studio
Write-Host "`n[2/3] Terminating LM Studio environment..." -ForegroundColor Yellow
$lmsProcs = Get-Process "LM Studio" -ErrorAction SilentlyContinue
if ($lmsProcs) {
    Write-Host "   Stopping $($lmsProcs.Count) LM Studio process(es)..." -ForegroundColor DarkYellow
    Stop-Process -Name "LM Studio" -Force -ErrorAction SilentlyContinue
    Write-Host "   ✅ LM Studio processes terminated." -ForegroundColor Green
} else {
    Write-Host "   (No active LM Studio processes detected)." -ForegroundColor DarkGray
}

# Step 3: Wait for WDDM to release VRAM after process exit
Write-Host "`n[3/3] Waiting for GPU memory release..." -ForegroundColor Yellow
Write-Host "   (Windows WDDM: VRAM frees when compute processes exit; --gpu-reset is Linux-only.)" -ForegroundColor DarkGray
Start-Sleep -Seconds 3

# Final VRAM Status Check
Write-Host ""
$vramUsed = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()
$vramTotal = (nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits).Trim()
$vramPercent = [math]::Round(([double]$vramUsed / [double]$vramTotal) * 100, 1)

Write-Host "🎮 Post-Cleanup VRAM Status: $vramUsed MB / $vramTotal MB ($vramPercent%)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Red
