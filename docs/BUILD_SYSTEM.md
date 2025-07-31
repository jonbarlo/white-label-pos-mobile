# Build System Documentation

This document explains how to use the build system for the White Label POS Mobile app.

## Available Tools

### 1. Makefile (Cross-platform)
```bash
# Show all available commands
make help

# Generate app configuration from .env file
make config

# Set app name and generate configuration
make set-name NAME="Your App Name"

# Build release APK
make build

# Full release build with configuration
make build-release

# Copy APK to distribution folder
make copy-apk

# Build and copy APK to distribution
make build-dist
```

### 2. PowerShell Script (Windows)
```powershell
# Show all available commands
.\scripts\make.ps1 help

# Generate app configuration from .env file
.\scripts\make.ps1 config

# Set app name and generate configuration
.\scripts\make.ps1 set-name "Your App Name"

# Build release APK
.\scripts\make.ps1 build

# Full release build with configuration
.\scripts\make.ps1 build-release

# Copy APK to distribution folder
.\scripts\make.ps1 copy-apk

# Build and copy APK to distribution
.\scripts\make.ps1 build-dist
```

## Common Workflows

### Development Setup
```bash
# Option 1: Makefile
make dev

# Option 2: PowerShell
.\scripts\make.ps1 dev
```

### Production Build
```bash
# Option 1: Makefile
make prod

# Option 2: PowerShell
.\scripts\make.ps1 prod
```

### Distribution Build
```bash
# Option 1: Makefile
make build-dist

# Option 2: PowerShell
.\scripts\make.ps1 build-dist
```

### White Label Configuration
```bash
# Set app name for different clients
make set-name NAME="Restaurant POS"
make set-name NAME="Cafe Manager"
make set-name NAME="Food Truck POS"

# Or with PowerShell
.\scripts\make.ps1 set-name "Restaurant POS"
.\scripts\make.ps1 set-name "Cafe Manager"
.\scripts\make.ps1 set-name "Food Truck POS"
```

## Available Commands

| Command | Description |
|---------|-------------|
| `config` | Generate app configuration from .env file |
| `config-clean` | Clean and regenerate app configuration |
| `build` | Build release APK |
| `build-debug` | Build debug APK |
| `build-clean` | Clean and build release APK |
| `install` | Install APK on connected device |
| `install-debug` | Install debug APK on connected device |
| `copy-apk` | Copy APK to distribution folder |
| `publish-apk` | Build and copy APK to distribution |
| `clean` | Clean Flutter build |
| `pub-get` | Get Flutter dependencies |
| `test` | Run tests |
| `test-widget` | Run widget tests |
| `set-name` | Set app name (requires NAME parameter) |
| `build-release` | Full release build with config |
| `dev` | Development environment setup |
| `prod` | Production build workflow |

## Environment Configuration

The app name is configured through the `.env` file:

```env
APP_NAME=Your Custom App Name
APP_VERSION=1.0.0
API_BASE_URL=http://localhost:3031/api
```

## Build Process

1. **Set app name** (if needed):
   ```bash
   make set-name NAME="Your App Name"
   ```

2. **Generate configuration**:
   ```bash
   make config
   ```

3. **Build APK**:
   ```bash
   make build
   ```

4. **Copy to distribution**:
   ```bash
   make copy-apk
   ```

5. **Install on device**:
   ```bash
   make install
   ```

## Distribution

The APK is automatically copied to:
```
C:\Users\jonba\Documents\GitHub\android-apk-distribution-page\apks\
```

### Quick Distribution Workflow
```bash
# Build and copy to distribution in one command
make build-dist
```

## Troubleshooting

### Build Issues
- Run `make clean` to clear build cache
- Run `make pub-get` to refresh dependencies
- Check that `.env` file exists and has correct format

### Configuration Issues
- Ensure `.env` file is in project root
- Verify `APP_NAME` variable is set correctly
- Run `make config` to regenerate configuration

### Installation Issues
- Ensure device is connected and authorized
- Run `flutter devices` to verify device connection
- Try `make install-debug` for debug builds

### Distribution Issues
- Ensure the distribution folder exists
- Check that APK was built successfully
- Run `make build` before `make copy-apk`