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

import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';

@GenerateMocks([Dio, Ref])
void main() {
  provideDummy<AuthState>(const AuthState());
  group('PosRepositoryImpl', () {
    late MockDio mockDio;
    late MockRef mockRef;
    late PosRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      mockRef = MockRef();
      when(mockDio.options).thenReturn(BaseOptions());
      when(mockDio.interceptors).thenReturn(Interceptors());
      repository = PosRepositoryImpl(mockDio, mockRef);
    });

    group('searchItems', () {
      test('should return list of cart items when API call is successful', () async {
        // Arrange
        when(mockDio.get(
          '/menu/items',
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
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
                'cost': 5.00,
                'preparationTime': 10,
                'isAvailable': true,
                'isActive': true,
                'createdAt': '2025-07-10T01:00:00.000Z',
                'updatedAt': '2025-07-10T01:00:00.000Z',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/menu/items'),
        ));

        // Act
        final result = await repository.searchItems('test');

        // Assert
        expect(result, hasLength(1));
        expect(result.first.name, 'Test Item');
        expect(result.first.price, 10.99);

        verify(mockDio.get(
          '/menu/items',
          queryParameters: {
            'search': 'test',
            'isAvailable': true,
            'isActive': true,
          },
        )).called(1);
      });

      test('should return empty list when search fails', () async {
        when(mockDio.get(
          '/menu/items',
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': false,
            'message': 'Search failed',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/menu/items'),
        ));

        final result = await repository.searchItems('test');

        expect(result, isEmpty);
      });

      test('should throw exception when network error occurs', () async {
        when(mockDio.get(
          '/menu/items',
          queryParameters: anyNamed('queryParameters'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/menu/items'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/menu/items'),
          ),
        ));

        expect(
          () => repository.searchItems('test'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getItemByBarcode', () {
      test('should return item when barcode is found', () async {
        when(mockDio.get(
          '/menu/items',
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': true,
            'data': [
              {
                'id': 1,
                'businessId': 1,
                'categoryId': 1,
                'name': 'Barcode Item',
                'description': 'Item with barcode',
                'price': 15.99,
                'cost': 7.00,
                'preparationTime': 5,
                'isAvailable': true,
                'isActive': true,
                'createdAt': '2025-07-10T01:00:00.000Z',
                'updatedAt': '2025-07-10T01:00:00.000Z',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/menu/items'),
        ));

        final result = await repository.getItemByBarcode('123456789');

        expect(result, isNotNull);
        expect(result!.name, 'Barcode Item');
        expect(result.price, 15.99);

        verify(mockDio.get(
          '/menu/items',
          queryParameters: {
            'barcode': '123456789',
            'isAvailable': true,
            'isActive': true,
          },
        )).called(1);
      });

      test('should return null when barcode not found', () async {
        when(mockDio.get(
          '/menu/items',
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': true,
            'data': [],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/menu/items'),
        ));

        final result = await repository.getItemByBarcode('nonexistent');

        expect(result, isNull);
      });
    });

    group('createSale', () {
      test('should create sale successfully', () async {
        final items = [
          CartItem(
            id: '1',
            name: 'Test Item',
            price: 10.99,
            quantity: 2,
          ),
        ];

        // Mock order creation
        when(mockDio.post('/orders', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: {
                    'success': true,
                    'data': {
                      'id': 1,
                      'businessId': 1,
                      'orderNumber': 'ORD-123',
                      'orderType': 'takeaway',
                      'status': 'pending',
                      'subtotal': 21.98,
                      'tax': 0.0,
                      'discount': 0.0,
                      'total': 21.98,
                      'createdAt': '2025-07-10T01:00:00.000Z',
                      'updatedAt': '2025-07-10T01:00:00.000Z',
                    }
                  },
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/orders'),
                ));

        // Mock order items creation
        when(mockDio.post('/orders/1/items', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: {'success': true},
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/orders/1/items'),
                ));

        // Mock sale creation with items
        when(mockDio.post('/api/sales/with-items', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: {
                    'success': true,
                    'data': {
                      'id': 1,
                      'total': 21.98,
                    }
                  },
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/api/sales/with-items'),
                ));

        // Mock auth state
        when(mockRef.read(any)).thenReturn(const AuthState(
          business: Business(
            id: 1,
            name: 'Demo',
            slug: 'demo',
            type: BusinessType.restaurant,
            taxRate: 0.0,
            currency: 'USD',
            timezone: 'UTC',
            isActive: true,
          ),
        ));

        final result = await repository.createSale(
          items: items,
          paymentMethod: PaymentMethod.cash,
          customerName: 'John Doe',
        );

        expect(result.id, '1');
        expect(result.total, 21.98);
        expect(result.customerName, 'John Doe');

        verify(mockDio.post('/api/sales/with-items', data: anyNamed('data'))).called(1);
      });

      test('should create sale with orderType in response', () async {
        final items = [
          CartItem(
            id: '1',
            name: 'Test Item',
            price: 10.99,
            quantity: 2,
          ),
        ];

        // Mock order creation with 'orderType' only
        when(mockDio.post('/orders', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: {
                    'success': true,
                    'data': {
                      'id': 1,
                      'businessId': 1,
                      'orderNumber': 'ORD-123',
                      'orderType': 'takeaway',
                      'status': 'pending',
                      'subtotal': 21.98,
                      'tax': 0.0,
                      'discount': 0.0,
                      'total': 21.98,
                      'createdAt': '2025-07-10T01:00:00.000Z',
                      'updatedAt': '2025-07-10T01:00:00.000Z',
                    }
                  },
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/orders'),
                ));

        // Mock order items creation
        when(mockDio.post('/orders/1/items', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: {'success': true},
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/orders/1/items'),
                ));

        // Mock sale creation with items
        when(mockDio.post('/api/sales/with-items', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: {
                    'success': true,
                    'data': {
                      'id': 1,
                      'total': 21.98,
                    }
                  },
                  statusCode: 201,
                  requestOptions: RequestOptions(path: '/api/sales/with-items'),
                ));

        // Mock auth state
        when(mockRef.read(any)).thenReturn(const AuthState(
          business: Business(
            id: 1,
            name: 'Demo',
            slug: 'demo',
            type: BusinessType.restaurant,
            taxRate: 0.0,
            currency: 'USD',
            timezone: 'UTC',
            isActive: true,
          ),
        ));

        final result = await repository.createSale(
          items: items,
          paymentMethod: PaymentMethod.cash,
          customerName: 'John Doe',
        );

        expect(result.id, '1');
        expect(result.total, 21.98);
        expect(result.customerName, 'John Doe');
      });
    });

    group('getRecentSales', () {
      test('should return recent sales', () async {
        when(mockDio.get(
          '/sales',
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': true,
            'data': [
              {
                'id': 1,
                'orderNumber': 'ORD-123',
                'total': 25.99,
                'paymentMethod': 'cash',
                'createdAt': '2025-07-10T01:00:00.000Z',
                'customerName': 'John Doe',
                'customerEmail': 'john@example.com',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/sales'),
        ));

        final result = await repository.getRecentSales(limit: 10);

        expect(result, hasLength(1));
        expect(result.first.id, '1');
        expect(result.first.total, 25.99);

        verify(mockDio.get(
          '/sales',
          queryParameters: {
            'limit': 10,
            'sort': 'createdAt',
            'order': 'desc',
          },
        )).called(1);
      });
    });
  });
} 