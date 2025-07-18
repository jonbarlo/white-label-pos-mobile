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
    repository = InventoryRepositoryImpl(mockDio);
  });

  group('InventoryRepositoryImpl', () {
    group('getInventoryItems', () {
      test('returns list of inventory items on success', () async {
        final responseData = {
          'success': true,
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stock': 100, // API uses 'stock' field
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
          requestOptions: RequestOptions(path: '/items'),
        );

        when(mockDio.get('/items'))
            .thenAnswer((_) async => response);

        final result = await repository.getInventoryItems();

        expect(result.isSuccess, isTrue);
        expect(result.data.length, 1);
        expect(result.data.first.name, 'Apple');
        expect(result.data.first.sku, 'APP001');
        expect(result.data.first.stockQuantity, 100); // Should be mapped from 'stock'
        verify(mockDio.get('/items')).called(1);
      });

      test('returns empty list when no items exist', () async {
        final responseData = {
          'success': true,
          'data': <dynamic>[]
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/items'),
        );

        when(mockDio.get('/items'))
            .thenAnswer((_) async => response);

        final result = await repository.getInventoryItems();

        expect(result.isSuccess, isTrue);
        expect(result.data, isEmpty);
      });

      test('returns failure on network error', () async {
        when(mockDio.get('/items'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/items'),
              response: Response(
                statusCode: 500,
                requestOptions: RequestOptions(path: '/items'),
              ),
            ));

        final result = await repository.getInventoryItems();

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, isNotEmpty);
      });
    });

    group('getInventoryItem', () {
      test('returns item when id exists', () async {
        final responseData = {
          'success': true,
          'data': {
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
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/items/1'),
        );

        when(mockDio.get('/items/1'))
            .thenAnswer((_) async => response);

        final result = await repository.getInventoryItem('1');

        expect(result.isSuccess, isTrue);
        expect(result.data.name, 'Apple');
        expect(result.data.sku, 'APP001');
        verify(mockDio.get('/items/1')).called(1);
      });

      test('returns failure when item not found', () async {
        when(mockDio.get('/items/999'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/items/999'),
              response: Response(
                statusCode: 404,
                requestOptions: RequestOptions(path: '/items/999'),
              ),
            ));

        final result = await repository.getInventoryItem('999');

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, isNotEmpty);
      });
    });

    group('createInventoryItem', () {
      test('creates item successfully', () async {
        const newItem = InventoryItem(
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
          'success': true,
          'data': {
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
          }
        };

        final response = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/items'),
        );

        when(mockDio.post('/items', data: anyNamed('data')))
            .thenAnswer((_) async => response);

        final result = await repository.createInventoryItem(newItem);

        expect(result.isSuccess, isTrue);
        expect(result.data.id, '3');
        expect(result.data.name, 'Orange');
        verify(mockDio.post('/items', data: anyNamed('data'))).called(1);
      });
    });

    group('updateInventoryItem', () {
      test('updates item successfully', () async {
        const updatedItem = InventoryItem(
          id: '1',
          name: 'Apple Updated',
          sku: 'APP001',
          price: 2.99,
          cost: 2.00,
          stockQuantity: 150,
          category: 'Fruits',
          barcode: '123456789',
          imageUrl: 'https://example.com/apple.jpg',
          description: 'Fresh red apples updated',
          minStockLevel: 15,
          maxStockLevel: 250,
        );

        final responseData = {
          'success': true,
          'data': {
            'id': '1',
            'name': 'Apple Updated',
            'sku': 'APP001',
            'price': 2.99,
            'cost': 2.00,
            'stockQuantity': 150,
            'category': 'Fruits',
            'barcode': '123456789',
            'imageUrl': 'https://example.com/apple.jpg',
            'description': 'Fresh red apples updated',
            'minStockLevel': 15,
            'maxStockLevel': 250,
          }
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/items/1'),
        );

        when(mockDio.put('/items/1', data: anyNamed('data')))
            .thenAnswer((_) async => response);

        final result = await repository.updateInventoryItem(updatedItem);

        expect(result.isSuccess, isTrue);
        expect(result.data.name, 'Apple Updated');
        expect(result.data.price, 2.99);
        verify(mockDio.put('/items/1', data: anyNamed('data'))).called(1);
      });
    });

    group('deleteInventoryItem', () {
      test('deletes item successfully', () async {
        when(mockDio.delete('/items/1'))
            .thenAnswer((_) async => Response(
              statusCode: 204,
              requestOptions: RequestOptions(path: '/items/1'),
            ));

        final result = await repository.deleteInventoryItem('1');

        expect(result.isSuccess, isTrue);
        expect(result.data, isTrue);
        verify(mockDio.delete('/items/1')).called(1);
      });
    });

    group('updateStockLevel', () {
      test('updates stock level successfully', () async {
        final responseData = {
          'success': true,
          'data': {
            'id': '1',
            'name': 'Apple',
            'sku': 'APP001',
            'price': 1.99,
            'cost': 1.50,
            'stockQuantity': 200,
            'category': 'Fruits',
            'barcode': '123456789',
            'imageUrl': 'https://example.com/apple.jpg',
            'description': 'Fresh red apples',
            'minStockLevel': 10,
            'maxStockLevel': 200,
          }
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/items/1/stock'),
        );

        when(mockDio.patch('/items/1/stock', data: anyNamed('data')))
            .thenAnswer((_) async => response);

        final result = await repository.updateStockLevel('1', 200);

        expect(result.isSuccess, isTrue);
        expect(result.data.stockQuantity, 200);
        verify(mockDio.patch('/items/1/stock', data: anyNamed('data'))).called(1);
      });
    });

    group('searchItems', () {
      test('returns search results', () async {
        final responseData = {
          'success': true,
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stock': 100, // API uses 'stock' field
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
          requestOptions: RequestOptions(path: '/items/search'),
        );

        when(mockDio.get('/items/search', queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => response);

        final result = await repository.searchItems('apple');

        expect(result.isSuccess, isTrue);
        expect(result.data.length, 1);
        expect(result.data.first.name, 'Apple');
        expect(result.data.first.stockQuantity, 100); // Should be mapped from 'stock'
        verify(mockDio.get('/items/search', queryParameters: anyNamed('queryParameters'))).called(1);
      });
    });

    group('getCategories', () {
      test('returns categories successfully', () async {
        final responseData = {
          'success': true,
          'data': [
            {
              'id': 1,
              'businessId': 1,
              'name': 'Fruits',
              'description': 'Fresh fruits',
              'displayOrder': 1,
              'isActive': true,
              'imageUrl': null,
              'colorCode': null,
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T00:00:00.000Z',
            },
            {
              'id': 2,
              'businessId': 1,
              'name': 'Vegetables',
              'description': 'Fresh vegetables',
              'displayOrder': 2,
              'isActive': true,
              'imageUrl': null,
              'colorCode': null,
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T00:00:00.000Z',
            },
            {
              'id': 3,
              'businessId': 1,
              'name': 'Dairy',
              'description': 'Dairy products',
              'displayOrder': 3,
              'isActive': true,
              'imageUrl': null,
              'colorCode': null,
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T00:00:00.000Z',
            },
            {
              'id': 4,
              'businessId': 1,
              'name': 'Meat',
              'description': 'Fresh meat',
              'displayOrder': 4,
              'isActive': true,
              'imageUrl': null,
              'colorCode': null,
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T00:00:00.000Z',
            },
          ]
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/menu/categories'),
        );

        when(mockDio.get('/menu/categories', queryParameters: anyNamed('queryParameters')))
            .thenAnswer((_) async => response);

        final result = await repository.getCategories(businessId: 1);

        expect(result.isSuccess, isTrue);
        expect(result.data.length, 4);
        expect(result.data.any((c) => c.name == 'Fruits'), isTrue);
        verify(mockDio.get('/menu/categories', queryParameters: anyNamed('queryParameters'))).called(1);
      });
    });

    group('getItemsByCategory', () {
      test('returns items by category', () async {
        final responseData = {
          'success': true,
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stock': 100, // API uses 'stock' field
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
          requestOptions: RequestOptions(path: '/items/category/Fruits'),
        );

        when(mockDio.get('/items/category/Fruits'))
            .thenAnswer((_) async => response);

        final result = await repository.getItemsByCategory('Fruits');

        expect(result.isSuccess, isTrue);
        expect(result.data.length, 1);
        expect(result.data.first.category, 'Fruits');
        expect(result.data.first.stockQuantity, 100); // Should be mapped from 'stock'
        verify(mockDio.get('/items/category/Fruits')).called(1);
      });
    });

    group('getLowStockItems', () {
      test('returns low stock items', () async {
        final responseData = {
          'success': true,
          'data': [
            {
              'id': '1',
              'name': 'Apple',
              'sku': 'APP001',
              'price': 1.99,
              'cost': 1.50,
              'stock': 5, // API uses 'stock' field
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
          requestOptions: RequestOptions(path: '/items/low-stock'),
        );

        when(mockDio.get('/items/low-stock'))
            .thenAnswer((_) async => response);

        final result = await repository.getLowStockItems();

        expect(result.isSuccess, isTrue);
        expect(result.data.length, 1);
        expect(result.data.first.stockQuantity, 5); // Should be mapped from 'stock'
        verify(mockDio.get('/items/low-stock')).called(1);
      });
    });
  });
} 