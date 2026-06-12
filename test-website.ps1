Write-Host "🧪 Running MyStudioChannel tests..." -ForegroundColor Cyan
Write-Host ""
Write-Host "📦 Build test:" -ForegroundColor Yellow
hermes -z "Run npm run build --dry-run and report only critical errors"

Write-Host ""
Write-Host "🔗 Link check:" -ForegroundColor Yellow
hermes -z "Check for any broken internal links in app/ directory"

Write-Host ""
Write-Host "⚡ Performance:" -ForegroundColor Yellow
hermes -z "Analyze app/layout.tsx and suggest 3 performance optimizations"

Write-Host ""
Write-Host "✅ Done!" -ForegroundColor Green
