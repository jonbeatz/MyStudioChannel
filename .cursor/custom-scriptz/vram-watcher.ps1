# vram-watcher.ps1
# Programmatic J.A.R.V.I.S. Continuous VRAM Telemetry Daemon

$logPath = "D:\Cursor_Projectz\MyStudioChannel\vram-log.txt"
Write-Host "📡 VRAM Telemetry Daemon Active. Logging alerts to: $logPath" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to terminate watcher daemon." -ForegroundColor DarkCyan

while ($true) {
    try {
        $vramRaw = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits).Trim()
        if ([string]::IsNullOrEmpty($vramRaw)) {
            Start-Sleep -Seconds 30
            continue
        }

        $vram = [double]$vramRaw
        if ($vram -gt 10000) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $alertMsg = "[$timestamp] ⚠️ WARNING: High VRAM allocation: $vram MB"
            Write-Host $alertMsg -ForegroundColor Yellow
            
            # Append log entry to vram-log.txt
            "$alertMsg" | Out-File -FilePath $logPath -Append -Encoding utf8
        }
    } catch {
        # Silent fail to ensure daemon doesn't terminate on temporary driver queries
    }
    Start-Sleep -Seconds 30
}
