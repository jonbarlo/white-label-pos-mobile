// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$promotionsHash() => r'b4a0756bdaf69fbed0c7f296460f9974d80c26f7';

/// See also [promotions].
@ProviderFor(promotions)
final promotionsProvider = AutoDisposeFutureProvider<List<Promotion>>.internal(
  promotions,
  name: r'promotionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$promotionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromotionsRef = AutoDisposeFutureProviderRef<List<Promotion>>;
String _$activePromotionsHash() => r'12a77712414c63a11452450527a1cccb3a5a30e3';

/// See also [activePromotions].
@ProviderFor(activePromotions)
final activePromotionsProvider =
    AutoDisposeFutureProvider<List<Promotion>>.internal(
  activePromotions,
  name: r'activePromotionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activePromotionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivePromotionsRef = AutoDisposeFutureProviderRef<List<Promotion>>;
String _$promotionsByTypeHash() => r'a475da947aa4680ee5614f219d4a3b6cc3d99d2c';

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

/// See also [promotionsByType].
@ProviderFor(promotionsByType)
const promotionsByTypeProvider = PromotionsByTypeFamily();

/// See also [promotionsByType].
class PromotionsByTypeFamily extends Family<AsyncValue<List<Promotion>>> {
  /// See also [promotionsByType].
  const PromotionsByTypeFamily();

  /// See also [promotionsByType].
  PromotionsByTypeProvider call(
    String type,
  ) {
    return PromotionsByTypeProvider(
      type,
    );
  }

  @override
  PromotionsByTypeProvider getProviderOverride(
    covariant PromotionsByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'promotionsByTypeProvider';
}

/// See also [promotionsByType].
class PromotionsByTypeProvider
    extends AutoDisposeFutureProvider<List<Promotion>> {
  /// See also [promotionsByType].
  PromotionsByTypeProvider(
    String type,
  ) : this._internal(
          (ref) => promotionsByType(
            ref as PromotionsByTypeRef,
            type,
          ),
          from: promotionsByTypeProvider,
          name: r'promotionsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$promotionsByTypeHash,
          dependencies: PromotionsByTypeFamily._dependencies,
          allTransitiveDependencies:
              PromotionsByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  PromotionsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  Override overrideWith(
    FutureOr<List<Promotion>> Function(PromotionsByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PromotionsByTypeProvider._internal(
        (ref) => create(ref as PromotionsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Promotion>> createElement() {
    return _PromotionsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PromotionsByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PromotionsByTypeRef on AutoDisposeFutureProviderRef<List<Promotion>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _PromotionsByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<Promotion>>
    with PromotionsByTypeRef {
  _PromotionsByTypeProviderElement(super.provider);

  @override
  String get type => (origin as PromotionsByTypeProvider).type;
}

String _$promotionsNotifierHash() =>
    r'22eb58dd551e11963435a0d290ef98710efb60b7';

/// See also [PromotionsNotifier].
@ProviderFor(PromotionsNotifier)
final promotionsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    PromotionsNotifier, List<Promotion>>.internal(
  PromotionsNotifier.new,
  name: r'promotionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promotionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PromotionsNotifier = AutoDisposeAsyncNotifier<List<Promotion>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
