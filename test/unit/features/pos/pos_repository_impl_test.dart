import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_repository_impl.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/cart_item.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/sale.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/menu_item.dart';

import 'pos_repository_impl_test.mocks.dart';

@GenerateMocks([Dio, Ref])
void main() {
  group('PosRepositoryImpl', () {
    late MockDio mockDio;
    late MockRef mockRef;
    late PosRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      mockRef = MockRef();
      repository = PosRepositoryImpl(mockDio, mockRef);
    });

    group('searchItems', () {
      test('should return list of cart items when API call is successful', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'success': true,
            'data': [
              {
                'id': 1,
                'businessId': 1,
                'categoryId': 1,
                'name': 'Test Item',
                'description': 'Test Description',
                'price': 10.99,
                'cost': 5.0,
                'image': null,
                'allergens': null,
                'nutritionalInfo': null,
                'preparationTime': 10,
                'isAvailable': true,
                'isActive': true,
                'createdAt': '2024-01-01T00:00:00Z',
                'updatedAt': '2024-01-01T00:00:00Z',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/menu/items'),
        );

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.searchItems('test');

        // Assert
        expect(result, isA<List<CartItem>>());
        expect(result.length, 1);
        expect(result.first.name, 'Test Item');
        expect(result.first.price, 10.99);
      });

      test('should return empty list when API call fails', () async {
        // Arrange
        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/api/menu/items'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/api/menu/items'),
          ),
        ));

        // Act & Assert
        expect(
          () => repository.searchItems('test'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getItemByBarcode', () {
      test('should return cart item when barcode is found', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'success': true,
            'data': [
              {
                'id': 1,
                'businessId': 1,
                'categoryId': 1,
                'name': 'Barcode Item',
                'description': 'Item found by barcode',
                'price': 15.99,
                'cost': 8.0,
                'image': null,
                'allergens': null,
                'nutritionalInfo': null,
                'preparationTime': 5,
                'isAvailable': true,
                'isActive': true,
                'createdAt': '2024-01-01T00:00:00Z',
                'updatedAt': '2024-01-01T00:00:00Z',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/menu/items'),
        );

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getItemByBarcode('123456789');

        // Assert
        expect(result, isA<CartItem>());
        expect(result!.name, 'Barcode Item');
        expect(result.price, 15.99);
      });

      test('should return null when barcode is not found', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'success': true,
            'data': []
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/menu/items'),
        );

        when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getItemByBarcode('nonexistent');

        // Assert
        expect(result, isNull);
      });
    });

    group('createSale', () {
      test('should create sale successfully', () async {
        // Arrange
        final items = [
          CartItem(
            id: '1',
            name: 'Test Item',
            price: 10.99,
            quantity: 2,
          )
        ];

        final orderResponse = Response(
          data: {
            'success': true,
            'data': {
              'id': 1,
              'businessId': 1,
              'customerId': null,
              'tableId': null,
              'orderNumber': 'ORD-1234567890-123',
              'type': 'takeaway',
              'status': 'pending',
              'subtotal': 21.98,
              'tax': 0.0,
              'discount': 0.0,
              'total': 21.98,
              'notes': null,
              'estimatedReadyTime': null,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': '2024-01-01T00:00:00Z',
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/api/orders'),
        );

        final saleResponse = Response(
          data: {
            'success': true,
            'data': {
              'id': 1,
              'orderId': 1,
              'customerName': 'Test Customer',
              'customerEmail': 'test@example.com',
              'paymentMethod': 'card',
              'total': 21.98,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': '2024-01-01T00:00:00Z',
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/api/sales'),
        );

        when(mockDio.post('/api/orders', data: anyNamed('data')))
            .thenAnswer((_) async => orderResponse);
        when(mockDio.post('/api/orders/1/items', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/api/orders/1/items'),
                ));
        when(mockDio.post('/api/sales', data: anyNamed('data')))
            .thenAnswer((_) async => saleResponse);

        // Act
        final result = await repository.createSale(
          items: items,
          paymentMethod: PaymentMethod.card,
          customerName: 'Test Customer',
          customerEmail: 'test@example.com',
        );

        // Assert
        expect(result, isA<Sale>());
        expect(result.id, '1');
        expect(result.total, 21.98);
        expect(result.paymentMethod, PaymentMethod.card);
        expect(result.customerName, 'Test Customer');
        expect(result.customerEmail, 'test@example.com');
      });
    });
  });
} 