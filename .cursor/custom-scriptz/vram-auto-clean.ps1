# vram-auto-clean.ps1
# J.A.R.V.I.S. Automated Memory Reclamation Trigger
# Intended for scheduled Task Scheduler runs (every 5 min).

try {
    $vramRaw = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()
    if ([string]::IsNullOrEmpty($vramRaw)) { exit 0 }

    $vram = [double]$vramRaw
    if ($vram -gt 12000) {
        Write-Host "[AUTO-CLEAN] VRAM threshold crossed ($vram MB). Stopping ComfyUI python..." -ForegroundColor Yellow
        Stop-Process -Name python, pythonw -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3

        if ($vram -gt 14000) {
            Write-Host "[AUTO-CLEAN] Still critical - stopping LM Studio..." -ForegroundColor Yellow
            Stop-Process -Name "LM Studio" -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 3
        }

        $vramAfter = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()
        Write-Host "[AUTO-CLEAN] Current VRAM: $vramAfter MB" -ForegroundColor Green
    }
} catch {
    # Fail-safe suppression
}
