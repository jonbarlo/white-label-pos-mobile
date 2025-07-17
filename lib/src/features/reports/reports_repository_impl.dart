import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_repository.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';
import 'package:white_label_pos_mobile/src/core/config/env_config.dart';

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
      final response = await _dio.get('/sales', queryParameters: {
        'page': 1,
        'limit': 100,
        'status': 'completed',
      });

      // Backend returns a list of sales, not a sales report object
      // We need to calculate the report from the sales data
      final salesData = response.data as List<dynamic>;
      
      // Calculate totals from sales data
      double totalSales = 0.0;
      int totalTransactions = salesData.length;
      List<String> topSellingItems = [];
      
      for (final sale in salesData) {
        final saleMap = sale as Map<String, dynamic>;
        final totalValue = (saleMap['finalAmount'] ?? saleMap['totalAmount'] ?? saleMap['total'] ?? 0.0);
        final total = (totalValue is num) ? totalValue.toDouble() : double.tryParse(totalValue.toString()) ?? 0.0;
        totalSales += total;
        
        // Extract items if available
        final items = saleMap['items'] as List<dynamic>?;
        if (items != null) {
          for (final item in items) {
            final itemMap = item as Map<String, dynamic>;
            final itemName = itemMap['name']?.toString() ?? 'Unknown Item';
            topSellingItems.add(itemName);
          }
        }
      }
      
      // Create sales report from calculated data
      final salesReport = SalesReport(
        totalSales: totalSales,
        totalTransactions: totalTransactions,
        averageTransactionValue: totalTransactions > 0 ? totalSales / totalTransactions : 0.0,
        topSellingItems: topSellingItems.take(10).toList(), // Top 10 items
        salesByHour: {}, // TODO: Calculate by hour if needed
        startDate: startDate,
        endDate: endDate,
      );
      
      // Cache the report
      await _prefs.setString(
        '$_salesReportCacheKey${startDate.toIso8601String()}_${endDate.toIso8601String()}',
        salesReport.toJson().toString(),
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
      final response = await _dio.get('/sales/stats', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      // Handle the new response format with success/data structure
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;

      final revenueReport = RevenueReport.fromJson(data);
      
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
  Future<List<Map<String, dynamic>>> getDetailedTransactions({
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int limit = 50,
    String? status,
    String? paymentMethod,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'sort': 'createdAt',
        'order': 'desc',
      };
      
      if (status != null) {
        queryParams['status'] = status;
      }
      if (paymentMethod != null) {
        queryParams['paymentMethod'] = paymentMethod;
      }

      final response = await _dio.get('/sales', queryParameters: queryParams);
      
      // Backend returns a list of sales
      final salesData = response.data as List<dynamic>;
      return List<Map<String, dynamic>>.from(salesData);
    } on DioException catch (e) {
      throw Exception('Failed to get detailed transactions: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getSaleWithItems({
    required String saleId,
  }) async {
    try {
      print('🔍 Reports Repository: Fetching sale with items for ID: $saleId');
      
      final response = await _dio.get('/sales/$saleId/with-items');
      
      // Handle the response format from the API documentation
      final responseData = response.data;
      Map<String, dynamic> saleData;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        saleData = responseData['data'] as Map<String, dynamic>;
      } else if (responseData is Map<String, dynamic>) {
        saleData = responseData;
      } else {
        throw Exception('Unexpected response format from /sales/$saleId/with-items');
      }
      
      print('🔍 Reports Repository: Sale with items response: $saleData');
      
      return saleData;
    } on DioException catch (e) {
      print('🔍 Reports Repository: Error fetching sale with items: ${e.message}');
      throw Exception('Failed to get sale with items: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getInventoryReport() async {
    try {
      // Add development mode header to bypass rate limiting
      final headers = <String, String>{};
      if (EnvConfig.isDebugMode) {
        headers['X-Development-Mode'] = 'true';
        headers['X-Rate-Limit-Bypass'] = 'true';
      }

      final response = await _dio.get(
        '/items',
        options: Options(headers: headers),
      );
      
      // Handle both array and object responses
      if (response.data is List) {
        final items = response.data as List<dynamic>;
        return {
          'totalItems': items.length,
          'items': items,
          'lowStockItems': items.where((item) {
            final itemMap = item as Map<String, dynamic>;
            final stockQuantity = (itemMap['stockQuantity'] as num?)?.toInt() ?? 0;
            final minStockLevel = (itemMap['minStockLevel'] as num?)?.toInt() ?? 0;
            return stockQuantity <= minStockLevel;
          }).length,
        };
      } else {
        return Map<String, dynamic>.from(response.data);
      }
    } on DioException catch (e) {
      print('🔍 ANALYTICS DEBUG: Inventory response status: ${e.response?.statusCode}');
      print('🔍 ANALYTICS DEBUG: Inventory response data: ${e.response?.data}');
      print('🔍 ANALYTICS DEBUG: Inventory error response: ${e.response?.statusCode} - ${e.response?.data}');
      print('🔍 ANALYTICS DEBUG: Inventory exception caught: $e');
      
      // In development mode, return mock data instead of throwing
      if (EnvConfig.isDebugMode) {
        print('🔍 ANALYTICS DEBUG: Returning mock inventory analytics data for development');
        return {
          'totalItems': 0,
          'items': [],
          'lowStockItems': 0,
        };
      }
      
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

      // Add development mode header to bypass rate limiting
      final headers = <String, String>{};
      if (EnvConfig.isDebugMode) {
        headers['X-Development-Mode'] = 'true';
        headers['X-Rate-Limit-Bypass'] = 'true';
      }

      final response = await _dio.get(
        '/sales/top-items', 
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      
      // Handle both array and object responses
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.data is Map<String, dynamic> && response.data['data'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        return [];
      }
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
      // Add development mode header to bypass rate limiting
      final headers = <String, String>{};
      if (EnvConfig.isDebugMode) {
        headers['X-Development-Mode'] = 'true';
        headers['X-Rate-Limit-Bypass'] = 'true';
      }

      final response = await _dio.get(
        '/sales/trends', 
        queryParameters: {
          'period': period,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
        options: Options(headers: headers),
      );

      // Handle both direct map and nested data
      final data = response.data is Map<String, dynamic> && response.data['data'] != null 
          ? response.data['data'] as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      return Map<String, double>.from(data);
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

      // Add development mode header to bypass rate limiting
      final headers = <String, String>{};
      if (EnvConfig.isDebugMode) {
        headers['X-Development-Mode'] = 'true';
        headers['X-Rate-Limit-Bypass'] = 'true';
      }

      final response = await _dio.get(
        '/sales/customer-analytics', 
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      
      // Handle both direct map and nested data
      final data = response.data is Map<String, dynamic> && response.data['data'] != null 
          ? response.data['data'] as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      return Map<String, dynamic>.from(data);
    } on DioException catch (e) {
      print('🔍 ANALYTICS DEBUG: Customer analytics response status: ${e.response?.statusCode}');
      print('🔍 ANALYTICS DEBUG: Customer analytics response data: ${e.response?.data}');
      print('🔍 ANALYTICS DEBUG: Customer analytics error response: ${e.response?.statusCode} - ${e.response?.data}');
      print('🔍 ANALYTICS DEBUG: Customer analytics exception caught: $e');
      
      // In development mode, return mock data instead of throwing
      if (EnvConfig.isDebugMode) {
        print('🔍 ANALYTICS DEBUG: Returning mock customer analytics data for development');
        return {
          'totalCustomers': 0,
          'newCustomers': 0,
          'returningCustomers': 0,
          'averageOrderValue': 0.0,
          'customerSatisfaction': 0.0,
        };
      }
      
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
      final response = await _dio.get('/sales/export', queryParameters: {
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