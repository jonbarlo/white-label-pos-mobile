// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$languageRepositoryHash() =>
    r'cf2bbd4db6b40569728062710b8bc5d7757f7369';

/// See also [languageRepository].
@ProviderFor(languageRepository)
final languageRepositoryProvider =
    AutoDisposeProvider<LanguageRepository>.internal(
  languageRepository,
  name: r'languageRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$languageRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LanguageRepositoryRef = AutoDisposeProviderRef<LanguageRepository>;
String _$currentLanguageCodeHash() =>
    r'0445a01df9dc81d6cf505c211748f3811417cf6e';

/// See also [currentLanguageCode].
@ProviderFor(currentLanguageCode)
final currentLanguageCodeProvider = AutoDisposeProvider<String>.internal(
  currentLanguageCode,
  name: r'currentLanguageCodeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLanguageCodeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLanguageCodeRef = AutoDisposeProviderRef<String>;
String _$supportedLanguagesHash() =>
    r'988eefa10446d50a6efe66fe3a4a5f980b27dd1a';

/// See also [supportedLanguages].
@ProviderFor(supportedLanguages)
final supportedLanguagesProvider = AutoDisposeProvider<List<Language>>.internal(
  supportedLanguages,
  name: r'supportedLanguagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supportedLanguagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupportedLanguagesRef = AutoDisposeProviderRef<List<Language>>;
String _$shouldRefreshAppHash() => r'211394108e3fb2ce7280230c97b56e13e867e5aa';

/// See also [shouldRefreshApp].
@ProviderFor(shouldRefreshApp)
final shouldRefreshAppProvider = AutoDisposeProvider<bool>.internal(
  shouldRefreshApp,
  name: r'shouldRefreshAppProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shouldRefreshAppHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShouldRefreshAppRef = AutoDisposeProviderRef<bool>;
String _$languageNotifierHash() => r'cc8589572f331fc508e9e98db7c83db7f778b6f8';

/// See also [LanguageNotifier].
@ProviderFor(LanguageNotifier)
final languageNotifierProvider = AutoDisposeAsyncNotifierProvider<
    LanguageNotifier, LanguageResponse?>.internal(
  LanguageNotifier.new,
  name: r'languageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$languageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LanguageNotifier = AutoDisposeAsyncNotifier<LanguageResponse?>;
String _$languageTestNotifierHash() =>
    r'f3d7adfdae4155a58b86e7953f8eaea31457d32a';

/// See also [LanguageTestNotifier].
@ProviderFor(LanguageTestNotifier)
final languageTestNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LanguageTestNotifier, void>.internal(
  LanguageTestNotifier.new,
  name: r'languageTestNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$languageTestNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LanguageTestNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
