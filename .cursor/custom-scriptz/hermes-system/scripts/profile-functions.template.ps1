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
        # Extract prompt by stripping standard prefixes
        $cleanPrompt = $text -replace '^\s*(make|generate|draw|paint|create)\s+(me\s+)?(an?\s+)?(hd\s+)?(widescreen\s+)?(image|photo|background|picture|logo|art|rendering|painting|canvas)\s+(of\s+)?', ''
        
        # If the prompt ends with "widescreen" or "hd", strip those too
        $cleanPrompt = $cleanPrompt -replace '\b(in\s+)?(hd|widescreen|1920x1080|16:9|landscape)\b', ''
        $cleanPrompt = $cleanPrompt.Trim()
        
        # Invoke our new gen-image function and let it handle size parsing!
        gen-image -prompt $cleanPrompt
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
        [int]$Width = $null,

        [Parameter(Mandatory=$false)]
        [int]$Height = $null
    )

    # 1. Touch VRAM activity timestamp so our auto-unload daemon is in sync
    Update-VramActivity

    # 1b. Dimension parsing from prompt hints
    $w = 1920
    $h = 1080

    if ($prompt -match '\b(4k|4K|ultra hd|ultra HD)\b') {
        # Hugging Face serverless API limit is max 2048x2048. Scale 4K/ultra-hd widescreen to the absolute max 16:9 bounds.
        $w = 2048
        $h = 1152
    } elseif ($prompt -match '\b(hd|HD|1080p|1080P|widescreen)\b') {
        $w = 1920
        $h = 1080
    } elseif ($prompt -match '\b(vertical|phone|9:16)\b') {
        $w = 1080
        $h = 1920
    } elseif ($prompt -match '\b(1024x768|4:3)\b') {
        $w = 1024
        $h = 768
    }

    # Override with explicitly passed parameters if provided
    if ($null -ne $Width -and $Width -gt 0) {
        $w = $Width
    }
    if ($null -ne $Height -and $Height -gt 0) {
        $h = $Height
    }

    # 2. Setup path if not passed
    $projectRoot = "__PROJECT_ROOT__"
    $outputArg = ""
    $resolvedPath = ""

    if ($Path) {
        $resolvedPath = [System.IO.Path]::GetFullPath($Path)
        $outputArg = "--output", $resolvedPath
    } else {
        $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
        $mediaDir = Join-Path $projectRoot "public\media"
        if (-not (Test-Path $mediaDir)) {
            New-Item -ItemType Directory -Path $mediaDir -Force | Out-Null
        }
        $resolvedPath = Join-Path $mediaDir "generated-$timestamp.png"
        $resolvedPath = [System.IO.Path]::GetFullPath($resolvedPath)
        $outputArg = "--output", $resolvedPath
    }

    Write-Host "[J.A.R.V.I.S.] Generating image..." -ForegroundColor Yellow
    Write-Host "Prompt: $prompt" -ForegroundColor Cyan
    Write-Host "Dimensions: ${w}x${h}" -ForegroundColor Cyan

    $pythonPath = "C:\Users\JONBEATZ\AppData\Local\Programs\Python\Python312\python.exe"
    $scriptPath = Join-Path $projectRoot "scripts\generate-image.py"

    # 3. Call python image generation script
    $responseRaw = & $pythonPath $scriptPath --prompt $prompt --width $w --height $h $outputArg 2>$null

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
        
        # Resolve the clean absolute path for Start-Process to avoid any weird formatting
        $cleanFile = Resolve-Path $file -ErrorAction SilentlyContinue
        if ($cleanFile) {
            $file = $cleanFile.ProviderPath
        } else {
            $file = [System.IO.Path]::GetFullPath($file)
        }

        # Ensure full UTF-8 emoji support in the console host so emojis don't render as '??' and break link parsing
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        $displayFile = $file.Replace('\', '/')

        Write-Host "[OK] [J.A.R.V.I.S.] Image successfully generated!" -ForegroundColor Green
        Write-Host "Saved to: $file" -ForegroundColor Green

        # 4. Speak confirmation
        Invoke-HermesTTS "Image generated, opening now."

        # 5. Automatically open the image in Windows native default photo viewer
        Start-Process -FilePath $file
    } else {
        $err = $response.error
        Write-Host "[J.A.R.V.I.S. Error] $err" -ForegroundColor Red
        Invoke-HermesTTS "Excuse me, Jon. I encountered an error while generating your image."
    }
}

function hermes { & "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe" $args }

# === ComfyUI Functions (New, Separate from gen-image) ===

function Start-ComfyUI {
    $port = 8188
    $url = "http://127.0.0.1:$port"
    Write-Host "[ComfyUI] Checking ComfyUI server status..." -ForegroundColor Cyan
    
    $tcp = New-Object System.Net.Sockets.TcpClient
    $connected = $false
    try {
        $tcp.Connect("127.0.0.1", $port)
        $connected = $true
        $tcp.Close()
    } catch {
        # Not running
    }

    if ($connected) {
        Write-Host "[ComfyUI] Server is already running on port $port." -ForegroundColor Green
        return $true
    }

    Write-Host "[ComfyUI] Server is not running. Starting ComfyUI Portable minimized..." -ForegroundColor Yellow
    $comfyDir = "D:\AI_Models\ComfyUI"
    $batPath = Join-Path $comfyDir "run_nvidia_gpu.bat"
    
    if (-not (Test-Path $batPath)) {
        Write-Error "ComfyUI executable batch file not found at: $batPath"
        return $false
    }

    # Start minimized background process
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "cd /d `"$comfyDir`" && $batPath" -WindowStyle Minimized

    # Poll until server responds
    Write-Host "[ComfyUI] Waiting for server to boot up on port $port (this may take up to 30 seconds)..." -ForegroundColor Yellow
    $timeout = 40
    $elapsed = 0
    while ($elapsed -lt $timeout) {
        Start-Sleep -Seconds 2
        $elapsed += 2
        $tcp = New-Object System.Net.Sockets.TcpClient
        try {
            $tcp.Connect("127.0.0.1", $port)
            $connected = $true
            $tcp.Close()
            break
        } catch {
            # Still booting
        }
    }

    if ($connected) {
        Write-Host "[ComfyUI] Server successfully booted and is listening on port $port!" -ForegroundColor Green
        return $true
    } else {
        Write-Error "Timed out waiting for ComfyUI server to start on port $port." -ForegroundColor Red
        return $false
    }
}

function Invoke-ComfyPrompt {
    param(
        [Parameter(Mandatory=$true)] [string]$WorkflowPath,
        [Parameter(Mandatory=$true)] [hashtable]$Overrides,
        [Parameter(Mandatory=$true)] [string]$FinalOutputPath
    )

    if (-not (Start-ComfyUI)) { return }

    # 1. Read Workflow Template
    if (-not (Test-Path $WorkflowPath)) {
        Write-Error "Workflow template not found at: $WorkflowPath"
        return
    }
    
    # Read as raw string and parse JSON
    $workflowRaw = Get-Content -Path $WorkflowPath -Raw
    try {
        $workflow = $workflowRaw | ConvertFrom-Json
    } catch {
        Write-Error "Failed to parse workflow template JSON."
        return
    }

    # 2. Apply Overrides
    foreach ($key in $Overrides.Keys) {
        $val = $Overrides[$key]
        $parts = $key.Split('.')
        $nodeId = $parts[0]
        $inputKey = $parts[1]
        
        if ($workflow.$nodeId -and $workflow.$nodeId.inputs) {
            $workflow.$nodeId.inputs.$inputKey = $val
        }
    }

    # Convert back to JSON payload
    $payloadJson = $workflow | ConvertTo-Json -Depth 100 -Compress
    $wrappedPayload = @{ prompt = $workflow } | ConvertTo-Json -Depth 100 -Compress

    # 3. Post to ComfyUI
    Write-Host "[ComfyUI] Submitting prompt payload to server..." -ForegroundColor Cyan
    $headers = @{ "Content-Type" = "application/json" }
    
    try {
        $response = Invoke-RestMethod -Uri "http://127.0.0.1:8188/prompt" -Method Post -Body $wrappedPayload -Headers $headers
        $promptId = $response.prompt_id
        Write-Host "[ComfyUI] Prompt successfully queued! ID: $promptId" -ForegroundColor Green
    } catch {
        Write-Error "Failed to queue ComfyUI prompt: $_"
        return
    }

    # 4. Poll /history for Completion
    Write-Host "[ComfyUI] Running generation. Polling for completion..." -ForegroundColor Yellow
    $completed = $false
    while (-not $completed) {
        Start-Sleep -Seconds 2
        try {
            $history = Invoke-RestMethod -Uri "http://127.0.0.1:8188/history/$promptId" -Method Get
            if ($history -and $history.$promptId) {
                $completed = $true
                $promptOutput = $history.$promptId
                break
            }
        } catch {
            Write-Warning "Error polling ComfyUI history API: $_"
        }
    }

    # 5. Retrieve output file
    $comfyOutputDir = "D:\AI_Models\ComfyUI\ComfyUI\output"
    
    $outputImages = @()
    if ($promptOutput.outputs) {
        foreach ($prop in $promptOutput.outputs.PSObject.Properties) {
            if ($prop.Value.images) {
                $outputImages += $prop.Value.images
            }
        }
    }

    if ($outputImages -and $outputImages.Count -gt 0) {
        $filename = $outputImages[0].filename
        $comfyFile = Join-Path $comfyOutputDir $filename
        
        if (Test-Path $comfyFile) {
            $targetDir = [System.IO.Path]::GetDirectoryName($FinalOutputPath)
            if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
            
            Copy-Item -Path $comfyFile -Destination $FinalOutputPath -Force
            return $FinalOutputPath
        }
    }

    Write-Error "Could not locate generated ComfyUI output image file in: $comfyOutputDir"
    return $null
}

function edit-image {
    param(
        [Parameter(Mandatory=$true)] [string]$InputPath,
        [Parameter(Mandatory=$true)] [string]$Prompt,
        [string]$OutputPath = "",
        [float]$Strength = 0.75
    )

    Write-Host "🤖 [J.A.R.V.I.S.] Initializing image-to-image editing workflow..." -ForegroundColor Green
    Write-Host "Prompt: $Prompt" -ForegroundColor Green
    Write-Host "Strength: $Strength" -ForegroundColor Green

    $resolvedInput = Resolve-Path $InputPath -ErrorAction SilentlyContinue
    if (-not $resolvedInput) {
        Write-Error "Input image path not found: $InputPath"
        return
    }
    $resolvedInputPath = $resolvedInput.ProviderPath

    $comfyInputFolder = "D:\AI_Models\ComfyUI\ComfyUI\input"
    if (-not (Test-Path $comfyInputFolder)) { New-Item -ItemType Directory -Path $comfyInputFolder -Force | Out-Null }
    
    $inputFileName = [System.IO.Path]::GetFileName($resolvedInputPath)
    $comfyInputPath = Join-Path $comfyInputFolder $inputFileName
    Copy-Item -Path $resolvedInputPath -Destination $comfyInputPath -Force

    if ([string]::IsNullOrEmpty($OutputPath)) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $projectRoot = "D:\Cursor_Projectz\MyStudioChannel"
        $OutputPath = Join-Path $projectRoot "public\media\edited-$timestamp.png"
    }
    $absoluteOutput = [System.IO.Path]::GetFullPath($OutputPath)

    $overrides = @{
        "4.text" = $Prompt
        "6.image" = $inputFileName
        "8.denoise" = $Strength
    }

    $workflowFile = "D:\AI_Models\ComfyUI\workflows\img2img.json"
    
    $resultFile = Invoke-ComfyPrompt -WorkflowPath $workflowFile -Overrides $overrides -FinalOutputPath $absoluteOutput

    if ($resultFile) {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        Write-Host "[OK] [J.A.R.V.I.S.] Image successfully edited!" -ForegroundColor Green
        Write-Host "Saved to: $resultFile" -ForegroundColor Green

        Invoke-HermesTTS "Image edited, opening now."
        Start-Process -FilePath $resultFile
    } else {
        Invoke-HermesTTS "Excuse me, Jon. I encountered an error while editing your image."
    }
}

function inpaint-image {
    param(
        [Parameter(Mandatory=$true)] [string]$InputPath,
        [Parameter(Mandatory=$true)] [string]$MaskPath,
        [Parameter(Mandatory=$true)] [string]$Prompt,
        [string]$OutputPath = ""
    )

    Write-Host "🤖 [J.A.R.V.I.S.] Initializing inpainting workflow..." -ForegroundColor Green
    Write-Host "Prompt: $Prompt" -ForegroundColor Green

    $resolvedInput = Resolve-Path $InputPath -ErrorAction SilentlyContinue
    if (-not $resolvedInput) {
        Write-Error "Input image path not found: $InputPath"
        return
    }
    $resolvedInputPath = $resolvedInput.ProviderPath

    $resolvedMask = Resolve-Path $MaskPath -ErrorAction SilentlyContinue
    if (-not $resolvedMask) {
        Write-Error "Mask image path not found: $MaskPath"
        return
    }
    $resolvedMaskPath = $resolvedMask.ProviderPath

    $comfyInputFolder = "D:\AI_Models\ComfyUI\ComfyUI\input"
    if (-not (Test-Path $comfyInputFolder)) { New-Item -ItemType Directory -Path $comfyInputFolder -Force | Out-Null }

    $inputFileName = [System.IO.Path]::GetFileName($resolvedInputPath)
    $maskFileName = [System.IO.Path]::GetFileName($resolvedMaskPath)
    
    Copy-Item -Path $resolvedInputPath -Destination (Join-Path $comfyInputFolder $inputFileName) -Force
    Copy-Item -Path $resolvedMaskPath -Destination (Join-Path $comfyInputFolder $maskFileName) -Force

    if ([string]::IsNullOrEmpty($OutputPath)) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $projectRoot = "D:\Cursor_Projectz\MyStudioChannel"
        $OutputPath = Join-Path $projectRoot "public\media\inpainted-$timestamp.png"
    }
    $absoluteOutput = [System.IO.Path]::GetFullPath($OutputPath)

    $overrides = @{
        "4.text" = $Prompt
        "6.image" = $inputFileName
        "11.image" = $maskFileName
    }

    $workflowFile = "D:\AI_Models\ComfyUI\workflows\inpaint.json"

    $resultFile = Invoke-ComfyPrompt -WorkflowPath $workflowFile -Overrides $overrides -FinalOutputPath $absoluteOutput

    if ($resultFile) {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        Write-Host "[OK] [J.A.R.V.I.S.] Inpainting successfully completed!" -ForegroundColor Green
        Write-Host "Saved to: $resultFile" -ForegroundColor Green

        Invoke-HermesTTS "Image inpainting completed, opening now."
        Start-Process -FilePath $resultFile
    } else {
        Invoke-HermesTTS "Excuse me, Jon. I encountered an error while inpainting your image."
    }
}
