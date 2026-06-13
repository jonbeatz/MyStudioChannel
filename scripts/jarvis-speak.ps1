# J.A.R.V.I.S. TTS — profile-independent (works in Cursor agent shells)
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Text
)

$ErrorActionPreference = "Stop"
$Tag = '[J.A.R.V.I.S.]'

$pythonPath = "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\python.exe"
$hermesRoot = "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent"

if (-not (Test-Path $pythonPath)) {
    Write-Warning "$Tag Hermes Python not found at: $pythonPath"
    Write-Warning "$Tag Run: .cursor/custom-scriptz/hermes-system/scripts/setup-hermes.ps1 -InstallPythonDeps"
    exit 1
}

if (-not $Text.Trim()) {
    Write-Warning "$Tag No text provided for speech synthesis."
    exit 1
}

$env:JARVIS_SPEAK_TEXT = $Text

$result = & $pythonPath -c @"
import json, logging, os, sys
logging.getLogger('tools.tts_tool').setLevel(logging.ERROR)
logging.getLogger('tools.voice_mode').setLevel(logging.ERROR)
sys.path.append(r'$hermesRoot')
from tools.tts_tool import text_to_speech_tool
from tools.voice_mode import play_audio_file

text = os.environ.get('JARVIS_SPEAK_TEXT', '').strip()
if not text:
    print(json.dumps({'success': False, 'error': 'empty text'}))
    sys.exit(1)
try:
    res = json.loads(text_to_speech_tool(text))
    if res.get('success'):
        play_audio_file(res['file_path'])
        print(json.dumps({'success': True, 'provider': res.get('provider'), 'file_path': res.get('file_path')}))
    else:
        print(json.dumps({'success': False, 'error': res.get('error', 'tts failed')}))
        sys.exit(1)
except Exception as e:
    print(json.dumps({'success': False, 'error': str(e)}))
    sys.exit(1)
"@ 2>&1

Remove-Item Env:JARVIS_SPEAK_TEXT -ErrorAction SilentlyContinue

if ($LASTEXITCODE -ne 0) {
    Write-Warning "$Tag Speech synthesis failed."
    if ($result) { Write-Host $result -ForegroundColor Yellow }
    exit 1
}

try {
    $parsed = $result | ConvertFrom-Json
    if ($parsed.success) {
        Write-Host "$Tag Voice active ($($parsed.provider))." -ForegroundColor Green
        exit 0
    }
} catch {
    if ($LASTEXITCODE -eq 0) { exit 0 }
}

Write-Warning "$Tag Unexpected TTS response: $result"
exit 1
