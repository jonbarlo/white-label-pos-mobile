import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository_impl.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';

import 'inventory_repository_impl_test.mocks.dart';

@GenerateMocks([Dio, SharedPreferences])
void main() {
  late InventoryRepositoryImpl repository;
  late MockDio mockDio;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockDio = MockDio();
    mockPrefs = MockSharedPreferences();
    repository = InventoryRepositoryImpl(mockDio, mockPrefs);
  });

  group('InventoryRepositoryImpl', () {
    group('getInventoryItems', () {
      test('returns list of inventory items on success', () async {
        final responseData = {
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stockQuantity': 100,
              'category': 'Fruits',
              'barcode': '123456789',
              'imageUrl': 'https://example.com/apple.jpg',
              'description': 'Fresh red apples',
              'minStockLevel': 10,
              'maxStockLevel': 200,
            }
          ]
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items'),
        );

        when(mockDio.get('/inventory/items'))
            .thenAnswer((_) async => response);
        when(mockPrefs.setString(any, any))
            .thenAnswer((_) async => true);

        final result = await repository.getInventoryItems();

        expect(result.length, 1);
        expect(result.first.name, 'Apple');
        expect(result.first.sku, 'APP001');
        verify(mockDio.get('/inventory/items')).called(1);
      });

      test('returns empty list when no items exist', () async {
        final responseData = {'data': []};

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items'),
        );

        when(mockDio.get('/inventory/items'))
            .thenAnswer((_) async => response);
        when(mockPrefs.setString(any, any))
            .thenAnswer((_) async => true);

        final result = await repository.getInventoryItems();

        expect(result, isEmpty);
      });

      test('throws exception on network error', () async {
        when(mockDio.get('/inventory/items'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/inventory/items'),
              response: Response(
                statusCode: 500,
                requestOptions: RequestOptions(path: '/inventory/items'),
              ),
            ));
        when(mockPrefs.getString(any)).thenReturn(null);

        expect(
          () async => await repository.getInventoryItems(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getInventoryItem', () {
      test('returns item when id exists', () async {
        final responseData = {
          'id': '1',
          'name': 'Apple',
          'sku': 'APP001',
          'price': 1.99,
          'cost': 1.50,
          'stockQuantity': 100,
          'category': 'Fruits',
          'barcode': '123456789',
          'imageUrl': 'https://example.com/apple.jpg',
          'description': 'Fresh red apples',
          'minStockLevel': 10,
          'maxStockLevel': 200,
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items/1'),
        );

        when(mockDio.get('/inventory/items/1'))
            .thenAnswer((_) async => response);

        final result = await repository.getInventoryItem('1');

        expect(result.name, 'Apple');
        expect(result.sku, 'APP001');
        verify(mockDio.get('/inventory/items/1')).called(1);
      });

      test('throws exception when item not found', () async {
        when(mockDio.get('/inventory/items/999'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/inventory/items/999'),
              response: Response(
                statusCode: 404,
                requestOptions: RequestOptions(path: '/inventory/items/999'),
              ),
            ));

        expect(
          () async => await repository.getInventoryItem('999'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('createInventoryItem', () {
      test('creates item successfully', () async {
        final newItem = InventoryItem(
          id: '',
          name: 'Orange',
          sku: 'ORA001',
          price: 1.49,
          cost: 1.20,
          stockQuantity: 75,
          category: 'Fruits',
          barcode: '555666777',
          imageUrl: 'https://example.com/orange.jpg',
          description: 'Fresh oranges',
          minStockLevel: 8,
          maxStockLevel: 150,
        );

        final responseData = {
          'id': '3',
          'name': 'Orange',
          'sku': 'ORA001',
          'price': 1.49,
          'cost': 1.20,
          'stockQuantity': 75,
          'category': 'Fruits',
          'barcode': '555666777',
          'imageUrl': 'https://example.com/orange.jpg',
          'description': 'Fresh oranges',
          'minStockLevel': 8,
          'maxStockLevel': 150,
        };

        final response = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/inventory/items'),
        );

        when(mockDio.post('/inventory/items', data: anyNamed('data')))
            .thenAnswer((_) async => response);
        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any))
            .thenAnswer((_) async => true);

        final result = await repository.createInventoryItem(newItem);

        expect(result.id, '3');
        expect(result.name, 'Orange');
        verify(mockDio.post('/inventory/items', data: anyNamed('data'))).called(1);
      });

      test('throws exception when creation fails', () async {
        final newItem = InventoryItem(
          id: '',
          name: 'Orange',
          sku: 'ORA001',
          price: 1.49,
          cost: 1.20,
          stockQuantity: 75,
          category: 'Fruits',
          barcode: '555666777',
          imageUrl: 'https://example.com/orange.jpg',
          description: 'Fresh oranges',
          minStockLevel: 8,
          maxStockLevel: 150,
        );

        when(mockDio.post('/inventory/items', data: anyNamed('data')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/inventory/items'),
              response: Response(
                statusCode: 400,
                requestOptions: RequestOptions(path: '/inventory/items'),
              ),
            ));

        expect(
          () async => await repository.createInventoryItem(newItem),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateInventoryItem', () {
      test('updates item successfully', () async {
        final updatedItem = InventoryItem(
          id: '1',
          name: 'Apple Updated',
          sku: 'APP001',
          price: 2.49,
          cost: 1.80,
          stockQuantity: 80,
          category: 'Fruits',
          barcode: '123456789',
          imageUrl: 'https://example.com/apple.jpg',
          description: 'Updated description',
          minStockLevel: 15,
          maxStockLevel: 250,
        );

        final responseData = {
          'id': '1',
          'name': 'Apple Updated',
          'sku': 'APP001',
          'price': 2.49,
          'cost': 1.80,
          'stockQuantity': 80,
          'category': 'Fruits',
          'barcode': '123456789',
          'imageUrl': 'https://example.com/apple.jpg',
          'description': 'Updated description',
          'minStockLevel': 15,
          'maxStockLevel': 250,
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items/1'),
        );

        when(mockDio.put('/inventory/items/1', data: anyNamed('data')))
            .thenAnswer((_) async => response);
        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any))
            .thenAnswer((_) async => true);

        final result = await repository.updateInventoryItem(updatedItem);

        expect(result.name, 'Apple Updated');
        expect(result.price, 2.49);
        verify(mockDio.put('/inventory/items/1', data: anyNamed('data'))).called(1);
      });
    });

    group('deleteInventoryItem', () {
      test('deletes item successfully', () async {
        when(mockDio.delete('/inventory/items/1'))
            .thenAnswer((_) async => Response(
                  statusCode: 204,
                  requestOptions: RequestOptions(path: '/inventory/items/1'),
                ));
        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any))
            .thenAnswer((_) async => true);

        final result = await repository.deleteInventoryItem('1');

        expect(result, isTrue);
        verify(mockDio.delete('/inventory/items/1')).called(1);
      });

      test('returns false when item not found', () async {
        when(mockDio.delete('/inventory/items/999'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/inventory/items/999'),
              response: Response(
                statusCode: 404,
                requestOptions: RequestOptions(path: '/inventory/items/999'),
              ),
            ));

        final result = await repository.deleteInventoryItem('999');

        expect(result, isFalse);
      });
    });

    group('updateStockLevel', () {
      test('updates stock level successfully', () async {
        final responseData = {
          'id': '1',
          'name': 'Apple',
          'sku': 'APP001',
          'price': 1.99,
          'cost': 1.50,
          'stockQuantity': 90,
          'category': 'Fruits',
          'barcode': '123456789',
          'imageUrl': 'https://example.com/apple.jpg',
          'description': 'Fresh red apples',
          'minStockLevel': 10,
          'maxStockLevel': 200,
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items/1/stock'),
        );

        when(mockDio.patch('/inventory/items/1/stock', data: anyNamed('data')))
            .thenAnswer((_) async => response);
        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any))
            .thenAnswer((_) async => true);

        final result = await repository.updateStockLevel('1', 90);

        expect(result.stockQuantity, 90);
        verify(mockDio.patch('/inventory/items/1/stock', data: anyNamed('data'))).called(1);
      });
    });

    group('getLowStockItems', () {
      test('returns items with low stock', () async {
        final responseData = {
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stockQuantity': 5,
              'category': 'Fruits',
              'barcode': '123456789',
              'imageUrl': 'https://example.com/apple.jpg',
              'description': 'Fresh red apples',
              'minStockLevel': 10,
              'maxStockLevel': 200,
            }
          ]
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items/low-stock'),
        );

        when(mockDio.get('/inventory/items/low-stock'))
            .thenAnswer((_) async => response);

        final result = await repository.getLowStockItems();

        expect(result.length, 1);
        expect(result.first.stockQuantity, 5);
        verify(mockDio.get('/inventory/items/low-stock')).called(1);
      });
    });

    group('getCategories', () {
      test('returns list of categories', () async {
        final responseData = {
          'data': ['Fruits', 'Vegetables', 'Dairy', 'Beverages']
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/categories'),
        );

        when(mockDio.get('/inventory/categories'))
            .thenAnswer((_) async => response);
        when(mockPrefs.setStringList(any, any))
            .thenAnswer((_) async => true);

        final result = await repository.getCategories();

        expect(result.length, 4);
        expect(result.contains('Fruits'), isTrue);
        verify(mockDio.get('/inventory/categories')).called(1);
      });
    });

    group('searchItems', () {
      test('returns search results', () async {
        final responseData = {
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stockQuantity': 100,
              'category': 'Fruits',
              'barcode': '123456789',
              'imageUrl': 'https://example.com/apple.jpg',
              'description': 'Fresh red apples',
              'minStockLevel': 10,
              'maxStockLevel': 200,
            }
          ]
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items/search'),
        );

        when(mockDio.get('/inventory/items/search', queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => response);

        final result = await repository.searchItems('apple');

        expect(result.length, 1);
        expect(result.first.name, 'Apple');
        verify(mockDio.get('/inventory/items/search', queryParameters: anyNamed('queryParameters'))).called(1);
      });
    });

    group('getItemsByCategory', () {
      test('returns items by category', () async {
        final responseData = {
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stockQuantity': 100,
              'category': 'Fruits',
              'barcode': '123456789',
              'imageUrl': 'https://example.com/apple.jpg',
              'description': 'Fresh red apples',
              'minStockLevel': 10,
              'maxStockLevel': 200,
            }
          ]
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/inventory/items'),
        );

        when(mockDio.get('/inventory/items', queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => response);

        final result = await repository.getItemsByCategory('Fruits');

        expect(result.length, 1);
        expect(result.first.category, 'Fruits');
        verify(mockDio.get('/inventory/items', queryParameters: anyNamed('queryParameters'))).called(1);
      });
    });
  });
} 