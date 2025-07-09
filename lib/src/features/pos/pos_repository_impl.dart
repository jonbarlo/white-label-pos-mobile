import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pos_repository.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/menu_item.dart';
import 'models/order.dart';
import 'models/order_item.dart';
import '../../core/config/env_config.dart';
import '../auth/auth_provider.dart';

class PosRepositoryImpl implements PosRepository {
  final Dio _dio;
  final Ref _ref;

  PosRepositoryImpl(this._dio, this._ref) {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = EnvConfig.apiBaseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: EnvConfig.apiTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: EnvConfig.apiTimeout);
    
    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authState = _ref.read(authNotifierProvider);
        if (authState.token != null) {
          options.headers['Authorization'] = 'Bearer ${authState.token}';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized - could trigger logout
          _ref.read(authNotifierProvider.notifier).logout();
        }
        handler.next(error);
      },
    ));
  }

  @override
  Future<List<CartItem>> searchItems(String query) async {
    try {
      final response = await _dio.get('/api/menu/items', queryParameters: {
        'search': query,
        'isAvailable': true,
        'isActive': true,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> items = response.data['data'] ?? [];
        return items.map((item) => _convertMenuItemToCartItem(MenuItem.fromJson(item))).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to search items: $e');
    }
  }

  @override
  Future<CartItem?> getItemByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/api/menu/items', queryParameters: {
        'barcode': barcode,
        'isAvailable': true,
        'isActive': true,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> items = response.data['data'] ?? [];
        if (items.isNotEmpty) {
          return _convertMenuItemToCartItem(MenuItem.fromJson(items.first));
        }
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get item by barcode: $e');
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
      // Create order
      final orderData = {
        'type': 'takeaway', // Default to takeaway for mobile POS
        'status': 'pending',
        'subtotal': items.fold(0.0, (sum, item) => sum + item.total),
        'tax': 0.0, // Calculate based on business tax rate
        'discount': 0.0,
        'total': items.fold(0.0, (sum, item) => sum + item.total),
        'notes': null,
      };

      final orderResponse = await _dio.post('/api/orders', data: orderData);
      
      if (orderResponse.statusCode != 201 || orderResponse.data['success'] != true) {
        throw Exception('Failed to create order');
      }

      final order = Order.fromJson(orderResponse.data['data']);

      // Create order items
      for (final item in items) {
        final orderItemData = {
          'orderId': order.id,
          'menuItemId': int.parse(item.id), // Assuming item.id is the menuItemId
          'quantity': item.quantity,
          'unitPrice': item.price,
          'totalPrice': item.total,
          'notes': null,
          'status': 'pending',
        };

        await _dio.post('/api/orders/${order.id}/items', data: orderItemData);
      }

      // Create sale record
      final saleData = {
        'orderId': order.id,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'paymentMethod': paymentMethod.name,
        'total': order.total,
      };

      final saleResponse = await _dio.post('/api/sales', data: saleData);
      
      if (saleResponse.statusCode != 201 || saleResponse.data['success'] != true) {
        throw Exception('Failed to create sale');
      }

      // Convert to Sale model
      return Sale(
        id: order.id.toString(),
        items: items,
        total: order.total,
        paymentMethod: paymentMethod,
        createdAt: order.createdAt,
        customerName: customerName,
        customerEmail: customerEmail,
        receiptNumber: order.orderNumber,
      );
    } catch (e) {
      throw Exception('Failed to create sale: $e');
    }
  }

  @override
  Future<List<Sale>> getRecentSales({int limit = 50}) async {
    try {
      final response = await _dio.get('/api/sales', queryParameters: {
        'limit': limit,
        'sort': 'createdAt',
        'order': 'desc',
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> sales = response.data['data'] ?? [];
        return sales.map((sale) => _convertApiSaleToSale(sale)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get recent sales: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getSalesSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get('/api/sales/summary', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] ?? {};
      }
      
      return {};
    } catch (e) {
      throw Exception('Failed to get sales summary: $e');
    }
  }

  @override
  Future<List<CartItem>> getTopSellingItems({int limit = 10}) async {
    try {
      final response = await _dio.get('/api/sales/top-items', queryParameters: {
        'limit': limit,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> items = response.data['data'] ?? [];
        return items.map((item) => _convertMenuItemToCartItem(MenuItem.fromJson(item))).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get top selling items: $e');
    }
  }

  @override
  Future<void> updateStockLevels(List<CartItem> items) async {
    try {
      for (final item in items) {
        // Update stock for each item
        await _dio.patch('/api/menu/items/${item.id}/stock', data: {
          'quantity': -item.quantity, // Decrease stock
        });
      }
    } catch (e) {
      throw Exception('Failed to update stock levels: $e');
    }
  }

  // Helper methods
  CartItem _convertMenuItemToCartItem(MenuItem menuItem) {
    return CartItem(
      id: menuItem.id.toString(),
      name: menuItem.name,
      price: menuItem.price,
      quantity: 1,
      imageUrl: menuItem.image,
      category: menuItem.categoryId.toString(),
    );
  }

  Sale _convertApiSaleToSale(Map<String, dynamic> apiSale) {
    // This is a simplified conversion - you might need to fetch order items separately
    return Sale(
      id: apiSale['id'].toString(),
      items: [], // Would need to fetch order items
      total: apiSale['total']?.toDouble() ?? 0.0,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == apiSale['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: DateTime.parse(apiSale['createdAt']),
      customerName: apiSale['customerName'],
      customerEmail: apiSale['customerEmail'],
      receiptNumber: apiSale['orderNumber'],
    );
  }
} 