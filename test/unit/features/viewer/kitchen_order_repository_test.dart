import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/features/viewer/kitchen_order_repository.dart';
import 'package:white_label_pos_mobile/src/features/viewer/kitchen_order.dart';

import 'kitchen_order_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('KitchenOrderRepository', () {
    late MockDio mockDio;
    late KitchenOrderRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = KitchenOrderRepository(mockDio);
    });

    group('fetchKitchenOrders', () {
      test('should fetch kitchen orders successfully', () async {
        // Arrange
        final mockResponse = {
          'data': [
            {
              'id': 1,
              'businessId': 1,
              'orderId': 1,
              'orderNumber': 'ORD-001',
              'status': 'pending',
              'items': [
                {
                  'id': 1,
                  'itemName': 'Burger',
                  'quantity': 2,
                  'status': 'pending',
                }
              ],
            }
          ]
        };

        when(mockDio.get(
          '/kitchen/orders',
          queryParameters: {'businessId': 1},
        )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/kitchen/orders'),
        ));

        // Act
        final result = await repository.fetchKitchenOrders(businessId: 1);

        // Assert
        expect(result, isA<List<KitchenOrder>>());
        expect(result.length, 1);
        expect(result.first.orderNumber, 'ORD-001');
        expect(result.first.status, 'pending');
        expect(result.first.items.length, 1);
        expect(result.first.items.first.itemName, 'Burger');
        expect(result.first.items.first.quantity, 2);

        verify(mockDio.get(
          '/kitchen/orders',
          queryParameters: {'businessId': 1},
        )).called(1);
      });

      test('should fetch kitchen orders with status filter', () async {
        // Arrange
        final mockResponse = {
          'data': [
            {
              'id': 1,
              'businessId': 1,
              'orderId': 1,
              'orderNumber': 'ORD-001',
              'status': 'preparing',
              'items': [],
            }
          ]
        };

        when(mockDio.get(
          '/kitchen/orders',
          queryParameters: {'businessId': 1, 'status': 'preparing'},
        )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/kitchen/orders'),
        ));

        // Act
        final result = await repository.fetchKitchenOrders(
          businessId: 1,
          status: 'preparing',
        );

        // Assert
        expect(result, isA<List<KitchenOrder>>());
        expect(result.length, 1);
        expect(result.first.status, 'preparing');

        verify(mockDio.get(
          '/kitchen/orders',
          queryParameters: {'businessId': 1, 'status': 'preparing'},
        )).called(1);
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockDio.get(
          '/kitchen/orders',
          queryParameters: {'businessId': 1},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/kitchen/orders'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/kitchen/orders'),
          ),
        ));

        // Act & Assert
        expect(
          () => repository.fetchKitchenOrders(businessId: 1),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('updateOrderStatus', () {
      test('should update order status successfully', () async {
        // Arrange
        when(mockDio.put(
          '/kitchen/orders/1/status',
          data: {'status': 'preparing'},
        )).thenAnswer((_) async => Response(
          data: {'success': true, 'message': 'Order status updated successfully'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/kitchen/orders/1/status'),
        ));

        // Act
        await repository.updateOrderStatus(1, 'preparing');

        // Assert
        verify(mockDio.put(
          '/kitchen/orders/1/status',
          data: {'status': 'preparing'},
        )).called(1);
      });

      test('should throw exception when status update fails', () async {
        // Arrange
        when(mockDio.put(
          '/kitchen/orders/1/status',
          data: {'status': 'preparing'},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/kitchen/orders/1/status'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/kitchen/orders/1/status'),
          ),
        ));

        // Act & Assert
        expect(
          () => repository.updateOrderStatus(1, 'preparing'),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
} 