# MyStudioChannel Build & Start Dev Pipeline
# Runs type validation, builds production next, and then auto-spins the Next.js dev server in the background

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..")
Set-Location $repoRoot

function Write-MscLog {
    param([string]$message, [string]$color = "Cyan")
    Write-Host "[MSC:Build-Dev] $message" -ForegroundColor $color
}

Write-MscLog "Starting schema validation and production build..." "Cyan"
npm run build

Write-MscLog "Build completed successfully! Auto-launching development server on port 3000..." "Green"

# 1. Clear any active listeners on port 3000
npm run msc:kill-dev-port

# 2. Spawn Next.js development server as a background PowerShell Job
$existingJob = Get-Job -Name "NextDevServer" -ErrorAction SilentlyContinue
if ($existingJob) {
    Stop-Job -Name "NextDevServer" -ErrorAction SilentlyContinue
    Remove-Job -Name "NextDevServer" -ErrorAction SilentlyContinue
}

Start-Job -Name "NextDevServer" -ScriptBlock {
    Set-Location "D:\Cursor_Projectz\MyStudioChannel"
    npm run dev:quick
} | Out-Null

Write-MscLog "Next.js dev server is now active and compiling in the background." "Green"
Write-MscLog "Please wait 3-5 seconds for initialization, then click any of the links below to open:" "Yellow"
Write-Host ""
Write-Host "Live Workspace Links:" -ForegroundColor Green
Write-Host "  - Public Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "  - Payload CMS Admin Portal: http://localhost:3000/admin" -ForegroundColor White
Write-Host "  - Dev Email Previews: http://localhost:3000/dev/email-preview" -ForegroundColor White
Write-Host ""
