# White Label POS Mobile - Makefile
# Usage: make <target>

.PHONY: help config clean build install test

# Default target
help:
	@echo "White Label POS Mobile - Available Commands:"
	@echo ""
	@echo "Configuration:"
	@echo "  config          - Generate app configuration from .env file"
	@echo "  config-clean    - Clean and regenerate app configuration"
	@echo ""
	@echo "Build:"
	@echo "  build           - Build release APK"
	@echo "  build-debug     - Build debug APK"
	@echo "  build-clean     - Clean and build release APK"
	@echo ""
	@echo "Install:"
	@echo "  install         - Install APK on connected device"
	@echo "  install-debug   - Install debug APK on connected device"
	@echo ""
	@echo "Distribution:"
	@echo "  copy-apk        - Copy APK to distribution folder"
	@echo "  build-dist      - Build and copy APK to distribution"
	@echo ""
	@echo "Development:"
	@echo "  clean           - Clean Flutter build"
	@echo "  pub-get         - Get Flutter dependencies"
	@echo "  test            - Run tests"
	@echo "  test-widget     - Run widget tests"
	@echo ""
	@echo "White Label:"
	@echo "  set-name        - Set app name (usage: make set-name NAME=YourAppName)"
	@echo "  build-release   - Full release build with config"

# Configuration commands
config:
	@echo "🔧 Generating app configuration from .env file..."
	dart scripts/generate_app_config.dart

config-clean: clean config
	@echo "✅ Configuration regenerated after clean"

# Build commands
build:
	@echo "📱 Building release APK..."
	flutter build apk --release

build-debug:
	@echo "📱 Building debug APK..."
	flutter build apk --debug

build-clean: clean build
	@echo "✅ Release APK built after clean"

# Install commands
install:
	@echo "📲 Installing release APK..."
	flutter install --release

install-debug:
	@echo "📲 Installing debug APK..."
	flutter install --debug

# Distribution commands
copy-apk:
	@echo "📦 Copying APK to distribution folder..."
	@if exist "build\app\outputs\flutter-apk\app-release.apk" ( \
		copy "build\app\outputs\flutter-apk\app-release.apk" "C:\Users\jonba\Documents\GitHub\android-apk-distribution-page\apks\" && \
		echo "✅ APK copied to distribution folder" \
	) else ( \
		echo "❌ APK not found. Run 'make build' first." \
	)

publish-apk: config build copy-apk
	@echo "✅ Build and distribution completed!"

# Development commands
clean:
	@echo "🧹 Cleaning Flutter build..."
	flutter clean

pub-get:
	@echo "📦 Getting Flutter dependencies..."
	flutter pub get

test:
	@echo "🧪 Running tests..."
	flutter test

test-widget:
	@echo "🧪 Running widget tests..."
	flutter test test/widget/

# White label commands
set-name:
	@echo "🔧 Setting app name to: $(NAME)"
	@echo APP_NAME=$(NAME) > .env
	@make config
	@echo "✅ App name set to: $(NAME)"

build-release: config build 
	@echo "✅ Full release build completed!"

install-release: config build install
	@echo "✅ Full release build completed!"

run-chrome:
	@echo "🚀 Running development environment..."
	flutter run -d chrome

# Quick development workflow
dev: pub-get config run-chrome
	@echo "🚀 Development environment ready!"
	@echo "Running 'flutter run' to start development"

# Production workflow
prod: clean pub-get config build install
	@echo "🎉 Production build completed!"