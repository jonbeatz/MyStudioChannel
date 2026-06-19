# MyStudioChannel Visual Kanban Stack - Unified Launcher
# Launches TaskBoardAI (3001), Hermes Workspace (3005), Hermes Dashboard (9119) as hidden background processes.

$ErrorActionPreference = "Stop"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  J.A.R.V.I.S. Visual Kanban Stack - Cold-Boot Sequence" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Start TaskBoardAI on Port 3001 (D:\Hermes\TaskBoardAI)
$port3001Active = Get-NetTCPConnection -LocalPort 3001 -State Listen, Established -ErrorAction SilentlyContinue
if ($port3001Active) {
    Write-Host "[TaskBoardAI] Port 3001 already active. Reusing instance." -ForegroundColor Green
} else {
    Write-Host "[TaskBoardAI] Starting Server on Port 3001 (hidden background)..." -ForegroundColor Yellow
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "npm run start:all" -WorkingDirectory "D:\Hermes\TaskBoardAI" -WindowStyle Hidden
    # Wait for startup confirmation
    $timeout = 20
    while ($timeout -gt 0 -and -not (Get-NetTCPConnection -LocalPort 3001 -State Listen, Established -ErrorAction SilentlyContinue)) {
        Start-Sleep -Seconds 1
        $timeout--
    }
    if (Get-NetTCPConnection -LocalPort 3001 -State Listen, Established -ErrorAction SilentlyContinue) {
        Write-Host "[TaskBoardAI] Online! Running on http://localhost:3001" -ForegroundColor Green
    } else {
        Write-Host "[TaskBoardAI] Warning: Launcher spawned, but Port 3001 did not respond in 20s." -ForegroundColor Red
    }
}

# 2. Start Hermes Workspace on Port 3005 (D:\Hermes\hermes-workspace)
$port3005Active = Get-NetTCPConnection -LocalPort 3005 -State Listen, Established -ErrorAction SilentlyContinue
if ($port3005Active) {
    Write-Host "[Hermes Workspace] Port 3005 already active. Reusing instance." -ForegroundColor Green
} else {
    Write-Host "[Hermes Workspace] Starting Server on Port 3005 (hidden background)..." -ForegroundColor Yellow
    if (Test-Path "D:\Hermes\hermes-workspace") {
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "npm run dev" -WorkingDirectory "D:\Hermes\hermes-workspace" -WindowStyle Hidden
        
        $timeout = 20
        while ($timeout -gt 0 -and -not (Get-NetTCPConnection -LocalPort 3005 -State Listen, Established -ErrorAction SilentlyContinue)) {
            Start-Sleep -Seconds 1
            $timeout--
        }
        if (Get-NetTCPConnection -LocalPort 3005 -State Listen, Established -ErrorAction SilentlyContinue) {
            Write-Host "[Hermes Workspace] Online! Running on http://localhost:3005" -ForegroundColor Green
        } else {
            Write-Host "[Hermes Workspace] Started, checking port status..." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[Hermes Workspace] Warning: D:\Hermes\hermes-workspace directory not found!" -ForegroundColor Red
    }
}

# 3. Start Hermes Dashboard on Port 9119 if not active
$port9119Active = Get-NetTCPConnection -LocalPort 9119 -State Listen, Established -ErrorAction SilentlyContinue
if ($port9119Active) {
    Write-Host "[Hermes Dashboard] Port 9119 already active. Reusing instance." -ForegroundColor Green
} else {
    Write-Host "[Hermes Dashboard] Starting Dashboard on Port 9119 (Hidden background)..." -ForegroundColor Yellow
    $hermesExe = "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe"
    if (Test-Path $hermesExe) {
        Start-Process -FilePath $hermesExe -ArgumentList "dashboard --no-open --port 9119" -WindowStyle Hidden
        $timeout = 10
        while ($timeout -gt 0 -and -not (Get-NetTCPConnection -LocalPort 9119 -State Listen, Established -ErrorAction SilentlyContinue)) {
            Start-Sleep -Seconds 1
            $timeout--
        }
        if (Get-NetTCPConnection -LocalPort 9119 -State Listen, Established -ErrorAction SilentlyContinue) {
            Write-Host "[Hermes Dashboard] Online! Running on http://localhost:9119" -ForegroundColor Green
        } else {
            Write-Host "[Hermes Dashboard] Started background service." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[Hermes Dashboard] Warning: hermes.exe not found. Dashboard skipped." -ForegroundColor Red
    }
}

# 4. Final handshake
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  ✅ ALL SYSTEM CHANNELS ONLINE!" -ForegroundColor Green
Write-Host "  👉 TaskBoardAI Planning Console:  http://localhost:3001" -ForegroundColor Cyan
Write-Host "  👉 Hermes Visual Kanban Board:   http://localhost:3005" -ForegroundColor Cyan
Write-Host "  👉 Hermes Agent Dashboard:        http://localhost:9119" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
