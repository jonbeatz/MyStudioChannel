# MyStudioChannel Visual Kanban Stack - Graceful Teardown Script
# Stops TaskBoardAI (Port 3001) and Hermes Workspace (Port 3005) cleanly

Write-Host "================================================================" -ForegroundColor Red
Write-Host "  Stopping J.A.R.V.I.S. Visual Kanban Stack..." -ForegroundColor Red
Write-Host "================================================================" -ForegroundColor Red

# 1. Kill Port 3001
$con3001 = Get-NetTCPConnection -LocalPort 3001 -ErrorAction SilentlyContinue
if ($con3001) {
    Write-Host "[TaskBoardAI] Terminating process on Port 3001..." -ForegroundColor Yellow
    foreach ($c in $con3001) {
        Stop-Process -Id $c.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    Write-Host "[TaskBoardAI] Offline." -ForegroundColor Green
} else {
    Write-Host "[TaskBoardAI] Port 3001 is already free." -ForegroundColor Gray
}

# 2. Kill Port 3005
$con3005 = Get-NetTCPConnection -LocalPort 3005 -ErrorAction SilentlyContinue
if ($con3005) {
    Write-Host "[Hermes Workspace] Terminating process on Port 3005..." -ForegroundColor Yellow
    foreach ($c in $con3005) {
        Stop-Process -Id $c.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    Write-Host "[Hermes Workspace] Offline." -ForegroundColor Green
} else {
    Write-Host "[Hermes Workspace] Port 3005 is already free." -ForegroundColor Gray
}

# 3. Kill Port 9119 (Hermes Embedded Dashboard if active)
$con9119 = Get-NetTCPConnection -LocalPort 9119 -ErrorAction SilentlyContinue
if ($con9119) {
    Write-Host "[Hermes Dashboard] Terminating process on Port 9119..." -ForegroundColor Yellow
    foreach ($c in $con9119) {
        Stop-Process -Id $c.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    Write-Host "[Hermes Dashboard] Offline." -ForegroundColor Green
}

Write-Host "================================================================" -ForegroundColor Red
Write-Host "  ✅ ALL KANBAN CHANNELS STOPPED." -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Red
