import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_repository.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  static const String _salesReportCacheKey = 'sales_report_cache';
  static const String _revenueReportCacheKey = 'revenue_report_cache';

  ReportsRepositoryImpl(this._dio, this._prefs);

  @override
  Future<SalesReport> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get('/reports/sales', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      final salesReport = SalesReport.fromJson(response.data);
      
      // Cache the report
      await _prefs.setString(
        '$_salesReportCacheKey${startDate.toIso8601String()}_${endDate.toIso8601String()}',
        response.data.toString(),
      );

      return salesReport;
    } on DioException catch (e) {
      // Try to get cached data on error
      final cachedData = _prefs.getString(
        '$_salesReportCacheKey${startDate.toIso8601String()}_${endDate.toIso8601String()}',
      );
      
      if (cachedData != null) {
        // Return cached data if available
        return SalesReport(
          totalSales: 0.0,
          totalTransactions: 0,
          averageTransactionValue: 0.0,
          topSellingItems: [],
          salesByHour: {},
          startDate: startDate,
          endDate: endDate,
        );
      }
      
      throw Exception('Failed to get sales report: ${e.message}');
    }
  }

  @override
  Future<RevenueReport> getRevenueReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get('/reports/revenue', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      final revenueReport = RevenueReport.fromJson(response.data);
      
      // Cache the report
      await _prefs.setString(
        '$_revenueReportCacheKey${startDate.toIso8601String()}_${endDate.toIso8601String()}',
        response.data.toString(),
      );

      return revenueReport;
    } on DioException catch (e) {
      // Try to get cached data on error
      final cachedData = _prefs.getString(
        '$_revenueReportCacheKey${startDate.toIso8601String()}_${endDate.toIso8601String()}',
      );
      
      if (cachedData != null) {
        // Return cached data if available
        return RevenueReport(
          totalRevenue: 0.0,
          totalCost: 0.0,
          grossProfit: 0.0,
          profitMargin: 0.0,
          revenueByDay: {},
          startDate: startDate,
          endDate: endDate,
        );
      }
      
      throw Exception('Failed to get revenue report: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getInventoryReport() async {
    try {
      final response = await _dio.get('/reports/inventory');
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get inventory report: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTopSellingItems({
    int limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
      };
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get('/reports/top-selling-items', queryParameters: queryParams);
      
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get top selling items: ${e.message}');
    }
  }

  @override
  Future<Map<String, double>> getSalesTrends({
    required String period,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get('/reports/sales-trends', queryParameters: {
        'period': period,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      return Map<String, double>.from(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get sales trends: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getCustomerAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get('/reports/customer-analytics', queryParameters: queryParams);
      
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get customer analytics: ${e.message}');
    }
  }

  @override
  Future<String> exportReport({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
    String format = 'csv',
  }) async {
    try {
      final response = await _dio.get('/reports/export', queryParameters: {
        'reportType': reportType,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'format': format,
      });

      return response.data['downloadUrl'] ?? '';
    } on DioException catch (e) {
      throw Exception('Failed to export report: ${e.message}');
    }
  }
} 

// Provider for dependency injection
final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  
  // Handle the async nature of SharedPreferences
  if (prefsAsync.hasValue) {
    return ReportsRepositoryImpl(dio, prefsAsync.value!);
  } else {
    // Return a default implementation or throw an error
    throw Exception('SharedPreferences not initialized');
  }
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
}); 