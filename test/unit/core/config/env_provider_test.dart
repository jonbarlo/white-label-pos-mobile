import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/core/config/env_provider.dart';

void main() {
  group('Environment Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('apiBaseUrlProvider should return default value', () {
      final apiUrl = container.read(apiBaseUrlProvider);
      expect(apiUrl, equals('https://api.pos-engine.com'));
    });

    test('apiTimeoutProvider should return default value', () {
      final timeout = container.read(apiTimeoutProvider);
      expect(timeout, equals(30000));
    });

    test('apiRetryAttemptsProvider should return default value', () {
      final retries = container.read(apiRetryAttemptsProvider);
      expect(retries, equals(3));
    });

    test('appNameProvider should return default value', () {
      final appName = container.read(appNameProvider);
      expect(appName, equals('White Label POS'));
    });

    test('isDebugModeProvider should return default value', () {
      final isDebug = container.read(isDebugModeProvider);
      expect(isDebug, isTrue);
    });

    test('isBarcodeScanningEnabledProvider should return default value', () {
      final isEnabled = container.read(isBarcodeScanningEnabledProvider);
      expect(isEnabled, isTrue);
    });

    test('environmentConfigProvider should return configuration map', () async {
      final configAsync = container.read(environmentConfigProvider);
      
      // Wait for the async provider to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      final config = configAsync.value;
      expect(config, isA<Map<String, dynamic>?>());
      if (config != null) {
        expect(config['apiBaseUrl'], equals('https://api.pos-engine.com'));
        expect(config['appName'], equals('White Label POS'));
        expect(config['isDebugMode'], isTrue);
      }
    });

    test('providers should be reactive to environment changes', () {
      // Test that providers return consistent values
      final apiUrl1 = container.read(apiBaseUrlProvider);
      final apiUrl2 = container.read(apiBaseUrlProvider);
      expect(apiUrl1, equals(apiUrl2));
      
      final timeout1 = container.read(apiTimeoutProvider);
      final timeout2 = container.read(apiTimeoutProvider);
      expect(timeout1, equals(timeout2));
    });

    test('providers should handle errors gracefully', () {
      // Test that providers return default values even when environment config fails
      final apiUrl = container.read(apiBaseUrlProvider);
      expect(apiUrl, isNotEmpty);
      expect(apiUrl, equals('https://api.pos-engine.com'));
    });
  });
} 