// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryRepositoryHash() =>
    r'cf015468ae3ae78c552e1a3d6d50cf35e80b225d';

/// See also [inventoryRepository].
@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider =
    AutoDisposeProvider<InventoryRepository>.internal(
  inventoryRepository,
  name: r'inventoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryRepositoryRef = AutoDisposeProviderRef<InventoryRepository>;
String _$inventoryItemsHash() => r'19f04ff2fb8893b084414ef464716765c8e62760';

/// See also [inventoryItems].
@ProviderFor(inventoryItems)
final inventoryItemsProvider =
    AutoDisposeFutureProvider<List<InventoryItem>>.internal(
  inventoryItems,
  name: r'inventoryItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryItemsRef = AutoDisposeFutureProviderRef<List<InventoryItem>>;
String _$lowStockItemsHash() => r'7a8dd1bcfe05bab7de96f1ba3266b9378239dda4';

/// See also [lowStockItems].
@ProviderFor(lowStockItems)
final lowStockItemsProvider =
    AutoDisposeFutureProvider<List<InventoryItem>>.internal(
  lowStockItems,
  name: r'lowStockItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lowStockItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LowStockItemsRef = AutoDisposeFutureProviderRef<List<InventoryItem>>;
String _$categoriesHash() => r'd2fd8efe3f9de5098ee160847b330f2bcbe806af';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  categories,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$inventoryHash() => r'59607b4bd6ff544d447055028ec1ed903c224488';

/// See also [Inventory].
@ProviderFor(Inventory)
final inventoryProvider =
    AutoDisposeNotifierProvider<Inventory, InventoryState>.internal(
  Inventory.new,
  name: r'inventoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$inventoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Inventory = AutoDisposeNotifier<InventoryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
