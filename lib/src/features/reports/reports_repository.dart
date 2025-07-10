import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';

abstract class ReportsRepository {
  /// Get sales report for a given date range
  Future<SalesReport> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get revenue report for a given date range
  Future<RevenueReport> getRevenueReport({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get detailed transactions for a given date range
  Future<List<Map<String, dynamic>>> getDetailedTransactions({
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int limit = 50,
    String? status,
    String? paymentMethod,
  });

  /// Get inventory summary report
  Future<Map<String, dynamic>> getInventoryReport();

  /// Get top selling items
  Future<List<Map<String, dynamic>>> getTopSellingItems({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get sales trends by period (daily, weekly, monthly)
  Future<Map<String, double>> getSalesTrends({
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get customer analytics
  Future<Map<String, dynamic>> getCustomerAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Export report data
  Future<String> exportReport({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
    String format = 'csv',
  });
} 