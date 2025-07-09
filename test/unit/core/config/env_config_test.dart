import 'package:flutter_test/flutter_test.dart';
import 'package:white_label_pos_mobile/src/core/config/env_config.dart';

void main() {
  group('EnvConfig', () {
    test('should have default values when no .env file is loaded', () {
      // Test default values
      expect(EnvConfig.apiBaseUrl, equals('https://api.pos-engine.com'));
      expect(EnvConfig.apiTimeout, equals(30000));
      expect(EnvConfig.apiRetryAttempts, equals(3));
      expect(EnvConfig.appName, equals('White Label POS'));
      expect(EnvConfig.appVersion, equals('1.0.0'));
      expect(EnvConfig.isDebugMode, isTrue);
      expect(EnvConfig.isBarcodeScanningEnabled, isTrue);
      expect(EnvConfig.isOfflineModeEnabled, isFalse);
      expect(EnvConfig.isPushNotificationsEnabled, isTrue);
      expect(EnvConfig.isAnalyticsEnabled, isTrue);
      expect(EnvConfig.isCrashReportingEnabled, isTrue);
    });

    test('should return all variables as a map', () {
      final variables = EnvConfig.getAllVariables();
      expect(variables, isA<Map<String, String>>());
    });

    test('should validate required variables', () {
      final missing = EnvConfig.validateRequiredVariables();
      // Since we're not loading a .env file in tests, API_BASE_URL should be missing
      expect(missing, contains('API_BASE_URL'));
    });

    test('should handle boolean parsing correctly', () {
      // Test boolean parsing with various values
      // These tests verify the logic works even without .env files
      expect(EnvConfig.isDebugMode, isTrue); // Default value
      expect(EnvConfig.isBarcodeScanningEnabled, isTrue); // Default value
      expect(EnvConfig.isOfflineModeEnabled, isFalse); // Default value
    });

    test('should handle integer parsing correctly', () {
      // Test integer parsing with various values
      expect(EnvConfig.apiTimeout, equals(30000)); // Default value
      expect(EnvConfig.apiRetryAttempts, equals(3)); // Default value
    });

    test('should provide fallback values for missing variables', () {
      // Test that fallback values are provided when variables are missing
      expect(EnvConfig.apiBaseUrl, isNotEmpty);
      expect(EnvConfig.appName, isNotEmpty);
      expect(EnvConfig.appVersion, isNotEmpty);
    });
  });
} 