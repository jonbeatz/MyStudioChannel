# docs-update.ps1 - MyStudioChannel Version Alignment Auditor
param(
    [string]$Version,
    [string]$BranchName
)

$ErrorActionPreference = 'Stop'
$Tag = '[Docs-Update]'
$RepoRoot = $PSScriptRoot

# --- Resolve inputs ---
$pkgPath = Join-Path $RepoRoot '..\package.json'
if (-not $Version) {
    if (Test-Path $pkgPath) {
        $pkg = [System.IO.File]::ReadAllText($pkgPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json
        $Version = $pkg.version
    } else {
        Write-Error "Could not resolve current version."
        exit 1
    }
}
if (-not $BranchName) {
    $BranchName = (git branch --show-current).Trim()
}

Write-Host ''
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " [Docs] MyStudioChannel Docs Version Alignment Auditor" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Target Version: $Version"
Write-Host "  Target Branch:  $BranchName"
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ''

$docsDir = Join-Path $RepoRoot '..\.cursor\docs'
$filesToCheck = @(
    (Join-Path $RepoRoot '..\README.md'),
    (Join-Path $docsDir 'START-HERE.md'),
    (Join-Path $docsDir 'Checkpoint.md'),
    (Join-Path $docsDir 'Restore-Points.md'),
    (Join-Path $docsDir 'project-log.md')
)

Write-Host "$Tag Auditing documentation alignment..." -ForegroundColor Gray

foreach ($f in $filesToCheck) {
    if (-not (Test-Path $f)) {
        Write-Warning "  File not found: $(Split-Path $f -Leaf)"
        continue
    }
    
    $content = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
    $modified = $false
    $name = Split-Path $f -Leaf

    # Check for version pattern mismatches
    if ($name -eq 'README.md') {
        # Update current version badge in README
        $badgePattern = "version-(\d+\.\d+\.\d+)-blue"
        if ($content -match $badgePattern) {
            $oldBadge = $Matches[0]
            if ($oldBadge -ne "version-$Version-blue") {
                $content = $content -replace [regex]::Escape($oldBadge), "version-$Version-blue"
                $modified = $true
                Write-Host "  Aligning README version badge -> $Version" -ForegroundColor Yellow
            }
        }
        # Update current version table row in README
        $tablePattern = "v\d+\.\d+\.\d+ \(\[Latest release\]"
        if ($content -match $tablePattern) {
            $oldTable = $Matches[0]
            if ($oldTable -ne "v$Version ([Latest release]") {
                $content = $content -replace [regex]::Escape($oldTable), "v$Version ([Latest release]"
                $modified = $true
                Write-Host "  Aligning README version table row -> $Version" -ForegroundColor Yellow
            }
        }
    }

    if ($name -eq 'Checkpoint.md') {
        # Update branch and version milestone in Checkpoint.md
        if ($content -match "MSC-Website-v\d+") {
            $oldB = $Matches[0]
            if ($oldB -ne $BranchName) {
                $content = $content -replace "MSC-Website-v\d+", $BranchName
                $modified = $true
                Write-Host "  Aligning Checkpoint branch -> $BranchName" -ForegroundColor Yellow
            }
        }
        if ($content -match "MyStudioChannel v\d+\.\d+\.\d+") {
            $oldV = $Matches[0]
            if ($oldV -ne "MyStudioChannel v$Version") {
                $content = $content -replace "MyStudioChannel v\d+\.\d+\.\d+", "MyStudioChannel v$Version"
                $modified = $true
                Write-Host "  Aligning Checkpoint milestone version -> $Version" -ForegroundColor Yellow
            }
        }
    }

    if ($modified) {
        [System.IO.File]::WriteAllText($f, $content, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host "  Successfully synchronized $name" -ForegroundColor Green
    } else {
        Write-Host "  OK - $name is aligned" -ForegroundColor Green
    }
}

Write-Host ''
Write-Host "$Tag Docs alignment complete. Running docs sync..." -ForegroundColor Gray
Push-Location (Join-Path $RepoRoot "..")
try {
    npm run msc:docs:sync
} finally {
    Pop-Location
}
Write-Host ''
exit 0
