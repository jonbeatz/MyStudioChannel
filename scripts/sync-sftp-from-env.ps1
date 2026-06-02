# One-way sync: .env.local FTP_* -> .vscode/sftp.json (gitignored). No secrets printed.
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $repoRoot ".env.local"
$outPath = Join-Path $repoRoot ".vscode/sftp.json"

if (-not (Test-Path -LiteralPath $envFile)) {
  Write-Host "FAIL: missing .env.local"
  exit 1
}

$vars = @{}
Get-Content -LiteralPath $envFile | ForEach-Object {
  $line = $_.Trim()
  if ($line -match "^\s*#" -or $line -eq "") { return }
  if ($line -match "^([^=]+)=(.*)$") {
    $vars[$Matches[1].Trim()] = $Matches[2].Trim()
  }
}

foreach ($k in @("FTP_HOST", "FTP_USERNAME", "FTP_PASSWORD")) {
  if (-not $vars.ContainsKey($k) -or [string]::IsNullOrWhiteSpace($vars[$k])) {
    Write-Host "FAIL: missing $k in .env.local"
    exit 1
  }
}

$port = 21
if ($vars.ContainsKey("FTP_PORT") -and $vars["FTP_PORT"]) {
  $port = [int]$vars["FTP_PORT"]
}

# Hostinger: Node runs from /nodejs (File Manager). public_html is NOT the app root.
$remotePath = "/nodejs"
if ($vars.ContainsKey("FTP_REMOTE_PATH") -and $vars["FTP_REMOTE_PATH"]) {
  $remotePath = $vars["FTP_REMOTE_PATH"]
}

$config = [ordered]@{
  name         = "Hostinger mystudiochannel.com"
  host         = $vars["FTP_HOST"]
  port         = $port
  username     = $vars["FTP_USERNAME"]
  password     = $vars["FTP_PASSWORD"]
  protocol     = "ftp"
  secure       = $true
  passive      = $true
  remotePath               = $remotePath
  uploadOnSave             = $false
  ignoreCertificateErrors  = $true
}

New-Item -ItemType Directory -Path (Split-Path $outPath) -Force | Out-Null
$config | ConvertTo-Json | Set-Content -LiteralPath $outPath -Encoding UTF8

Write-Host "OK: synced .vscode/sftp.json from .env.local"
Write-Host "  host: $($vars['FTP_HOST'])"
Write-Host "  port: $port"
Write-Host "  user: $($vars['FTP_USERNAME'])"
Write-Host "  remotePath: $remotePath"
