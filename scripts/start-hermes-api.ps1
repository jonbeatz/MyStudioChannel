# Jarvis Launcher - LiteLLM in elevated Windows Terminal, clean exit
$ErrorActionPreference = 'Stop'

$Tag = '[J.A.R.V.I.S.]'
$RepoRoot = Split-Path $PSScriptRoot -Parent
$ConfigRel = './config/litellm_config.yaml'
$Port = 4000
$ReadyTimeoutSeconds = 90

function Test-LiteLLMPortOpen {
    $conn = Test-NetConnection -ComputerName '127.0.0.1' -Port $Port -WarningAction SilentlyContinue
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

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'wt'
    $psi.Arguments = 'nt --title "LiteLLM" cmd /k cd /d "' + $RepoRoot + '" && litellm --config "' + $ConfigRel + '" --port ' + $Port
    $psi.Verb = 'runas'
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized
    [System.Diagnostics.Process]::Start($psi) | Out-Null
}

Write-Host ''
Write-Host "$Tag Session startup - LiteLLM proxy" -ForegroundColor Cyan
Write-Host ''

if (Test-LiteLLMOnline) {
    Write-Host "$Tag LiteLLM already running on port $Port" -ForegroundColor Green
    $ready = $true
} else {
    Stop-LiteLLMProxy
    Start-LiteLLM-Window
    $ready = Wait-LiteLLMReady
}

if ($ready) {
    Write-Host "$Tag LiteLLM online on port $Port" -ForegroundColor Green
    Write-Host "$Tag Test: npm run msc:litellm:verify" -ForegroundColor DarkGray
    Write-Host ''
    exit 0
}

Write-Warning "$Tag LiteLLM did not come online within ${ReadyTimeoutSeconds}s."
Write-Warning "$Tag Check the LiteLLM Windows Terminal tab for errors, or run: npm run msc:google-api:start"
Write-Host ''
exit 1
