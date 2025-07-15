import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/env_config.dart';
import '../auth/auth_provider.dart';
import '../pos/models/cart_item.dart';
import 'models/table.dart' as waiter_table;

class WaiterOrderRepository {
  final Dio dio;
  final Ref _ref;
  WaiterOrderRepository(this.dio, this._ref);

  Future<Map<String, dynamic>> submitTableOrder({
    required int tableId,
    required String customerName,
    required String customerNotes,
    required List<CartItem> items,
    required double subtotal,
    required double tax,
    required double total,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Submitting order for table $tableId');
      print('🪑 WAITER ORDER: Customer: $customerName');
      print('🪑 WAITER ORDER: Items count: ${items.length}');
      print('🪑 WAITER ORDER: Total: \$${total.toStringAsFixed(2)}');
    }

    // Convert cart items to order items format
    // The cart item ID should be the menu item ID that the backend expects
    final orderItems = items.map((cartItem) {
      // Try to parse as integer, but if it fails, we need to handle this differently
      final itemId = int.tryParse(cartItem.id);
      if (itemId == null) {
        throw Exception('Invalid menu item ID: ${cartItem.id}');
      }
      
      return {
        'itemId': itemId,
        'quantity': cartItem.quantity,
        'notes': cartItem.category ?? '', // Add notes field as per API documentation
      };
    }).toList();

    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Order items being sent:');
      for (int i = 0; i < orderItems.length; i++) {
        final item = orderItems[i];
        print('🪑 WAITER ORDER:   Item $i: itemId=${item['itemId']}, quantity=${item['quantity']}, notes=${item['notes']}');
      }
      print('🪑 WAITER ORDER: Using menu item IDs from /menu-items endpoint');
      
      // Debug: Let's also fetch and log the available menu items to see what IDs are valid
      try {
        final menuItems = await getMenuItems();
        print('🪑 WAITER ORDER: Available menu items:');
        for (final menuItem in menuItems) {
          print('🪑 WAITER ORDER:   Menu item: ID=${menuItem['id']}, Name=${menuItem['name']}, Price=${menuItem['price']}');
        }
      } catch (e) {
        print('🪑 WAITER ORDER: Could not fetch menu items for debugging: $e');
      }
    }

    // Get auth state for business and user info
    final authState = _ref.read(authNotifierProvider);
    final businessId = authState.business?.id;
    final userId = authState.user?.id;
    
    if (businessId == null || userId == null) {
      throw Exception('Missing business or user information');
    }

    final orderData = {
      'tableId': tableId,
      'items': orderItems,
      'notes': customerNotes, // Use notes instead of customerNotes
    };
    
    // Add customerId if we have customer information
    if (customerName.isNotEmpty && customerName != 'Guest') {
      // Note: In a real implementation, you might want to create/find customer first
      // For now, we'll just include the customer name in notes
      orderData['notes'] = '${orderData['notes']}\nCustomer: $customerName';
    }

    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Full orderData payload:');
      print(orderData);
    }

    try {
      final response = await dio.post('/orders/table', data: orderData);
      if (EnvConfig.isDebugMode) {
        print('🪑 WAITER ORDER: Response status: ${response.statusCode}');
        print('🪑 WAITER ORDER: Response data: ${response.data}');
      }
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData['success'] == true) {
          if (EnvConfig.isDebugMode) {
            print('🪑 WAITER ORDER: Order submitted successfully!');
            print('🪑 WAITER ORDER: Order ID: ${responseData['data']?['id'] ?? responseData['id']}');
          }
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Order submission failed');
        }
      }
      return responseData;
    } on DioException catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🪑 WAITER ORDER: DioException caught during order submission!');
        print('🪑 WAITER ORDER: DioException type: ${e.type}');
        print('🪑 WAITER ORDER: DioException status: ${e.response?.statusCode}');
        print('🪑 WAITER ORDER: DioException data: ${e.response?.data}');
        print('🪑 WAITER ORDER: DioException message: ${e.message}');
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTableOrders(int tableId) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Fetching orders for table $tableId using new endpoint');
    }

    final response = await dio.get('/orders/table/$tableId');

    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Response status: ${response.statusCode}');
      print('🪑 WAITER ORDER: Response data: ${response.data}');
    }

    // Handle the new response format
    List<dynamic> orders;
    if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
      orders = response.data['data'] as List<dynamic>;
    } else if (response.data is List<dynamic>) {
      orders = response.data;
    } else {
      orders = [];
    }

    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Found ${orders.length} orders');
    }

    return List<Map<String, dynamic>>.from(orders);
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Updating order $orderId status to $status');
    }

    final response = await dio.put(
      '/orders/$orderId/status',
      data: {'status': status},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> addItemsToOrder({
    required String orderId,
    required List<CartItem> items,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Adding ${items.length} items to order $orderId');
    }

    final orderItems = items.map((cartItem) => {
      'itemId': int.parse(cartItem.id),
      'quantity': cartItem.quantity,
      'price': cartItem.price,
      'notes': cartItem.category ?? '',
    }).toList();

    final response = await dio.post(
      '/orders/$orderId/items',
      data: {'items': orderItems},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getOrderById(int orderId) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Fetching order by ID $orderId');
    }
    final response = await dio.get('/orders/$orderId');
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Raw response data: ${response.data}');
      print('🪑 WAITER ORDER: Response status: ${response.statusCode}');
    }
    
    // Handle the new response format with success/data structure
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data')) {
        final data = responseData['data'] ?? {};
        if (EnvConfig.isDebugMode) {
          print('🪑 WAITER ORDER: Using data field: $data');
          print('🪑 WAITER ORDER: Order items in data: ${data['items']}');
        }
        return data;
      } else if (responseData.containsKey('success') && responseData['success'] == true) {
        if (EnvConfig.isDebugMode) {
          print('🪑 WAITER ORDER: Using success response: $responseData');
          print('🪑 WAITER ORDER: Order items in success: ${responseData['items']}');
        }
        return responseData;
      }
    }
    
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Returning raw response data: $responseData');
    }
    return responseData;
  }

  Future<List<Map<String, dynamic>>> getMenuItems({String? search}) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Fetching menu items');
      if (search != null) print('🪑 WAITER ORDER: Search query: $search');
    }

    try {
      // Get business ID from auth state
      final authState = _ref.read(authNotifierProvider);
      final businessId = authState.business?.id;
      
      if (businessId == null) {
        throw Exception('Missing business information');
      }

      final queryParams = <String, dynamic>{
        'businessId': businessId,
        'isAvailable': true,
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (EnvConfig.isDebugMode) {
        print('🪑 WAITER ORDER: Making request to /menu-items with params: $queryParams');
      }

      final response = await dio.get('/menu-items', queryParameters: queryParams);

      if (EnvConfig.isDebugMode) {
        print('🪑 WAITER ORDER: Response status: ${response.statusCode}');
        print('🪑 WAITER ORDER: Response data: ${response.data}');
      }

      // Handle different response formats
      List<dynamic> data;
      if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
        data = response.data['data'] as List<dynamic>;
      } else if (response.data is List<dynamic>) {
        data = response.data;
      } else {
        throw Exception('Unexpected response format from /menu-items');
      }

      final menuItems = List<Map<String, dynamic>>.from(data);

      if (EnvConfig.isDebugMode) {
        print('🪑 WAITER ORDER: Found ${menuItems.length} menu items');
      }

      return menuItems;
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🪑 WAITER ORDER: Error fetching menu items: $e');
        if (e is DioException) {
          print('🪑 WAITER ORDER: DioException status: ${e.response?.statusCode}');
          print('🪑 WAITER ORDER: DioException data: ${e.response?.data}');
        }
      }
      rethrow;
    }
  }
}

final waiterOrderRepositoryProvider = Provider<WaiterOrderRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return WaiterOrderRepository(dio, ref);
});

final submitTableOrderProvider = FutureProvider.family<Map<String, dynamic>, ({
  int tableId,
  String customerName,
  String customerNotes,
  List<CartItem> items,
  double subtotal,
  double tax,
  double total,
})>((ref, params) async {
  final repo = ref.watch(waiterOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  
  if (user == null) throw Exception('Not authenticated');

  return await repo.submitTableOrder(
    tableId: params.tableId,
    customerName: params.customerName,
    customerNotes: params.customerNotes,
    items: params.items,
    subtotal: params.subtotal,
    tax: params.tax,
    total: params.total,
  );
});

final tableOrdersProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, tableId) async {
  final repo = ref.watch(waiterOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  
  if (user == null) throw Exception('Not authenticated');

  return await repo.getTableOrders(tableId);
});

final updateOrderStatusProvider = FutureProvider.family<Map<String, dynamic>, ({String orderId, String status})>((ref, params) async {
  final repo = ref.watch(waiterOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  
  if (user == null) throw Exception('Not authenticated');

  return await repo.updateOrderStatus(
    orderId: params.orderId,
    status: params.status,
  );
});

final addItemsToOrderProvider = FutureProvider.family<Map<String, dynamic>, ({String orderId, List<CartItem> items})>((ref, params) async {
  final repo = ref.watch(waiterOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  
  if (user == null) throw Exception('Not authenticated');

  return await repo.addItemsToOrder(
    orderId: params.orderId,
    items: params.items,
  );
}); 

final orderByIdProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, orderId) async {
  final repo = ref.watch(waiterOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  return await repo.getOrderById(orderId);
});

final menuItemsProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, search) async {
  final repo = ref.watch(waiterOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  return await repo.getMenuItems(search: search);
}); 