# i18n Testing Script
# Tests the internationalization functionality

Write-Host "🌐 Testing i18n System" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

# Test 1: Check if translation files exist
Write-Host "`n1. Checking Translation Files" -ForegroundColor Yellow
$arbFiles = @(
    "assets/translations/app_es_CR.arb",
    "assets/translations/app_en_US.arb"
)

foreach ($file in $arbFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file exists" -ForegroundColor Green
    } else {
        Write-Host "❌ $file missing" -ForegroundColor Red
    }
}

# Test 2: Check if generated files exist
Write-Host "`n2. Checking Generated Files" -ForegroundColor Yellow
$generatedFiles = @(
    "lib/src/core/i18n/app_localizations.dart",
    "lib/src/core/i18n/intl/messages_es_CR.dart",
    "lib/src/core/i18n/intl/messages_en.dart",
    "lib/src/core/i18n/intl/messages_all.dart"
)

foreach ($file in $generatedFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file exists" -ForegroundColor Green
    } else {
        Write-Host "❌ $file missing" -ForegroundColor Red
    }
}

# Test 3: Check if language service exists
Write-Host "`n3. Checking Language Service" -ForegroundColor Yellow
$serviceFile = "lib/src/core/services/language_service.dart"
if (Test-Path $serviceFile) {
    Write-Host "✅ Language service exists" -ForegroundColor Green
} else {
    Write-Host "❌ Language service missing" -ForegroundColor Red
}

# Test 4: Check if test screens exist
Write-Host "`n4. Checking Test Screens" -ForegroundColor Yellow
$testScreens = @(
    "lib/src/features/settings/language_settings_screen.dart",
    "lib/src/features/settings/i18n_test_screen.dart"
)

foreach ($file in $testScreens) {
    if (Test-Path $file) {
        Write-Host "✅ $file exists" -ForegroundColor Green
    } else {
        Write-Host "❌ $file missing" -ForegroundColor Red
    }
}

# Test 5: Check pubspec.yaml configuration
Write-Host "`n5. Checking pubspec.yaml Configuration" -ForegroundColor Yellow
$pubspecContent = Get-Content "pubspec.yaml" -Raw
if ($pubspecContent -match "flutter_intl:") {
    Write-Host "✅ flutter_intl configuration found" -ForegroundColor Green
} else {
    Write-Host "❌ flutter_intl configuration missing" -ForegroundColor Red
}

if ($pubspecContent -match "intl_utils:") {
    Write-Host "✅ intl_utils dependency found" -ForegroundColor Green
} else {
    Write-Host "❌ intl_utils dependency missing" -ForegroundColor Red
}

# Test 6: Check main app configuration
Write-Host "`n6. Checking Main App Configuration" -ForegroundColor Yellow
$mainAppContent = Get-Content "lib/src/core/main_app.dart" -Raw
if ($mainAppContent -match "AppLocalizations") {
    Write-Host "✅ AppLocalizations import found" -ForegroundColor Green
} else {
    Write-Host "❌ AppLocalizations import missing" -ForegroundColor Red
}

if ($mainAppContent -match "localizationsDelegates") {
    Write-Host "✅ Localization delegates configured" -ForegroundColor Green
} else {
    Write-Host "❌ Localization delegates missing" -ForegroundColor Red
}

Write-Host "`n🌐 i18n System Test Complete!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run 'flutter run' to test the app" -ForegroundColor Cyan
Write-Host "2. Navigate to /i18n-test to test language switching" -ForegroundColor Cyan
Write-Host "3. Navigate to /language-settings to change language" -ForegroundColor Cyan 