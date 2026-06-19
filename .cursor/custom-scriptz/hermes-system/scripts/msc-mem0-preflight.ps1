# MyStudioChannel - Mem0 LM Studio preflight (VRAM-optimized)
# Loads qwen3-4b-instruct-2507 with small context for memory add/search only.
# Typical VRAM: ~2.5 GB weights + modest KV cache (~3-4 GB total vs ~12 GB at 64k/parallel 4).

param(
    [switch]$Quiet
)

$ErrorActionPreference = 'Continue'

$Mem0Model = 'qwen3-4b-instruct-2507'
$Mem0Context = 8192
$Mem0Parallel = 1
$LmsApi = 'http://127.0.0.1:1234/v1/models'

function Write-Mem0Log {
    param([string]$Message, [string]$Color = 'Cyan')
    if (-not $Quiet) {
        Write-Host "[MSC:Mem0] $Message" -ForegroundColor $Color
    }
}

function Test-LmsAvailable {
    if (-not (Get-Command lms -ErrorAction SilentlyContinue)) {
        Write-Mem0Log 'lms CLI not found. Install LM Studio and ensure lms is on PATH.' 'Red'
        exit 1
    }
}

function Get-LoadedLlmState {
    $raw = & lms ps --json 2>&1
    if ($LASTEXITCODE -ne 0 -or -not $raw) {
        return $null
    }
    try {
        $items = $raw | ConvertFrom-Json
        if (-not $items) { return $null }
        if ($items -is [System.Array]) {
            return @($items | Where-Object { $_.type -eq 'llm' } | Select-Object -First 1)
        }
        return $items
    } catch {
        return $null
    }
}

function Test-Mem0LoadOptimal {
    param($Loaded)
    if (-not $Loaded) { return $false }
    $id = [string]$Loaded.identifier
    if ($id -ne $Mem0Model) { return $false }
    $ctx = [int]$Loaded.contextLength
    $par = [int]$Loaded.parallel
    return ($ctx -le $Mem0Context) -and ($par -le $Mem0Parallel)
}

function Wait-LmsApi {
    param([int]$MaxSeconds = 30)
    $deadline = (Get-Date).AddSeconds($MaxSeconds)
    while ((Get-Date) -lt $deadline) {
        try {
            $null = Invoke-RestMethod -Uri $LmsApi -TimeoutSec 3
            return $true
        } catch {
            Start-Sleep -Seconds 1
        }
    }
    return $false
}

Test-LmsAvailable

$loaded = Get-LoadedLlmState

if (Test-Mem0LoadOptimal -Loaded $loaded) {
    Write-Mem0Log "Model already optimal: $Mem0Model (context $Mem0Context, parallel $Mem0Parallel)." 'Green'
} else {
    if ($loaded) {
        $curId = [string]$loaded.identifier
        $curCtx = [int]$loaded.contextLength
        $curPar = [int]$loaded.parallel
        Write-Mem0Log "Reloading for Mem0: was $curId (context $curCtx, parallel $curPar) -> context $Mem0Context, parallel $Mem0Parallel." 'Yellow'
        & lms unload $curId 2>&1 | Out-Null
        $unloadExit = $LASTEXITCODE
        if ($unloadExit -ne 0) {
            Write-Mem0Log "Unload failed; attempting load anyway." 'Yellow'
        }
        Start-Sleep -Seconds 2
    } else {
        Write-Mem0Log "No model loaded. Loading $Mem0Model for Mem0 (context $Mem0Context, parallel $Mem0Parallel)..." 'Yellow'
    }

    & lms load $Mem0Model -c $Mem0Context --parallel $Mem0Parallel 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Mem0Log "Failed to load $Mem0Model with Mem0-optimized settings." 'Red'
        exit 1
    }
    Write-Mem0Log "Loaded $Mem0Model (context $Mem0Context, parallel $Mem0Parallel)." 'Green'
}

if (-not (Wait-LmsApi)) {
    Write-Mem0Log "LM Studio API not responding at $LmsApi" 'Red'
    exit 1
}

$loadedAfter = Get-LoadedLlmState
if ($loadedAfter) {
    $sizeGb = [math]::Round([double]$loadedAfter.sizeBytes / 1GB, 2)
    Write-Mem0Log "Ready: $($loadedAfter.identifier) | context $($loadedAfter.contextLength) | parallel $($loadedAfter.parallel) | weights ~${sizeGb} GB" 'Green'
}

if (-not $Quiet) {
    try {
        $vramLine = & nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader 2>&1
        if ($vramLine) {
            Write-Mem0Log "GPU VRAM: $vramLine" 'DarkGray'
        }
    } catch {
        # optional
    }
}

exit 0
