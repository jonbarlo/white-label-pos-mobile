# Environment Configuration Setup

This document explains how to set up and use environment variables in the White Label POS mobile app.

## Overview

The app uses environment variables to configure different settings for different environments (development, staging, production). This allows you to easily switch between different API endpoints, feature flags, and other configuration options.

## Environment Files

The app supports multiple environment files:

- `.env` - Default environment file (fallback)
- `.env.development` - Development environment
- `.env.staging` - Staging environment  
- `.env.production` - Production environment

## Available Environment Variables

### API Configuration
- `API_BASE_URL` - Base URL for the API (required)
- `API_TIMEOUT` - API request timeout in milliseconds (default: 30000)
- `API_RETRY_ATTEMPTS` - Number of retry attempts for failed API calls (default: 3)

### App Configuration
- `APP_NAME` - Application name (default: "White Label POS")
- `APP_VERSION` - Application version (default: "1.0.0")
- `DEBUG_MODE` - Enable debug mode (default: true)

### Feature Flags
- `ENABLE_BARCODE_SCANNING` - Enable barcode scanning feature (default: true)
- `ENABLE_OFFLINE_MODE` - Enable offline mode (default: false)
- `ENABLE_PUSH_NOTIFICATIONS` - Enable push notifications (default: true)

### Analytics & Monitoring
- `ANALYTICS_ENABLED` - Enable analytics (default: true)
- `CRASH_REPORTING_ENABLED` - Enable crash reporting (default: true)

## Usage

### 1. Setting Environment Variables

Create or modify the appropriate `.env` file for your environment:

```bash
# .env.development
API_BASE_URL=http://localhost:3000
API_TIMEOUT=10000
API_RETRY_ATTEMPTS=2
APP_NAME=White Label POS (Dev)
DEBUG_MODE=true
ENABLE_BARCODE_SCANNING=true
ENABLE_OFFLINE_MODE=false
```

### 2. Running with Different Environments

#### Using Dart Define (Recommended)
```bash
# Development
flutter run --dart-define=ENVIRONMENT=development

# Staging
flutter run --dart-define=ENVIRONMENT=staging

# Production
flutter run --dart-define=ENVIRONMENT=production
```

#### Using Build Configuration
```bash
# Development
flutter run --flavor development

# Staging
flutter run --flavor staging

# Production
flutter run --flavor production
```

### 3. Using Environment Variables in Code

#### Direct Access
```dart
import 'package:white_label_pos_mobile/src/core/config/env_config.dart';

// Get API base URL
final apiUrl = EnvConfig.apiBaseUrl;

// Check if debug mode is enabled
if (EnvConfig.isDebugMode) {
  print('Debug mode is enabled');
}

// Check feature flags
if (EnvConfig.isBarcodeScanningEnabled) {
  // Enable barcode scanning
}
```

#### Using Riverpod Providers (Recommended)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/core/config/env_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiUrl = ref.watch(apiBaseUrlProvider);
    final isDebug = ref.watch(isDebugModeProvider);
    
    return Text('API URL: $apiUrl, Debug: $isDebug');
  }
}
```

## Environment File Examples

### Development (.env.development)
```bash
API_BASE_URL=http://localhost:3000
API_TIMEOUT=10000
API_RETRY_ATTEMPTS=2
APP_NAME=White Label POS (Dev)
DEBUG_MODE=true
ENABLE_BARCODE_SCANNING=true
ENABLE_OFFLINE_MODE=false
ENABLE_PUSH_NOTIFICATIONS=false
ANALYTICS_ENABLED=false
CRASH_REPORTING_ENABLED=false
```

### Staging (.env.staging)
```bash
API_BASE_URL=https://staging-api.pos-engine.com
API_TIMEOUT=30000
API_RETRY_ATTEMPTS=3
APP_NAME=White Label POS (Staging)
DEBUG_MODE=false
ENABLE_BARCODE_SCANNING=true
ENABLE_OFFLINE_MODE=false
ENABLE_PUSH_NOTIFICATIONS=true
ANALYTICS_ENABLED=true
CRASH_REPORTING_ENABLED=true
```

### Production (.env.production)
```bash
API_BASE_URL=https://api.pos-engine.com
API_TIMEOUT=30000
API_RETRY_ATTEMPTS=3
APP_NAME=White Label POS
DEBUG_MODE=false
ENABLE_BARCODE_SCANNING=true
ENABLE_OFFLINE_MODE=true
ENABLE_PUSH_NOTIFICATIONS=true
ANALYTICS_ENABLED=true
CRASH_REPORTING_ENABLED=true
```

## Testing

The environment configuration includes comprehensive tests:

```bash
# Run environment configuration tests
flutter test test/unit/core/config/

# Run all tests
flutter test
```

## Debug Screen

For development and debugging, you can access the environment debug screen to see current configuration values. This screen shows:

- Current environment settings
- Full configuration map
- Available environment files
- Instructions for switching environments

## Best Practices

1. **Never commit sensitive data** to environment files
2. **Use different API endpoints** for different environments
3. **Enable debug features** only in development
4. **Use feature flags** to control functionality
5. **Test with different environments** before deployment
6. **Document environment-specific settings** in your team

## Troubleshooting

### Environment file not loading
- Ensure the `.env` file is in the project root
- Check that the file is included in `pubspec.yaml` assets
- Verify the file format (no spaces around `=`)

### Environment variable not found
- Check the variable name spelling
- Ensure the variable is defined in the correct `.env` file
- Verify the environment is set correctly when running the app

### Default values being used
- This is expected behavior when environment variables are not set
- Check that your `.env` file is being loaded correctly
- Verify the environment configuration in the debug screen 