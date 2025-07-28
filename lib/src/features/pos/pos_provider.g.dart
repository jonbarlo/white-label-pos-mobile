// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$posRepositoryHash() => r'011c480286c06f2a1fa056820e0e62f2952756a8';

/// See also [posRepository].
@ProviderFor(posRepository)
final posRepositoryProvider = AutoDisposeFutureProvider<PosRepository>.internal(
  posRepository,
  name: r'posRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$posRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PosRepositoryRef = AutoDisposeFutureProviderRef<PosRepository>;
String _$cartTotalHash() => r'3095ca29bd6cd95ea9e059b336f4e2dd6821b139';

/// See also [cartTotal].
@ProviderFor(cartTotal)
final cartTotalProvider = AutoDisposeProvider<double>.internal(
  cartTotal,
  name: r'cartTotalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartTotalRef = AutoDisposeProviderRef<double>;
String _$createSaleHash() => r'fc6a28f6822b485d62617d96ae5c63c270c19d07';

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

/// See also [createSale].
@ProviderFor(createSale)
const createSaleProvider = CreateSaleFamily();

/// See also [createSale].
class CreateSaleFamily extends Family<AsyncValue<Sale>> {
  /// See also [createSale].
  const CreateSaleFamily();

  /// See also [createSale].
  CreateSaleProvider call(
    PaymentMethod paymentMethod, {
    String? customerName,
    String? customerEmail,
  }) {
    return CreateSaleProvider(
      paymentMethod,
      customerName: customerName,
      customerEmail: customerEmail,
    );
  }

  @override
  CreateSaleProvider getProviderOverride(
    covariant CreateSaleProvider provider,
  ) {
    return call(
      provider.paymentMethod,
      customerName: provider.customerName,
      customerEmail: provider.customerEmail,
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
  String? get name => r'createSaleProvider';
}

/// See also [createSale].
class CreateSaleProvider extends AutoDisposeFutureProvider<Sale> {
  /// See also [createSale].
  CreateSaleProvider(
    PaymentMethod paymentMethod, {
    String? customerName,
    String? customerEmail,
  }) : this._internal(
          (ref) => createSale(
            ref as CreateSaleRef,
            paymentMethod,
            customerName: customerName,
            customerEmail: customerEmail,
          ),
          from: createSaleProvider,
          name: r'createSaleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createSaleHash,
          dependencies: CreateSaleFamily._dependencies,
          allTransitiveDependencies:
              CreateSaleFamily._allTransitiveDependencies,
          paymentMethod: paymentMethod,
          customerName: customerName,
          customerEmail: customerEmail,
        );

  CreateSaleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentMethod,
    required this.customerName,
    required this.customerEmail,
  }) : super.internal();

  final PaymentMethod paymentMethod;
  final String? customerName;
  final String? customerEmail;

  @override
  Override overrideWith(
    FutureOr<Sale> Function(CreateSaleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateSaleProvider._internal(
        (ref) => create(ref as CreateSaleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentMethod: paymentMethod,
        customerName: customerName,
        customerEmail: customerEmail,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Sale> createElement() {
    return _CreateSaleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateSaleProvider &&
        other.paymentMethod == paymentMethod &&
        other.customerName == customerName &&
        other.customerEmail == customerEmail;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);
    hash = _SystemHash.combine(hash, customerName.hashCode);
    hash = _SystemHash.combine(hash, customerEmail.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateSaleRef on AutoDisposeFutureProviderRef<Sale> {
  /// The parameter `paymentMethod` of this provider.
  PaymentMethod get paymentMethod;

  /// The parameter `customerName` of this provider.
  String? get customerName;

  /// The parameter `customerEmail` of this provider.
  String? get customerEmail;
}

class _CreateSaleProviderElement extends AutoDisposeFutureProviderElement<Sale>
    with CreateSaleRef {
  _CreateSaleProviderElement(super.provider);

  @override
  PaymentMethod get paymentMethod =>
      (origin as CreateSaleProvider).paymentMethod;
  @override
  String? get customerName => (origin as CreateSaleProvider).customerName;
  @override
  String? get customerEmail => (origin as CreateSaleProvider).customerEmail;
}

String _$scanBarcodeHash() => r'6e6bfbe7e3c9885b917d66472796d3a6d382ee87';

/// See also [scanBarcode].
@ProviderFor(scanBarcode)
const scanBarcodeProvider = ScanBarcodeFamily();

/// See also [scanBarcode].
class ScanBarcodeFamily extends Family<AsyncValue<CartItem?>> {
  /// See also [scanBarcode].
  const ScanBarcodeFamily();

  /// See also [scanBarcode].
  ScanBarcodeProvider call(
    String barcode,
  ) {
    return ScanBarcodeProvider(
      barcode,
    );
  }

  @override
  ScanBarcodeProvider getProviderOverride(
    covariant ScanBarcodeProvider provider,
  ) {
    return call(
      provider.barcode,
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
  String? get name => r'scanBarcodeProvider';
}

/// See also [scanBarcode].
class ScanBarcodeProvider extends AutoDisposeFutureProvider<CartItem?> {
  /// See also [scanBarcode].
  ScanBarcodeProvider(
    String barcode,
  ) : this._internal(
          (ref) => scanBarcode(
            ref as ScanBarcodeRef,
            barcode,
          ),
          from: scanBarcodeProvider,
          name: r'scanBarcodeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scanBarcodeHash,
          dependencies: ScanBarcodeFamily._dependencies,
          allTransitiveDependencies:
              ScanBarcodeFamily._allTransitiveDependencies,
          barcode: barcode,
        );

  ScanBarcodeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.barcode,
  }) : super.internal();

  final String barcode;

  @override
  Override overrideWith(
    FutureOr<CartItem?> Function(ScanBarcodeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScanBarcodeProvider._internal(
        (ref) => create(ref as ScanBarcodeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        barcode: barcode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CartItem?> createElement() {
    return _ScanBarcodeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScanBarcodeProvider && other.barcode == barcode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, barcode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScanBarcodeRef on AutoDisposeFutureProviderRef<CartItem?> {
  /// The parameter `barcode` of this provider.
  String get barcode;
}

class _ScanBarcodeProviderElement
    extends AutoDisposeFutureProviderElement<CartItem?> with ScanBarcodeRef {
  _ScanBarcodeProviderElement(super.provider);

  @override
  String get barcode => (origin as ScanBarcodeProvider).barcode;
}

String _$salesSummaryHash() => r'2c7a6bf253af04d5b883282bde83d11cbd64bb4b';

/// See also [salesSummary].
@ProviderFor(salesSummary)
const salesSummaryProvider = SalesSummaryFamily();

/// See also [salesSummary].
class SalesSummaryFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [salesSummary].
  const SalesSummaryFamily();

  /// See also [salesSummary].
  SalesSummaryProvider call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return SalesSummaryProvider(
      startDate,
      endDate,
    );
  }

  @override
  SalesSummaryProvider getProviderOverride(
    covariant SalesSummaryProvider provider,
  ) {
    return call(
      provider.startDate,
      provider.endDate,
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
  String? get name => r'salesSummaryProvider';
}

/// See also [salesSummary].
class SalesSummaryProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [salesSummary].
  SalesSummaryProvider(
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
          (ref) => salesSummary(
            ref as SalesSummaryRef,
            startDate,
            endDate,
          ),
          from: salesSummaryProvider,
          name: r'salesSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$salesSummaryHash,
          dependencies: SalesSummaryFamily._dependencies,
          allTransitiveDependencies:
              SalesSummaryFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  SalesSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(SalesSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SalesSummaryProvider._internal(
        (ref) => create(ref as SalesSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _SalesSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesSummaryProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SalesSummaryRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _SalesSummaryProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with SalesSummaryRef {
  _SalesSummaryProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as SalesSummaryProvider).startDate;
  @override
  DateTime get endDate => (origin as SalesSummaryProvider).endDate;
}

String _$topSellingItemsHash() => r'31799e0b8bacbb1b6a032350f7acd65aec4fcfa8';

/// See also [topSellingItems].
@ProviderFor(topSellingItems)
const topSellingItemsProvider = TopSellingItemsFamily();

/// See also [topSellingItems].
class TopSellingItemsFamily extends Family<AsyncValue<List<CartItem>>> {
  /// See also [topSellingItems].
  const TopSellingItemsFamily();

  /// See also [topSellingItems].
  TopSellingItemsProvider call({
    int limit = 10,
  }) {
    return TopSellingItemsProvider(
      limit: limit,
    );
  }

  @override
  TopSellingItemsProvider getProviderOverride(
    covariant TopSellingItemsProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'topSellingItemsProvider';
}

/// See also [topSellingItems].
class TopSellingItemsProvider
    extends AutoDisposeFutureProvider<List<CartItem>> {
  /// See also [topSellingItems].
  TopSellingItemsProvider({
    int limit = 10,
  }) : this._internal(
          (ref) => topSellingItems(
            ref as TopSellingItemsRef,
            limit: limit,
          ),
          from: topSellingItemsProvider,
          name: r'topSellingItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topSellingItemsHash,
          dependencies: TopSellingItemsFamily._dependencies,
          allTransitiveDependencies:
              TopSellingItemsFamily._allTransitiveDependencies,
          limit: limit,
        );

  TopSellingItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<CartItem>> Function(TopSellingItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopSellingItemsProvider._internal(
        (ref) => create(ref as TopSellingItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CartItem>> createElement() {
    return _TopSellingItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopSellingItemsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopSellingItemsRef on AutoDisposeFutureProviderRef<List<CartItem>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _TopSellingItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<CartItem>>
    with TopSellingItemsRef {
  _TopSellingItemsProviderElement(super.provider);

  @override
  int get limit => (origin as TopSellingItemsProvider).limit;
}

String _$createSplitSaleHash() => r'2dd7b2a9d79940d20f873a726859e97f7fc9d373';

/// See also [createSplitSale].
@ProviderFor(createSplitSale)
const createSplitSaleProvider = CreateSplitSaleFamily();

/// See also [createSplitSale].
class CreateSplitSaleFamily extends Family<AsyncValue<SplitSaleResponse>> {
  /// See also [createSplitSale].
  const CreateSplitSaleFamily();

  /// See also [createSplitSale].
  CreateSplitSaleProvider call(
    SplitSaleRequest request,
  ) {
    return CreateSplitSaleProvider(
      request,
    );
  }

  @override
  CreateSplitSaleProvider getProviderOverride(
    covariant CreateSplitSaleProvider provider,
  ) {
    return call(
      provider.request,
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
  String? get name => r'createSplitSaleProvider';
}

/// See also [createSplitSale].
class CreateSplitSaleProvider
    extends AutoDisposeFutureProvider<SplitSaleResponse> {
  /// See also [createSplitSale].
  CreateSplitSaleProvider(
    SplitSaleRequest request,
  ) : this._internal(
          (ref) => createSplitSale(
            ref as CreateSplitSaleRef,
            request,
          ),
          from: createSplitSaleProvider,
          name: r'createSplitSaleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createSplitSaleHash,
          dependencies: CreateSplitSaleFamily._dependencies,
          allTransitiveDependencies:
              CreateSplitSaleFamily._allTransitiveDependencies,
          request: request,
        );

  CreateSplitSaleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final SplitSaleRequest request;

  @override
  Override overrideWith(
    FutureOr<SplitSaleResponse> Function(CreateSplitSaleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateSplitSaleProvider._internal(
        (ref) => create(ref as CreateSplitSaleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        request: request,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SplitSaleResponse> createElement() {
    return _CreateSplitSaleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateSplitSaleProvider && other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateSplitSaleRef on AutoDisposeFutureProviderRef<SplitSaleResponse> {
  /// The parameter `request` of this provider.
  SplitSaleRequest get request;
}

class _CreateSplitSaleProviderElement
    extends AutoDisposeFutureProviderElement<SplitSaleResponse>
    with CreateSplitSaleRef {
  _CreateSplitSaleProviderElement(super.provider);

  @override
  SplitSaleRequest get request => (origin as CreateSplitSaleProvider).request;
}

String _$addPaymentToSaleHash() => r'201863ff865f0313c320098e35fd5ca7f05e79b9';

/// See also [addPaymentToSale].
@ProviderFor(addPaymentToSale)
const addPaymentToSaleProvider = AddPaymentToSaleFamily();

/// See also [addPaymentToSale].
class AddPaymentToSaleFamily extends Family<AsyncValue<SplitSale>> {
  /// See also [addPaymentToSale].
  const AddPaymentToSaleFamily();

  /// See also [addPaymentToSale].
  AddPaymentToSaleProvider call(
    int saleId,
    AddPaymentRequest request,
  ) {
    return AddPaymentToSaleProvider(
      saleId,
      request,
    );
  }

  @override
  AddPaymentToSaleProvider getProviderOverride(
    covariant AddPaymentToSaleProvider provider,
  ) {
    return call(
      provider.saleId,
      provider.request,
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
  String? get name => r'addPaymentToSaleProvider';
}

/// See also [addPaymentToSale].
class AddPaymentToSaleProvider extends AutoDisposeFutureProvider<SplitSale> {
  /// See also [addPaymentToSale].
  AddPaymentToSaleProvider(
    int saleId,
    AddPaymentRequest request,
  ) : this._internal(
          (ref) => addPaymentToSale(
            ref as AddPaymentToSaleRef,
            saleId,
            request,
          ),
          from: addPaymentToSaleProvider,
          name: r'addPaymentToSaleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addPaymentToSaleHash,
          dependencies: AddPaymentToSaleFamily._dependencies,
          allTransitiveDependencies:
              AddPaymentToSaleFamily._allTransitiveDependencies,
          saleId: saleId,
          request: request,
        );

  AddPaymentToSaleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.saleId,
    required this.request,
  }) : super.internal();

  final int saleId;
  final AddPaymentRequest request;

  @override
  Override overrideWith(
    FutureOr<SplitSale> Function(AddPaymentToSaleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddPaymentToSaleProvider._internal(
        (ref) => create(ref as AddPaymentToSaleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        saleId: saleId,
        request: request,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SplitSale> createElement() {
    return _AddPaymentToSaleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddPaymentToSaleProvider &&
        other.saleId == saleId &&
        other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, saleId.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddPaymentToSaleRef on AutoDisposeFutureProviderRef<SplitSale> {
  /// The parameter `saleId` of this provider.
  int get saleId;

  /// The parameter `request` of this provider.
  AddPaymentRequest get request;
}

class _AddPaymentToSaleProviderElement
    extends AutoDisposeFutureProviderElement<SplitSale>
    with AddPaymentToSaleRef {
  _AddPaymentToSaleProviderElement(super.provider);

  @override
  int get saleId => (origin as AddPaymentToSaleProvider).saleId;
  @override
  AddPaymentRequest get request => (origin as AddPaymentToSaleProvider).request;
}

String _$refundSplitPaymentHash() =>
    r'01b7a3c0e000b135af4e8afe16509ac49407c1a6';

/// See also [refundSplitPayment].
@ProviderFor(refundSplitPayment)
const refundSplitPaymentProvider = RefundSplitPaymentFamily();

/// See also [refundSplitPayment].
class RefundSplitPaymentFamily extends Family<AsyncValue<SplitSale>> {
  /// See also [refundSplitPayment].
  const RefundSplitPaymentFamily();

  /// See also [refundSplitPayment].
  RefundSplitPaymentProvider call(
    int saleId,
    RefundRequest request,
  ) {
    return RefundSplitPaymentProvider(
      saleId,
      request,
    );
  }

  @override
  RefundSplitPaymentProvider getProviderOverride(
    covariant RefundSplitPaymentProvider provider,
  ) {
    return call(
      provider.saleId,
      provider.request,
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
  String? get name => r'refundSplitPaymentProvider';
}

/// See also [refundSplitPayment].
class RefundSplitPaymentProvider extends AutoDisposeFutureProvider<SplitSale> {
  /// See also [refundSplitPayment].
  RefundSplitPaymentProvider(
    int saleId,
    RefundRequest request,
  ) : this._internal(
          (ref) => refundSplitPayment(
            ref as RefundSplitPaymentRef,
            saleId,
            request,
          ),
          from: refundSplitPaymentProvider,
          name: r'refundSplitPaymentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$refundSplitPaymentHash,
          dependencies: RefundSplitPaymentFamily._dependencies,
          allTransitiveDependencies:
              RefundSplitPaymentFamily._allTransitiveDependencies,
          saleId: saleId,
          request: request,
        );

  RefundSplitPaymentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.saleId,
    required this.request,
  }) : super.internal();

  final int saleId;
  final RefundRequest request;

  @override
  Override overrideWith(
    FutureOr<SplitSale> Function(RefundSplitPaymentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RefundSplitPaymentProvider._internal(
        (ref) => create(ref as RefundSplitPaymentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        saleId: saleId,
        request: request,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SplitSale> createElement() {
    return _RefundSplitPaymentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RefundSplitPaymentProvider &&
        other.saleId == saleId &&
        other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, saleId.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RefundSplitPaymentRef on AutoDisposeFutureProviderRef<SplitSale> {
  /// The parameter `saleId` of this provider.
  int get saleId;

  /// The parameter `request` of this provider.
  RefundRequest get request;
}

class _RefundSplitPaymentProviderElement
    extends AutoDisposeFutureProviderElement<SplitSale>
    with RefundSplitPaymentRef {
  _RefundSplitPaymentProviderElement(super.provider);

  @override
  int get saleId => (origin as RefundSplitPaymentProvider).saleId;
  @override
  RefundRequest get request => (origin as RefundSplitPaymentProvider).request;
}

String _$getSplitBillingStatsHash() =>
    r'03e6342ed99a49e32fb4b4ec588adb25fd3dee24';

/// See also [getSplitBillingStats].
@ProviderFor(getSplitBillingStats)
final getSplitBillingStatsProvider =
    AutoDisposeFutureProvider<SplitBillingStats>.internal(
  getSplitBillingStats,
  name: r'getSplitBillingStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSplitBillingStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetSplitBillingStatsRef
    = AutoDisposeFutureProviderRef<SplitBillingStats>;
String _$menuItemsHash() => r'e9edb21f968f924b8cab89c4230215032fa17261';

/// See also [menuItems].
@ProviderFor(menuItems)
final menuItemsProvider = AutoDisposeFutureProvider<List<MenuItem>>.internal(
  menuItems,
  name: r'menuItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$menuItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MenuItemsRef = AutoDisposeFutureProviderRef<List<MenuItem>>;
String _$itemAnalyticsHash() => r'8dc998c701ab0aa953d09465be2d2265d056f9d1';

/// See also [itemAnalytics].
@ProviderFor(itemAnalytics)
const itemAnalyticsProvider = ItemAnalyticsFamily();

/// See also [itemAnalytics].
class ItemAnalyticsFamily extends Family<AsyncValue<ItemAnalytics>> {
  /// See also [itemAnalytics].
  const ItemAnalyticsFamily();

  /// See also [itemAnalytics].
  ItemAnalyticsProvider call({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return ItemAnalyticsProvider(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  @override
  ItemAnalyticsProvider getProviderOverride(
    covariant ItemAnalyticsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      limit: provider.limit,
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
  String? get name => r'itemAnalyticsProvider';
}

/// See also [itemAnalytics].
class ItemAnalyticsProvider extends AutoDisposeFutureProvider<ItemAnalytics> {
  /// See also [itemAnalytics].
  ItemAnalyticsProvider({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) : this._internal(
          (ref) => itemAnalytics(
            ref as ItemAnalyticsRef,
            startDate: startDate,
            endDate: endDate,
            limit: limit,
          ),
          from: itemAnalyticsProvider,
          name: r'itemAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemAnalyticsHash,
          dependencies: ItemAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              ItemAnalyticsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          limit: limit,
        );

  ItemAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.limit,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;

  @override
  Override overrideWith(
    FutureOr<ItemAnalytics> Function(ItemAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemAnalyticsProvider._internal(
        (ref) => create(ref as ItemAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ItemAnalytics> createElement() {
    return _ItemAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemAnalyticsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemAnalyticsRef on AutoDisposeFutureProviderRef<ItemAnalytics> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _ItemAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<ItemAnalytics>
    with ItemAnalyticsRef {
  _ItemAnalyticsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as ItemAnalyticsProvider).startDate;
  @override
  DateTime? get endDate => (origin as ItemAnalyticsProvider).endDate;
  @override
  int? get limit => (origin as ItemAnalyticsProvider).limit;
}

String _$revenueAnalyticsHash() => r'557d3a3eda5396e6be718340a43d567bb89bc7a5';

/// See also [revenueAnalytics].
@ProviderFor(revenueAnalytics)
const revenueAnalyticsProvider = RevenueAnalyticsFamily();

/// See also [revenueAnalytics].
class RevenueAnalyticsFamily extends Family<AsyncValue<RevenueAnalytics>> {
  /// See also [revenueAnalytics].
  const RevenueAnalyticsFamily();

  /// See also [revenueAnalytics].
  RevenueAnalyticsProvider call({
    DateTime? startDate,
    DateTime? endDate,
    String? period,
  }) {
    return RevenueAnalyticsProvider(
      startDate: startDate,
      endDate: endDate,
      period: period,
    );
  }

  @override
  RevenueAnalyticsProvider getProviderOverride(
    covariant RevenueAnalyticsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      period: provider.period,
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
  String? get name => r'revenueAnalyticsProvider';
}

/// See also [revenueAnalytics].
class RevenueAnalyticsProvider
    extends AutoDisposeFutureProvider<RevenueAnalytics> {
  /// See also [revenueAnalytics].
  RevenueAnalyticsProvider({
    DateTime? startDate,
    DateTime? endDate,
    String? period,
  }) : this._internal(
          (ref) => revenueAnalytics(
            ref as RevenueAnalyticsRef,
            startDate: startDate,
            endDate: endDate,
            period: period,
          ),
          from: revenueAnalyticsProvider,
          name: r'revenueAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$revenueAnalyticsHash,
          dependencies: RevenueAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              RevenueAnalyticsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          period: period,
        );

  RevenueAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.period,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;
  final String? period;

  @override
  Override overrideWith(
    FutureOr<RevenueAnalytics> Function(RevenueAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RevenueAnalyticsProvider._internal(
        (ref) => create(ref as RevenueAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RevenueAnalytics> createElement() {
    return _RevenueAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RevenueAnalyticsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RevenueAnalyticsRef on AutoDisposeFutureProviderRef<RevenueAnalytics> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `period` of this provider.
  String? get period;
}

class _RevenueAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<RevenueAnalytics>
    with RevenueAnalyticsRef {
  _RevenueAnalyticsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as RevenueAnalyticsProvider).startDate;
  @override
  DateTime? get endDate => (origin as RevenueAnalyticsProvider).endDate;
  @override
  String? get period => (origin as RevenueAnalyticsProvider).period;
}

String _$staffAnalyticsHash() => r'acc309e0af4a289dea6ae98d108de407e93e02b0';

/// See also [staffAnalytics].
@ProviderFor(staffAnalytics)
const staffAnalyticsProvider = StaffAnalyticsFamily();

/// See also [staffAnalytics].
class StaffAnalyticsFamily extends Family<AsyncValue<StaffAnalytics>> {
  /// See also [staffAnalytics].
  const StaffAnalyticsFamily();

  /// See also [staffAnalytics].
  StaffAnalyticsProvider call({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return StaffAnalyticsProvider(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  @override
  StaffAnalyticsProvider getProviderOverride(
    covariant StaffAnalyticsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      limit: provider.limit,
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
  String? get name => r'staffAnalyticsProvider';
}

/// See also [staffAnalytics].
class StaffAnalyticsProvider extends AutoDisposeFutureProvider<StaffAnalytics> {
  /// See also [staffAnalytics].
  StaffAnalyticsProvider({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) : this._internal(
          (ref) => staffAnalytics(
            ref as StaffAnalyticsRef,
            startDate: startDate,
            endDate: endDate,
            limit: limit,
          ),
          from: staffAnalyticsProvider,
          name: r'staffAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$staffAnalyticsHash,
          dependencies: StaffAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              StaffAnalyticsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          limit: limit,
        );

  StaffAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.limit,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;

  @override
  Override overrideWith(
    FutureOr<StaffAnalytics> Function(StaffAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StaffAnalyticsProvider._internal(
        (ref) => create(ref as StaffAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<StaffAnalytics> createElement() {
    return _StaffAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StaffAnalyticsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StaffAnalyticsRef on AutoDisposeFutureProviderRef<StaffAnalytics> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _StaffAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<StaffAnalytics>
    with StaffAnalyticsRef {
  _StaffAnalyticsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as StaffAnalyticsProvider).startDate;
  @override
  DateTime? get endDate => (origin as StaffAnalyticsProvider).endDate;
  @override
  int? get limit => (origin as StaffAnalyticsProvider).limit;
}

String _$customerAnalyticsHash() => r'2c1b59c4a33a4a5ae4ec99d48440133152b66ed0';

/// See also [customerAnalytics].
@ProviderFor(customerAnalytics)
const customerAnalyticsProvider = CustomerAnalyticsFamily();

/// See also [customerAnalytics].
class CustomerAnalyticsFamily extends Family<AsyncValue<CustomerAnalytics>> {
  /// See also [customerAnalytics].
  const CustomerAnalyticsFamily();

  /// See also [customerAnalytics].
  CustomerAnalyticsProvider call({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    return CustomerAnalyticsProvider(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  @override
  CustomerAnalyticsProvider getProviderOverride(
    covariant CustomerAnalyticsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      limit: provider.limit,
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
  String? get name => r'customerAnalyticsProvider';
}

/// See also [customerAnalytics].
class CustomerAnalyticsProvider
    extends AutoDisposeFutureProvider<CustomerAnalytics> {
  /// See also [customerAnalytics].
  CustomerAnalyticsProvider({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) : this._internal(
          (ref) => customerAnalytics(
            ref as CustomerAnalyticsRef,
            startDate: startDate,
            endDate: endDate,
            limit: limit,
          ),
          from: customerAnalyticsProvider,
          name: r'customerAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerAnalyticsHash,
          dependencies: CustomerAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              CustomerAnalyticsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          limit: limit,
        );

  CustomerAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.limit,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;

  @override
  Override overrideWith(
    FutureOr<CustomerAnalytics> Function(CustomerAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerAnalyticsProvider._internal(
        (ref) => create(ref as CustomerAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CustomerAnalytics> createElement() {
    return _CustomerAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerAnalyticsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerAnalyticsRef on AutoDisposeFutureProviderRef<CustomerAnalytics> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _CustomerAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<CustomerAnalytics>
    with CustomerAnalyticsRef {
  _CustomerAnalyticsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as CustomerAnalyticsProvider).startDate;
  @override
  DateTime? get endDate => (origin as CustomerAnalyticsProvider).endDate;
  @override
  int? get limit => (origin as CustomerAnalyticsProvider).limit;
}

String _$inventoryAnalyticsHash() =>
    r'8da59ca779e9f21c095c0796d92600ea0f40a2b5';

/// See also [inventoryAnalytics].
@ProviderFor(inventoryAnalytics)
const inventoryAnalyticsProvider = InventoryAnalyticsFamily();

/// See also [inventoryAnalytics].
class InventoryAnalyticsFamily extends Family<AsyncValue<InventoryAnalytics>> {
  /// See also [inventoryAnalytics].
  const InventoryAnalyticsFamily();

  /// See also [inventoryAnalytics].
  InventoryAnalyticsProvider call({
    int? limit,
  }) {
    return InventoryAnalyticsProvider(
      limit: limit,
    );
  }

  @override
  InventoryAnalyticsProvider getProviderOverride(
    covariant InventoryAnalyticsProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'inventoryAnalyticsProvider';
}

/// See also [inventoryAnalytics].
class InventoryAnalyticsProvider
    extends AutoDisposeFutureProvider<InventoryAnalytics> {
  /// See also [inventoryAnalytics].
  InventoryAnalyticsProvider({
    int? limit,
  }) : this._internal(
          (ref) => inventoryAnalytics(
            ref as InventoryAnalyticsRef,
            limit: limit,
          ),
          from: inventoryAnalyticsProvider,
          name: r'inventoryAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inventoryAnalyticsHash,
          dependencies: InventoryAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              InventoryAnalyticsFamily._allTransitiveDependencies,
          limit: limit,
        );

  InventoryAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int? limit;

  @override
  Override overrideWith(
    FutureOr<InventoryAnalytics> Function(InventoryAnalyticsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InventoryAnalyticsProvider._internal(
        (ref) => create(ref as InventoryAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InventoryAnalytics> createElement() {
    return _InventoryAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryAnalyticsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InventoryAnalyticsRef
    on AutoDisposeFutureProviderRef<InventoryAnalytics> {
  /// The parameter `limit` of this provider.
  int? get limit;
}

class _InventoryAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<InventoryAnalytics>
    with InventoryAnalyticsRef {
  _InventoryAnalyticsProviderElement(super.provider);

  @override
  int? get limit => (origin as InventoryAnalyticsProvider).limit;
}

String _$posCategoriesHash() => r'5f2b84d3e8ea1effac4ee42d1efb5817169f06e7';

/// See also [posCategories].
@ProviderFor(posCategories)
final posCategoriesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  posCategories,
  name: r'posCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$posCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PosCategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$itemsByCategoryHash() => r'9c5989e024cd2d86b432ee1dbdeb62b1a2034f03';

/// See also [itemsByCategory].
@ProviderFor(itemsByCategory)
const itemsByCategoryProvider = ItemsByCategoryFamily();

/// See also [itemsByCategory].
class ItemsByCategoryFamily extends Family<AsyncValue<List<CartItem>>> {
  /// See also [itemsByCategory].
  const ItemsByCategoryFamily();

  /// See also [itemsByCategory].
  ItemsByCategoryProvider call(
    String category,
  ) {
    return ItemsByCategoryProvider(
      category,
    );
  }

  @override
  ItemsByCategoryProvider getProviderOverride(
    covariant ItemsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'itemsByCategoryProvider';
}

/// See also [itemsByCategory].
class ItemsByCategoryProvider
    extends AutoDisposeFutureProvider<List<CartItem>> {
  /// See also [itemsByCategory].
  ItemsByCategoryProvider(
    String category,
  ) : this._internal(
          (ref) => itemsByCategory(
            ref as ItemsByCategoryRef,
            category,
          ),
          from: itemsByCategoryProvider,
          name: r'itemsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemsByCategoryHash,
          dependencies: ItemsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              ItemsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  ItemsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<CartItem>> Function(ItemsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemsByCategoryProvider._internal(
        (ref) => create(ref as ItemsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CartItem>> createElement() {
    return _ItemsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemsByCategoryRef on AutoDisposeFutureProviderRef<List<CartItem>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _ItemsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<CartItem>>
    with ItemsByCategoryRef {
  _ItemsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as ItemsByCategoryProvider).category;
}

String _$allMenuItemsHash() => r'3632cdc5be18b86caed6d41d7236c091f725752b';

/// See also [allMenuItems].
@ProviderFor(allMenuItems)
final allMenuItemsProvider = AutoDisposeFutureProvider<List<CartItem>>.internal(
  allMenuItems,
  name: r'allMenuItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allMenuItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllMenuItemsRef = AutoDisposeFutureProviderRef<List<CartItem>>;
String _$tableOrdersReadyToChargeHash() =>
    r'af5e6690252d01d08a31ed356bc7966db2b4aed4';

/// See also [tableOrdersReadyToCharge].
@ProviderFor(tableOrdersReadyToCharge)
final tableOrdersReadyToChargeProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  tableOrdersReadyToCharge,
  name: r'tableOrdersReadyToChargeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tableOrdersReadyToChargeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TableOrdersReadyToChargeRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$restaurantOrdersHash() => r'9d965dda6e97ba6bfaefdc38050d7ab01526e332';

/// See also [restaurantOrders].
@ProviderFor(restaurantOrders)
final restaurantOrdersProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  restaurantOrders,
  name: r'restaurantOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$restaurantOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RestaurantOrdersRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$dailyTransactionsHash() => r'3e7d87788fb51497b8f12c922d1d713d591c98dd';

/// See also [dailyTransactions].
@ProviderFor(dailyTransactions)
final dailyTransactionsProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  dailyTransactions,
  name: r'dailyTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyTransactionsRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$inventoryStatusHash() => r'8da89a51fb3fda970b24e9efe88d2ae4914df1a0';

/// See also [inventoryStatus].
@ProviderFor(inventoryStatus)
final inventoryStatusProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  inventoryStatus,
  name: r'inventoryStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryStatusRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$cartNotifierHash() => r'3c7b3606d59f8a0be1ed390808870100bf6e87c1';

/// See also [CartNotifier].
@ProviderFor(CartNotifier)
final cartNotifierProvider =
    AutoDisposeNotifierProvider<CartNotifier, List<CartItem>>.internal(
  CartNotifier.new,
  name: r'cartNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CartNotifier = AutoDisposeNotifier<List<CartItem>>;
String _$searchNotifierHash() => r'd15b01bbdee17b7b734a574b2b35973c4acf3d3f';

/// See also [SearchNotifier].
@ProviderFor(SearchNotifier)
final searchNotifierProvider =
    AutoDisposeNotifierProvider<SearchNotifier, List<MenuItem>>.internal(
  SearchNotifier.new,
  name: r'searchNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchNotifier = AutoDisposeNotifier<List<MenuItem>>;
String _$recentSalesNotifierHash() =>
    r'61fcab2dd3cb843d826273cc0fd9a7017b5d9034';

/// See also [RecentSalesNotifier].
@ProviderFor(RecentSalesNotifier)
final recentSalesNotifierProvider =
    AutoDisposeNotifierProvider<RecentSalesNotifier, List<Sale>>.internal(
  RecentSalesNotifier.new,
  name: r'recentSalesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentSalesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentSalesNotifier = AutoDisposeNotifier<List<Sale>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
