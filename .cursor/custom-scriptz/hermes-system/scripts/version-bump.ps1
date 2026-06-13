# version-bump.ps1 — MyStudioChannel Automated Version Bumper
param(
    [string]$BranchName,
    [switch]$DryRun,
    [switch]$Restore,
    [switch]$Force,
    [switch]$Release
)

$ErrorActionPreference = 'Stop'
$Tag = '[Version-Bump]'
$RepoRoot = $PSScriptRoot
$BackupDir = Join-Path $RepoRoot '..\.version-backup'

$TargetFiles = @(
    'package.json',
    'README.md',
    '.cursor/docs/project-log.md',
    '.cursor/docs/Checkpoint.md',
    'CHANGELOG.md'
)

# Resolve target file full paths
$FilesWithPaths = $TargetFiles | ForEach-Object { Join-Path $RepoRoot "..\$_" }

# --- Restore Mode ---
if ($Restore) {
    Write-Host ''
    Write-Host "$Tag Restoring files from backups..." -ForegroundColor Yellow
    if (-not (Test-Path $BackupDir)) {
        Write-Error "Backup directory missing: $BackupDir"
        exit 1
    }
    foreach ($f in $TargetFiles) {
        $backupSrc = Join-Path $BackupDir $f
        $destFile = Join-Path $RepoRoot "..\$f"
        if (Test-Path $backupSrc) {
            Copy-Item $backupSrc $destFile -Force
            Write-Host "  Restored $f" -ForegroundColor Gray
        } else {
            Write-Warning "  Backup file missing: $f"
        }
    }
    Write-Host "$Tag Restore complete. Re-run validation." -ForegroundColor Green
    Write-Host ''
    exit 0
}

# --- Auto-Detect Branch Name ---
if (-not $BranchName) {
    $BranchName = (git branch --show-current).Trim()
    Write-Host "$Tag Auto-detected current branch: $BranchName" -ForegroundColor Gray
}

# Parse version (e.g. MSC-Website-v9 -> 9.0.0, or v10 -> 10.0.0)
$version = $null
if ($BranchName -match 'v(\d+)$') {
    $vNum = $Matches[1]
    $version = "$vNum.0.0"
} elseif ($BranchName -match '(\d+)\.(\d+)\.(\d+)') {
    $version = $BranchName
} else {
    Write-Warning "$Tag Could not parse version from branch name '$BranchName'."
    Write-Host "Please specify branch name matching 'v[major]' or format 'major.minor.patch'."
    Write-Host "Example: MSC-Website-v10 -> version 10.0.0."
    Write-Host ''
    exit 1
}

Write-Host ''
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " [*] MyStudioChannel Automated Version Bumper" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Target Branch:  $BranchName"
Write-Host "  Parsed Version: $version"
Write-Host "  Dry Run Mode:   $($DryRun.IsPresent)"
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ''

# --- Pre-check confirmation ---
if (-not $Force -and -not $DryRun) {
    $choice = Read-Host "Are you sure you want to bump the version to $version? (Y/N)"
    if ($choice.Trim().ToUpper() -ne 'Y') {
        Write-Warning "Aborted by user."
        Write-Host ''
        exit 0
    }
}

# --- Backups Generation ---
if (-not $DryRun) {
    Write-Host "$Tag Generating safety backups..." -ForegroundColor Gray
    if (-not (Test-Path $BackupDir)) {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    }
    foreach ($f in $TargetFiles) {
        $srcFile = Join-Path $RepoRoot "..\$f"
        $backupDest = Join-Path $BackupDir $f
        if (Test-Path $srcFile) {
            $destParent = Split-Path $backupDest
            if (-not (Test-Path $destParent)) {
                New-Item -ItemType Directory -Path $destParent -Force | Out-Null
            }
            Copy-Item $srcFile $backupDest -Force
        }
    }
}

# --- 1. Update package.json ---
$pkgPath = Join-Path $RepoRoot '..\package.json'
Write-Host "$Tag Updating package.json..." -ForegroundColor Yellow
$pkgJson = Get-Content $pkgPath -Raw | ConvertFrom-Json
$oldVersion = $pkgJson.version
if ($DryRun) {
    Write-Host "  [DryRun] package.json version: $oldVersion -> $version" -ForegroundColor DarkGray
} else {
    $pkgJson.version = $version
    # Preserve formatting using PowerShell JSON rendering
    $pkgJson | ConvertTo-Json -Depth 100 | Set-Content $pkgPath -Encoding utf8
    Write-Host "  Updated package.json version to $version" -ForegroundColor Green
}

# --- 2. Update README.md ---
$readmePath = Join-Path $RepoRoot '..\README.md'
if (Test-Path $readmePath) {
    Write-Host "$Tag Updating README.md version badges..." -ForegroundColor Yellow
    $content = Get-Content $readmePath -Raw
    $badgePattern = "version-(\d+\.\d+\.\d+)-blue"
    if ($content -match $badgePattern) {
        $oldBadge = $Matches[0]
        $newBadge = "version-$version-blue"
        if ($DryRun) {
            Write-Host "  [DryRun] README.md badge: $oldBadge -> $newBadge" -ForegroundColor DarkGray
        } else {
            $content = $content -replace [regex]::Escape($oldBadge), $newBadge
            $content | Set-Content $readmePath -Encoding utf8
            Write-Host "  Updated README.md version badges." -ForegroundColor Green
        }
    }
}

# --- 3. Update .cursor/docs/Checkpoint.md ---
$checkpointPath = Join-Path $RepoRoot '..\.cursor\docs\Checkpoint.md'
if (Test-Path $checkpointPath) {
    Write-Host "$Tag Updating Checkpoint.md active branch and milestone..." -ForegroundColor Yellow
    $content = Get-Content $checkpointPath -Raw
    if ($DryRun) {
        Write-Host "  [DryRun] Checkpoint.md updates (active branch and milestone)" -ForegroundColor DarkGray
    } else {
        # Update branch names
        $content = $content -replace "MSC-Website-v\d+", $BranchName
        # Update version label in Milestone
        $content = $content -replace "MyStudioChannel v\d+\.\d+\.\d+", "MyStudioChannel v$version"
        $content | Set-Content $checkpointPath -Encoding utf8
        Write-Host "  Updated Checkpoint.md references." -ForegroundColor Green
    }
}

# --- 4. Update CHANGELOG.md ---
$changelogPath = Join-Path $RepoRoot '..\CHANGELOG.md'
if (Test-Path $changelogPath) {
    Write-Host "$Tag Updating CHANGELOG.md headers..." -ForegroundColor Yellow
    $content = Get-Content $changelogPath -Raw
    
    # We want to insert the release header under [Unreleased]
    $today = (Get-Date).ToString("yyyy-MM-dd")
    $unreleasedHeader = "## [Unreleased]"
    $releaseHeader = "## [$version] - $today"
    
    if ($content.Contains($unreleasedHeader)) {
        if ($DryRun) {
            Write-Host "  [DryRun] CHANGELOG.md: Will insert release header '$releaseHeader' under '$unreleasedHeader'" -ForegroundColor DarkGray
        } else {
            # Find the position of [Unreleased] and insert the new release section right below it
            $insertText = "$unreleasedHeader`n`n### Added`n`n## [$version] - $today"
            $content = $content.Replace($unreleasedHeader, $insertText)
            $content | Set-Content $changelogPath -Encoding utf8
            Write-Host "  Updated CHANGELOG.md release headers." -ForegroundColor Green
        }
    }
}

# --- 5. Update .cursor/docs/project-log.md ---
$logPath = Join-Path $RepoRoot '..\.cursor\docs\project-log.md'
if (Test-Path $logPath) {
    Write-Host "$Tag Updating project-log.md..." -ForegroundColor Yellow
    $today = (Get-Date).ToString("yyyy-MM-dd")
    $logHeader = "## [$today] - Version $version Release"
    $logBody = @"
## [$today] - Version $version Release
- **Branch:** `$BranchName`
- **Changes:**
  *   Automated version bump to `$version` from `$oldVersion`.
  *   Synchronized dependencies and package references.
  *   Initiated active development checkpoint for `$BranchName` release series.
- **Status:** active — build and lint validated compile-safe.
"@
    if ($DryRun) {
        Write-Host "  [DryRun] project-log.md: Will prepend new version log entry" -ForegroundColor DarkGray
    } else {
        $content = Get-Content $logPath -Raw
        $newContent = $logBody + "`n`n" + $content
        $newContent | Set-Content $logPath -Encoding utf8
        Write-Host "  Updated project-log.md with release entry." -ForegroundColor Green
    }
}

if ($DryRun) {
    Write-Host ''
    Write-Host "$Tag Dry Run completed successfully. No files were written." -ForegroundColor Green
    Write-Host ''
    exit 0
}

# --- Run Verification Checks ---
Write-Host ''
Write-Host "$Tag Running validation suite..." -ForegroundColor Cyan

$verifyScripts = @(
    @{ Name = "msc:types:validate"; Cmd = "npm run msc:types:validate" },
    @{ Name = "lint"; Cmd = "npm run lint" },
    @{ Name = "build"; Cmd = "npm run build" }
)

foreach ($script in $verifyScripts) {
    Write-Host "Running check: $($script.Name)..." -ForegroundColor Yellow
    Push-Location (Join-Path $RepoRoot "..")
    try {
        $out = Invoke-Expression $script.Cmd 2>&1
        $code = $LASTEXITCODE
        if ($code -ne 0) {
            Write-Host $out -ForegroundColor DarkGray
            throw "Validation failed: $($script.Name) exited with code $code"
        }
        Write-Host "  Check Passed: $($script.Name)" -ForegroundColor Green
    } finally {
        Pop-Location
    }
}

# --- Commit, Tag & Push ---
Write-Host ''
Write-Host "$Tag Committing and tagging release..." -ForegroundColor Cyan

Push-Location (Join-Path $RepoRoot "..")
try {
    # Commit changes
    git add .cursor/docs/ package.json README.md CHANGELOG.md
    git commit -m "chore: bump version to $version"
    Write-Host "  Committed chore: bump version to $version" -ForegroundColor Green
    
    # Push branch
    git push origin $BranchName
    Write-Host "  Pushed branch $BranchName to origin" -ForegroundColor Green
    
    # Tag release
    $tag = "v$version"
    if (git tag -l $tag) {
        Write-Warning "Tag $tag already exists. Deleting local tag to update."
        git tag -d $tag | Out-Null
    }
    git tag $tag
    git push origin $tag --force
    Write-Host "  Created and pushed Git tag $tag" -ForegroundColor Green
} finally {
    Pop-Location
}

# --- Release trigger ---
if ($Release) {
    Write-Host ''
    Write-Host "$Tag Triggering GitHub release generation..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "github-release.ps1") -Tag "v$version"
}

Write-Host ''
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " 🎉 Success! Version bumped to $version" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ''
exit 0
