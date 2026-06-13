# setup-hermes.ps1 — Full J.A.R.V.I.S. & Hermes Setup/Restore Environment Utility
# Enables quick deployment of speech, model switcher, memory, and image pipelines on a fresh Windows system.

param(
    [string]$ProjectRoot,
    [switch]$WhatIf,
    [switch]$SkipProfile,
    [switch]$InstallPythonDeps
)

$ErrorActionPreference = "Stop"
$ScriptRoot = $PSScriptRoot

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " 🪐 J.A.R.V.I.S. & Hermes Environment Setup Utility" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Use this utility to fully configure Hermes Agent and integrate J.A.R.V.I.S."
Write-Host "voice commands, model switcher, and image generation pipelines on a fresh system."
Write-Host ""

# Determine Project Root
if (-not $ProjectRoot) {
    # Move up past '.cursor/custom-scriptz/hermes-system' to find repo root
    $ProjectRoot = Split-Path (Split-Path (Split-Path (Split-Path $ScriptRoot -Parent) -Parent) -Parent) -Parent
}
$resolvedRoot = Resolve-Path $ProjectRoot -ErrorAction SilentlyContinue
if (-not $resolvedRoot) { $resolvedRoot = $ProjectRoot }
Write-Host "Target Project Root: $resolvedRoot" -ForegroundColor Yellow

# [1] Set up Directories
Write-Host ""
Write-Host "[1] Checking folder structures..." -ForegroundColor Green
$globalHermesDir = "C:\Users\JONBEATZ\AppData\Local\hermes"
if (-not (Test-Path $globalHermesDir)) {
    if ($WhatIf) {
        Write-Host "[WhatIf] Create folder: $globalHermesDir"
    } else {
        New-Item -ItemType Directory -Path $globalHermesDir -Force | Out-Null
        Write-Host "Created global directory: $globalHermesDir" -ForegroundColor Gray
    }
} else {
    Write-Host "Global directory already exists: $globalHermesDir" -ForegroundColor Gray
}

# [2] Restore Global configuration
Write-Host ""
Write-Host "[2] Restoring global config.yaml from template..." -ForegroundColor Green
$templateFile = Join-Path $ScriptRoot "config.yaml.template"
$configFile = Join-Path $globalHermesDir "config.yaml"

if (-not (Test-Path $templateFile)) {
    Write-Error "Template config file missing: $templateFile"
    exit 1
}

if ($WhatIf) {
    Write-Host "[WhatIf] Copy: $templateFile -> $configFile"
} else {
    Copy-Item $templateFile $configFile -Force
    Write-Host "Config file copied and restored to: $configFile" -ForegroundColor Gray
    Write-Host "  -> Active Model Provider: Vertex AI via local LiteLLM Proxy (port 4000)"
    Write-Host "  -> Default TTS Voice: Ryan Neural (Edge TTS Fallback)"
}

# [3] Python Executable Check and Virtual Env Setup instructions
Write-Host ""
Write-Host "[3] Validating python virtual environment..." -ForegroundColor Green
$pythonPath = "C:\Users\JONBEATZ\AppData\Local\Programs\Python\Python312\python.exe"
$venvDir = Join-Path $globalHermesDir "hermes-agent\venv"
$venvPython = Join-Path $venvDir "Scripts\python.exe"

if (-not (Test-Path $pythonPath)) {
    Write-Host "⚠️ System Python 3.12 was not found at expected path: $pythonPath" -ForegroundColor Yellow
    Write-Host "Please ensure Python 3.12 is installed and register it, or update path references in profile template."
} else {
    Write-Host "System Python 3.12 verified at: $pythonPath" -ForegroundColor Gray
    
    # Check if hermes virtual environment exists
    if (-not (Test-Path $venvPython)) {
        Write-Host "Hermes agent virtual env missing at $venvDir" -ForegroundColor Yellow
        Write-Host "Creating virtual environment at $venvDir..." -ForegroundColor Yellow
        if (-not $WhatIf) {
            New-Item -ItemType Directory -Path (Split-Path $venvDir) -Force -ErrorAction SilentlyContinue | Out-Null
            & $pythonPath -m venv $venvDir
            Write-Host "Virtual environment created successfully!" -ForegroundColor Green
        }
    } else {
        Write-Host "Hermes agent virtual env verified at: $venvDir" -ForegroundColor Gray
    }
}

# [4] Install Python Dependencies
if ($InstallPythonDeps) {
    Write-Host ""
    Write-Host "[4] Installing required J.A.R.V.I.S. Python dependencies..." -ForegroundColor Green
    if (Test-Path $venvPython) {
        if ($WhatIf) {
            Write-Host "[WhatIf] Run pip install inside Hermes virtualenv"
        } else {
            Write-Host "Installing packages inside Hermes venv: huggingface_hub pillow python-dotenv mem0ai sentence-transformers..."
            & $venvPython -m pip install huggingface_hub pillow python-dotenv mem0ai sentence-transformers
            Write-Host "Dependencies installed successfully!" -ForegroundColor Green
        }
    } else {
        Write-Host "⚠️ Cannot install packages. Hermes virtual env not configured yet." -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "[4] Python dependencies instructions (Run manually or use -InstallPythonDeps):" -ForegroundColor Green
    Write-Host "  To manually setup pipelines, run this in your active environment:" -ForegroundColor Yellow
    Write-Host "  & \"$pythonPath\" -m pip install huggingface_hub pillow python-dotenv mem0ai sentence-transformers" -ForegroundColor Gray
}

# [5] Restore PowerShell Profile Integrations
if (-not $SkipProfile) {
    Write-Host ""
    Write-Host "[5] Integrating J.A.R.V.I.S. custom commands into PowerShell profile..." -ForegroundColor Green
    
    $profileTemplateFile = Join-Path $ScriptRoot "profile-functions.template.ps1"
    if (-not (Test-Path $profileTemplateFile)) {
        Write-Error "Profile functions template missing: $profileTemplateFile"
        exit 1
    }

    # Locate profile file (standard profile is in $PROFILE)
    $profilePath = $PROFILE
    $profileDir = Split-Path $profilePath
    
    if ($WhatIf) {
        Write-Host "[WhatIf] Target Profile: $profilePath"
    } else {
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        if (-not (Test-Path $profilePath)) {
            New-Item -ItemType File -Path $profilePath -Force | Out-Null
        }
    }

    # Backup existing profile
    if (Test-Path $profilePath) {
        $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
        $backupPath = "$profilePath.backup-$timestamp"
        if ($WhatIf) {
            Write-Host "[WhatIf] Backup existing profile to: $backupPath"
        } else {
            Copy-Item $profilePath $backupPath -Force
            Write-Host "Backup of current profile created at: $backupPath" -ForegroundColor Gray
        }
    }

    # Load and process the template (replace __PROJECT_ROOT__)
    $escapedRoot = $resolvedRoot.ToString().Replace('\', '\\')
    $templateContent = Get-Content $profileTemplateFile -Raw
    $processedContent = $templateContent.Replace("__PROJECT_ROOT__", $resolvedRoot.ToString())

    # Check if J.A.R.V.I.S. functions are already present to avoid duplicates
    $existingProfileText = ""
    if (Test-Path $profilePath) {
        $existingProfileText = Get-Content $profilePath -Raw
    }

    if ($existingProfileText -match "function speak\s*\{") {
        Write-Host "⚠️ J.A.R.V.I.S. profile functions appear to already be integrated into: $profilePath" -ForegroundColor Yellow
        Write-Host "If you want to update them, please clean the block from your profile or restore the backup first."
    } else {
        if ($WhatIf) {
            Write-Host "[WhatIf] Appending J.A.R.V.I.S. profile functions template to: $profilePath"
        } else {
            Add-Content -Path $profilePath -Value "`n# ==========================================================`n# 🪐 J.A.R.V.I.S. & Hermes System Integration Functions`n# ==========================================================`n" | Out-Null
            Add-Content -Path $profilePath -Value $processedContent | Out-Null
            Write-Host "J.A.R.V.I.S. system-wide shortcuts successfully injected into profile!" -ForegroundColor Green
            Write-Host "Injected functions: speak, remember, recall, gen-image, load-qwen, load-deepseek, keep-model-on/off, etc." -ForegroundColor Gray
        }
    }
} else {
    Write-Host ""
    Write-Host "[5] Appending J.A.R.V.I.S. to PowerShell Profile skipped (-SkipProfile specified)." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🎉 Environment Setup complete!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "To complete the setup:"
Write-Host "1. Restart this PowerShell terminal window to load your updated Profile commands."
Write-Host "2. Verify speech is active: test-voice \"Hello Jon, J.A.R.V.I.S. is online.\""
Write-Host "3. Start LM Studio and run LiteLLM (npm run start google-api) on port 4000."
Write-Host "4. Type 'speak how does NextJS work?' to test the conversational reasoning link."
Write-Host ""
