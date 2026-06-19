# start-mystudio.ps1
# J.A.R.V.I.S. Unified Workstation Stack Launcher
# VRAM pre-flight, dev stack, Kanban — ComfyUI is opt-in only.

$ErrorActionPreference = "Stop"

Clear-Host
Write-Host "=== MYSTUDIOCHANNEL WORKSTATION STACK LAUNCHER ===" -ForegroundColor Magenta

Write-Host ""
Write-Host "ComfyUI launch mode:" -ForegroundColor Cyan
Write-Host "  1. Full stack (no ComfyUI) — recommended" -ForegroundColor White
Write-Host "  2. Full stack + ComfyUI" -ForegroundColor White
Write-Host "  3. ComfyUI only" -ForegroundColor White
Write-Host "  4. Skip ComfyUI (same as 1)" -ForegroundColor White
Write-Host "  5. Enable ComfyUI idle watcher (15min suggestion daemon)" -ForegroundColor White
$comfyChoice = Read-Host "Enter 1-5 (default 1)"
if ([string]::IsNullOrWhiteSpace($comfyChoice)) { $comfyChoice = "1" }

$startComfy = $comfyChoice -in @("2", "3")
$comfyOnly = $comfyChoice -eq "3"
$startIdleWatcher = $comfyChoice -eq "5"

# Step 1: VRAM Pre-Flight Safeguard
Write-Host ""
Write-Host "[1/5] Checking VRAM status..." -ForegroundColor Cyan
& .\.cursor\custom-scriptz\vram-check.ps1
$vramExitCode = $LASTEXITCODE

if ($vramExitCode -ne 0) {
    Write-Host ""
    Write-Host "[WARN] High VRAM usage detected." -ForegroundColor Yellow
    Write-Host "   Option 1: Run cleanup now (stops LM Studio + ComfyUI python)" -ForegroundColor Cyan
    Write-Host "   Option 2: Continue anyway" -ForegroundColor Cyan
    Write-Host "   Option 3: Abort" -ForegroundColor Cyan
    $choice = Read-Host "Enter 1, 2, or 3"
    if ($choice -eq "1") {
        & .\.cursor\custom-scriptz\vram-cleanup.ps1
        Start-Sleep -Seconds 2
        & .\.cursor\custom-scriptz\vram-check.ps1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[WARN] VRAM still high after cleanup. Consider reboot or closing Brave/Cursor GPU tabs." -ForegroundColor Yellow
        }
    } elseif ($choice -ne "2") {
        Write-Host "[FAIL] Boot aborted." -ForegroundColor Red
        exit
    }
}

if ($comfyOnly) {
    Write-Host ""
    Write-Host "[ComfyUI] Starting ComfyUI only..." -ForegroundColor Cyan
    & .\.cursor\custom-scriptz\start-comfyui.ps1
    if ($startIdleWatcher) {
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File .\.cursor\custom-scriptz\comfy-idle-watcher.ps1 -Daemon" -WorkingDirectory "D:\Cursor_Projectz\MyStudioChannel" -WindowStyle Minimized
    }
    exit $LASTEXITCODE
}

if (-not $comfyOnly) {
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
}

# Step 4: ComfyUI (opt-in)
Write-Host ""
if ($startComfy) {
    Write-Host "[4/5] Starting ComfyUI (explicit request)..." -ForegroundColor Cyan
    & .\.cursor\custom-scriptz\start-comfyui.ps1
} else {
    Write-Host "[4/5] ComfyUI skipped (opt-in only). Use npm run msc:comfy:start when needed." -ForegroundColor DarkGray
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

if ($startIdleWatcher) {
    Write-Host ""
    Write-Host "[Optional] Starting ComfyUI idle watcher daemon..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File .\.cursor\custom-scriptz\comfy-idle-watcher.ps1 -Daemon" -WorkingDirectory "D:\Cursor_Projectz\MyStudioChannel" -WindowStyle Minimized
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

Start-Sleep -Seconds 5

foreach ($svc in $services) {
    $active = Get-NetTCPConnection -LocalPort $svc.Port -State Listen -ErrorAction SilentlyContinue
    if ($active) {
        Write-Host "   [OK] $($svc.Name) responding on Port $($svc.Port)" -ForegroundColor Green
    } else {
        $optional = ($svc.Port -eq 8188 -and -not $startComfy)
        if ($optional) {
            Write-Host "   [SKIP] $($svc.Name) not started (ComfyUI opt-in)" -ForegroundColor DarkGray
        } else {
            Write-Host "   [FAIL] $($svc.Name) NOT listening on Port $($svc.Port)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "STACK INITIALIZED!" -ForegroundColor Green
Write-Host "Dashboard: http://localhost:3000" -ForegroundColor Cyan
Write-Host "Kanban:    http://localhost:3005" -ForegroundColor Cyan
Write-Host "ComfyUI:   npm run msc:comfy:start (when needed)" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Magenta

Start-Process "http://localhost:3000"
