import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import 'kitchen_order.dart';
import 'kitchen_order_repository.dart';

final kitchenOrderRepositoryProvider = Provider<KitchenOrderRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return KitchenOrderRepository(dio);
});

final kitchenOrdersProvider = FutureProvider.autoDispose<List<KitchenOrder>>((ref) async {
  final repo = ref.watch(kitchenOrderRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  final businessId = user.businessId;
  
  // Fetch all kitchen orders without status filter to get all active orders
  final orders = await repo.fetchKitchenOrders(businessId: businessId);
  
  // Sort by order number
  orders.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
  
  return orders;
});

final updateOrderStatusProvider = FutureProvider.family<void, ({int orderId, String status})>((ref, params) async {
  final repo = ref.watch(kitchenOrderRepositoryProvider);
  await repo.updateOrderStatus(params.orderId, params.status);
}); 