import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/env_config.dart';
import '../auth/auth_provider.dart';
import '../pos/models/cart_item.dart';
import 'models/table.dart' as waiter_table;

class WaiterOrderRepository {
  final Dio dio;
  WaiterOrderRepository(this.dio);

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
      'price': cartItem.price,
      'notes': cartItem.category ?? '',
    }).toList();

    final orderData = {
      'tableId': tableId,
      'customerName': customerName,
      'customerNotes': customerNotes,
      'items': orderItems,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'orderType': 'table_service',
      'waiterId': null, // Will be set from auth context
    };

    final response = await dio.post('/orders/table', data: orderData);

    if (EnvConfig.isDebugMode) {
      print('🪑 WAITER ORDER: Response status: ${response.statusCode}');
      print('🪑 WAITER ORDER: Response data: ${response.data}');
    }

    return response.data;
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
}

final waiterOrderRepositoryProvider = Provider<WaiterOrderRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return WaiterOrderRepository(dio);
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