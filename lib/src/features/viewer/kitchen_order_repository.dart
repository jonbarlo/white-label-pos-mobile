import 'package:dio/dio.dart';
import 'kitchen_order.dart';

class KitchenOrderRepository {
  final Dio dio;
  KitchenOrderRepository(this.dio);

  Future<List<KitchenOrder>> fetchKitchenOrders({required int businessId, String? status}) async {
    final response = await dio.get(
      '/kitchen/orders',
      queryParameters: {
        'businessId': businessId,
        if (status != null) 'status': status,
      },
    );
    
    final data = response.data['data'] as List<dynamic>;
    return data.map((json) => KitchenOrder.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    await dio.put(
      '/kitchen/orders/$orderId/status',
      data: {
        'status': status,
      },
    );
  }
} 