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
String _$inventoryItemsHash() => r'31428c5ef6bb46f7051953dc9d58479a69812bc6';

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
String _$lowStockItemsHash() => r'7f5d9f1d020a1cbb7fbc9e2c398113f8305eadfa';

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
String _$categoriesHash() => r'9e058b1834749b30a0db69c73ee944c8e311da29';

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
String _$inventoryHash() => r'96db431064a2ea7509ed563151675b6e07f696f8';

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
