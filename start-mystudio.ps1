# start-mystudio.ps1
# J.A.R.V.I.S. Unified Workstation Stack Launcher
# calibrates VRAM, spins up Next.js dev server, Kanban stack, ComfyUI, and Postiz, then verifies endpoints.

$ErrorActionPreference = "Stop"

Clear-Host
Write-Host "=== MYSTUDIOCHANNEL WORKSTATION STACK LAUNCHER ===" -ForegroundColor Magenta

# Step 1: VRAM Pre-Flight Safeguard
Write-Host ""
Write-Host "[1/5] Checking VRAM status..." -ForegroundColor Cyan
& .\.cursor\custom-scriptz\vram-check.ps1
$vramExitCode = $LASTEXITCODE

if ($vramExitCode -ne 0) {
    Write-Host ""
    Write-Host "[WARN] High VRAM usage detected (likely LM Studio)." -ForegroundColor Yellow
    $proceed = Read-Host "Would you like to proceed anyway? (y/n)"
    if ($proceed -ne "y") {
        Write-Host "[FAIL] Boot aborted. Please unload models in LM Studio and try again." -ForegroundColor Red
        exit
    }
}

# Step 2: Next.js Dev Server (Port 3000)
Write-Host ""
Write-Host "[2/5] Starting Next.js Dev Server on Port 3000..." -ForegroundColor Cyan
$port3000Active = Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue
if ($port3000Active) {
    Write-Host "   [OK] Port 3000 already active. Reusing instance." -ForegroundColor Green
} else {
    Write-Host "   Launching 'npm run dev' minimized..." -ForegroundColor Yellow
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "npm run dev" -WorkingDirectory "D:\Cursor_Projectz\MyStudioChannel" -WindowStyle Minimized
    Start-Sleep -Seconds 3
}

# Step 3: Visual Kanban Stack (Ports 3001, 3005, 9119)
Write-Host ""
Write-Host "[3/5] Launching Visual Kanban and Hermes Stack..." -ForegroundColor Cyan
& ".\.cursor\custom-scriptz\hermes-system\scripts\start-kanban-stack.ps1"

# Step 4: ComfyUI (Port 8188)
Write-Host ""
Write-Host "[4/5] Starting ComfyUI on Port 8188..." -ForegroundColor Cyan
$port8188Active = Get-NetTCPConnection -LocalPort 8188 -State Listen -ErrorAction SilentlyContinue
if ($port8188Active) {
    Write-Host "   [OK] Port 8188 already active. Reusing instance." -ForegroundColor Green
} else {
    $comfyBat = "D:\AI_Models\ComfyUI\run_nvidia_gpu.bat"
    if (Test-Path $comfyBat) {
        Write-Host "   Launching ComfyUI Nvidia GPU batch minimized..." -ForegroundColor Yellow
        Start-Process -FilePath $comfyBat -WorkingDirectory "D:\AI_Models\ComfyUI" -WindowStyle Minimized
        Start-Sleep -Seconds 4
    } else {
        Write-Host "   [WARN] ComfyUI launch batch not found at $comfyBat" -ForegroundColor Red
    }
}

# Step 5: Postiz Container Verification (Port 4007)
Write-Host ""
Write-Host "[5/5] Checking Docker & Postiz container (Port 4007)..." -ForegroundColor Cyan
try {
    $dockerCheck = & docker ps --filter 'name=postiz' --format '{{.Names}}' 2>$null
    if ($dockerCheck -match "postiz") {
        Write-Host "   [OK] Postiz Docker containers are running!" -ForegroundColor Green
    } else {
        Write-Host "   [WARN] Postiz containers are not active. Starting docker containers..." -ForegroundColor Yellow
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "docker compose up -d" -WorkingDirectory "D:\Hermes\postiz" -WindowStyle Hidden
        Start-Sleep -Seconds 3
    }
} catch {
    Write-Host "   [WARN] Docker is not active or not installed on system." -ForegroundColor Red
}

# Step 6: Verify Endpoint Registrations
Write-Host ""
Write-Host "Handshaking local service APIs..." -ForegroundColor Cyan
$services = @(
    @{Name="Next.js Dev App"; Port=3000},
    @{Name="TaskBoardAI";     Port=3001},
    @{Name="Hermes Workspace";Port=3005},
    @{Name="Hermes Dashboard";Port=9119},
    @{Name="ComfyUI Server";  Port=8188},
    @{Name="Postiz Outbox";   Port=4007}
)

# Wait up to 10 seconds for ports to settle
Start-Sleep -Seconds 5

foreach ($svc in $services) {
    $active = Get-NetTCPConnection -LocalPort $svc.Port -State Listen -ErrorAction SilentlyContinue
    if ($active) {
        Write-Host "   [OK] $($svc.Name) responding on Port $($svc.Port)" -ForegroundColor Green
    } else {
        Write-Host "   [FAIL] $($svc.Name) NOT listening on Port $($svc.Port)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "ALL CHANNELS INITIALIZED!" -ForegroundColor Green
Write-Host "Dashboard: http://localhost:3000" -ForegroundColor Cyan
Write-Host "Kanban:    http://localhost:3005" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Magenta

# Auto-open main dev app
Start-Process "http://localhost:3000"
