param(
    [Parameter(Mandatory=$true)]
    [string]$AppName,
    
    [string]$Environment = "development"
)

Write-Host "🔧 Setting app name to: $AppName" -ForegroundColor Green

# Set environment variable
$env:APP_NAME = $AppName

# Run the Dart script to update platform configurations
Write-Host "📱 Updating platform configurations..." -ForegroundColor Yellow
dart scripts/generate_app_config.dart

# Clean and rebuild
Write-Host "🧹 Cleaning and rebuilding..." -ForegroundColor Yellow
flutter clean
flutter pub get

Write-Host "✅ App name updated to: $AppName" -ForegroundColor Green
Write-Host "💡 Run 'flutter run' to test the changes" -ForegroundColor Cyan