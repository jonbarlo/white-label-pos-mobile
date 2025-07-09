import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pos_repository.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';

class PosRepositoryImpl implements PosRepository {
  final Dio _dio;
  final SharedPreferences _prefs;

  PosRepositoryImpl(this._dio, this._prefs);

  String get _baseUrl => _prefs.getString('api_base_url') ?? 'http://localhost:3000/api';
  String get _authToken => _prefs.getString('auth_token') ?? '';

  @override
  Future<List<CartItem>> searchItems(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/pos/items/search',
        queryParameters: {'q': query},
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'] ?? [];
        return data.map((json) => CartItem.fromJson(json)).toList();
      }

      throw Exception('Failed to search items: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<CartItem?> getItemByBarcode(String barcode) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/pos/items/barcode/$barcode',
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['item'];
        return data != null ? CartItem.fromJson(data) : null;
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw Exception('Failed to get item by barcode: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<Sale> createSale({
    required List<CartItem> items,
    required PaymentMethod paymentMethod,
    String? customerName,
    String? customerEmail,
  }) async {
    try {
      final total = items.fold(0.0, (sum, item) => sum + item.total);
      
      final response = await _dio.post(
        '$_baseUrl/pos/sales',
        data: {
          'items': items.map((item) => item.toJson()).toList(),
          'total': total,
          'paymentMethod': paymentMethod.name,
          'customerName': customerName,
          'customerEmail': customerEmail,
        },
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 201) {
        return Sale.fromJson(response.data['sale']);
      }

      throw Exception('Failed to create sale: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<Sale>> getRecentSales({int limit = 50}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/pos/sales/recent',
        queryParameters: {'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sales'] ?? [];
        return data.map((json) => Sale.fromJson(json)).toList();
      }

      throw Exception('Failed to get recent sales: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getSalesSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/pos/sales/summary',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw Exception('Failed to get sales summary: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<List<CartItem>> getTopSellingItems({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/pos/items/top-selling',
        queryParameters: {'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'] ?? [];
        return data.map((json) => CartItem.fromJson(json)).toList();
      }

      throw Exception('Failed to get top selling items: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> updateStockLevels(List<CartItem> items) async {
    try {
      await _dio.post(
        '$_baseUrl/pos/items/update-stock',
        data: {
          'items': items.map((item) => {
            'id': item.id,
            'quantity': item.quantity,
          }).toList(),
        },
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update stock levels: ${e.message}');
    }
  }
} 