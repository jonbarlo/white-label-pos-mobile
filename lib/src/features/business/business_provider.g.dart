// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$businessesHash() => r'896dde1f5c8052ab046c16f340a380c71f4eecf6';

/// See also [Businesses].
@ProviderFor(Businesses)
final businessesProvider =
    AutoDisposeAsyncNotifierProvider<Businesses, List<Business>>.internal(
  Businesses.new,
  name: r'businessesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$businessesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Businesses = AutoDisposeAsyncNotifier<List<Business>>;
String _$businessNotifierHash() => r'6a5737b2df7b99285d75ec905398ca1074396ca8';

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

abstract class _$BusinessNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Business?> {
  late final int businessId;

  FutureOr<Business?> build(
    int businessId,
  );
}

/// See also [BusinessNotifier].
@ProviderFor(BusinessNotifier)
const businessNotifierProvider = BusinessNotifierFamily();

/// See also [BusinessNotifier].
class BusinessNotifierFamily extends Family<AsyncValue<Business?>> {
  /// See also [BusinessNotifier].
  const BusinessNotifierFamily();

  /// See also [BusinessNotifier].
  BusinessNotifierProvider call(
    int businessId,
  ) {
    return BusinessNotifierProvider(
      businessId,
    );
  }

  @override
  BusinessNotifierProvider getProviderOverride(
    covariant BusinessNotifierProvider provider,
  ) {
    return call(
      provider.businessId,
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
  String? get name => r'businessNotifierProvider';
}

/// See also [BusinessNotifier].
class BusinessNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BusinessNotifier, Business?> {
  /// See also [BusinessNotifier].
  BusinessNotifierProvider(
    int businessId,
  ) : this._internal(
          () => BusinessNotifier()..businessId = businessId,
          from: businessNotifierProvider,
          name: r'businessNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$businessNotifierHash,
          dependencies: BusinessNotifierFamily._dependencies,
          allTransitiveDependencies:
              BusinessNotifierFamily._allTransitiveDependencies,
          businessId: businessId,
        );

  BusinessNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessId,
  }) : super.internal();

  final int businessId;

  @override
  FutureOr<Business?> runNotifierBuild(
    covariant BusinessNotifier notifier,
  ) {
    return notifier.build(
      businessId,
    );
  }

  @override
  Override overrideWith(BusinessNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BusinessNotifierProvider._internal(
        () => create()..businessId = businessId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessId: businessId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BusinessNotifier, Business?>
      createElement() {
    return _BusinessNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessNotifierProvider && other.businessId == businessId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BusinessNotifierRef on AutoDisposeAsyncNotifierProviderRef<Business?> {
  /// The parameter `businessId` of this provider.
  int get businessId;
}

class _BusinessNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BusinessNotifier, Business?>
    with BusinessNotifierRef {
  _BusinessNotifierProviderElement(super.provider);

  @override
  int get businessId => (origin as BusinessNotifierProvider).businessId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
