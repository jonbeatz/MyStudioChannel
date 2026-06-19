# vram-check.ps1
# Programmatic J.A.R.V.I.S. VRAM Collision Guard

$vramUsedRaw = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()
$vramTotalRaw = (nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits).Trim()

if ([string]::IsNullOrEmpty($vramUsedRaw) -or [string]::IsNullOrEmpty($vramTotalRaw)) {
    Write-Host "⚠️  WARNING: nvidia-smi failed to respond. Skipping hardware threshold check." -ForegroundColor Yellow
    exit 0
}

$vramUsed = [double]$vramUsedRaw
$vramTotal = [double]$vramTotalRaw
$vramPercent = [math]::Round(($vramUsed / $vramTotal) * 100, 1)

Write-Host "🎮 VRAM Status: $vramUsed MB / $vramTotal MB ($vramPercent%)" -ForegroundColor Cyan

if ($vramUsed -gt 10000) {
    Write-Host "⚠️  WARNING: High VRAM usage detected ($vramUsed MB)" -ForegroundColor Yellow
    Write-Host "   Check if LM Studio is running with Qwen 3.6 35B MoE loaded" -ForegroundColor Yellow
    Write-Host "   Consider unloading model before starting ComfyUI" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ VRAM available for ComfyUI operations" -ForegroundColor Green
    exit 0
}
