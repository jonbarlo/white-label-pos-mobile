// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiBaseUrlHash() => r'7c2ea381d71ec151c6a237e5496c13d1f3e529ae';

/// Provider for API base URL
///
/// Copied from [apiBaseUrl].
@ProviderFor(apiBaseUrl)
final apiBaseUrlProvider = AutoDisposeProvider<String>.internal(
  apiBaseUrl,
  name: r'apiBaseUrlProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiBaseUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiBaseUrlRef = AutoDisposeProviderRef<String>;
String _$apiTimeoutHash() => r'fe7ffd019e7929bb4e8f91423878ff37da88f76c';

/// Provider for API timeout
///
/// Copied from [apiTimeout].
@ProviderFor(apiTimeout)
final apiTimeoutProvider = AutoDisposeProvider<int>.internal(
  apiTimeout,
  name: r'apiTimeoutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiTimeoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiTimeoutRef = AutoDisposeProviderRef<int>;
String _$apiRetryAttemptsHash() => r'92983f6bf951d69304ac14a6a2c4ec9bf0130430';

/// Provider for API retry attempts
///
/// Copied from [apiRetryAttempts].
@ProviderFor(apiRetryAttempts)
final apiRetryAttemptsProvider = AutoDisposeProvider<int>.internal(
  apiRetryAttempts,
  name: r'apiRetryAttemptsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiRetryAttemptsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiRetryAttemptsRef = AutoDisposeProviderRef<int>;
String _$appNameHash() => r'68d3ab3096949a773db0475ef3e9e387cb4f5b78';

/// Provider for app name
///
/// Copied from [appName].
@ProviderFor(appName)
final appNameProvider = AutoDisposeProvider<String>.internal(
  appName,
  name: r'appNameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppNameRef = AutoDisposeProviderRef<String>;
String _$isDebugModeHash() => r'e091dbdc098732cb09c86e40bcc27517af09ce41';

/// Provider for debug mode status
///
/// Copied from [isDebugMode].
@ProviderFor(isDebugMode)
final isDebugModeProvider = AutoDisposeProvider<bool>.internal(
  isDebugMode,
  name: r'isDebugModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isDebugModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDebugModeRef = AutoDisposeProviderRef<bool>;
String _$isBarcodeScanningEnabledHash() =>
    r'abdbaedcd3a675e97c477e807a50a96654a95676';

/// Provider for barcode scanning feature flag
///
/// Copied from [isBarcodeScanningEnabled].
@ProviderFor(isBarcodeScanningEnabled)
final isBarcodeScanningEnabledProvider = AutoDisposeProvider<bool>.internal(
  isBarcodeScanningEnabled,
  name: r'isBarcodeScanningEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isBarcodeScanningEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsBarcodeScanningEnabledRef = AutoDisposeProviderRef<bool>;
String _$environmentConfigHash() => r'a82fa8b7e76f3c944ff3950cc5d2498054a846de';

/// Provider for environment configuration
///
/// Copied from [EnvironmentConfig].
@ProviderFor(EnvironmentConfig)
final environmentConfigProvider = AutoDisposeAsyncNotifierProvider<
    EnvironmentConfig, Map<String, dynamic>>.internal(
  EnvironmentConfig.new,
  name: r'environmentConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$environmentConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EnvironmentConfig = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
