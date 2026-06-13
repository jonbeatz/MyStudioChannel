# Jarvis Launcher - LiteLLM + ngrok in elevated Windows Terminal, clean exit
$ErrorActionPreference = 'Stop'

$Tag = '[J.A.R.V.I.S.]'
$RepoRoot = Split-Path $PSScriptRoot -Parent
$ConfigRel = './config/litellm_config.yaml'
$Port = 4000
$NgrokInspector = 'http://127.0.0.1:4040'
$ReadyTimeoutSeconds = 90
$NgrokTimeoutSeconds = 45
$SessionFile = Join-Path $RepoRoot '.cursor/session-google-api.json'

function Import-DotEnvLocal {
    $envPath = Join-Path $RepoRoot '.env.local'
    if (-not (Test-Path $envPath)) {
        return
    }
    Get-Content $envPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -eq '' -or $line.StartsWith('#')) {
            return
        }
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
        if ($content -match 'master_key:\s*(\S+)') {
            return $matches[1]
        }
    }
    if ($env:MSC_LITELLM_MASTER_KEY) {
        return $env:MSC_LITELLM_MASTER_KEY
    }
    return 'sk-vader-protocol-1234'
}

function Get-NgrokExecutable {
    if ($env:MSC_NGROK_BIN -and (Test-Path $env:MSC_NGROK_BIN)) {
        return $env:MSC_NGROK_BIN
    }
    $localCandidates = @(
        (Join-Path $RepoRoot 'google-api/ngrok.exe'),
        (Join-Path $RepoRoot 'google-api/ngrok')
    )
    foreach ($candidate in $localCandidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }
    $where = Get-Command ngrok -ErrorAction SilentlyContinue
    if ($where) {
        return $where.Source
    }
    throw 'ngrok not found - install to google-api/ngrok.exe or PATH'
}

function Test-LiteLLMPortOpen {
    $conn = Test-NetConnection -ComputerName '127.0.0.1' -Port $Port -WarningAction SilentlyContinue
    return [bool]$conn.TcpTestSucceeded
}

function Test-NgrokInspectorOpen {
    $conn = Test-NetConnection -ComputerName '127.0.0.1' -Port 4040 -WarningAction SilentlyContinue
    return [bool]$conn.TcpTestSucceeded
}

function Test-LiteLLMOnline {
    if (-not (Test-LiteLLMPortOpen)) {
        return $false
    }
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
        if (-not $tunnel) {
            $tunnel = $body.tunnels | Where-Object { $_.proto -eq 'https' } | Select-Object -First 1
        }
        if ($tunnel.public_url) {
            return $tunnel.public_url.TrimEnd('/')
        }
    } catch {
        return $null
    }
    return $null
}

function Test-NgrokTunnelOnline {
    $url = Get-NgrokHttpsUrl
    return [bool]$url
}

function Test-NgrokLiteLLMReachable {
    param([string]$PublicBaseUrl)

    if (-not $PublicBaseUrl) {
        return $false
    }
    $v1 = "$PublicBaseUrl/v1/models"
    $headers = @{
        'ngrok-skip-browser-warning' = 'true'
        Authorization = "Bearer $(Get-LiteLLMMasterKey)"
    }
    try {
        $response = Invoke-WebRequest -Uri $v1 -Headers $headers -TimeoutSec 10 -UseBasicParsing
        return $response.StatusCode -eq 200
    } catch {
        return $false
    }
}

function Wait-LiteLLMReady {
    param([int]$TimeoutSeconds = $ReadyTimeoutSeconds)

    $elapsed = 0
    while ($elapsed -lt $TimeoutSeconds) {
        if (Test-LiteLLMPortOpen) {
            Start-Sleep -Seconds 2
            if (Test-LiteLLMOnline) {
                return $true
            }
        }
        if ($elapsed -gt 0 -and ($elapsed % 10) -eq 0) {
            Write-Host "$Tag Waiting for LiteLLM on port $Port (${elapsed}s)..." -ForegroundColor DarkGray
        }
        Start-Sleep -Seconds 1
        $elapsed++
    }
    return $false
}

function Wait-NgrokReady {
    param([int]$TimeoutSeconds = $NgrokTimeoutSeconds)

    $elapsed = 0
    while ($elapsed -lt $TimeoutSeconds) {
        $url = Get-NgrokHttpsUrl
        if ($url) {
            return $url
        }
        if ($elapsed -gt 0 -and ($elapsed % 5) -eq 0) {
            Write-Host "$Tag Waiting for ngrok tunnel (${elapsed}s)..." -ForegroundColor DarkGray
        }
        Start-Sleep -Seconds 1
        $elapsed++
    }
    return $null
}

function Stop-LiteLLMProxy {
    Push-Location $RepoRoot
    try {
        npm run msc:litellm:stop | Out-Null
    } finally {
        Pop-Location
    }
}

function Start-LiteLLM-Window {
    Write-Host "$Tag Launching LiteLLM in Windows Terminal..." -ForegroundColor Cyan

    $litellmCmd = 'cd /d "' + $RepoRoot + '" && litellm --config "' + $ConfigRel + '" --port ' + $Port
    Start-WtWindow -Arguments ('nt --title "LiteLLM" cmd /k ' + $litellmCmd) -Elevated
}

function Get-NgrokCmdLine {
    param([string]$NgrokBin)

    $envPrefix = ''
    if ($env:NGROK_AUTHTOKEN) {
        $envPrefix = 'set NGROK_AUTHTOKEN=' + $env:NGROK_AUTHTOKEN + ' && '
    }
    return 'cd /d "' + $RepoRoot + '" && ' + $envPrefix + '"' + $NgrokBin + '" http ' + $Port
}

function Start-Ngrok-Window {
    param(
        [string]$NgrokBin,
        [switch]$UseWindowsTerminal
    )

    if ($UseWindowsTerminal) {
        Write-Host "$Tag Launching ngrok in Windows Terminal..." -ForegroundColor Cyan
        $ngrokCmd = Get-NgrokCmdLine -NgrokBin $NgrokBin
        Start-WtWindow -Arguments ('nt --title "ngrok" cmd /k ' + $ngrokCmd) -Elevated
        return
    }

    Write-Host "$Tag Launching ngrok (minimized process)..." -ForegroundColor Cyan
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $NgrokBin
    $psi.Arguments = "http $Port"
    $psi.WorkingDirectory = $RepoRoot
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized
    $psi.UseShellExecute = $false
    if ($env:NGROK_AUTHTOKEN) {
        $psi.EnvironmentVariables['NGROK_AUTHTOKEN'] = $env:NGROK_AUTHTOKEN
    }
    [void][System.Diagnostics.Process]::Start($psi)
}

function Start-LiteLLMAndNgrok-Window {
    param([string]$NgrokBin)

    Write-Host "$Tag Launching LiteLLM (elevated WT) + ngrok (minimized)..." -ForegroundColor Cyan
    Start-LiteLLM-Window
    Start-Sleep -Seconds 2
    Start-Ngrok-Window -NgrokBin $NgrokBin
}

function Start-WtWindow {
    param(
        [string]$Arguments,
        [switch]$Elevated
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'wt'
    $psi.Arguments = $Arguments
    if ($Elevated) {
        $psi.Verb = 'runas'
    }
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized
    [System.Diagnostics.Process]::Start($psi) | Out-Null
}

function Write-SessionGoogleApiInfo {
    param(
        [string]$NgrokUrl,
        [bool]$RemoteVerified
    )

    $cursorDir = Join-Path $RepoRoot '.cursor'
    if (-not (Test-Path $cursorDir)) {
        New-Item -ItemType Directory -Path $cursorDir | Out-Null
    }

    $payload = [ordered]@{
        ngrokPublicUrl = $NgrokUrl
        ngrokV1 = "$NgrokUrl/v1"
        litellmPort = $Port
        remoteVerified = $RemoteVerified
        capturedAt = (Get-Date).ToUniversalTime().ToString('o')
    }
    $payload | ConvertTo-Json | Set-Content -Path $SessionFile -Encoding utf8
}

function Write-CursorNgrokSettings {
    param([string]$PublicBaseUrl)

    $baseV1 = "$PublicBaseUrl/v1"
    $keyHint = if ($env:MSC_LITELLM_MASTER_KEY) {
        'MSC_LITELLM_MASTER_KEY (from .env.local)'
    } else {
        'sk-vader-protocol-1234 (config/litellm_config.yaml master_key)'
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
}

Import-DotEnvLocal

Write-Host ''
Write-Host "$Tag Session startup - LiteLLM proxy + ngrok tunnel" -ForegroundColor Cyan
Write-Host ''

# --- LiteLLM ---
$needLiteLLM = -not (Test-LiteLLMOnline)
$ngrokBin = $null

try {
    $ngrokBin = Get-NgrokExecutable
} catch {
    if ($needLiteLLM) {
        Write-Warning "$Tag $($_.Exception.Message)"
        Write-Warning "$Tag Cannot start session without ngrok for Cursor Cloud Agent."
        Write-Host ''
        exit 1
    }
    Write-Warning "$Tag $($_.Exception.Message)"
    Write-Warning "$Tag LiteLLM will start; ngrok skipped."
}

$needNgrok = $ngrokBin -and -not (Test-NgrokTunnelOnline)
$launchedNgrok = $false

if ($needLiteLLM -and $needNgrok) {
    Stop-LiteLLMProxy
    Start-LiteLLMAndNgrok-Window -NgrokBin $ngrokBin
    $launchedNgrok = $true
    $litellmReady = Wait-LiteLLMReady
} elseif ($needLiteLLM) {
    Stop-LiteLLMProxy
    Start-LiteLLM-Window
    $litellmReady = Wait-LiteLLMReady
} else {
    Write-Host "$Tag LiteLLM already running on port $Port" -ForegroundColor Green
    $litellmReady = $true
}

if (-not $litellmReady) {
    Write-Warning "$Tag LiteLLM did not come online within ${ReadyTimeoutSeconds}s."
    Write-Warning "$Tag Check the LiteLLM Windows Terminal tab for errors."
    Write-Host ''
    exit 1
}

Write-Host "$Tag LiteLLM online on port $Port" -ForegroundColor Green

# --- ngrok ---
$ngrokUrl = $null
if (-not $ngrokBin) {
    Write-Warning "$Tag ngrok unavailable - local proxy only at http://127.0.0.1:${Port}/v1"
    Write-Host ''
    exit 1
}

if (Test-NgrokTunnelOnline) {
    $ngrokUrl = Get-NgrokHttpsUrl
    Write-Host "$Tag ngrok already running - reusing tunnel" -ForegroundColor Green
} elseif ($needNgrok) {
    if (-not (Test-NgrokInspectorOpen) -and -not $launchedNgrok) {
        # LiteLLM already up: ngrok without elevation avoids a second UAC prompt.
        Start-Ngrok-Window -NgrokBin $ngrokBin
    } else {
        Write-Host "$Tag ngrok inspector active - waiting for HTTPS tunnel..." -ForegroundColor DarkGray
    }
    $ngrokUrl = Wait-NgrokReady
} else {
    $ngrokUrl = Wait-NgrokReady -TimeoutSeconds 5
}

if (-not $ngrokUrl) {
    Write-Warning "$Tag ngrok did not expose an HTTPS URL within ${NgrokTimeoutSeconds}s."
    Write-Warning "$Tag Check the ngrok Windows Terminal tab and NGROK_AUTHTOKEN in .env.local."
    Write-Host ''
    exit 1
}

Write-Host "$Tag ngrok tunnel online: $ngrokUrl" -ForegroundColor Green

$remoteOk = Test-NgrokLiteLLMReachable -PublicBaseUrl $ngrokUrl
if ($remoteOk) {
    Write-Host "$Tag ngrok /v1/models verified - HTTP 200" -ForegroundColor Green
} else {
    Write-Warning "$Tag ngrok URL reachable but /v1/models probe failed - tunnel may still be warming up."
    Write-Warning "$Tag Retry: npm run msc:litellm:test:ngrok"
}

Write-SessionGoogleApiInfo -NgrokUrl $ngrokUrl -RemoteVerified $remoteOk
Write-CursorNgrokSettings -PublicBaseUrl $ngrokUrl

Write-Host "$Tag Session file: $SessionFile" -ForegroundColor DarkGray
Write-Host "$Tag Test: npm run msc:litellm:verify" -ForegroundColor DarkGray
Write-Host "$Tag Test ngrok: npm run msc:litellm:test:ngrok" -ForegroundColor DarkGray
Write-Host ''
exit 0
