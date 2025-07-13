import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pos_repository.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/menu_item.dart';
import 'models/order.dart';
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
      if (EnvConfig.isDebugMode) {
        print('🔍 POS SEARCH: Searching for items with query: "$query"');
        print('🔍 POS SEARCH: Making request to /items (menu routes disabled)');
      }

      // Get business ID from auth state
      final authState = _ref.read(authNotifierProvider);
      final businessId = authState.business?.id;
      
      if (businessId == null) {
        print('🔍 POS SEARCH: ERROR - No businessId found in auth state');
        throw Exception('No businessId found in auth state');
      }

      print('🔍 POS SEARCH: Using businessId: $businessId');

      final response = await _dio.get('/items', queryParameters: {
        'businessId': businessId,
        if (query.isNotEmpty) 'search': query,
        'isActive': true,
      });

      if (EnvConfig.isDebugMode) {
        print('✅ RESPONSE[${response.statusCode}] => FULL URL: ${response.requestOptions.uri}');
        print('✅ Response Data: ${response.data}');
      }

      // The new /items endpoint returns a List directly
      final items = (response.data as List)
          .map((item) => _convertMenuItemToCartItem(_safeMenuItemFromJson(item as Map<String, dynamic>)))
          .toList();

      if (EnvConfig.isDebugMode) {
        print('🔍 POS SEARCH: Found \x1B[32m${items.length}\x1B[0m items');
      }
      return items;
    } catch (e, stack) {
      if (EnvConfig.isDebugMode) {
        print('🔍 POS SEARCH: Error occurred: $e');
      }
      throw Exception('Failed to search items: $e');
    }
  }

  @override
  Future<CartItem?> getItemByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/items', queryParameters: {
        'barcode': barcode,
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
      print('🛒 SALE CREATION: Starting sale creation...');
      print('🛒 SALE CREATION: Items count: ${items.length}');
      print('🛒 SALE CREATION: Payment method: ${paymentMethod.name}');
      print('🛒 SALE CREATION: Customer name: $customerName');
      print('🛒 SALE CREATION: Customer email: $customerEmail');
      
      final authState = _ref.read(authNotifierProvider);
      print('🛒 SALE CREATION: Auth state - User ID: ${authState.user?.id}');
      print('🛒 SALE CREATION: Auth state - Business ID: ${authState.business?.id}');
      
      final businessId = authState.business?.id;
      if (businessId == null) {
        print('🛒 SALE CREATION: ERROR - No businessId found in auth state');
        throw Exception('No businessId found in auth state');
      }

      // Calculate total
      final total = items.fold<double>(0.0, (sum, item) => sum + (item.price * (item.quantity ?? 1)));
      print('🛒 SALE CREATION: Calculated total: $total');

      // Create sale with items using the /api/sales/with-items endpoint
      // This will automatically create kitchen orders
      final orderItems = items.map((item) => {
        'itemId': int.tryParse(item.id) ?? 1,
        'quantity': item.quantity ?? 1,
        'unitPrice': item.price,
      }).toList();

      final saleData = {
        'userId': authState.user?.id ?? businessId,
        'businessId': businessId,
        'customerName': customerName ?? 'Guest',
        'customerEmail': customerEmail ?? 'guest@pos.com',
        'totalAmount': total,
        'paymentMethod': _mapPaymentMethodToApi(paymentMethod),
        'status': 'completed',
        'orderItems': orderItems,
      };

      print('🛒 SALE CREATION: Final sale data to send:');
      saleData.forEach((key, value) {
        if (key == 'orderItems') {
          print('🛒 SALE CREATION:   $key: ${(value as List).length} items');
          for (int i = 0; i < (value as List).length; i++) {
            final item = value[i];
            print('🛒 SALE CREATION:     Item $i: ID=${item['itemId']}, Qty=${item['quantity']}, Price=${item['unitPrice']}');
          }
        } else {
          print('🛒 SALE CREATION:   $key: $value');
        }
      });

      print('🛒 SALE CREATION: Making POST request to /sales/with-items');
      final saleResponse = await _dio.post('/sales/with-items', data: saleData);
      
      print('🛒 SALE CREATION: Response received!');
      print('🛒 SALE CREATION: Response status code: ${saleResponse.statusCode}');
      print('🛒 SALE CREATION: Response data type: ${saleResponse.data.runtimeType}');
      print('🛒 SALE CREATION: Full response data: ${saleResponse.data}');

      // Check for success response
      if (saleResponse.statusCode == 200 || saleResponse.statusCode == 201) {
        print('🛒 SALE CREATION: Status code indicates success');
        final responseData = saleResponse.data;
        
        print('🛒 SALE CREATION: Checking response format...');
        print('🛒 SALE CREATION: Has success field: ${responseData.containsKey('success')}');
        print('🛒 SALE CREATION: Success value: ${responseData['success']}');
        print('🛒 SALE CREATION: Has message field: ${responseData.containsKey('message')}');
        print('🛒 SALE CREATION: Message value: ${responseData['message']}');
        
        // Handle both success formats
        final hasSuccessField = responseData['success'] == true;
        final hasSuccessMessage = responseData['message']?.toString().toLowerCase().contains('sale') == true && 
                                 responseData['message']?.toString().toLowerCase().contains('successfully') == true;
        
        print('🛒 SALE CREATION: Has success field: $hasSuccessField');
        print('🛒 SALE CREATION: Has success message: $hasSuccessMessage');
        
        if (hasSuccessField || hasSuccessMessage) {
          print('🛒 SALE CREATION: Sale creation successful!');
          final saleObj = responseData['data'] ?? responseData['sale'] ?? {};
          print('🛒 SALE CREATION: Sale object: $saleObj');
          
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
          
          print('🛒 SALE CREATION: Created sale object with ID: ${sale.id}');
          return sale;
        } else {
          print('🛒 SALE CREATION: ERROR - Response indicates failure');
          print('🛒 SALE CREATION: Error message: ${responseData['message']}');
          throw Exception(responseData['message'] ?? 'Failed to create sale');
        }
      } else {
        print('🛒 SALE CREATION: ERROR - Bad status code: ${saleResponse.statusCode}');
        print('🛒 SALE CREATION: Error response: ${saleResponse.data}');
        throw Exception(saleResponse.data['message'] ?? 'Failed to create sale');
      }
    } catch (e) {
      print('🛒 SALE CREATION: EXCEPTION CAUGHT: $e');
      print('🛒 SALE CREATION: Exception type: ${e.runtimeType}');
      if (e is DioException) {
        print('🛒 SALE CREATION: DioException details:');
        print('🛒 SALE CREATION:   Status code: ${e.response?.statusCode}');
        print('🛒 SALE CREATION:   Response data: ${e.response?.data}');
        print('🛒 SALE CREATION:   Request data: ${e.requestOptions.data}');
      }
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
    print('🧾 DEBUG: apiSale[id]:  [32m${apiSale['id']} [0m');
    print('🧾 DEBUG: apiSale[finalAmount]:  [33m${apiSale['finalAmount']} [0m');
    print('🧾 DEBUG: apiSale[totalAmount]:  [33m${apiSale['totalAmount']} [0m');
    print('🧾 DEBUG: apiSale[total]:  [33m${apiSale['total']} [0m');
    final totalValue = (apiSale['finalAmount'] ?? apiSale['totalAmount'] ?? apiSale['total'] ?? 0.0);
    print('🧾 DEBUG: Computed totalValue (before .toDouble()):  [36m$totalValue [0m');
    final total = (totalValue is num) ? totalValue.toDouble() : double.tryParse(totalValue.toString()) ?? 0.0;
    print('🧾 DEBUG: Final total (double):  [36m$total [0m');
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
      print('💳 SPLIT SALE: Starting split sale creation...');
      print('💳 SPLIT SALE: User ID: ${request.userId}');
      print('💳 SPLIT SALE: Total amount: ${request.totalAmount}');
      print('💳 SPLIT SALE: Payments count: ${request.payments.length}');
      print('💳 SPLIT SALE: Customer name: ${request.customerName}');
      print('💳 SPLIT SALE: Customer email: ${request.customerEmail}');
      print('💳 SPLIT SALE: Notes: ${request.notes}');
      print('💳 SPLIT SALE: Items count: ${request.items?.length ?? 0}');

      final requestJson = request.toJson();
      print('💳 SPLIT SALE: Request JSON:');
      requestJson.forEach((key, value) {
        print('💳 SPLIT SALE:   $key: $value');
      });

      print('💳 SPLIT SALE: Making POST request to /sales/split');
      final response = await _dio.post('/sales/split', data: requestJson);

      print('💳 SPLIT SALE: Response received!');
      print('💳 SPLIT SALE: Response status code: ${response.statusCode}');
      print('💳 SPLIT SALE: Response data type: ${response.data.runtimeType}');
      print('💳 SPLIT SALE: Full response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('💳 SPLIT SALE: Status code indicates success');
        print('💳 SPLIT SALE: Parsing response to SplitSaleResponse...');
        final splitSaleResponse = SplitSaleResponse.fromJson(response.data);
        print('💳 SPLIT SALE: Successfully created SplitSaleResponse');
        print('💳 SPLIT SALE: Sale ID: ${splitSaleResponse.sale.id}');
        return splitSaleResponse;
      } else {
        print('💳 SPLIT SALE: ERROR - Bad status code: ${response.statusCode}');
        print('💳 SPLIT SALE: Error response: ${response.data}');
        throw Exception(response.data['error'] ?? 'Failed to create split sale');
      }
    } catch (e) {
      print('💳 SPLIT SALE: EXCEPTION CAUGHT: $e');
      print('💳 SPLIT SALE: Exception type: ${e.runtimeType}');
      if (e is DioException) {
        print('💳 SPLIT SALE: DioException details:');
        print('💳 SPLIT SALE:   Status code: ${e.response?.statusCode}');
        print('💳 SPLIT SALE:   Response data: ${e.response?.data}');
        print('💳 SPLIT SALE:   Request data: ${e.requestOptions.data}');
      }
      throw Exception('Failed to create split sale: $e');
    }
  }

  @override
  Future<SplitSale> addPaymentToSale(int saleId, AddPaymentRequest request) async {
    try {
      if (EnvConfig.isDebugMode) {
        print('💳 ADD PAYMENT: Adding payment to sale $saleId');
        print('💳 ADD PAYMENT: Amount: ${request.amount}, Method: ${request.method}');
      }

      final response = await _dio.post('/sales/$saleId/payments', data: request.toJson());

      if (EnvConfig.isDebugMode) {
        print('💳 ADD PAYMENT: Response status: ${response.statusCode}');
        print('💳 ADD PAYMENT: Response data: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SplitSale.fromJson(response.data['sale']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to add payment');
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('💳 ADD PAYMENT: Error occurred: $e');
      }
      throw Exception('Failed to add payment: $e');
    }
  }

  @override
  Future<SplitSale> refundSplitPayment(int saleId, RefundRequest request) async {
    try {
      if (EnvConfig.isDebugMode) {
        print('💳 REFUND: Processing refund for sale $saleId');
        print('💳 REFUND: Payment index: ${request.paymentIndex}, Amount: ${request.refundAmount}');
      }

      final response = await _dio.post('/sales/$saleId/refund', data: request.toJson());

      if (EnvConfig.isDebugMode) {
        print('💳 REFUND: Response status: ${response.statusCode}');
        print('💳 REFUND: Response data: ${response.data}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SplitSale.fromJson(response.data['sale']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to process refund');
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('💳 REFUND: Error occurred: $e');
      }
      throw Exception('Failed to process refund: $e');
    }
  }

  @override
  Future<SplitBillingStats> getSplitBillingStats() async {
    try {
      if (EnvConfig.isDebugMode) {
        print('💳 STATS: Fetching split billing statistics');
      }

      final response = await _dio.get('/sales/split/stats');

      if (EnvConfig.isDebugMode) {
        print('💳 STATS: Response status: ${response.statusCode}');
        print('💳 STATS: Response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        return SplitBillingStats.fromJson(response.data);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to get split billing stats');
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('💳 STATS: Error occurred: $e');
      }
      throw Exception('Failed to get split billing stats: $e');
    }
  }
} 