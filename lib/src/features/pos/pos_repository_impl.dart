import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pos_repository.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/menu_item.dart';
import 'models/split_payment.dart';
import 'models/analytics.dart';

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
        // Only logout on 401 errors for specific endpoints that require authentication
        // Don't logout for sales creation as it might be a temporary issue
        if (error.response?.statusCode == 401) {
          final requestPath = error.requestOptions.path;
          // Only logout for sensitive operations, not for sales creation
          if (!requestPath.contains('/sales/') && !requestPath.contains('/menu/')) {
            print('🔍 POS Repository: 401 error on $requestPath, logging out');
            _ref.read(authNotifierProvider.notifier).logout();
          } else {
            print('🔍 POS Repository: 401 error on $requestPath, but not logging out (sales/menu operation)');
          }
        }
        handler.next(error);
      },
    ));
  }

  @override
  Future<List<CartItem>> searchItems(String query) async {
    try {
      // Get business ID from auth state
      final authState = _ref.read(authNotifierProvider);
      final businessId = authState.business?.id;
      
      if (businessId == null) {
        throw Exception('No businessId found in auth state');
      }

      // Use the correct endpoint: /menu/items
      final response = await _dio.get('/menu/items', queryParameters: {
        'businessId': businessId, // Required parameter
        if (query.isNotEmpty) 'search': query, // Use 'search' for search as per API docs
        'limit': 100, // Get more items for POS
      });

      // The /menu/items endpoint returns {success: true, data: [...]}
      final responseData = response.data;
      List<dynamic> items;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        items = responseData['data'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        items = responseData;
      } else {
        throw Exception('Unexpected response format from /menu/items');
      }

      // Debug: Print raw API response for first item
      if (items.isNotEmpty) {
        print('🔍 Raw API response for first item: ${items.first}');
      }

      return items
          .map((item) => _convertMenuItemToCartItem(_safeMenuItemFromJson(item as Map<String, dynamic>)))
          .toList();
    } catch (e) {
      throw Exception('Failed to search menu items: $e');
    }
  }

  @override
  Future<CartItem?> getItemByBarcode(String barcode) async {
    try {
      // Get business ID from auth state
      final authState = _ref.read(authNotifierProvider);
      final businessId = authState.business?.id;
      
      if (businessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/menu/items', queryParameters: {
        'businessId': businessId, // Required parameter
        'barcode': barcode,
      });

      if (response.statusCode == 200) {
        final responseData = response.data;
        List<dynamic> items;
        
        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          items = responseData['data'] as List<dynamic>;
        } else if (responseData is List<dynamic>) {
          items = responseData;
        } else {
          return null;
        }
        
        if (items.isNotEmpty) {
          return _convertMenuItemToCartItem(_safeMenuItemFromJson(items.first as Map<String, dynamic>));
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
      print('🔍 POS Repository: Creating sale with ${items.length} items');
      final authState = _ref.read(authNotifierProvider);
      
      print('🔍 POS Repository: Auth state - Status: ${authState.status}, User: ${authState.user?.id}, Business: ${authState.business?.id}');
      
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
          
          print('🔍 POS Repository: Sale created successfully - ID: ${sale.id}, Total: ${sale.total}');
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

      if (response.statusCode == 200) {
        // Handle both response formats: direct array or wrapped response
        List<dynamic> sales;
        if (response.data is List) {
          // Direct array format as per API docs
          sales = response.data as List<dynamic>;
        } else if (response.data is Map && response.data['success'] == true) {
          // Wrapped response format
          sales = response.data['data'] ?? [];
        } else {
          sales = [];
        }
        
        return sales.map((sale) => _convertApiSaleToSale(sale)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get recent sales: $e');
    }
  }

  @override
  Future<Sale?> getSaleWithItems(String saleId) async {
    try {
      final response = await _dio.get('/sales/$saleId/with-items');

      if (response.statusCode == 200) {
        final saleData = response.data;
        
        // Convert saleItems to CartItems
        List<CartItem> items = [];
        if (saleData['saleItems'] != null) {
          final saleItems = saleData['saleItems'] as List<dynamic>;
          items = saleItems.map((item) {
            final itemData = item['item'] as Map<String, dynamic>;
            return CartItem(
              id: itemData['id'].toString(),
              name: itemData['name'] ?? 'Unknown Item',
              price: (item['unitPrice'] as num?)?.toDouble() ?? 0.0,
              quantity: item['quantity'] as int? ?? 1,
              imageUrl: itemData['imageUrl'],
              category: itemData['category']?.toString() ?? '1',
            );
          }).toList();
        }

        // Handle receipt number - try different possible field names
        final receiptNumber = saleData['saleNumber'] ?? 
                             saleData['orderNumber'] ?? 
                             saleData['receiptNumber'] ?? 
                             'SALE-$saleId';
        
        // Handle payment method mapping
        final paymentMethodStr = saleData['paymentMethod']?.toString().toLowerCase() ?? 'cash';
        PaymentMethod paymentMethod;
        switch (paymentMethodStr) {
          case 'card':
          case 'credit_card':
            paymentMethod = PaymentMethod.card;
            break;
          case 'mobile':
          case 'mobile_payment':
            paymentMethod = PaymentMethod.mobile;
            break;
          case 'check':
            paymentMethod = PaymentMethod.check;
            break;
          default:
            paymentMethod = PaymentMethod.cash;
        }

        return Sale(
          id: saleData['id'].toString(),
          items: items,
          total: (saleData['totalAmount'] as num?)?.toDouble() ?? 0.0,
          paymentMethod: paymentMethod,
          createdAt: DateTime.parse(saleData['createdAt']),
          customerName: saleData['customerName'] ?? 'Guest',
          customerEmail: saleData['customerEmail'] ?? 'guest@pos.com',
          receiptNumber: receiptNumber,
          status: saleData['status'],
        );
      }
      
      return null;
    } catch (e) {
      print('Error fetching sale with items: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> getSalesSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Use /sales endpoint with date filters to get sales for the period
      final startDateStr = startDate.toIso8601String().split('T')[0]; // YYYY-MM-DD format
      final endDateStr = endDate.toIso8601String().split('T')[0]; // YYYY-MM-DD format
      
      print('🔵 POS Repository: Getting sales summary from $startDateStr to $endDateStr');
      
      final response = await _dio.get('/sales', queryParameters: {
        'startDate': startDateStr,
        'endDate': endDateStr,
        'status': 'completed',
        'limit': 1000, // Get all sales for the period
      });

      print('🔵 POS Repository: Sales summary API response status: ${response.statusCode}');
      print('🔵 POS Repository: Sales summary API response data length: ${response.data is List ? (response.data as List).length : 'not a list'}');

      if (response.statusCode == 200) {
        // Handle both response formats: direct array or wrapped response
        List<dynamic> sales;
        if (response.data is List) {
          // Direct array format as per API docs
          sales = response.data as List<dynamic>;
        } else if (response.data is Map && response.data['success'] == true) {
          // Wrapped response format
          sales = response.data['data'] ?? [];
        } else {
          sales = [];
        }
        
        print('🔵 POS Repository: Found ${sales.length} sales for the period');
        
        // Calculate summary from sales data
        double totalSales = 0.0;
        int totalTransactions = sales.length;
        
        for (final sale in sales) {
          final saleAmount = (sale['totalAmount'] as num?)?.toDouble() ?? 0.0;
          totalSales += saleAmount;
          print('🔵 POS Repository: Sale ${sale['id']} amount: $saleAmount');
        }
        
        final summary = {
          'totalSales': totalSales,
          'totalTransactions': totalTransactions,
          'averageOrderValue': totalTransactions > 0 ? totalSales / totalTransactions : 0.0,
        };
        
        print('🔵 POS Repository: Calculated summary: $summary');
        return summary;
      }
      
      print('🔵 POS Repository: API error, returning default summary');
      return {'totalSales': 0.0, 'totalTransactions': 0, 'averageOrderValue': 0.0};
    } catch (e) {
      print('🔵 POS Repository: Error getting sales summary: $e');
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
    // Check for different possible image field names in the API response
    String? imageUrl = json['image'] as String? ?? 
                      json['imageUrl'] as String? ?? 
                      json['image_url'] as String? ??
                      json['photo'] as String? ??
                      json['photoUrl'] as String? ??
                      json['photo_url'] as String?;
    
    final itemName = json['name'] as String;
    
    // Handle both numeric and string category IDs
    final categoryValue = json['category'];
    int categoryId;
    
    if (categoryValue is int) {
      categoryId = categoryValue;
    } else if (categoryValue is String) {
      categoryId = 1; // Default category ID
    } else {
      categoryId = 1;
    }
    
    print('Processing menu item: "$itemName" (category: $categoryValue, original image: $imageUrl)');
    print('🔍 Available fields in JSON: ${json.keys.toList()}');

    final menuItem = MenuItem(
      id: json['id'] as int,
      businessId: json['businessId'] as int? ?? 1,
      categoryId: categoryId,
      name: itemName,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Handle null price
      cost: 0.0, // API doesn't provide cost
      image: imageUrl, // Use the actual image URL from API
      allergens: null, // Not in API response
      nutritionalInfo: null, // Not in API response
      preparationTime: 15, // Default preparation time
      isAvailable: true,
      isActive: true,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
    
    print('Created MenuItem for "$itemName" with image: ${menuItem.image}');
    return menuItem;
  }

  String _getSampleImageUrl(int categoryId, String itemName) {
    // Use Unsplash API for sample food images with better parameters
    final category = _getCategoryName(categoryId);
    final encodedName = Uri.encodeComponent(itemName);
    // Use more specific search terms and better image quality
    final imageUrl = 'https://source.unsplash.com/400x300/?food,$category,$encodedName&fit=crop&w=400&h=300';
    print('Generated sample image URL for "$itemName" (category $categoryId): $imageUrl');
    return imageUrl;
  }

  String _getCategoryName(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'appetizer';
      case 2:
        return 'main-course';
      case 3:
        return 'dessert';
      case 4:
        return 'drink';
      default:
        return 'food';
    }
  }

  String _getCategoryNameFromString(String categoryName) {
    // Handle string-based category names from the API
    final lowerCategory = categoryName.toLowerCase();
    if (lowerCategory.contains('burger') || lowerCategory.contains('main') || lowerCategory.contains('entree')) {
      return 'main-course';
    } else if (lowerCategory.contains('side') || lowerCategory.contains('appetizer') || lowerCategory.contains('starter')) {
      return 'appetizer';
    } else if (lowerCategory.contains('dessert') || lowerCategory.contains('sweet')) {
      return 'dessert';
    } else if (lowerCategory.contains('drink') || lowerCategory.contains('beverage') || lowerCategory.contains('wine') || lowerCategory.contains('beer')) {
      return 'drink';
    } else if (lowerCategory.contains('salad')) {
      return 'salad';
    } else {
      return 'food';
    }
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
    
    // Handle receipt number - try different possible field names
    final receiptNumber = apiSale['orderNumber'] ?? 
                         apiSale['receiptNumber'] ?? 
                         apiSale['saleNumber'] ?? 
                         'SALE-${apiSale['id']}';
    
    // Handle payment method mapping
    final paymentMethodStr = apiSale['paymentMethod']?.toString().toLowerCase() ?? 'cash';
    PaymentMethod paymentMethod;
    switch (paymentMethodStr) {
      case 'card':
      case 'credit_card':
        paymentMethod = PaymentMethod.card;
        break;
      case 'mobile':
      case 'mobile_payment':
        paymentMethod = PaymentMethod.mobile;
        break;
      case 'check':
        paymentMethod = PaymentMethod.check;
        break;
      default:
        paymentMethod = PaymentMethod.cash;
    }
    
    return Sale(
      id: apiSale['id'].toString(),
      items: null, // Items will be fetched separately using getSaleWithItems
      total: total,
      paymentMethod: paymentMethod,
      createdAt: DateTime.parse(apiSale['createdAt']),
      customerName: apiSale['customerName'] ?? 'Guest',
      customerEmail: apiSale['customerEmail'] ?? 'guest@pos.com',
      receiptNumber: receiptNumber,
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

  // Analytics implementations
  @override
  Future<ItemAnalytics> getItemAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      print('🔍 ANALYTICS DEBUG: Calling item analytics endpoint');
      print('🔍 ANALYTICS DEBUG: Base URL: ${_dio.options.baseUrl}');
      print('🔍 ANALYTICS DEBUG: Full URL: ${_dio.options.baseUrl}/sales/analytics/items');
      print('🔍 ANALYTICS DEBUG: Query parameters: $queryParams');
      print('🔍 ANALYTICS DEBUG: Headers: ${_dio.options.headers}');
      
      final response = await _dio.get('/sales/analytics/items', queryParameters: queryParams);
      
      print('🔍 ANALYTICS DEBUG: Response status: ${response.statusCode}');
      print('🔍 ANALYTICS DEBUG: Response headers: ${response.headers}');
      print('🔍 ANALYTICS DEBUG: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('🔍 ANALYTICS DEBUG: Raw item analytics response: $responseData');
        
        // The API returns a different structure than expected
        // It has topSellers, worstSellers, and summary directly
        if (responseData != null) {
          final topSellers = responseData['topSellers'] as List<dynamic>? ?? [];
          final worstSellers = responseData['worstSellers'] as List<dynamic>? ?? [];
          final summary = responseData['summary'] as Map<String, dynamic>? ?? {};
          
          final transformedData = {
            'topSellers': topSellers.map((item) => {
              'itemId': item['itemId'] ?? 0,
              'itemName': item['itemName'] ?? '',
              'quantitySold': item['totalQuantity'] ?? 0,
              'totalRevenue': (item['totalRevenue'] ?? 0.0).toDouble(),
              'averagePrice': (item['averagePrice'] ?? 0.0).toDouble(),
            }).toList(),
            'worstSellers': worstSellers.map((item) => {
              'itemId': item['itemId'] ?? 0,
              'itemName': item['itemName'] ?? '',
              'quantitySold': item['totalQuantity'] ?? 0,
              'totalRevenue': (item['totalRevenue'] ?? 0.0).toDouble(),
              'averagePrice': (item['averagePrice'] ?? 0.0).toDouble(),
            }).toList(),
            'profitMargins': topSellers.map((item) => {
              'itemId': item['itemId'] ?? 0,
              'itemName': item['itemName'] ?? '',
              'cost': 0.0, // API doesn't provide cost
              'revenue': (item['totalRevenue'] ?? 0.0).toDouble(),
              'profitMargin': (item['profitMargin'] ?? 0.0).toDouble(),
            }).toList(),
            'totalItemsSold': summary['totalItemsSold'] ?? 0,
            'totalRevenue': (summary['totalRevenue'] ?? 0.0).toDouble(),
          };
          
          print('🔍 ANALYTICS DEBUG: Item analytics transformed data: $transformedData');
          return ItemAnalytics.fromJson(transformedData);
        }
        print('🔍 ANALYTICS DEBUG: Item analytics response data is null');
        return ItemAnalytics.fromJson({});
      } else {
        print('🔍 ANALYTICS DEBUG: Error response: ${response.statusCode} - ${response.data}');
        throw Exception(response.data['message'] ?? 'Failed to get item analytics');
      }
    } catch (e) {
      print('🔍 ANALYTICS DEBUG: Exception caught: $e');
      print('🔍 ANALYTICS DEBUG: Exception type: ${e.runtimeType}');
      if (e is DioException) {
        print('🔍 ANALYTICS DEBUG: DioException details:');
        print('  - Type: ${e.type}');
        print('  - Message: ${e.message}');
        print('  - Response: ${e.response?.data}');
        print('  - Status code: ${e.response?.statusCode}');
      }
      throw Exception('Failed to get item analytics: $e');
    }
  }

  @override
  Future<RevenueAnalytics> getRevenueAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? period,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }
      if (period != null) {
        queryParams['period'] = period;
      }

      print('🔍 ANALYTICS DEBUG: Calling revenue analytics endpoint');
      print('🔍 ANALYTICS DEBUG: Base URL: ${_dio.options.baseUrl}');
      print('🔍 ANALYTICS DEBUG: Full URL: ${_dio.options.baseUrl}/sales/analytics/revenue');
      print('🔍 ANALYTICS DEBUG: Query parameters: $queryParams');
      
      final response = await _dio.get('/sales/analytics/revenue', queryParameters: queryParams);
      
      print('🔍 ANALYTICS DEBUG: Revenue response status: ${response.statusCode}');
      print('🔍 ANALYTICS DEBUG: Revenue response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('🔍 ANALYTICS DEBUG: Raw revenue analytics response: $responseData');
        
        // The API returns periodData and summary directly
        if (responseData != null) {
          final periodData = responseData['periodData'] as List<dynamic>? ?? [];
          final summary = responseData['summary'] as Map<String, dynamic>? ?? {};
          
          final transformedData = {
            'dailyTrends': periodData.map((trend) => {
              'period': trend['period'] ?? '',
              'revenue': (trend['revenue'] ?? 0.0).toDouble(),
              'orders': trend['transactions'] ?? 0,
              'averageOrderValue': (trend['averageOrderValue'] ?? 0.0).toDouble(),
            }).toList(),
            'weeklyTrends': [], // API doesn't provide weekly trends separately
            'monthlyTrends': [], // API doesn't provide monthly trends separately
            'yearlyTrends': [], // API doesn't provide yearly trends separately
            'totalRevenue': (summary['totalRevenue'] ?? 0.0).toDouble(),
            'averageOrderValue': (summary['averageOrderValue'] ?? 0.0).toDouble(),
            'totalOrders': summary['totalTransactions'] ?? 0,
          };
          
          print('🔍 ANALYTICS DEBUG: Revenue analytics transformed data: $transformedData');
          return RevenueAnalytics.fromJson(transformedData);
        }
        print('🔍 ANALYTICS DEBUG: Revenue analytics response data is null');
        return RevenueAnalytics.fromJson({});
      } else {
        print('🔍 ANALYTICS DEBUG: Revenue error response: ${response.statusCode} - ${response.data}');
        throw Exception(response.data['message'] ?? 'Failed to get revenue analytics');
      }
    } catch (e) {
      print('🔍 ANALYTICS DEBUG: Revenue exception caught: $e');
      if (e is DioException) {
        print('🔍 ANALYTICS DEBUG: Revenue DioException details:');
        print('  - Type: ${e.type}');
        print('  - Message: ${e.message}');
        print('  - Response: ${e.response?.data}');
        print('  - Status code: ${e.response?.statusCode}');
      }
      throw Exception('Failed to get revenue analytics: $e');
    }
  }

  @override
  Future<StaffAnalytics> getStaffAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      print('🔍 ANALYTICS DEBUG: Calling staff analytics endpoint');
      print('🔍 ANALYTICS DEBUG: Base URL: ${_dio.options.baseUrl}');
      print('🔍 ANALYTICS DEBUG: Full URL: ${_dio.options.baseUrl}/sales/analytics/staff');
      print('🔍 ANALYTICS DEBUG: Query parameters: $queryParams');
      
      final response = await _dio.get('/sales/analytics/staff', queryParameters: queryParams);
      
      print('🔍 ANALYTICS DEBUG: Staff response status: ${response.statusCode}');
      print('🔍 ANALYTICS DEBUG: Staff response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('🔍 ANALYTICS DEBUG: Raw staff analytics response: $responseData');
        
        // For now, return empty data until we see the actual response structure
        if (responseData != null) {
          final transformedData = {
            'topPerformers': [],
            'allStaff': [],
            'averageSalesPerStaff': 0.0,
            'totalStaff': 0,
          };
          
          print('🔍 ANALYTICS DEBUG: Staff analytics transformed data: $transformedData');
          return StaffAnalytics.fromJson(transformedData);
        }
        print('🔍 ANALYTICS DEBUG: Staff analytics response data is null');
        return StaffAnalytics.fromJson({});
      } else {
        print('🔍 ANALYTICS DEBUG: Staff error response: ${response.statusCode} - ${response.data}');
        throw Exception(response.data['message'] ?? 'Failed to get staff analytics');
      }
    } catch (e) {
      print('🔍 ANALYTICS DEBUG: Staff exception caught: $e');
      if (e is DioException) {
        print('🔍 ANALYTICS DEBUG: Staff DioException details:');
        print('  - Type: ${e.type}');
        print('  - Message: ${e.message}');
        print('  - Response: ${e.response?.data}');
        print('  - Status code: ${e.response?.statusCode}');
      }
      throw Exception('Failed to get staff analytics: $e');
    }
  }

  @override
  Future<CustomerAnalytics> getCustomerAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      print('🔍 ANALYTICS DEBUG: Calling customer analytics endpoint');
      print('🔍 ANALYTICS DEBUG: Base URL: ${_dio.options.baseUrl}');
      print('🔍 ANALYTICS DEBUG: Full URL: ${_dio.options.baseUrl}/sales/analytics/customers');
      print('🔍 ANALYTICS DEBUG: Query parameters: $queryParams');
      
      final response = await _dio.get('/sales/analytics/customers', queryParameters: queryParams);
      
      print('🔍 ANALYTICS DEBUG: Customer response status: ${response.statusCode}');
      print('🔍 ANALYTICS DEBUG: Customer response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('🔍 ANALYTICS DEBUG: Raw customer analytics response: $responseData');
        
        // For now, return empty data until we see the actual response structure
        if (responseData != null) {
          final transformedData = {
            'topCustomers': [],
            'allCustomers': [],
            'averageCustomerSpend': 0.0,
            'totalCustomers': 0,
            'retentionRate': 0.0,
          };
          
          print('🔍 ANALYTICS DEBUG: Customer analytics transformed data: $transformedData');
          return CustomerAnalytics.fromJson(transformedData);
        }
        print('🔍 ANALYTICS DEBUG: Customer analytics response data is null');
        return CustomerAnalytics.fromJson({});
      } else {
        print('🔍 ANALYTICS DEBUG: Customer error response: ${response.statusCode} - ${response.data}');
        throw Exception(response.data['message'] ?? 'Failed to get customer analytics');
      }
    } catch (e) {
      print('🔍 ANALYTICS DEBUG: Customer exception caught: $e');
      if (e is DioException) {
        print('🔍 ANALYTICS DEBUG: Customer DioException details:');
        print('  - Type: ${e.type}');
        print('  - Message: ${e.message}');
        print('  - Response: ${e.response?.data}');
        print('  - Status code: ${e.response?.statusCode}');
      }
      throw Exception('Failed to get customer analytics: $e');
    }
  }

  @override
  Future<InventoryAnalytics> getInventoryAnalytics({
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      print('🔍 ANALYTICS DEBUG: Calling inventory analytics endpoint');
      print('🔍 ANALYTICS DEBUG: Base URL: ${_dio.options.baseUrl}');
      print('🔍 ANALYTICS DEBUG: Full URL: ${_dio.options.baseUrl}/sales/analytics/inventory');
      print('🔍 ANALYTICS DEBUG: Query parameters: $queryParams');
      
      final response = await _dio.get('/sales/analytics/inventory', queryParameters: queryParams);
      
      print('🔍 ANALYTICS DEBUG: Inventory response status: ${response.statusCode}');
      print('🔍 ANALYTICS DEBUG: Inventory response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('🔍 ANALYTICS DEBUG: Raw inventory analytics response: $responseData');
        
        // For now, return empty data until we see the actual response structure
        if (responseData != null) {
          final transformedData = {
            'lowStockItems': [],
            'outOfStockItems': [],
            'turnoverRates': [],
            'totalInventoryValue': 0.0,
            'totalItems': 0,
          };
          
          print('🔍 ANALYTICS DEBUG: Inventory analytics transformed data: $transformedData');
          return InventoryAnalytics.fromJson(transformedData);
        }
        print('🔍 ANALYTICS DEBUG: Inventory analytics response data is null');
        return InventoryAnalytics.fromJson({});
      } else {
        print('🔍 ANALYTICS DEBUG: Inventory error response: ${response.statusCode} - ${response.data}');
        throw Exception(response.data['message'] ?? 'Failed to get inventory analytics');
      }
    } catch (e) {
      print('🔍 ANALYTICS DEBUG: Inventory exception caught: $e');
      if (e is DioException) {
        print('🔍 ANALYTICS DEBUG: Inventory DioException details:');
        print('  - Type: ${e.type}');
        print('  - Message: ${e.message}');
        print('  - Response: ${e.response?.data}');
        print('  - Status code: ${e.response?.statusCode}');
      }
      throw Exception('Failed to get inventory analytics: $e');
    }
  }
} 