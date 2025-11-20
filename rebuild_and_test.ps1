# Clean and rebuild Flutter web app with cache clearing
Write-Host "🧹 Cleaning Flutter build..." -ForegroundColor Yellow
flutter clean

Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "🔨 Building for web..." -ForegroundColor Yellow
flutter build web --release

Write-Host "✅ Build complete! Now:" -ForegroundColor Green
Write-Host "  1. Stop your current web server" -ForegroundColor Cyan
Write-Host "  2. Clear browser cache (Ctrl+Shift+Delete)" -ForegroundColor Cyan
Write-Host "  3. Restart: flutter run -d chrome" -ForegroundColor Cyan
Write-Host "  4. Or serve from build: flutter run -d web-server --web-port=8080" -ForegroundColor Cyan