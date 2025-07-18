import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_repository_impl.dart';

part 'reports_provider.g.dart';

// Use the direct provider from the implementation file instead of creating a circular dependency

@riverpod
Future<SalesReport> salesReport(
  SalesReportRef ref, {
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getSalesReport(
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<RevenueReport> revenueReport(
  RevenueReportRef ref, {
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getRevenueReport(
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<List<Map<String, dynamic>>> detailedTransactions(
  DetailedTransactionsRef ref, {
  required DateTime startDate,
  required DateTime endDate,
  int page = 1,
  int limit = 50,
  String? status,
  String? paymentMethod,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getDetailedTransactions(
    startDate: startDate,
    endDate: endDate,
    page: page,
    limit: limit,
    status: status,
    paymentMethod: paymentMethod,
  );
}

@riverpod
Future<Map<String, dynamic>> saleWithItems(
  SaleWithItemsRef ref, {
  required String saleId,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getSaleWithItems(
    saleId: saleId,
  );
}

@riverpod
Future<Map<String, dynamic>> inventoryReport(InventoryReportRef ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getInventoryReport();
}

@riverpod
Future<List<Map<String, dynamic>>> topSellingItems(
  TopSellingItemsRef ref, {
  int limit = 10,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getTopSellingItems(
    limit: limit,
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<Map<String, double>> salesTrends(
  SalesTrendsRef ref, {
  required String period,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getSalesTrends(
    period: period,
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<Map<String, dynamic>> customerAnalytics(
  CustomerAnalyticsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return await repository.getCustomerAnalytics(
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<Map<String, dynamic>> salesSummary(
  SalesSummaryRef ref, {
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  final transactions = await repository.getDetailedTransactions(
    startDate: startDate,
    endDate: endDate,
    status: 'completed',
  );
  
  double totalSales = 0.0;
  int totalTransactions = transactions.length;
  
  for (final transaction in transactions) {
    totalSales += (transaction['totalAmount'] as num?)?.toDouble() ?? 0.0;
  }
  
  return {
    'totalSales': totalSales,
    'totalTransactions': totalTransactions,
    'averageTransaction': totalTransactions > 0 ? totalSales / totalTransactions : 0.0,
  };
}

@riverpod
class ReportsNotifier extends _$ReportsNotifier {
  @override
  Future<void> build() async {
    // Initialize with default state
  }

  Future<String> exportReport({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
    String format = 'csv',
  }) async {
    final repository = ref.read(reportsRepositoryProvider);
    return await repository.exportReport(
      reportType: reportType,
      startDate: startDate,
      endDate: endDate,
      format: format,
    );
  }

  void refreshReports() {
    ref.invalidate(salesReportProvider);
    ref.invalidate(revenueReportProvider);
    ref.invalidate(inventoryReportProvider);
    ref.invalidate(topSellingItemsProvider);
    ref.invalidate(salesTrendsProvider);
    ref.invalidate(customerAnalyticsProvider);
  }
} 