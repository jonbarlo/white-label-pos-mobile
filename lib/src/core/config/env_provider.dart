import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'env_config.dart';

part 'env_provider.g.dart';

/// Provider for environment configuration
@riverpod
class EnvironmentConfig extends _$EnvironmentConfig {
  @override
  Future<Map<String, dynamic>> build() async {
    // Initialize environment configuration
    await EnvConfig.initialize();
    
    // Validate required variables
    final missingVariables = EnvConfig.validateRequiredVariables();
    if (missingVariables.isNotEmpty) {
      throw Exception('Missing required environment variables: ${missingVariables.join(', ')}');
    }
    
    // Return all configuration as a map
    return {
      'apiBaseUrl': EnvConfig.apiBaseUrl,
      'apiTimeout': EnvConfig.apiTimeout,
      'apiRetryAttempts': EnvConfig.apiRetryAttempts,
      'appName': EnvConfig.appName,
      'appVersion': EnvConfig.appVersion,
      'isDebugMode': EnvConfig.isDebugMode,
      'isBarcodeScanningEnabled': EnvConfig.isBarcodeScanningEnabled,
      'isPushNotificationsEnabled': EnvConfig.isPushNotificationsEnabled,
      'isAnalyticsEnabled': EnvConfig.isAnalyticsEnabled,
      'isCrashReportingEnabled': EnvConfig.isCrashReportingEnabled,
    };
  }
}

/// Provider for API base URL
@riverpod
String apiBaseUrl(ApiBaseUrlRef ref) {
  final config = ref.watch(environmentConfigProvider);
  return config.when(
    data: (data) => data['apiBaseUrl'] as String,
    loading: () => EnvConfig.apiBaseUrl,
    error: (error, stack) => EnvConfig.apiBaseUrl,
  );
}

/// Provider for API timeout
@riverpod
int apiTimeout(ApiTimeoutRef ref) {
  final config = ref.watch(environmentConfigProvider);
  return config.when(
    data: (data) => data['apiTimeout'] as int,
    loading: () => EnvConfig.apiTimeout,
    error: (error, stack) => EnvConfig.apiTimeout,
  );
}

/// Provider for API retry attempts
@riverpod
int apiRetryAttempts(ApiRetryAttemptsRef ref) {
  final config = ref.watch(environmentConfigProvider);
  return config.when(
    data: (data) => data['apiRetryAttempts'] as int,
    loading: () => EnvConfig.apiRetryAttempts,
    error: (error, stack) => EnvConfig.apiRetryAttempts,
  );
}

/// Provider for app name
@riverpod
String appName(AppNameRef ref) {
  final config = ref.watch(environmentConfigProvider);
  return config.when(
    data: (data) => data['appName'] as String,
    loading: () => EnvConfig.appName,
    error: (error, stack) => EnvConfig.appName,
  );
}

/// Provider for debug mode status
@riverpod
bool isDebugMode(IsDebugModeRef ref) {
  final config = ref.watch(environmentConfigProvider);
  return config.when(
    data: (data) => data['isDebugMode'] as bool,
    loading: () => EnvConfig.isDebugMode,
    error: (error, stack) => EnvConfig.isDebugMode,
  );
}

/// Provider for barcode scanning feature flag
@riverpod
bool isBarcodeScanningEnabled(IsBarcodeScanningEnabledRef ref) {
  final config = ref.watch(environmentConfigProvider);
  return config.when(
    data: (data) => data['isBarcodeScanningEnabled'] as bool,
    loading: () => EnvConfig.isBarcodeScanningEnabled,
    error: (error, stack) => EnvConfig.isBarcodeScanningEnabled,
  );
} 