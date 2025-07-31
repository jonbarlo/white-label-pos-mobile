param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$Name
)

function Show-Help {
    Write-Host "White Label POS Mobile - Available Commands:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Configuration:" -ForegroundColor Yellow
    Write-Host "  config          - Generate app configuration from .env file"
    Write-Host "  config-clean    - Clean and regenerate app configuration"
    Write-Host ""
    Write-Host "Build:" -ForegroundColor Yellow
    Write-Host "  build           - Build release APK"
    Write-Host "  build-debug     - Build debug APK"
    Write-Host "  build-clean     - Clean and build release APK"
    Write-Host ""
    Write-Host "Install:" -ForegroundColor Yellow
    Write-Host "  install         - Install APK on connected device"
    Write-Host "  install-debug   - Install debug APK on connected device"
    Write-Host ""
    Write-Host "Distribution:" -ForegroundColor Yellow
    Write-Host "  copy-apk        - Copy APK to distribution folder"
    Write-Host "  build-dist      - Build and copy APK to distribution"
    Write-Host ""
    Write-Host "Development:" -ForegroundColor Yellow
    Write-Host "  clean           - Clean Flutter build"
    Write-Host "  pub-get         - Get Flutter dependencies"
    Write-Host "  test            - Run tests"
    Write-Host "  test-widget     - Run widget tests"
    Write-Host ""
    Write-Host "White Label:" -ForegroundColor Yellow
    Write-Host "  set-name <name> - Set app name"
    Write-Host "  build-release   - Full release build with config"
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Green
    Write-Host "  .\scripts\make.ps1 <command> [parameters]"
    Write-Host "  Example: .\scripts\make.ps1 set-name 'Restaurant POS'"
}

function Invoke-Config {
    Write-Host "Generating app configuration from .env file..." -ForegroundColor Yellow
    dart scripts/generate_app_config.dart
}

function Invoke-Clean {
    Write-Host "Cleaning Flutter build..." -ForegroundColor Yellow
    flutter clean
}

function Invoke-PubGet {
    Write-Host "Getting Flutter dependencies..." -ForegroundColor Yellow
    flutter pub get
}

function Invoke-Build {
    Write-Host "Building release APK..." -ForegroundColor Yellow
    flutter build apk --release
}

function Invoke-BuildDebug {
    Write-Host "Building debug APK..." -ForegroundColor Yellow
    flutter build apk --debug
}

function Invoke-Install {
    Write-Host "Installing release APK..." -ForegroundColor Yellow
    flutter install --release
}

function Invoke-InstallDebug {
    Write-Host "Installing debug APK..." -ForegroundColor Yellow
    flutter install --debug
}

function Invoke-Test {
    Write-Host "Running tests..." -ForegroundColor Yellow
    flutter test
}

function Invoke-TestWidget {
    Write-Host "Running widget tests..." -ForegroundColor Yellow
    flutter test test/widget/
}

function Invoke-CopyApk {
    Write-Host "Copying APK to distribution folder..." -ForegroundColor Yellow
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    $distPath = "C:\Users\jonba\Documents\GitHub\android-apk-distribution-page\apks\"
    
    if (Test-Path $apkPath) {
        Copy-Item $apkPath $distPath -Force
        Write-Host "APK copied to distribution folder" -ForegroundColor Green
    } else {
        Write-Host "APK not found. Run 'build' first." -ForegroundColor Red
    }
}

function Invoke-BuildDist {
    Invoke-Build
    Invoke-CopyApk
    Write-Host "Build and distribution completed!" -ForegroundColor Green
}

function Invoke-SetName {
    if (-not $Name) {
        Write-Host "Error: Name parameter required" -ForegroundColor Red
        Write-Host "Usage: .\scripts\make.ps1 set-name 'YourAppName'" -ForegroundColor Yellow
        return
    }
    
    Write-Host "Setting app name to: $Name" -ForegroundColor Yellow
    "APP_NAME=$Name" | Out-File -FilePath ".env" -Encoding UTF8
    Invoke-Config
    Write-Host "App name set to: $Name" -ForegroundColor Green
}

# Main command processing
switch ($Command.ToLower()) {
    "help" { Show-Help }
    "config" { Invoke-Config }
    "config-clean" { Invoke-Clean; Invoke-Config }
    "build" { Invoke-Build }
    "build-debug" { Invoke-BuildDebug }
    "build-clean" { Invoke-Clean; Invoke-Build }
    "install" { Invoke-Install }
    "install-debug" { Invoke-InstallDebug }
    "copy-apk" { Invoke-CopyApk }
    "build-dist" { Invoke-BuildDist }
    "clean" { Invoke-Clean }
    "pub-get" { Invoke-PubGet }
    "test" { Invoke-Test }
    "test-widget" { Invoke-TestWidget }
    "set-name" { Invoke-SetName }
    "build-release" { Invoke-Config; Invoke-Build; Invoke-Install }
    "dev" { Invoke-PubGet; Invoke-Config; Write-Host "Development environment ready!" -ForegroundColor Green }
    "prod" { Invoke-Clean; Invoke-PubGet; Invoke-Config; Invoke-Build; Invoke-Install; Write-Host "Production build completed!" -ForegroundColor Green }
    default { 
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Show-Help
    }
}