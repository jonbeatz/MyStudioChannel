# Print the standard hPanel Node.js restart reminder (clickable in most terminals).
param(
  [ValidateSet("success", "pending")]
  [string]$Status = "success"
)

$hpanelUrl = "https://hpanel.hostinger.com/websites/mystudiochannel.com"

Write-Host ""
if ($Status -eq "success") {
  Write-Host "Deployment successful!" -ForegroundColor Green
} else {
  Write-Host "Deployment upload started / zip ready." -ForegroundColor Yellow
}
Write-Host "IMPORTANT: You MUST restart your Node.js app for changes to take effect." -ForegroundColor Yellow
Write-Host "Click here to restart: $hpanelUrl" -ForegroundColor Cyan
Write-Host "(open the site in hPanel, go to Node.js, then click Restart)" -ForegroundColor Gray
Write-Host ""
