# MyStudioChannel Payload Types Sync Engine
# Usage: powershell -File scripts/payload-types-sync.ps1 [-Watch] [-Validate] [-PreCommit]

param (
    [switch]$Watch,
    [switch]$Validate,
    [switch]$PreCommit
)

$ErrorActionPreference = "Stop"

# Helper to find project root directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptDir "..")
Set-Location $projectRoot

function Write-MscLog {
    param([string]$message, [string]$color = "Cyan")
    Write-Host "[MSC:TypeSync] $message" -ForegroundColor $color
}

# --- 1. WATCH MODE ---
if ($Watch) {
    Write-MscLog "Starting interactive schema watcher..." "Green"
    Write-MscLog "Watching 'collections/', 'globals/', and 'payload.config.ts' for modifications..." "Yellow"

    # Setup FileSystemWatcher objects
    $watchPaths = @(
        (Join-Path $projectRoot "collections"),
        (Join-Path $projectRoot "globals")
    )
    
    $watchers = @()

    foreach ($path in $watchPaths) {
        if (Test-Path $path) {
            $watcher = New-Object System.IO.FileSystemWatcher
            $watcher.Path = $path
            $watcher.Filter = "*.ts"
            $watcher.IncludeSubdirectories = $true
            $watcher.EnableRaisingEvents = $true
            $watchers += $watcher
        }
    }

    # Watch payload.config.ts file directly in parent directory
    $configWatcher = New-Object System.IO.FileSystemWatcher
    $configWatcher.Path = $projectRoot
    $configWatcher.Filter = "payload.config.ts"
    $configWatcher.EnableRaisingEvents = $true
    $watchers += $configWatcher

    # Throttling helper to prevent multiple quick compilations
    $lastRun = [DateTime]::MinValue
    $throttleMs = 2000

    $action = {
        $changePath = $Event.SourceEventArgs.FullPath
        $now = [DateTime]::Now
        if (($now - $lastRun).TotalMilliseconds -gt $throttleMs) {
            $global:lastRun = $now
            Write-Host ""
            Write-MscLog "Detected change in: $changePath" "Yellow"
            Write-MscLog "Recompiling database schemas & types..." "Yellow"
            try {
                npm run msc:generate:types
                Write-MscLog "Type generation successful!" "Green"
            } catch {
                Write-MscLog "Type generation failed! Check schema errors." "Red"
            }
        }
    }

    # Bind events
    foreach ($w in $watchers) {
        Register-ObjectEvent $w "Changed" -Action $action | Out-Null
        Register-ObjectEvent $w "Created" -Action $action | Out-Null
        Register-ObjectEvent $w "Deleted" -Action $action | Out-Null
    }

    Write-MscLog "Watcher active! Press Ctrl+C to stop." "Green"

    # Infinite loop to keep process running
    while ($true) {
        Start-Sleep -Seconds 1
    }
}

# --- 2. VALIDATION MODE ---
elseif ($Validate) {
    Write-MscLog "Starting schema type-safety validation..." "Green"
    
    # 1. Clean verify build or directly run schema compile
    Write-MscLog "Generating current schemas..." "Yellow"
    npm run msc:generate:types

    # 2. Check if git diff shows changes in payload-types.ts
    Write-MscLog "Analyzing changes on payload-types.ts..." "Yellow"
    $diff = git diff --name-only payload-types.ts

    if ($diff) {
        Write-MscLog "❌ VALIDATION FAILED: payload-types.ts is out of sync with your collections or globals schemas!" "Red"
        Write-MscLog "Please commit the newly compiled payload-types.ts file." "Red"
        exit 1
    } else {
        Write-MscLog "✅ VALIDATION PASSED: database types are fully synchronized!" "Green"
        exit 0
    }
}

# --- 3. PRE-COMMIT HOOK MODE ---
elseif ($PreCommit) {
    Write-MscLog "Husky Pre-Commit Checklist running..." "Cyan"

    # Get list of staged files
    $stagedFiles = git diff --cached --name-only

    # Check if any staged files belong to schemas or configuration
    $schemaChanges = $stagedFiles | Where-Object {
        $_ -like "collections/*" -or 
        $_ -like "globals/*" -or 
        $_ -eq "payload.config.ts"
    }

    if ($schemaChanges) {
        Write-MscLog "Detected staged changes to CMS schemas:" "Yellow"
        foreach ($file in $schemaChanges) {
            Write-MscLog "  - $file" "Cyan"
        }
        
        Write-MscLog "Auto-compiling database types before commit..." "Yellow"
        try {
            npm run msc:generate:types
            
            # Auto-stage the updated payload-types.ts file
            git add payload-types.ts
            Write-MscLog "✅ Re-staged payload-types.ts cleanly." "Green"
        } catch {
            Write-MscLog "❌ Type generation failed. Aborting commit." "Red"
            exit 1
        }
    } else {
        Write-MscLog "No schema modifications detected. Skipping type re-compilation." "Green"
    }
    exit 0
}

# --- NO OPTION SPECIFIED ---
else {
    Write-MscLog "No option specified. Use -Watch, -Validate, or -PreCommit." "Red"
    exit 1
}
