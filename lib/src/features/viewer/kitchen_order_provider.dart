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
  
  // Fetch orders with statuses that kitchen staff should see
  // 'preparing' and 'confirmed' are the active statuses for kitchen orders
  final preparingOrders = await repo.fetchKitchenOrders(businessId: businessId, status: 'preparing');
  final confirmedOrders = await repo.fetchKitchenOrders(businessId: businessId, status: 'confirmed');
  
  // Combine and sort by order number
  final allOrders = [...preparingOrders, ...confirmedOrders];
  allOrders.sort((a, b) => a.orderNumber.compareTo(b.orderNumber));
  
  return allOrders;
}); 