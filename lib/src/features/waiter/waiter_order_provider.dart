import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import '../pos/models/cart_item.dart';


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

    try {
      final response = await dio.post('/orders/table', data: orderData);
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Order submission failed');
        }
      }
      return responseData;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTableOrders(int tableId) async {
    final response = await dio.get('/orders/table/$tableId');

    // Handle the new response format
    List<dynamic> orders;
    if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
      orders = response.data['data'] as List<dynamic>;
    } else if (response.data is List<dynamic>) {
      orders = response.data;
    } else {
      orders = [];
    }

    return List<Map<String, dynamic>>.from(orders);
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
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
    final orderItems = items.map((cartItem) => {
      'itemId': int.parse(cartItem.id),
      'quantity': cartItem.quantity,
      'notes': cartItem.category ?? '',
    }).toList();

    final response = await dio.post(
      '/orders/$orderId/items',
      data: {'items': orderItems},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getOrderById(int orderId) async {
    final response = await dio.get('/orders/$orderId');
    
    // Handle the new response format with success/data structure
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data')) {
        final data = responseData['data'] ?? {};
        return data;
      } else if (responseData.containsKey('success') && responseData['success'] == true) {
        return responseData;
      }
    }
    
    return responseData;
  }

  Future<List<Map<String, dynamic>>> getMenuItems({String? search}) async {
    try {
      // Get business ID from auth state
      final authState = _ref.read(authNotifierProvider);
      final businessId = authState.business?.id;
      
      if (businessId == null) {
        throw Exception('Missing business information');
      }

      final queryParams = <String, dynamic>{
        'businessId': businessId,
        'available': true,
        'limit': 100, // Get more items for waiter interface
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search; // Use 'search' for search as per API docs
      }

      final response = await dio.get('/menu/items', queryParameters: queryParams);

      // Handle different response formats
      List<dynamic> data;
      if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
        data = response.data['data'] as List<dynamic>;
      } else if (response.data is List<dynamic>) {
        data = response.data;
      } else {
        throw Exception('Unexpected response format from /menu/items');
      }

      final menuItems = List<Map<String, dynamic>>.from(data);

      return menuItems;
    } catch (e) {
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

final mergedTableOrdersProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, tableId) async {
  final repo = ref.watch(waiterOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  
  if (user == null) throw Exception('Not authenticated');

  final tableOrders = await repo.getTableOrders(tableId);
  
  if (tableOrders.isEmpty) {
    return {
      'customerName': '',
      'customerNotes': '',
      'items': [],
      'totalItems': 0,
    };
  }

  // Merge all orders into a single cart state
  final mergedItems = <Map<String, dynamic>>[];
  String customerName = '';
  String customerNotes = '';
  
  for (int i = 0; i < tableOrders.length; i++) {
    final order = tableOrders[i];
    
    // Use customer data from first order
    if (i == 0) {
      final customerData = order['customer'] ?? order['customerData'];
      customerName = customerData?['name'] ?? '';
      customerNotes = order['notes'] ?? '';
      
      // If customer name is not in customerData, try to extract it from notes
      if (customerName.isEmpty && customerNotes.isNotEmpty) {
        final lines = customerNotes.split('\n');
        for (final line in lines) {
          if (line.trim().startsWith('Customer: ')) {
            customerName = line.trim().substring('Customer: '.length);
            // Remove the customer line from notes
            customerNotes = lines.where((l) => !l.trim().startsWith('Customer: ')).join('\n').trim();
            break;
          }
        }
      }
    }
    
    // Get items from this order
    final items = order['items'] as List? ?? 
                 order['orderItems'] as List? ?? 
                 order['order_items'] as List?;
    
    if (items != null) {
      for (final item in items) {
        // Check if item already exists and merge quantities
        final existingIndex = mergedItems.indexWhere((mergedItem) => 
          mergedItem['itemId'] == item['itemId'] || 
          mergedItem['id'] == item['itemId']
        );
        
        if (existingIndex >= 0) {
          // Merge quantities
          final existingQuantity = mergedItems[existingIndex]['quantity'] as int;
          final newQuantity = (item['quantity'] ?? 1) as int;
          mergedItems[existingIndex]['quantity'] = existingQuantity + newQuantity;
        } else {
          // Add new item
          mergedItems.add({
            'id': item['id'],
            'itemId': item['itemId'],
            'itemName': item['itemName'] ?? item['name'],
            'quantity': item['quantity'] ?? 1,
            'unitPrice': item['unitPrice'] ?? item['price'],
            'menuItem': item['menuItem'],
            'imageUrl': item['imageUrl'],
            'category': item['category'],
          });
        }
      }
    }
  }
  
  return {
    'customerName': customerName,
    'customerNotes': customerNotes,
    'items': mergedItems,
    'totalItems': mergedItems.length,
    'orderCount': tableOrders.length,
  };
}); 