function Invoke-HermesTTS {
    param([string]$text)
    if ($text.Trim()) {
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
    else:
        # If primary (Gemini/Orus) fails, automatically fall back to Sonia (Edge TTS)!
        # We print a clean diagnostic, switch to Sonia (Edge), speak, and restore Orus.
        print('🎙️ Gemini/Orus API limit hit. Seamlessly falling back to Sonia (Edge TTS)...', file=sys.stderr)
        
        # 1. Switch config to Sonia (Edge)
        subprocess.run(['hermes', 'config', 'set', 'tts.provider', 'edge'], stdout=subprocess.DEVNULL)
        subprocess.run(['hermes', 'config', 'set', 'tts.edge.voice', 'en-GB-SoniaNeural'], stdout=subprocess.DEVNULL)
        
        # 2. Retry generation with the free fallback
        res_fallback = json.loads(text_to_speech_tool(text))
        if res_fallback.get('success'):
            play_audio_file(res_fallback['file_path'])
            
        # 3. Restore config to Orus (Gemini)
        subprocess.run(['hermes', 'config', 'set', 'tts.provider', 'gemini'], stdout=subprocess.DEVNULL)
        subprocess.run(['hermes', 'config', 'set', 'tts.gemini.voice', 'Orus'], stdout=subprocess.DEVNULL)
except Exception as e:
    print('Error:', e, file=sys.stderr)
" $text 2>$null
    }
}

function test-voice {
    $text = $args -join " "
    Invoke-HermesTTS $text
}

function speak {
    $text = $args -join " "
    if (-not $text.Trim()) { return }
    
    # 1. Detect if the user wants to trigger our intelligent image generation pipeline
    $isImageTrigger = $text -match '^\s*(make|generate|draw|paint|create)\b.*\b(image|photo|background|picture|logo|art|rendering|canvas)\b'
    
    if ($isImageTrigger) {
        # Check if they requested widescreen or HD dimensions
        $w = 1024
        $h = 1024
        if ($text -match '\b(hd|widescreen|1920x1080|16:9|landscape)\b') {
            $w = 1920
            $h = 1080
        }
        
        # Extract prompt by stripping standard prefixes
        $cleanPrompt = $text -replace '^\s*(make|generate|draw|paint|create)\s+(me\s+)?(an?\s+)?(hd\s+)?(widescreen\s+)?(image|photo|background|picture|logo|art|rendering|painting|canvas)\s+(of\s+)?', ''
        
        # If the prompt ends with "widescreen" or "hd", strip those too
        $cleanPrompt = $cleanPrompt -replace '\b(in\s+)?(hd|widescreen|1920x1080|16:9|landscape)\b', ''
        $cleanPrompt = $cleanPrompt.Trim()
        
        # Invoke our new gen-image function!
        gen-image -prompt $cleanPrompt -Width $w -Height $h
        return
    }

    # 2. Detect if the input is an AI query ONLY if it starts with an AI question or instruction/action word
    $isAIQuery = $text -match '^\s*(how|what|why|who|where|when|can|could|should|would|will|is|are|do|does|did|tell|explain|write|create|analyze|review|suggest|check|run|test|get)\b'
    
    if ($isAIQuery) {
        # Touch VRAM Activity timestamp for AI reasoning tasks
        Update-VramActivity
        
        # Ensure a model is loaded for any local inference
        Ensure-ModelLoaded
        
        # Execute oneshot query with Hermes, display response, and speak it out loud
        $response = hermes -z $text
        Write-Host $response
        $cleanResponse = $response -join "`n"
        Invoke-HermesTTS $cleanResponse
    } else {
        # Directly speak the plain text without calling the LLM
        Invoke-HermesTTS $text
    }
}

# --- Edge TTS Voice Shortcuts ---
function set-voice-andrew {
    hermes config set tts.provider edge | Out-Null
    hermes config set tts.edge.voice en-US-AndrewMultilingualNeural | Out-Null
    Invoke-HermesTTS "Andrew is active."
    Write-Host "🎙️ Default voice set to Andrew (en-US-AndrewMultilingualNeural)" -ForegroundColor Cyan
}

function set-voice-sonia {
    hermes config set tts.provider edge | Out-Null
    hermes config set tts.edge.voice en-GB-SoniaNeural | Out-Null
    Invoke-HermesTTS "Sonia is active."
    Write-Host "🎙️ Default voice set to Sonia (en-GB-SoniaNeural)" -ForegroundColor Cyan
}

function set-voice-ryan {
    hermes config set tts.provider edge | Out-Null
    hermes config set tts.edge.voice en-GB-RyanNeural | Out-Null
    Invoke-HermesTTS "Ryan is active."
    Write-Host "🎙️ Default voice set to Ryan (en-GB-RyanNeural)" -ForegroundColor Cyan
}

# --- Gemini TTS Voice Shortcuts ---
function set-voice-orus {
    hermes config set tts.provider gemini | Out-Null
    hermes config set tts.gemini.voice Orus | Out-Null
    Invoke-HermesTTS "Orus is active."
    Write-Host "🎙️ Default voice set to Orus (Gemini - Orus)" -ForegroundColor Cyan
}

function set-voice-charon {
    hermes config set tts.provider gemini | Out-Null
    hermes config set tts.gemini.voice Charon | Out-Null
    Invoke-HermesTTS "Charon is active."
    Write-Host "🎙️ Default voice set to Charon (Gemini - Charon)" -ForegroundColor Cyan
}

function set-voice-zephyr {
    hermes config set tts.provider gemini | Out-Null
    hermes config set tts.gemini.voice Zephyr | Out-Null
    Invoke-HermesTTS "Zephyr is active."
    Write-Host "🎙️ Default voice set to Zephyr (Gemini - Zephyr)" -ForegroundColor Cyan
}

function set-voice-kore {
    hermes config set tts.provider gemini | Out-Null
    hermes config set tts.gemini.voice Kore | Out-Null
    Invoke-HermesTTS "Kore is active."
    Write-Host "🎙️ Default voice set to Kore (Gemini - Kore)" -ForegroundColor Cyan
}

# --- VRAM & Memory Lifecycle Helpers ---
function Update-VramActivity {
    $stateFile = "__PROJECT_ROOT__\.vram-idle-state.json"
    $timeStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    
    $keepOn = $false
    if (Test-Path $stateFile) {
        try {
            $json = Get-Content $stateFile -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
            if ($json -and $null -ne $json.KeepModelOn) {
                $keepOn = $json.KeepModelOn
            }
        } catch {}
    }
    
    $state = @{
        LastActivityTime = $timeStr
        KeepModelOn = $keepOn
    }
    $state | ConvertTo-Json | Out-File $stateFile -Encoding utf8 -ErrorAction SilentlyContinue
}

function Ensure-ModelLoaded {
    $models = lms ps 2>$null
    $hasModel = $false
    foreach ($line in $models) {
        if ($line -match "^\s*([a-zA-Z0-9_\-\.]+)\s*\|") {
            $hasModel = $true
            break
        }
    }
    if (-not $hasModel) {
        Write-Host "[J.A.R.V.I.S.] No active reasoning model found. Auto-loading Qwen 4B..." -ForegroundColor Yellow
        load-qwen
    }
}

# --- Mem0 J.A.R.V.I.S. Memory Layer Functions ---
function remember {
    $text = $args -join " "
    if (-not $text.Trim()) {
        Write-Warning "Usage: remember <text_to_store>"
        return
    }
    
    # Touch VRAM Activity timestamp & auto-load model if needed
    Update-VramActivity
    Ensure-ModelLoaded
    
    & "__PROJECT_ROOT__\scripts\mem0-chat.ps1" -Action "add" -Text $text
}

function recall {
    $query = $args -join " "
    if (-not $query.Trim()) {
        Write-Warning "Usage: recall <query_to_search>"
        return
    }
    
    # Touch VRAM Activity timestamp & auto-load model if needed
    Update-VramActivity
    Ensure-ModelLoaded
    
    & "__PROJECT_ROOT__\scripts\mem0-chat.ps1" -Action "search" -Query $query
}

# --- LM Studio CLI Model Switcher Functions ---
function load-qwen {
    Update-VramActivity
    lms load "qwen3-4b-instruct-2507"
    Write-Host "[OK] Qwen 4B loaded" -ForegroundColor Green
}

function load-deepseek {
    Update-VramActivity
    lms load "deepseek-coder-33b-instruct"
    Write-Host "[OK] DeepSeek 33B loaded" -ForegroundColor Green
}

function unload-model {
    lms unload --all
    Write-Host "[OK] Model unloaded" -ForegroundColor Yellow
}

function model-status {
    lms ps
}

# --- Manual Overrides & VRAM Controls ---
function keep-model-on {
    $stateFile = "__PROJECT_ROOT__\.vram-idle-state.json"
    $timeStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    $state = @{
        LastActivityTime = $timeStr
        KeepModelOn = $true
    }
    $state | ConvertTo-Json | Out-File $stateFile -Encoding utf8 -ErrorAction SilentlyContinue
    Invoke-HermesTTS "Auto-unload disabled. Keeping model loaded."
    Write-Host "[J.A.R.V.I.S.] Auto-unload disabled. Keeping model loaded indefinitely." -ForegroundColor Yellow
}

function keep-model-off {
    $stateFile = "__PROJECT_ROOT__\.vram-idle-state.json"
    $timeStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    $state = @{
        LastActivityTime = $timeStr
        KeepModelOn = $false
    }
    $state | ConvertTo-Json | Out-File $stateFile -Encoding utf8 -ErrorAction SilentlyContinue
    Invoke-HermesTTS "Auto-unload safety restored."
    Write-Host "[J.A.R.V.I.S.] Auto-unload safety restored. Models will unload after fifteen minutes of idle time." -ForegroundColor Green
}

function vram-status {
    powershell -File "__PROJECT_ROOT__\scripts\vram-idle-manager.ps1"
}

function vram-unload {
    powershell -File "__PROJECT_ROOT__\scripts\vram-idle-manager.ps1" -UnloadNow
}

function vram-daemon-start {
    $existing = Get-Job -Name "VramIdleManager" -ErrorAction SilentlyContinue
    if ($existing -and $existing.State -eq "Running") {
        Write-Host "[J.A.R.V.I.S.] VRAM Idle Manager Daemon is already running as background job." -ForegroundColor Yellow
        return
    }
    
    Start-Job -Name "VramIdleManager" -ScriptBlock {
        powershell -ExecutionPolicy Bypass -File "__PROJECT_ROOT__\scripts\vram-idle-manager.ps1" -Daemon
    } | Out-Null
    
    Invoke-HermesTTS "V RAM Idle Manager daemon started successfully."
    Write-Host "[OK] [J.A.R.V.I.S.] VRAM Idle Manager Daemon started as active background job." -ForegroundColor Green
}

function vram-daemon-stop {
    Stop-Job -Name "VramIdleManager" -ErrorAction SilentlyContinue
    Remove-Job -Name "VramIdleManager" -ErrorAction SilentlyContinue
    Invoke-HermesTTS "V RAM Idle Manager daemon stopped."
    Write-Host "[STOP] [J.A.R.V.I.S.] VRAM Idle Manager Daemon stopped." -ForegroundColor Red
}

# --- Free Image Generation Pipeline Function ---
function gen-image {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$prompt,

        [Parameter(Mandatory=$false)]
        [string]$Path,

        [Parameter(Mandatory=$false)]
        [int]$Width = 1024,

        [Parameter(Mandatory=$false)]
        [int]$Height = 1024
    )

    # 1. Touch VRAM activity timestamp so our auto-unload daemon is in sync
    Update-VramActivity

    # 2. Setup path if not passed
    $projectRoot = "__PROJECT_ROOT__"
    $outputArg = ""
    $resolvedPath = ""

    if ($Path) {
        $resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue
        if (-not $resolvedPath) { $resolvedPath = $Path }
        $outputArg = "--output", $resolvedPath
    } else {
        $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
        $mediaDir = Join-Path $projectRoot "public\media"
        if (-not (Test-Path $mediaDir)) {
            New-Item -ItemType Directory -Path $mediaDir -Force | Out-Null
        }
        $resolvedPath = Join-Path $mediaDir "generated-$timestamp.png"
        $outputArg = "--output", $resolvedPath
    }

    Write-Host "[J.A.R.V.I.S.] Generating image..." -ForegroundColor Yellow
    Write-Host "Prompt: $prompt" -ForegroundColor Cyan
    Write-Host "Dimensions: ${Width}x${Height}" -ForegroundColor Cyan

    $pythonPath = "C:\Users\JONBEATZ\AppData\Local\Programs\Python\Python312\python.exe"
    $scriptPath = Join-Path $projectRoot "scripts\generate-image.py"

    # 3. Call python image generation script
    $responseRaw = & $pythonPath $scriptPath --prompt $prompt --width $Width --height $Height $outputArg 2>$null

    if (-not $responseRaw) {
        Write-Error "No response received from image generation layer."
        return
    }

    try {
        $response = $responseRaw | ConvertFrom-Json
    } catch {
        Write-Host "[Raw Output] $responseRaw" -ForegroundColor Red
        Write-Error "Failed to parse JSON response from image generation layer."
        return
    }

    if ($response -and $response.success) {
        $file = $response.file_path
        Write-Host "[OK] [J.A.R.V.I.S.] Image successfully generated!" -ForegroundColor Green
        Write-Host "Saved to: $file" -ForegroundColor Green

        # 4. Speak confirmation
        Invoke-HermesTTS "Image generated, Jon. Opening it now."

        # 5. Automatically open the image in Windows native default photo viewer
        Start-Process $file
    } else {
        $err = $response.error
        Write-Host "[J.A.R.V.I.S. Error] $err" -ForegroundColor Red
        Invoke-HermesTTS "Excuse me, Jon. I encountered an error while generating your image."
    }
}

function hermes { & "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe" $args }
