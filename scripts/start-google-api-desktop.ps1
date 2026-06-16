# Start-Google-API v2 — single-window desktop launcher
# LiteLLM runs in THIS window; ngrok starts hidden in the background.
# Reuses existing services when already online (no extra windows).
$ErrorActionPreference = 'Stop'

$Tag = '[Google-API v2]'
$RepoRoot = Split-Path $PSScriptRoot -Parent
$Port = 4000
$NgrokInspector = 'http://127.0.0.1:4040'

function Import-DotEnvLocal {
    $envPath = Join-Path $RepoRoot '.env.local'
    if (-not (Test-Path $envPath)) {
        return
    }
    Get-Content $envPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -eq '' -or $line.StartsWith('#')) { return }
        if ($line -match '^\s*([^=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim().Trim('"').Trim("'")
            Set-Item -Path "Env:$name" -Value $value
        }
    }
}

function Get-LiteLLMMasterKey {
    $configPath = Join-Path $RepoRoot 'config/litellm_config.yaml'
    if (Test-Path $configPath) {
        $content = Get-Content $configPath -Raw
        if ($content -match 'master_key:\s*(\S+)') { return $matches[1] }
    }
    if ($env:MSC_LITELLM_MASTER_KEY) { return $env:MSC_LITELLM_MASTER_KEY }
    return 'sk-vader-protocol-1234'
}

function Test-LiteLLMOnline {
    Push-Location $RepoRoot
    try {
        $status = (& npm run msc:litellm:status 2>&1 | Out-String)
        return $status -match 'online'
    } finally {
        Pop-Location
    }
}

function Get-NgrokHttpsUrl {
    try {
        $body = Invoke-RestMethod -Uri "$NgrokInspector/api/tunnels" -TimeoutSec 3
        $tunnel = $body.tunnels |
            Where-Object { $_.public_url -like 'https://*' } |
            Select-Object -First 1
        if ($tunnel.public_url) { return $tunnel.public_url.TrimEnd('/') }
    } catch { return $null }
    return $null
}

function Write-CursorBlock {
    param([string]$PublicBaseUrl)

    $baseV1 = "$PublicBaseUrl/v1"
    $keyHint = if ($env:MSC_LITELLM_MASTER_KEY) {
        'MSC_LITELLM_MASTER_KEY (from .env.local)'
    } else {
        'sk-vader-protocol-1234'
    }

    Write-Host ''
    Write-Host '----------------------------------------------------------------' -ForegroundColor DarkCyan
    Write-Host 'Cursor Settings (Override OpenAI Base URL)' -ForegroundColor Cyan
    Write-Host '----------------------------------------------------------------' -ForegroundColor DarkCyan
    Write-Host "   Override OpenAI Base URL: $baseV1"
    Write-Host "   OpenAI API Key:         $keyHint"
    Write-Host '   Custom model:           vader-3.5-flash'
    Write-Host '----------------------------------------------------------------' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host "$Tag Stop all: npm run msc:session:stop" -ForegroundColor DarkGray
    Write-Host "$Tag Verify:   npm run msc:litellm:verify" -ForegroundColor DarkGray
    Write-Host ''
}

Set-Location $RepoRoot
Import-DotEnvLocal

Write-Host ''
Write-Host "$Tag Single-window launcher (LiteLLM here + ngrok hidden)" -ForegroundColor Cyan
Write-Host ''

$litellmUp = Test-LiteLLMOnline
$ngrokUrl = Get-NgrokHttpsUrl

if ($litellmUp -and $ngrokUrl) {
    Write-Host "$Tag LiteLLM already online on port $Port" -ForegroundColor Green
    Write-Host "$Tag ngrok already running: $ngrokUrl" -ForegroundColor Green
    Write-CursorBlock -PublicBaseUrl $ngrokUrl
    Write-Host "$Tag Nothing to start — connection is ready." -ForegroundColor Green
    Write-Host "$Tag To cold-restart: npm run msc:litellm:stop then re-run this shortcut." -ForegroundColor DarkGray
    Write-Host ''
    return
}

if ($litellmUp -and -not $ngrokUrl) {
    Write-Host "$Tag LiteLLM is up but ngrok tunnel missing — starting ngrok only..." -ForegroundColor Yellow
}

Write-Host "$Tag Starting LiteLLM + ngrok (one window)..." -ForegroundColor Cyan
Write-Host "$Tag ngrok runs hidden; LiteLLM logs stay in this window." -ForegroundColor DarkGray
Write-Host ''

# Foreground: LiteLLM in this window. ngrok detached via msc-litellm-start.mjs --ngrok
npm run msc:litellm:start:ngrok
