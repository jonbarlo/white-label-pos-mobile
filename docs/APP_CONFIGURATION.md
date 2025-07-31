# App Configuration Guide

This guide explains how to configure the app name and other settings for different white-label versions of the POS mobile app.

## Setting the App Name

### Method 1: Using PowerShell Script (Recommended)

```powershell
# Set app name for a specific client
.\scripts\set-app-name.ps1 -AppName "Restaurant POS"

# Set app name for another client
.\scripts\set-app-name.ps1 -AppName "Cafe Manager"
```

### Method 2: Using Environment Variables

1. Create a `.env` file in the project root:
```env
APP_NAME=Your Custom App Name
APP_VERSION=1.0.0
API_BASE_URL=http://localhost:3031/api
```

2. Run the configuration script:
```bash
dart scripts/generate_app_config.dart
```

3. Clean and rebuild:
```bash
flutter clean
flutter pub get
```

### Method 3: Manual Platform Configuration

#### Android
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Your Custom App Name"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

#### iOS
Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Your Custom App Name</string>
```

## Using App Name in Code

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/config/app_info_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = ref.watch(appInfoProvider);
    
    return appInfo.when(
      data: (info) => Text('Welcome to ${info.displayName}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error loading app info'),
    );
  }
}
```

## Environment Variables Reference

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_NAME` | App name displayed on device | "POS Mobile" |
| `APP_VERSION` | App version string | "1.0.0" |
| `API_BASE_URL` | Backend API URL | "http://localhost:3031/api" |
| `DEBUG_MODE` | Enable debug features | "true" |

## White-Label Configuration Examples

### Restaurant Chain
```env
APP_NAME=Restaurant Manager
APP_VERSION=2.1.0
```

### Cafe
```env
APP_NAME=Cafe POS
APP_VERSION=1.5.0
```

### Food Truck
```env
APP_NAME=Food Truck Manager
APP_VERSION=1.0.0
```

## Build Process

1. Set environment variables
2. Run configuration script
3. Clean and rebuild
4. Test on device/simulator

```bash
# Complete workflow
.\scripts\set-app-name.ps1 -AppName "Your App Name"
flutter run
```