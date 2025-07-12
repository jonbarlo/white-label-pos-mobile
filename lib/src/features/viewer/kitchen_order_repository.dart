import 'package:dio/dio.dart';
import 'kitchen_order.dart';
import '../../core/config/env_config.dart';

class KitchenOrderRepository {
  final Dio dio;
  KitchenOrderRepository(this.dio);

  Future<List<KitchenOrder>> fetchKitchenOrders({required int businessId, String? status}) async {
    if (EnvConfig.isDebugMode) {
      print('🍳 KITCHEN: Fetching kitchen orders for businessId: $businessId, status: $status');
    }
    
    final response = await dio.get(
      '/kitchen/orders',
      queryParameters: {
        'businessId': businessId,
        if (status != null) 'status': status,
      },
    );
    
    if (EnvConfig.isDebugMode) {
      print('🍳 KITCHEN: Response status: ${response.statusCode}');
      print('🍳 KITCHEN: Response data: ${response.data}');
    }
    
    if (EnvConfig.isDebugMode) {
      print('🍳 KITCHEN: Response data type: ${response.data.runtimeType}');
      print('🍳 KITCHEN: Response data keys: ${response.data.keys.toList()}');
    }
    
    final data = response.data['data'] as List<dynamic>;
    
    if (EnvConfig.isDebugMode) {
      print('🍳 KITCHEN: Data list length: ${data.length}');
      if (data.isNotEmpty) {
        print('🍳 KITCHEN: First item keys: ${(data.first as Map<String, dynamic>).keys.toList()}');
      }
    }
    
    final orders = data.map((json) {
      try {
        return KitchenOrder.fromJson(json as Map<String, dynamic>);
      } catch (e) {
        if (EnvConfig.isDebugMode) {
          print('🍳 KITCHEN: Error parsing order: $e');
          print('🍳 KITCHEN: Problematic JSON: $json');
        }
        rethrow;
      }
    }).toList();
    
    if (EnvConfig.isDebugMode) {
      print('🍳 KITCHEN: Parsed ${orders.length} orders');
      for (int i = 0; i < orders.length; i++) {
        final order = orders[i];
        print('🍳 KITCHEN: Order $i: ${order.orderNumber}, status: ${order.status}, items: ${order.items.length}');
      }
    }
    
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