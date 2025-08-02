// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currencyRepositoryHash() =>
    r'8d2676b283f7731cf479f3a0f5262685aaa8ba55';

/// See also [currencyRepository].
@ProviderFor(currencyRepository)
final currencyRepositoryProvider =
    AutoDisposeProvider<CurrencyRepository>.internal(
  currencyRepository,
  name: r'currencyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrencyRepositoryRef = AutoDisposeProviderRef<CurrencyRepository>;
String _$defaultCurrencyHash() => r'76b127d5fbe8476d3561aad1007c2783a5c1d526';

/// See also [defaultCurrency].
@ProviderFor(defaultCurrency)
final defaultCurrencyProvider = AutoDisposeProvider<Currency?>.internal(
  defaultCurrency,
  name: r'defaultCurrencyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$defaultCurrencyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefaultCurrencyRef = AutoDisposeProviderRef<Currency?>;
String _$formatCurrencyHash() => r'92317d6c5ab1e8c5cdfe217960b44443cc71847f';

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

/// See also [formatCurrency].
@ProviderFor(formatCurrency)
const formatCurrencyProvider = FormatCurrencyFamily();

/// See also [formatCurrency].
class FormatCurrencyFamily extends Family<String> {
  /// See also [formatCurrency].
  const FormatCurrencyFamily();

  /// See also [formatCurrency].
  FormatCurrencyProvider call(
    double amount, {
    Currency? currency,
  }) {
    return FormatCurrencyProvider(
      amount,
      currency: currency,
    );
  }

  @override
  FormatCurrencyProvider getProviderOverride(
    covariant FormatCurrencyProvider provider,
  ) {
    return call(
      provider.amount,
      currency: provider.currency,
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
  String? get name => r'formatCurrencyProvider';
}

/// See also [formatCurrency].
class FormatCurrencyProvider extends AutoDisposeProvider<String> {
  /// See also [formatCurrency].
  FormatCurrencyProvider(
    double amount, {
    Currency? currency,
  }) : this._internal(
          (ref) => formatCurrency(
            ref as FormatCurrencyRef,
            amount,
            currency: currency,
          ),
          from: formatCurrencyProvider,
          name: r'formatCurrencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$formatCurrencyHash,
          dependencies: FormatCurrencyFamily._dependencies,
          allTransitiveDependencies:
              FormatCurrencyFamily._allTransitiveDependencies,
          amount: amount,
          currency: currency,
        );

  FormatCurrencyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.amount,
    required this.currency,
  }) : super.internal();

  final double amount;
  final Currency? currency;

  @override
  Override overrideWith(
    String Function(FormatCurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FormatCurrencyProvider._internal(
        (ref) => create(ref as FormatCurrencyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        amount: amount,
        currency: currency,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _FormatCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FormatCurrencyProvider &&
        other.amount == amount &&
        other.currency == currency;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);
    hash = _SystemHash.combine(hash, currency.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FormatCurrencyRef on AutoDisposeProviderRef<String> {
  /// The parameter `amount` of this provider.
  double get amount;

  /// The parameter `currency` of this provider.
  Currency? get currency;
}

class _FormatCurrencyProviderElement extends AutoDisposeProviderElement<String>
    with FormatCurrencyRef {
  _FormatCurrencyProviderElement(super.provider);

  @override
  double get amount => (origin as FormatCurrencyProvider).amount;
  @override
  Currency? get currency => (origin as FormatCurrencyProvider).currency;
}

String _$currencyNotifierHash() => r'fc41eed63632ee1329f6bf859ac4f7e0ea01d9ec';

/// See also [CurrencyNotifier].
@ProviderFor(CurrencyNotifier)
final currencyNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CurrencyNotifier, Result<List<Currency>>>.internal(
  CurrencyNotifier.new,
  name: r'currencyNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencyNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrencyNotifier = AutoDisposeAsyncNotifier<Result<List<Currency>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
