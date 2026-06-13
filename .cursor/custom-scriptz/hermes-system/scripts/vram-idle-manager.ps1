# MyStudioChannel VRAM Idle Manager Daemon
# Usage: powershell -File scripts/vram-idle-manager.ps1 [-Daemon] [-UnloadNow]

param (
    [switch]$Daemon,
    [switch]$UnloadNow
)

$ErrorActionPreference = "SilentlyContinue"

# Path config
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptDir "..")
$stateFile = Join-Path $projectRoot ".vram-idle-state.json"
$idleLimitSeconds = 900 # 15 Minutes
$warningThreshold = 840 # 14 Minutes 

function Write-VramLog {
    param([string]$message, [string]$color = "Cyan")
    Write-Host "[MSC:VRAM-Manager] $message" -ForegroundColor $color
}

# Ensure state file exists with valid defaults
function Initialize-StateFile {
    if (-not (Test-Path $stateFile)) {
        $defaultState = @{
            LastActivityTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
            KeepModelOn = $false
        }
        $defaultState | ConvertTo-Json | Out-File $stateFile -Encoding utf8
    }
}

function Get-State {
    Initialize-StateFile
    try {
        $content = Get-Content $stateFile -Raw
        return $content | ConvertFrom-Json
    } catch {
        # Fallback if file corrupt or locked
        return @{ LastActivityTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ"); KeepModelOn = $false }
    }
}

function Get-LoadedModels {
    # lms ps returns list of loaded models. If it contains lines with model names, they are loaded.
    $output = lms ps 2>$null
    if ($null -eq $output) { return @() }
    
    $models = @()
    foreach ($line in $output) {
        $trimmed = $line.Trim()
        if (-not $trimmed -or $trimmed -match "^IDENTIFIER") { continue }
        
        # Capture first column/word as the model identifier
        if ($trimmed -match "^([a-zA-Z0-9_\-\.]+)") {
            $models += $Matches[1]
        }
    }
    return $models
}

function Speak-Notification {
    param([string]$text)
    # Check if the speak function is available in the current environment session
    if (Get-Command speak -ErrorAction SilentlyContinue) {
        speak $text 2>$null
    } else {
        # Python fallback if function not exported
        & "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\python.exe" -c "
        import sys, json, logging, subprocess
        logging.getLogger('tools.tts_tool').setLevel(logging.ERROR)
        logging.getLogger('tools.voice_mode').setLevel(logging.ERROR)
        sys.path.append(r'C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent')
        from tools.tts_tool import text_to_speech_tool
        from tools.voice_mode import play_audio_file

        text = sys.argv[1]
        try:
            res = json.loads(text_to_speech_tool(text))
            if res.get('success'):
                play_audio_file(res['file_path'])
        except Exception:
            pass
        " $text 2>$null
    }
}

# --- DIRECT UNLOAD NOW MODE ---
if ($UnloadNow) {
    Write-VramLog "Manual unload trigger received. Purging loaded models..." "Yellow"
    lms unload --all 2>$null
    Speak-Notification "Models successfully unloaded. VRAM has been reclaimed."
    Write-VramLog "✅ VRAM purged." "Green"
    exit 0
}

# --- DAEMON MONITORING LOOP ---
if ($Daemon) {
    Write-VramLog "Starting VRAM Idle Manager Daemon..." "Green"
    Initialize-StateFile
    
    $warnedThisPeriod = $false
    
    while ($true) {
        $state = Get-State
        $loadedModels = Get-LoadedModels
        
        if ($loadedModels.Count -eq 0) {
            # No models loaded, reset warning flag and idle check
            $warnedThisPeriod = $false
            Start-Sleep -Seconds 30
            continue
        }
        
        # We have models loaded! Let's check KeepModelOn override
        if ($state.KeepModelOn -eq $true) {
            Write-VramLog "Active models: $($loadedModels -join ', ') | Auto-unload disabled by override." "Yellow"
            $warnedThisPeriod = $false
            Start-Sleep -Seconds 30
            continue
        }
        
        # Calculate elapsed time
        $lastActivity = [DateTime]::Parse($state.LastActivityTime).ToUniversalTime()
        $now = (Get-Date).ToUniversalTime()
        $elapsedSeconds = ($now - $lastActivity).TotalSeconds
        
        $timeLeft = $idleLimitSeconds - $elapsedSeconds
        Write-VramLog "Active models: $($loadedModels -join ', ') | Idle for: $([Math]::Round($elapsedSeconds))s | Auto-unload in: $([Math]::Round($timeLeft))s" "Cyan"
        
        # Check warning threshold (between 14 and 15 mins)
        if ($elapsedSeconds -ge $warningThreshold -and $elapsedSeconds -lt $idleLimitSeconds) {
            if (-not $warnedThisPeriod) {
                Write-VramLog "Model idle limit approaching! Triggering verbal warning..." "Yellow"
                Speak-Notification "Warning: Model has been idle for fourteen minutes and will be unloaded shortly to conserve VRAM."
                $warnedThisPeriod = $true
            }
        }
        
        # Check unload threshold (>= 15 mins)
        if ($elapsedSeconds -ge $idleLimitSeconds) {
            Write-VramLog "Idle limit reached ($elapsedSeconds >= $idleLimitSeconds). Auto-unloading models..." "Red"
            lms unload --all 2>$null
            Speak-Notification "Model auto unloaded to free up system VRAM."
            $warnedThisPeriod = $false
            
            # Update last activity to avoid loop re-triggering immediately
            $state.LastActivityTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
            $state | ConvertTo-Json | Out-File $stateFile -Encoding utf8
        }
        
        Start-Sleep -Seconds 30
    }
} else {
    # Single run/status check
    $state = Get-State
    $loadedModels = Get-LoadedModels
    
    Write-VramLog "--- VRAM Status ---" "Green"
    Write-VramLog "Loaded Models:     $($loadedModels -join ', ')" "Cyan"
    Write-VramLog "Keep Model Loaded: $($state.KeepModelOn)" "Cyan"
    Write-VramLog "Last Activity:     $($state.LastActivityTime)" "Cyan"
    
    if ($loadedModels.Count -gt 0) {
        $lastActivity = [DateTime]::Parse($state.LastActivityTime).ToUniversalTime()
        $now = (Get-Date).ToUniversalTime()
        $elapsedSeconds = ($now - $lastActivity).TotalSeconds
        Write-VramLog "Idle Duration:     $([Math]::Round($elapsedSeconds)) seconds" "Cyan"
    }
}
