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
    final orderItems = items.map((cartItem) => {
      'itemId': int.parse(cartItem.id),
      'quantity': cartItem.quantity,
      'notes': cartItem.category ?? '', // Add notes field as per API documentation
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
      'orderType': 'dine_in', // Required field as per API documentation
      'items': orderItems,
      'notes': customerNotes, // Use notes instead of customerNotes
    };
    
    // Add customerId if we have customer information
    if (customerName.isNotEmpty && customerName != 'Guest') {
      // Note: In a real implementation, you might want to create/find customer first
      // For now, we'll just include the customer name in notes
      orderData['notes'] = '${orderData['notes']}\nCustomer: $customerName';
    }

    final response = await dio.post('/orders', data: orderData);

    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Response status: ${response.statusCode}');
      print('🪑 WAITER ORDER: Response data: ${response.data}');
    }

    // Handle the new response format with success/data structure
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      if (responseData['success'] == true) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Order submission failed');
      }
    }

    return responseData;
  }

  Future<List<Map<String, dynamic>>> getTableOrders(int tableId) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Fetching orders for table $tableId');
    }

    final response = await dio.get('/orders/table/$tableId');

    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Found ${response.data['data']?.length ?? 0} orders');
    }

    return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
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
      print('🪑 WAITER ORDER: Order details: ${response.data}');
    }
    
    // Handle the new response format with success/data structure
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('data')) {
        return responseData['data'] ?? {};
      } else if (responseData.containsKey('success') && responseData['success'] == true) {
        return responseData;
      }
    }
    
    return responseData;
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