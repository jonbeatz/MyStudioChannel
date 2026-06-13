# Jarvis Launcher — Start Google API, Wait, and Speak Greeting (Windows 11)
$ErrorActionPreference = "Stop"

# 1. Start the Google API Proxy (LiteLLM + ngrok) in the background
Write-Host "[J.A.R.V.I.S.] Initializing Google API Proxy (LiteLLM + ngrok)..." -ForegroundColor Cyan
npm run msc:google-api:start | Out-Null

# 2. Wait for LiteLLM to boot on port 4000
Write-Host "[J.A.R.V.I.S.] Waiting for server connection on port 4000..." -ForegroundColor Yellow
$timeoutSeconds = 15
$elapsed = 0
$ready = $false

while ($elapsed -lt $timeoutSeconds) {
    $connection = Test-NetConnection -ComputerName "127.0.0.1" -Port 4000 -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        $ready = $true
        break
    }
    Start-Sleep -Seconds 1
    $elapsed++
}

# 3. Wait 2 seconds for system/tunnel stabilization
if ($ready) {
    Write-Host "[J.A.R.V.I.S.] Connection detected. Stabilizing system..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
}

# 4. Trigger Vocal Greeting with error suppression
if (Get-Command speak -ErrorAction SilentlyContinue) {
    speak "Welcome back Jon, I am J.A.R.V.I.S. your personal assistant. All systems are fully functional. How may I assist you today?" 2>$null
} else {
    # Bulletproof fallback to run Python synthesis directly if profile isn't loaded in the current scope
    & "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\python.exe" -c "
import sys, json, logging
logging.getLogger('tools.tts_tool').setLevel(logging.ERROR)
logging.getLogger('tools.voice_mode').setLevel(logging.ERROR)
sys.path.append(r'C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent')
from tools.tts_tool import text_to_speech_tool
from tools.voice_mode import play_audio_file

text = 'Welcome back Jon, I am J.A.R.V.I.S. your personal assistant. All systems are fully functional. How may I assist you today?'
try:
    res = json.loads(text_to_speech_tool(text))
    if res.get('success'):
        play_audio_file(res['file_path'])
except Exception:
    pass
" 2>$null
}

if ($ready) {
    Write-Host "[J.A.R.V.I.S.] Systems active and ready. API proxy is online on port 4000!" -ForegroundColor Green
} else {
    Write-Warning "[J.A.R.V.I.S.] Startup complete, but port 4000 did not respond in time."
}
