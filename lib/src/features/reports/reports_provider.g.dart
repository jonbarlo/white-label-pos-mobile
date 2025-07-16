// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$salesReportHash() => r'1f029ffcf41398694a7a45d871f097c819dbbe7d';

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

/// See also [salesReport].
@ProviderFor(salesReport)
const salesReportProvider = SalesReportFamily();

/// See also [salesReport].
class SalesReportFamily extends Family<AsyncValue<SalesReport>> {
  /// See also [salesReport].
  const SalesReportFamily();

  /// See also [salesReport].
  SalesReportProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return SalesReportProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  SalesReportProvider getProviderOverride(
    covariant SalesReportProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  String? get name => r'salesReportProvider';
}

/// See also [salesReport].
class SalesReportProvider extends AutoDisposeFutureProvider<SalesReport> {
  /// See also [salesReport].
  SalesReportProvider({
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => salesReport(
            ref as SalesReportRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: salesReportProvider,
          name: r'salesReportProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$salesReportHash,
          dependencies: SalesReportFamily._dependencies,
          allTransitiveDependencies:
              SalesReportFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  SalesReportProvider._internal(
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
    FutureOr<SalesReport> Function(SalesReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SalesReportProvider._internal(
        (ref) => create(ref as SalesReportRef),
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
  AutoDisposeFutureProviderElement<SalesReport> createElement() {
    return _SalesReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesReportProvider &&
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
mixin SalesReportRef on AutoDisposeFutureProviderRef<SalesReport> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _SalesReportProviderElement
    extends AutoDisposeFutureProviderElement<SalesReport> with SalesReportRef {
  _SalesReportProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as SalesReportProvider).startDate;
  @override
  DateTime get endDate => (origin as SalesReportProvider).endDate;
}

String _$revenueReportHash() => r'd275c89b8968e9e43cd3e16d201d19651155aa66';

/// See also [revenueReport].
@ProviderFor(revenueReport)
const revenueReportProvider = RevenueReportFamily();

/// See also [revenueReport].
class RevenueReportFamily extends Family<AsyncValue<RevenueReport>> {
  /// See also [revenueReport].
  const RevenueReportFamily();

  /// See also [revenueReport].
  RevenueReportProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return RevenueReportProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  RevenueReportProvider getProviderOverride(
    covariant RevenueReportProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  String? get name => r'revenueReportProvider';
}

/// See also [revenueReport].
class RevenueReportProvider extends AutoDisposeFutureProvider<RevenueReport> {
  /// See also [revenueReport].
  RevenueReportProvider({
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => revenueReport(
            ref as RevenueReportRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: revenueReportProvider,
          name: r'revenueReportProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$revenueReportHash,
          dependencies: RevenueReportFamily._dependencies,
          allTransitiveDependencies:
              RevenueReportFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  RevenueReportProvider._internal(
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
    FutureOr<RevenueReport> Function(RevenueReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RevenueReportProvider._internal(
        (ref) => create(ref as RevenueReportRef),
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
  AutoDisposeFutureProviderElement<RevenueReport> createElement() {
    return _RevenueReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RevenueReportProvider &&
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
mixin RevenueReportRef on AutoDisposeFutureProviderRef<RevenueReport> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _RevenueReportProviderElement
    extends AutoDisposeFutureProviderElement<RevenueReport>
    with RevenueReportRef {
  _RevenueReportProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as RevenueReportProvider).startDate;
  @override
  DateTime get endDate => (origin as RevenueReportProvider).endDate;
}

String _$detailedTransactionsHash() =>
    r'4d52880bc02357746ff6f8610e2cbfd52148ca54';

/// See also [detailedTransactions].
@ProviderFor(detailedTransactions)
const detailedTransactionsProvider = DetailedTransactionsFamily();

/// See also [detailedTransactions].
class DetailedTransactionsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [detailedTransactions].
  const DetailedTransactionsFamily();

  /// See also [detailedTransactions].
  DetailedTransactionsProvider call({
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int limit = 50,
    String? status,
    String? paymentMethod,
  }) {
    return DetailedTransactionsProvider(
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
      status: status,
      paymentMethod: paymentMethod,
    );
  }

  @override
  DetailedTransactionsProvider getProviderOverride(
    covariant DetailedTransactionsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      page: provider.page,
      limit: provider.limit,
      status: provider.status,
      paymentMethod: provider.paymentMethod,
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
  String? get name => r'detailedTransactionsProvider';
}

/// See also [detailedTransactions].
class DetailedTransactionsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [detailedTransactions].
  DetailedTransactionsProvider({
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int limit = 50,
    String? status,
    String? paymentMethod,
  }) : this._internal(
          (ref) => detailedTransactions(
            ref as DetailedTransactionsRef,
            startDate: startDate,
            endDate: endDate,
            page: page,
            limit: limit,
            status: status,
            paymentMethod: paymentMethod,
          ),
          from: detailedTransactionsProvider,
          name: r'detailedTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$detailedTransactionsHash,
          dependencies: DetailedTransactionsFamily._dependencies,
          allTransitiveDependencies:
              DetailedTransactionsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          page: page,
          limit: limit,
          status: status,
          paymentMethod: paymentMethod,
        );

  DetailedTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.page,
    required this.limit,
    required this.status,
    required this.paymentMethod,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int page;
  final int limit;
  final String? status;
  final String? paymentMethod;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            DetailedTransactionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DetailedTransactionsProvider._internal(
        (ref) => create(ref as DetailedTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        page: page,
        limit: limit,
        status: status,
        paymentMethod: paymentMethod,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _DetailedTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DetailedTransactionsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.page == page &&
        other.limit == limit &&
        other.status == status &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, paymentMethod.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DetailedTransactionsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `paymentMethod` of this provider.
  String? get paymentMethod;
}

class _DetailedTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with DetailedTransactionsRef {
  _DetailedTransactionsProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as DetailedTransactionsProvider).startDate;
  @override
  DateTime get endDate => (origin as DetailedTransactionsProvider).endDate;
  @override
  int get page => (origin as DetailedTransactionsProvider).page;
  @override
  int get limit => (origin as DetailedTransactionsProvider).limit;
  @override
  String? get status => (origin as DetailedTransactionsProvider).status;
  @override
  String? get paymentMethod =>
      (origin as DetailedTransactionsProvider).paymentMethod;
}

String _$saleWithItemsHash() => r'97c42b7fce09d4edf06c4619830fe4ae236caa3b';

/// See also [saleWithItems].
@ProviderFor(saleWithItems)
const saleWithItemsProvider = SaleWithItemsFamily();

/// See also [saleWithItems].
class SaleWithItemsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [saleWithItems].
  const SaleWithItemsFamily();

  /// See also [saleWithItems].
  SaleWithItemsProvider call({
    required String saleId,
  }) {
    return SaleWithItemsProvider(
      saleId: saleId,
    );
  }

  @override
  SaleWithItemsProvider getProviderOverride(
    covariant SaleWithItemsProvider provider,
  ) {
    return call(
      saleId: provider.saleId,
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
  String? get name => r'saleWithItemsProvider';
}

/// See also [saleWithItems].
class SaleWithItemsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [saleWithItems].
  SaleWithItemsProvider({
    required String saleId,
  }) : this._internal(
          (ref) => saleWithItems(
            ref as SaleWithItemsRef,
            saleId: saleId,
          ),
          from: saleWithItemsProvider,
          name: r'saleWithItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saleWithItemsHash,
          dependencies: SaleWithItemsFamily._dependencies,
          allTransitiveDependencies:
              SaleWithItemsFamily._allTransitiveDependencies,
          saleId: saleId,
        );

  SaleWithItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.saleId,
  }) : super.internal();

  final String saleId;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(SaleWithItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaleWithItemsProvider._internal(
        (ref) => create(ref as SaleWithItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        saleId: saleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _SaleWithItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleWithItemsProvider && other.saleId == saleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, saleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaleWithItemsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `saleId` of this provider.
  String get saleId;
}

class _SaleWithItemsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with SaleWithItemsRef {
  _SaleWithItemsProviderElement(super.provider);

  @override
  String get saleId => (origin as SaleWithItemsProvider).saleId;
}

String _$inventoryReportHash() => r'55af2ca19c08561a692ba1e69c049909da56b9a0';

/// See also [inventoryReport].
@ProviderFor(inventoryReport)
final inventoryReportProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  inventoryReport,
  name: r'inventoryReportProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryReportHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryReportRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$topSellingItemsHash() => r'ad151423125d4d33e31f523b495240b224f79fa9';

/// See also [topSellingItems].
@ProviderFor(topSellingItems)
const topSellingItemsProvider = TopSellingItemsFamily();

/// See also [topSellingItems].
class TopSellingItemsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [topSellingItems].
  const TopSellingItemsFamily();

  /// See also [topSellingItems].
  TopSellingItemsProvider call({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TopSellingItemsProvider(
      limit: limit,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  TopSellingItemsProvider getProviderOverride(
    covariant TopSellingItemsProvider provider,
  ) {
    return call(
      limit: provider.limit,
      startDate: provider.startDate,
      endDate: provider.endDate,
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
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [topSellingItems].
  TopSellingItemsProvider({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
          (ref) => topSellingItems(
            ref as TopSellingItemsRef,
            limit: limit,
            startDate: startDate,
            endDate: endDate,
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
          startDate: startDate,
          endDate: endDate,
        );

  TopSellingItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final int limit;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(TopSellingItemsRef provider)
        create,
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
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _TopSellingItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopSellingItemsProvider &&
        other.limit == limit &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopSellingItemsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _TopSellingItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with TopSellingItemsRef {
  _TopSellingItemsProviderElement(super.provider);

  @override
  int get limit => (origin as TopSellingItemsProvider).limit;
  @override
  DateTime? get startDate => (origin as TopSellingItemsProvider).startDate;
  @override
  DateTime? get endDate => (origin as TopSellingItemsProvider).endDate;
}

String _$salesTrendsHash() => r'854a129b372c5ce0e4a8e70e3053a64ac7fac50d';

/// See also [salesTrends].
@ProviderFor(salesTrends)
const salesTrendsProvider = SalesTrendsFamily();

/// See also [salesTrends].
class SalesTrendsFamily extends Family<AsyncValue<Map<String, double>>> {
  /// See also [salesTrends].
  const SalesTrendsFamily();

  /// See also [salesTrends].
  SalesTrendsProvider call({
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return SalesTrendsProvider(
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  SalesTrendsProvider getProviderOverride(
    covariant SalesTrendsProvider provider,
  ) {
    return call(
      period: provider.period,
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  String? get name => r'salesTrendsProvider';
}

/// See also [salesTrends].
class SalesTrendsProvider
    extends AutoDisposeFutureProvider<Map<String, double>> {
  /// See also [salesTrends].
  SalesTrendsProvider({
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => salesTrends(
            ref as SalesTrendsRef,
            period: period,
            startDate: startDate,
            endDate: endDate,
          ),
          from: salesTrendsProvider,
          name: r'salesTrendsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$salesTrendsHash,
          dependencies: SalesTrendsFamily._dependencies,
          allTransitiveDependencies:
              SalesTrendsFamily._allTransitiveDependencies,
          period: period,
          startDate: startDate,
          endDate: endDate,
        );

  SalesTrendsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String period;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<Map<String, double>> Function(SalesTrendsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SalesTrendsProvider._internal(
        (ref) => create(ref as SalesTrendsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, double>> createElement() {
    return _SalesTrendsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesTrendsProvider &&
        other.period == period &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SalesTrendsRef on AutoDisposeFutureProviderRef<Map<String, double>> {
  /// The parameter `period` of this provider.
  String get period;

  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _SalesTrendsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, double>>
    with SalesTrendsRef {
  _SalesTrendsProviderElement(super.provider);

  @override
  String get period => (origin as SalesTrendsProvider).period;
  @override
  DateTime get startDate => (origin as SalesTrendsProvider).startDate;
  @override
  DateTime get endDate => (origin as SalesTrendsProvider).endDate;
}

String _$customerAnalyticsHash() => r'fd116b8b591c33dcc4d6f968d881a47773b6836f';

/// See also [customerAnalytics].
@ProviderFor(customerAnalytics)
const customerAnalyticsProvider = CustomerAnalyticsFamily();

/// See also [customerAnalytics].
class CustomerAnalyticsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [customerAnalytics].
  const CustomerAnalyticsFamily();

  /// See also [customerAnalytics].
  CustomerAnalyticsProvider call({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CustomerAnalyticsProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  CustomerAnalyticsProvider getProviderOverride(
    covariant CustomerAnalyticsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
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
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [customerAnalytics].
  CustomerAnalyticsProvider({
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
          (ref) => customerAnalytics(
            ref as CustomerAnalyticsRef,
            startDate: startDate,
            endDate: endDate,
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
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(CustomerAnalyticsRef provider)
        create,
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
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _CustomerAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerAnalyticsProvider &&
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
mixin CustomerAnalyticsRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _CustomerAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with CustomerAnalyticsRef {
  _CustomerAnalyticsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as CustomerAnalyticsProvider).startDate;
  @override
  DateTime? get endDate => (origin as CustomerAnalyticsProvider).endDate;
}

String _$salesSummaryHash() => r'ae5ac93777d77821a11fd049892cd11a1467ce65';

/// See also [salesSummary].
@ProviderFor(salesSummary)
const salesSummaryProvider = SalesSummaryFamily();

/// See also [salesSummary].
class SalesSummaryFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [salesSummary].
  const SalesSummaryFamily();

  /// See also [salesSummary].
  SalesSummaryProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return SalesSummaryProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  SalesSummaryProvider getProviderOverride(
    covariant SalesSummaryProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  SalesSummaryProvider({
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => salesSummary(
            ref as SalesSummaryRef,
            startDate: startDate,
            endDate: endDate,
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

String _$reportsNotifierHash() => r'6b5d4fb6fd0f7e067bf482560100ea099d218d00';

/// See also [ReportsNotifier].
@ProviderFor(ReportsNotifier)
final reportsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReportsNotifier, void>.internal(
  ReportsNotifier.new,
  name: r'reportsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReportsNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
