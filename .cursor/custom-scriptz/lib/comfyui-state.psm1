# comfyui-state.psm1 — shared ComfyUI detection, queue poll, logging

$script:ComfyUiRoot = 'H:\AI_Models\ComfyUI'
$script:ComfyUiPort = 8188
$script:ComfyUiLogMaxLines = 500

function Get-ComfyUiLogPath {
    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\..') -ErrorAction SilentlyContinue
    if (-not $repoRoot) { $repoRoot = 'D:\Cursor_Projectz\MyStudioChannel' }
    $logDir = Join-Path $repoRoot 'logs'
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    return Join-Path $logDir 'comfyui.log'
}

function Write-ComfyUiLog {
    param(
        [Parameter(Mandatory = $true)][string]$Action,
        [string]$Detail = ''
    )
    $logPath = Get-ComfyUiLogPath
    $vramUsed = (nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>$null).Trim()
    $vramGb = if ($vramUsed) { [math]::Round([double]$vramUsed / 1024, 1) } else { '?' }
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Action - VRAM: ${vramGb}GB - $Detail"
    Add-Content -Path $logPath -Value $line -Encoding utf8
    if (Test-Path $logPath) {
        $lines = Get-Content $logPath -ErrorAction SilentlyContinue
        if ($lines.Count -gt $script:ComfyUiLogMaxLines) {
            $lines | Select-Object -Last $script:ComfyUiLogMaxLines | Set-Content $logPath -Encoding utf8
        }
    }
}

function Test-ComfyUiPortListening {
    $conn = Get-NetTCPConnection -LocalPort $script:ComfyUiPort -State Listen -ErrorAction SilentlyContinue |
        Select-Object -First 1
    return [ordered]@{
        listening = [bool]$conn
        owningPid = if ($conn) { [int]$conn.OwningProcess } else { $null }
    }
}

function Get-ComfyPythonProcesses {
    $procs = @()
    $seen = @{}

    try {
        Get-CimInstance Win32_Process -Filter "Name='python.exe' OR Name='pythonw.exe'" -ErrorAction Stop |
            ForEach-Object {
                $cmd = $_.CommandLine
                if ($cmd -match 'ComfyUI|AI_Models\\ComfyUI|comfyui\\main\.py') {
                    $pid = [int]$_.ProcessId
                    if (-not $seen.ContainsKey($pid)) {
                        $seen[$pid] = $true
                        $procs += [ordered]@{
                            pid         = $pid
                            commandLine = $cmd
                            source      = 'wmi'
                        }
                    }
                }
            }
    } catch {
        # Fallback: port 8188 owner + tasklist PIDs (limited cmdline on Windows)
        $port = Test-ComfyUiPortListening
        if ($port.owningPid -and -not $seen.ContainsKey($port.owningPid)) {
            $seen[$port.owningPid] = $true
            $procs += [ordered]@{
                pid         = $port.owningPid
                commandLine = ''
                source      = 'port8188'
            }
        }
        tasklist /FI "IMAGENAME eq python.exe" /FO CSV /NH 2>$null |
            ConvertFrom-Csv -Header 'ImageName', 'PID', 'SessionName', 'SessionNum', 'MemUsage' -ErrorAction SilentlyContinue |
            ForEach-Object {
                $pid = [int]$_.PID
                if ($pid -gt 0 -and -not $seen.ContainsKey($pid)) {
                    $seen[$pid] = $true
                    $procs += [ordered]@{
                        pid         = $pid
                        commandLine = ''
                        source      = 'tasklist'
                    }
                }
            }
    }

    $portInfo = Test-ComfyUiPortListening
    if ($portInfo.owningPid -and -not $seen.ContainsKey($portInfo.owningPid)) {
        $seen[$portInfo.owningPid] = $true
        $procs += [ordered]@{
            pid         = $portInfo.owningPid
            commandLine = ''
            source      = 'port8188'
        }
    }

    return $procs
}

function Get-ComfyUiQueue {
    param([int]$Retries = 3)

    $queueError = $false
    $running = $null
    $pending = $null
    $raw = $null

    for ($i = 0; $i -lt $Retries; $i++) {
        try {
            $raw = Invoke-RestMethod -Uri "http://127.0.0.1:$($script:ComfyUiPort)/queue" -Method Get -TimeoutSec 3
            if ($raw.queue_running) { $running = @($raw.queue_running).Count } else { $running = 0 }
            if ($raw.queue_pending) { $pending = @($raw.queue_pending).Count } else { $pending = 0 }
            return [ordered]@{
                queueRunning = $running
                queuePending = $pending
                queueError   = $false
            }
        } catch {
            $queueError = $true
            if ($i -lt ($Retries - 1)) { Start-Sleep -Seconds 1 }
        }
    }

    return [ordered]@{
        queueRunning = $null
        queuePending = $null
        queueError   = $true
    }
}

function Get-LmStudioLoadedModels {
    $models = @()
    try {
        $output = & lms ps 2>$null
        if ($output) {
            foreach ($line in $output) {
                $trimmed = $line.Trim()
                if (-not $trimmed -or $trimmed -match '^IDENTIFIER') { continue }
                if ($trimmed -match '^([a-zA-Z0-9_\-\.]+)') {
                    $models += $Matches[1]
                }
            }
        }
    } catch { }
    return $models
}

function Get-ComfyUiState {
    $port = Test-ComfyUiPortListening
    $procs = Get-ComfyPythonProcesses
    $pids = @($procs | ForEach-Object { $_.pid })

    $queue = [ordered]@{
        queueRunning = $null
        queuePending = $null
        queueError   = $false
    }

    if ($port.listening) {
        $queue = Get-ComfyUiQueue -Retries 3
    }

    $processDetected = $procs.Count -gt 0
    $state = 'stopped'

    if (-not $port.listening -and -not $processDetected) {
        $state = 'stopped'
    } elseif ($port.listening -and $queue.queueError) {
        $state = 'unknown'
    } elseif ($port.listening -or $processDetected) {
        if ($queue.queueError) {
            $state = 'unknown'
        } elseif (($queue.queueRunning -gt 0) -or ($queue.queuePending -gt 0)) {
            $state = 'generating'
        } else {
            $state = 'idle'
        }
    } elseif ($processDetected) {
        $state = 'unknown'
    }

    $lmModels = @(Get-LmStudioLoadedModels)
    $lmRunning = (Get-Process -Name 'LM Studio' -ErrorAction SilentlyContinue).Count -gt 0

    return [ordered]@{
        comfyui = [ordered]@{
            portListening   = $port.listening
            processDetected = $processDetected
            pids            = @($pids)
            state           = $state
            queueRunning    = $queue.queueRunning
            queuePending    = $queue.queuePending
            queueError      = $queue.queueError
        }
        lmStudio = [ordered]@{
            running      = $lmRunning
            loadedModels = @($lmModels)
            vramNote     = 'Per-process VRAM N/A on WDDM; use total usedMb'
        }
        processes = $procs
    }
}

function Get-ComfyUiKillTargets {
    $targets = Get-ComfyPythonProcesses
    $port = Test-ComfyUiPortListening
    if ($port.owningPid) {
        $found = $false
        foreach ($t in $targets) {
            if ($t.pid -eq $port.owningPid) { $found = $true; break }
        }
        if (-not $found) {
            $targets += [ordered]@{ pid = $port.owningPid; commandLine = ''; source = 'port8188' }
        }
    }
    return $targets
}

Export-ModuleMember -Function @(
    'Get-ComfyUiState',
    'Get-ComfyPythonProcesses',
    'Get-ComfyUiKillTargets',
    'Write-ComfyUiLog',
    'Get-ComfyUiLogPath',
    'Test-ComfyUiPortListening',
    'Get-ComfyUiQueue',
    'Get-LmStudioLoadedModels'
)
