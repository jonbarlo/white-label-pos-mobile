import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_repository_impl.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/cart_item.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/sale.dart';

import 'pos_repository_impl_test.mocks.dart';

@GenerateMocks([Dio, SharedPreferences])
void main() {
  late MockDio mockDio;
  late MockSharedPreferences mockPrefs;
  late PosRepositoryImpl posRepository;

  setUp(() {
    mockDio = MockDio();
    mockPrefs = MockSharedPreferences();
    posRepository = PosRepositoryImpl(mockDio, mockPrefs);

    when(mockPrefs.getString('api_base_url')).thenReturn('http://localhost:3000/api');
    when(mockPrefs.getString('auth_token')).thenReturn('test_token');
  });

  group('PosRepositoryImpl', () {
    group('searchItems', () {
      test('returns items when API call succeeds', () async {
        final query = 'apple';
        final responseData = {
          'items': [
            {
              'id': '1',
              'name': 'Apple',
              'price': 1.99,
              'quantity': 1,
              'barcode': '123456789',
              'imageUrl': 'https://example.com/apple.jpg',
              'category': 'Fruits',
            },
            {
              'id': '2',
              'name': 'Apple Juice',
              'price': 2.99,
              'quantity': 1,
              'barcode': '987654321',
              'imageUrl': 'https://example.com/juice.jpg',
              'category': 'Beverages',
            },
          ]
        };

        when(mockDio.get(
          'http://localhost:3000/api/pos/items/search',
          queryParameters: {'q': query},
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        final result = await posRepository.searchItems(query);

        expect(result.length, 2);
        expect(result.first.name, 'Apple');
        expect(result.first.price, 1.99);
        expect(result.last.name, 'Apple Juice');
        expect(result.last.price, 2.99);
      });

      test('returns empty list when API returns no items', () async {
        final query = 'nonexistent';
        final responseData = {'items': []};

        when(mockDio.get(
          'http://localhost:3000/api/pos/items/search',
          queryParameters: {'q': query},
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        final result = await posRepository.searchItems(query);

        expect(result, isEmpty);
      });

      test('throws exception when API call fails', () async {
        final query = 'apple';

        when(mockDio.get(
          'http://localhost:3000/api/pos/items/search',
          queryParameters: {'q': query},
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        expect(
          () async => await posRepository.searchItems(query),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getItemByBarcode', () {
      test('returns item when barcode exists', () async {
        final barcode = '123456789';
        final responseData = {
          'item': {
            'id': '1',
            'name': 'Apple',
            'price': 1.99,
            'quantity': 1,
            'barcode': barcode,
          }
        };

        when(mockDio.get(
          'http://localhost:3000/api/pos/items/barcode/$barcode',
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        final result = await posRepository.getItemByBarcode(barcode);

        expect(result, isNotNull);
        expect(result!.name, 'Apple');
        expect(result.barcode, barcode);
      });

      test('returns null when barcode not found', () async {
        final barcode = '999999999';

        when(mockDio.get(
          'http://localhost:3000/api/pos/items/barcode/$barcode',
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        final result = await posRepository.getItemByBarcode(barcode);

        expect(result, isNull);
      });
    });

    group('createSale', () {
      test('creates sale successfully', () async {
        final items = [
          CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 2),
          CartItem(id: '2', name: 'Banana', price: 0.99, quantity: 1),
        ];
        final paymentMethod = PaymentMethod.cash;
        final responseData = {
          'sale': {
            'id': 'sale_123',
            'items': items.map((item) => item.toJson()).toList(),
            'total': 4.97,
            'paymentMethod': paymentMethod.name,
            'createdAt': DateTime.now().toIso8601String(),
          }
        };

        when(mockDio.post(
          'http://localhost:3000/api/pos/sales',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        ));

        final result = await posRepository.createSale(
          items: items,
          paymentMethod: paymentMethod,
        );

        expect(result.id, 'sale_123');
        expect(result.total, 4.97);
        expect(result.paymentMethod, PaymentMethod.cash);
        expect(result.items.length, 2);
      });

      test('throws exception when sale creation fails', () async {
        final items = [CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1)];
        final paymentMethod = PaymentMethod.card;

        when(mockDio.post(
          'http://localhost:3000/api/pos/sales',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        ));

        expect(
          () async => await posRepository.createSale(
            items: items,
            paymentMethod: paymentMethod,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getRecentSales', () {
      test('returns recent sales successfully', () async {
        final responseData = {
          'sales': [
            {
              'id': 'sale_1',
              'items': [
                {
                  'id': '1',
                  'name': 'Apple',
                  'price': 1.99,
                  'quantity': 1,
                }
              ],
              'total': 1.99,
              'paymentMethod': 'cash',
              'createdAt': DateTime.now().toIso8601String(),
            },
            {
              'id': 'sale_2',
              'items': [
                {
                  'id': '2',
                  'name': 'Banana',
                  'price': 0.99,
                  'quantity': 2,
                }
              ],
              'total': 1.98,
              'paymentMethod': 'card',
              'createdAt': DateTime.now().toIso8601String(),
            },
          ]
        };

        when(mockDio.get(
          'http://localhost:3000/api/pos/sales/recent',
          queryParameters: {'limit': 10},
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        final result = await posRepository.getRecentSales(limit: 10);

        expect(result.length, 2);
        expect(result.first.id, 'sale_1');
        expect(result.last.id, 'sale_2');
      });
    });
  });
} 