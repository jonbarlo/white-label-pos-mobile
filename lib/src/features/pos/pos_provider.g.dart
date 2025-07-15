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
String _$createSaleHash() => r'90b662c0a580f63dc3e8513be529acc83f41331f';

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

String _$createSplitSaleHash() => r'c3feeae84a705864e01358ae1f842773c6709c25';

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
String _$menuItemsHash() => r'0b0644ceb06e4ce841cdc13e36b928baf12c66fc';

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
String _$searchNotifierHash() => r'c9339d2ba7bb6a22d959578a22ae58dca4829959';

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
    r'77db73cc5b4e3ea79aa34a9d380d534248b2bb2f';

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
