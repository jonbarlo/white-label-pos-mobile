// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_recipe_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$smartRecipeRepositoryHash() =>
    r'21e1cea8df74a1df181cb7a6344c8bf7b7a387c0';

/// See also [smartRecipeRepository].
@ProviderFor(smartRecipeRepository)
final smartRecipeRepositoryProvider =
    AutoDisposeProvider<SmartRecipeRepository>.internal(
  smartRecipeRepository,
  name: r'smartRecipeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$smartRecipeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SmartRecipeRepositoryRef
    = AutoDisposeProviderRef<SmartRecipeRepository>;
String _$smartRecipeSuggestionsHash() =>
    r'0fc4d41cdb8e475241744519d5d510c13eb51ab2';

/// See also [smartRecipeSuggestions].
@ProviderFor(smartRecipeSuggestions)
final smartRecipeSuggestionsProvider =
    AutoDisposeFutureProvider<List<SmartRecipeSuggestion>>.internal(
  smartRecipeSuggestions,
  name: r'smartRecipeSuggestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$smartRecipeSuggestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SmartRecipeSuggestionsRef
    = AutoDisposeFutureProviderRef<List<SmartRecipeSuggestion>>;
String _$inventorySummaryHash() => r'cf67965ca880d42b7accd5cc839079c9d628961c';

/// See also [inventorySummary].
@ProviderFor(inventorySummary)
final inventorySummaryProvider =
    AutoDisposeFutureProvider<InventorySummary>.internal(
  inventorySummary,
  name: r'inventorySummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventorySummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventorySummaryRef = AutoDisposeFutureProviderRef<InventorySummary>;
String _$expiringItemsHash() => r'295d62cb18a539e51a6982724fda3c400e2e6689';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [expiringItems].
@ProviderFor(expiringItems)
const expiringItemsProvider = ExpiringItemsFamily();

/// See also [expiringItems].
class ExpiringItemsFamily extends Family<AsyncValue<List<InventoryItem>>> {
  /// See also [expiringItems].
  const ExpiringItemsFamily();

  /// See also [expiringItems].
  ExpiringItemsProvider call(
    int days,
  ) {
    return ExpiringItemsProvider(
      days,
    );
  }

  @override
  ExpiringItemsProvider getProviderOverride(
    covariant ExpiringItemsProvider provider,
  ) {
    return call(
      provider.days,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expiringItemsProvider';
}

/// See also [expiringItems].
class ExpiringItemsProvider
    extends AutoDisposeFutureProvider<List<InventoryItem>> {
  /// See also [expiringItems].
  ExpiringItemsProvider(
    int days,
  ) : this._internal(
          (ref) => expiringItems(
            ref as ExpiringItemsRef,
            days,
          ),
          from: expiringItemsProvider,
          name: r'expiringItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expiringItemsHash,
          dependencies: ExpiringItemsFamily._dependencies,
          allTransitiveDependencies:
              ExpiringItemsFamily._allTransitiveDependencies,
          days: days,
        );

  ExpiringItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<List<InventoryItem>> Function(ExpiringItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpiringItemsProvider._internal(
        (ref) => create(ref as ExpiringItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<InventoryItem>> createElement() {
    return _ExpiringItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpiringItemsProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpiringItemsRef on AutoDisposeFutureProviderRef<List<InventoryItem>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _ExpiringItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<InventoryItem>>
    with ExpiringItemsRef {
  _ExpiringItemsProviderElement(super.provider);

  @override
  int get days => (origin as ExpiringItemsProvider).days;
}

String _$underperformingItemsHash() =>
    r'68a18073e360f2621a0d7829ebee3d3c817e9606';

/// See also [underperformingItems].
@ProviderFor(underperformingItems)
final underperformingItemsProvider =
    AutoDisposeFutureProvider<List<InventoryItem>>.internal(
  underperformingItems,
  name: r'underperformingItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$underperformingItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnderperformingItemsRef
    = AutoDisposeFutureProviderRef<List<InventoryItem>>;
String _$inventoryAlertsHash() => r'6b908301e80345454b6ffc54798364828ab8e27c';

/// See also [inventoryAlerts].
@ProviderFor(inventoryAlerts)
final inventoryAlertsProvider =
    AutoDisposeFutureProvider<List<InventoryAlert>>.internal(
  inventoryAlerts,
  name: r'inventoryAlertsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryAlertsRef = AutoDisposeFutureProviderRef<List<InventoryAlert>>;
String _$urgentSuggestionsHash() => r'9814cff89a99ca5f6abfff26cfc1c97259dd0ab2';

/// See also [urgentSuggestions].
@ProviderFor(urgentSuggestions)
final urgentSuggestionsProvider =
    AutoDisposeFutureProvider<List<SmartRecipeSuggestion>>.internal(
  urgentSuggestions,
  name: r'urgentSuggestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$urgentSuggestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UrgentSuggestionsRef
    = AutoDisposeFutureProviderRef<List<SmartRecipeSuggestion>>;
String _$mediumSuggestionsHash() => r'e39aa9c5b9029856f182bee836701a486e29de0a';

/// See also [mediumSuggestions].
@ProviderFor(mediumSuggestions)
final mediumSuggestionsProvider =
    AutoDisposeFutureProvider<List<SmartRecipeSuggestion>>.internal(
  mediumSuggestions,
  name: r'mediumSuggestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mediumSuggestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MediumSuggestionsRef
    = AutoDisposeFutureProviderRef<List<SmartRecipeSuggestion>>;
String _$lowSuggestionsHash() => r'5c313dfcbf5dc684fff1d7d763395e9bd1225e03';

/// See also [lowSuggestions].
@ProviderFor(lowSuggestions)
final lowSuggestionsProvider =
    AutoDisposeFutureProvider<List<SmartRecipeSuggestion>>.internal(
  lowSuggestions,
  name: r'lowSuggestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lowSuggestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LowSuggestionsRef
    = AutoDisposeFutureProviderRef<List<SmartRecipeSuggestion>>;
String _$urgentAlertsHash() => r'b481f8912311da3f8c941382a35e5f515da85281';

/// See also [urgentAlerts].
@ProviderFor(urgentAlerts)
final urgentAlertsProvider =
    AutoDisposeFutureProvider<List<InventoryAlert>>.internal(
  urgentAlerts,
  name: r'urgentAlertsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$urgentAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UrgentAlertsRef = AutoDisposeFutureProviderRef<List<InventoryAlert>>;
String _$mediumAlertsHash() => r'92549c4bd51e10c393587d583a8a7aa295c5f004';

/// See also [mediumAlerts].
@ProviderFor(mediumAlerts)
final mediumAlertsProvider =
    AutoDisposeFutureProvider<List<InventoryAlert>>.internal(
  mediumAlerts,
  name: r'mediumAlertsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mediumAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MediumAlertsRef = AutoDisposeFutureProviderRef<List<InventoryAlert>>;
String _$lowAlertsHash() => r'ecf11cab69bf0575fad67b4555c15dab8ebb51cd';

/// See also [lowAlerts].
@ProviderFor(lowAlerts)
final lowAlertsProvider =
    AutoDisposeFutureProvider<List<InventoryAlert>>.internal(
  lowAlerts,
  name: r'lowAlertsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lowAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LowAlertsRef = AutoDisposeFutureProviderRef<List<InventoryAlert>>;
String _$updateTrackingDataHash() =>
    r'993948b3fb033202dd6b05d9d855596cc08282dc';

/// See also [updateTrackingData].
@ProviderFor(updateTrackingData)
final updateTrackingDataProvider = AutoDisposeFutureProvider<void>.internal(
  updateTrackingData,
  name: r'updateTrackingDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateTrackingDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateTrackingDataRef = AutoDisposeFutureProviderRef<void>;
String _$highUrgencyExpiringItemsHash() =>
    r'd9ece6d2c0d4723d971c6718da4cf64e489680fe';

/// See also [highUrgencyExpiringItems].
@ProviderFor(highUrgencyExpiringItems)
final highUrgencyExpiringItemsProvider =
    AutoDisposeFutureProvider<List<InventoryItem>>.internal(
  highUrgencyExpiringItems,
  name: r'highUrgencyExpiringItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highUrgencyExpiringItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HighUrgencyExpiringItemsRef
    = AutoDisposeFutureProviderRef<List<InventoryItem>>;
String _$mediumUrgencyExpiringItemsHash() =>
    r'40805e821a426e1552b143071185561d151a5bc3';

/// See also [mediumUrgencyExpiringItems].
@ProviderFor(mediumUrgencyExpiringItems)
final mediumUrgencyExpiringItemsProvider =
    AutoDisposeFutureProvider<List<InventoryItem>>.internal(
  mediumUrgencyExpiringItems,
  name: r'mediumUrgencyExpiringItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mediumUrgencyExpiringItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MediumUrgencyExpiringItemsRef
    = AutoDisposeFutureProviderRef<List<InventoryItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
