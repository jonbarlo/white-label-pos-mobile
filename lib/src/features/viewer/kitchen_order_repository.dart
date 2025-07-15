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
    
    final orders = data.map((json) {
      try {
        return KitchenOrder.fromJson(json as Map<String, dynamic>);
      } catch (e) {
        rethrow;
      }
    }).toList();
    
    return orders;
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