import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pos_repository.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/menu_item.dart';
import 'models/split_payment.dart';

import '../../core/config/env_config.dart';
import '../auth/auth_provider.dart';

class PosRepositoryImpl implements PosRepository {
  final Dio _dio;
  final Ref _ref;

  PosRepositoryImpl(this._dio, this._ref) {
    _setupDio();
  }

  void _setupDio() {
    // Remove hardcoded baseUrl setup - let DioClient handle it
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
      final authState = _ref.read(authNotifierProvider);
      final businessId = authState.business?.id;
      
      if (businessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/menu-items', queryParameters: {
        'businessId': businessId,
        if (query.isNotEmpty) 'search': query,
        'isAvailable': true,
      });

      // The /menu-items endpoint returns a List directly
      final items = (response.data as List)
          .map((item) => _convertMenuItemToCartItem(_safeMenuItemFromJson(item as Map<String, dynamic>)))
          .toList();

      return items;
    } catch (e) {
      throw Exception('Failed to search menu items: $e');
    }
  }

  @override
  Future<CartItem?> getItemByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/menu-items', queryParameters: {
        'barcode': barcode,
        'isAvailable': true,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> items = response.data['data'] ?? [];
        if (items.isNotEmpty) {
          return _convertMenuItemToCartItem(MenuItem.fromJson(items.first));
        }
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get menu item by barcode: $e');
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
      final authState = _ref.read(authNotifierProvider);
      
      final businessId = authState.business?.id;
      if (businessId == null) {
        throw Exception('No businessId found in auth state');
      }

      // Calculate total
      final total = items.fold<double>(0.0, (sum, item) => sum + (item.price * (item.quantity ?? 1)));

      // Create sale with items using the /api/sales/with-items endpoint
      // This will automatically create kitchen orders
      final orderItems = items.map((item) => {
        'itemId': int.tryParse(item.id) ?? 1,
        'quantity': item.quantity ?? 1,
        'unitPrice': item.price, // Required field as per API documentation
      }).toList();

      final saleData = {
        'userId': authState.user?.id ?? businessId, // Required field
        'businessId': businessId, // Required field
        'customerName': customerName ?? 'Guest',
        'customerEmail': customerEmail ?? 'guest@pos.com',
        'totalAmount': total,
        'paymentMethod': _mapPaymentMethodToApi(paymentMethod),
        'status': 'completed',
        'orderItems': orderItems, // Required field with unitPrice
      };

      final saleResponse = await _dio.post('/sales/with-items', data: saleData);
      
      // Check for success response
      if (saleResponse.statusCode == 200 || saleResponse.statusCode == 201) {
        final responseData = saleResponse.data;
        
        // Handle both success formats
        final hasSuccessField = responseData['success'] == true;
        final hasSuccessMessage = responseData['message']?.toString().toLowerCase().contains('sale') == true && 
                                 responseData['message']?.toString().toLowerCase().contains('successfully') == true;
        
        if (hasSuccessField || hasSuccessMessage) {
          // Handle both new response formats: {success, data} and {message, sale}
          final saleObj = responseData['data'] ?? responseData['sale'] ?? {};
          
          final sale = Sale(
            id: saleObj['id']?.toString() ?? 'unknown',
            items: items,
            total: total,
            paymentMethod: paymentMethod,
            createdAt: DateTime.now(),
            customerName: customerName,
            customerEmail: customerEmail,
            receiptNumber: saleObj['orderNumber'] ?? 'SALE-${DateTime.now().millisecondsSinceEpoch}',
          );
          
          return sale;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to create sale');
        }
      } else {
        throw Exception(saleResponse.data['message'] ?? 'Failed to create sale');
      }
    } catch (e) {
      throw Exception('Failed to create sale: $e');
    }
  }

  @override
  Future<List<Sale>> getRecentSales({int limit = 50}) async {
    try {
      final response = await _dio.get('/sales', queryParameters: {
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
      final response = await _dio.get('/sales/summary', queryParameters: {
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
      final response = await _dio.get('/sales/top-items', queryParameters: {
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
        await _dio.patch('/items/${item.id}/stock', data: {
          'quantity': -item.quantity, // Decrease stock
        });
      }
    } catch (e) {
      throw Exception('Failed to update stock levels: $e');
    }
  }

  // Helper methods
  MenuItem _safeMenuItemFromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      businessId: json['businessId'] as int,
      categoryId: json['categoryId'] as int? ?? 1, // Handle missing categoryId
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Handle null price
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0, // Handle null cost
      image: json['imageUrl'] as String?,
      allergens: null, // Not in API response
      nutritionalInfo: null, // Not in API response
      preparationTime: json['preparationTime'] as int? ?? 15,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

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

  String _mapPaymentMethodToApi(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.card:
        return 'card'; // Use 'card' instead of 'credit_card'
      case PaymentMethod.mobile:
        return 'card'; // Map mobile payments to 'card' since API doesn't support mobile_payment
      case PaymentMethod.check:
        return 'check';
      default:
        return 'cash';
    }
  }

  Sale _convertApiSaleToSale(Map<String, dynamic> apiSale) {
    // Debug output for total fields
    final totalValue = (apiSale['finalAmount'] ?? apiSale['totalAmount'] ?? apiSale['total'] ?? 0.0);
    final total = (totalValue is num) ? totalValue.toDouble() : double.tryParse(totalValue.toString()) ?? 0.0;
    // This is a simplified conversion - you might need to fetch order items separately
    return Sale(
      id: apiSale['id'].toString(),
      items: [], // Would need to fetch order items
      total: total,
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

  // Split payment implementations
  @override
  Future<SplitSaleResponse> createSplitSale(SplitSaleRequest request) async {
    try {
      final requestJson = request.toJson();

      final response = await _dio.post('/sales/split', data: requestJson);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final splitSaleResponse = SplitSaleResponse.fromJson(response.data);
        return splitSaleResponse;
      } else {
        throw Exception(response.data['error'] ?? 'Failed to create split sale');
      }
    } catch (e) {
      throw Exception('Failed to create split sale: $e');
    }
  }

  @override
  Future<SplitSale> addPaymentToSale(int saleId, AddPaymentRequest request) async {
    try {
      final response = await _dio.post('/sales/$saleId/payments', data: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SplitSale.fromJson(response.data['sale']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to add payment');
      }
    } catch (e) {
      throw Exception('Failed to add payment: $e');
    }
  }

  @override
  Future<SplitSale> refundSplitPayment(int saleId, RefundRequest request) async {
    try {
      final response = await _dio.post('/sales/$saleId/refund', data: request.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SplitSale.fromJson(response.data['sale']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to process refund');
      }
    } catch (e) {
      throw Exception('Failed to process refund: $e');
    }
  }

  @override
  Future<SplitBillingStats> getSplitBillingStats() async {
    try {
      final response = await _dio.get('/sales/split/stats');

      if (response.statusCode == 200) {
        return SplitBillingStats.fromJson(response.data);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to get split billing stats');
      }
    } catch (e) {
      throw Exception('Failed to get split billing stats: $e');
    }
  }
} 