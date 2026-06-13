# github-release.ps1 — MyStudioChannel Automated GitHub Release Creator
param(
    [string]$Tag
)

$ErrorActionPreference = 'Stop'
$Prefix = '[GH-Release]'
$RepoRoot = $PSScriptRoot

# --- Auto-Detect Tag ---
if (-not $Tag) {
    $pkgPath = Join-Path $RepoRoot '..\package.json'
    if (Test-Path $pkgPath) {
        $pkg = Get-Content $pkgPath -Raw | ConvertFrom-Json
        $Tag = "v$($pkg.version)"
    } else {
        Write-Error "Could not find package.json to resolve version tag."
        exit 1
    }
}

Write-Host ''
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " [GH] MyStudioChannel GitHub Release Automator" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Target Tag:  $Tag"
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ''

# --- Check GH CLI availability ---
$gh = Get-Command gh -ErrorAction SilentlyContinue
if (-not $gh) {
    Write-Warning "$Prefix GitHub CLI 'gh' is not installed or available on system PATH."
    Write-Warning "$Prefix Please install 'gh' from https://cli.github.com/ to automate releases."
    Write-Host ''
    exit 1
}

# --- Check GH auth status ---
Write-Host "$Prefix Checking GitHub authentication..." -ForegroundColor Gray
$auth = & gh auth status 2>&1 | Out-String
if ($auth -match "Logged in to") {
    Write-Host "  GitHub authenticated successfully!" -ForegroundColor Green
} else {
    Write-Warning "$Prefix You are not logged in to GitHub CLI. Please run 'gh auth login' inside a terminal."
    Write-Host ''
    exit 1
}

# --- Create GitHub Release ---
Write-Host "$Prefix Creating GitHub release for tag $Tag..." -ForegroundColor Yellow
Push-Location (Join-Path $RepoRoot "..")
try {
    # Check if release already exists
    $existing = & gh release view $Tag 2>&1 | Out-String
    if ($existing -match "tag:") {
        Write-Warning "Release for tag $Tag already exists on GitHub. Skipping recreation."
        Write-Host ''
        exit 0
    }

    # Create release
    & gh release create $Tag --generate-notes
    Write-Host "  GitHub Release $Tag successfully published!" -ForegroundColor Green
} catch {
    Write-Error "Failed to create GitHub release: $($_.Exception.Message)"
    exit 1
} finally {
    Pop-Location
}

Write-Host ''
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " 🎉 GitHub Release completed successfully!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ''
exit 0
