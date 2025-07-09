import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository_impl.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/shared/models/api_response.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';

import 'inventory_repository_test.mocks.dart';

@GenerateMocks([Dio, SharedPreferences])
void main() {
  group('InventoryRepositoryImpl', () {
    late InventoryRepositoryImpl repository;
    late MockDio mockDio;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockDio = MockDio();
      mockPrefs = MockSharedPreferences();
      repository = InventoryRepositoryImpl(mockDio, mockPrefs);
    });

    group('getInventoryItems', () {
      test('should return success with inventory items', () async {
        // Arrange
        final mockItems = [
          {
            'id': '1',
            'name': 'Test Item 1',
            'sku': 'SKU001',
            'price': 10.0,
            'cost': 5.0,
            'stockQuantity': 100,
            'category': 'Electronics',
            'minStockLevel': 10,
            'maxStockLevel': 200,
            'createdAt': '2023-01-01T00:00:00Z',
            'updatedAt': '2023-01-01T00:00:00Z',
          },
          {
            'id': '2',
            'name': 'Test Item 2',
            'sku': 'SKU002',
            'price': 20.0,
            'cost': 10.0,
            'stockQuantity': 50,
            'category': 'Clothing',
            'minStockLevel': 5,
            'maxStockLevel': 100,
            'createdAt': '2023-01-01T00:00:00Z',
            'updatedAt': '2023-01-01T00:00:00Z',
          },
        ];

        final apiResponse = ApiResponse<List<dynamic>>(
          success: true,
          message: 'Success',
          data: mockItems,
        );

        when(mockDio.get('/inventory/items')).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson((items) => items),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/items'),
          ),
        );

        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        // Act
        final result = await repository.getInventoryItems();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, hasLength(2));
        expect(result.data.first.name, 'Test Item 1');
        expect(result.data.last.name, 'Test Item 2');
      });

      test('should return failure on network error', () async {
        // Arrange
        when(mockDio.get('/inventory/items')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/inventory/items'),
            type: DioExceptionType.connectionError,
          ),
        );

        when(mockPrefs.getString(any)).thenReturn(null);

        // Act
        final result = await repository.getInventoryItems();

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, isNotNull);
      });
    });

    group('getInventoryItem', () {
      test('should return success with inventory item', () async {
        // Arrange
        final mockItem = {
          'id': '1',
          'name': 'Test Item',
          'sku': 'SKU001',
          'price': 10.0,
          'cost': 5.0,
          'stockQuantity': 100,
          'category': 'Electronics',
          'minStockLevel': 10,
          'maxStockLevel': 200,
          'createdAt': '2023-01-01T00:00:00Z',
          'updatedAt': '2023-01-01T00:00:00Z',
        };

        final apiResponse = ApiResponse<Map<String, dynamic>>(
          success: true,
          message: 'Success',
          data: mockItem,
        );

        when(mockDio.get('/inventory/items/1')).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson((item) => item),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/items/1'),
          ),
        );

        // Act
        final result = await repository.getInventoryItem('1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data.name, 'Test Item');
        expect(result.data.sku, 'SKU001');
      });

      test('should return failure on not found', () async {
        // Arrange
        when(mockDio.get('/inventory/items/999')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/inventory/items/999'),
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/inventory/items/999'),
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act
        final result = await repository.getInventoryItem('999');

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, isNotNull);
      });
    });

    group('createInventoryItem', () {
      test('should return success with created item', () async {
        // Arrange
        final item = InventoryItem(
          id: '1',
          name: 'New Item',
          sku: 'SKU001',
          price: 10.0,
          cost: 5.0,
          stockQuantity: 100,
          category: 'Electronics',
          minStockLevel: 10,
          maxStockLevel: 200,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final mockResponse = {
          'id': '1',
          'name': 'New Item',
          'sku': 'SKU001',
          'price': 10.0,
          'cost': 5.0,
          'stockQuantity': 100,
          'category': 'Electronics',
          'minStockLevel': 10,
          'maxStockLevel': 200,
          'createdAt': '2023-01-01T00:00:00Z',
          'updatedAt': '2023-01-01T00:00:00Z',
        };

        final apiResponse = ApiResponse<Map<String, dynamic>>(
          success: true,
          message: 'Success',
          data: mockResponse,
        );

        when(mockDio.post('/inventory/items', data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson((item) => item),
            statusCode: 201,
            requestOptions: RequestOptions(path: '/inventory/items'),
          ),
        );

        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        // Act
        final result = await repository.createInventoryItem(item);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data.name, 'New Item');
      });
    });

    group('updateInventoryItem', () {
      test('should return success with updated item', () async {
        // Arrange
        final item = InventoryItem(
          id: '1',
          name: 'Updated Item',
          sku: 'SKU001',
          price: 15.0,
          cost: 7.0,
          stockQuantity: 80,
          category: 'Electronics',
          minStockLevel: 10,
          maxStockLevel: 200,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final mockResponse = {
          'id': '1',
          'name': 'Updated Item',
          'sku': 'SKU001',
          'price': 15.0,
          'cost': 7.0,
          'stockQuantity': 80,
          'category': 'Electronics',
          'minStockLevel': 10,
          'maxStockLevel': 200,
          'createdAt': '2023-01-01T00:00:00Z',
          'updatedAt': '2023-01-01T00:00:00Z',
        };

        final apiResponse = ApiResponse<Map<String, dynamic>>(
          success: true,
          message: 'Success',
          data: mockResponse,
        );

        when(mockDio.put('/inventory/items/1', data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/items/1'),
          ),
        );

        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        // Act
        final result = await repository.updateInventoryItem(item);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data.name, 'Updated Item');
        expect(result.data.price, 15.0);
      });
    });

    group('deleteInventoryItem', () {
      test('should return success when item is deleted', () async {
        // Arrange
        when(mockDio.delete('/inventory/items/1')).thenAnswer(
          (_) async => Response(
            statusCode: 204,
            requestOptions: RequestOptions(path: '/inventory/items/1'),
          ),
        );

        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        // Act
        final result = await repository.deleteInventoryItem('1');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, isTrue);
      });

      test('should return success false when item not found', () async {
        // Arrange
        when(mockDio.delete('/inventory/items/999')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/inventory/items/999'),
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/inventory/items/999'),
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act
        final result = await repository.deleteInventoryItem('999');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, isFalse);
      });
    });

    group('updateStockLevel', () {
      test('should return success with updated item', () async {
        // Arrange
        final mockResponse = {
          'id': '1',
          'name': 'Test Item',
          'sku': 'SKU001',
          'price': 10.0,
          'cost': 5.0,
          'stockQuantity': 150,
          'category': 'Electronics',
          'minStockLevel': 10,
          'maxStockLevel': 200,
          'createdAt': '2023-01-01T00:00:00Z',
          'updatedAt': '2023-01-01T00:00:00Z',
        };

        final apiResponse = ApiResponse<Map<String, dynamic>>(
          success: true,
          message: 'Success',
          data: mockResponse,
        );

        when(mockDio.patch('/inventory/items/1/stock', data: anyNamed('data'))).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/items/1/stock'),
          ),
        );

        when(mockPrefs.getString(any)).thenReturn('[]');
        when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

        // Act
        final result = await repository.updateStockLevel('1', 150);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data.stockQuantity, 150);
      });
    });

    group('getLowStockItems', () {
      test('should return success with low stock items', () async {
        // Arrange
        final mockItems = [
          {
            'id': '1',
            'name': 'Low Stock Item',
            'sku': 'SKU001',
            'price': 10.0,
            'cost': 5.0,
            'stockQuantity': 5,
            'category': 'Electronics',
            'minStockLevel': 10,
            'maxStockLevel': 200,
            'createdAt': '2023-01-01T00:00:00Z',
            'updatedAt': '2023-01-01T00:00:00Z',
          },
        ];

        final apiResponse = ApiResponse<List<dynamic>>(
          success: true,
          message: 'Success',
          data: mockItems,
        );

        when(mockDio.get('/inventory/items/low-stock')).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/items/low-stock'),
          ),
        );

        // Act
        final result = await repository.getLowStockItems();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, hasLength(1));
        expect(result.data.first.name, 'Low Stock Item');
        expect(result.data.first.isLowStock, isTrue);
      });
    });

    group('getCategories', () {
      test('should return success with categories', () async {
        // Arrange
        final mockCategories = ['Electronics', 'Clothing', 'Food'];

        final apiResponse = ApiResponse<List<dynamic>>(
          success: true,
          message: 'Success',
          data: mockCategories,
        );

        when(mockDio.get('/inventory/categories')).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/categories'),
          ),
        );

        when(mockPrefs.setStringList(any, any)).thenAnswer((_) async => true);

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, hasLength(3));
        expect(result.data, contains('Electronics'));
        expect(result.data, contains('Clothing'));
        expect(result.data, contains('Food'));
      });
    });

    group('searchItems', () {
      test('should return success with search results', () async {
        // Arrange
        final mockItems = [
          {
            'id': '1',
            'name': 'Test Item',
            'sku': 'SKU001',
            'price': 10.0,
            'cost': 5.0,
            'stockQuantity': 100,
            'category': 'Electronics',
            'minStockLevel': 10,
            'maxStockLevel': 200,
            'createdAt': '2023-01-01T00:00:00Z',
            'updatedAt': '2023-01-01T00:00:00Z',
          },
        ];

        final apiResponse = ApiResponse<List<dynamic>>(
          success: true,
          message: 'Success',
          data: mockItems,
        );

        when(mockDio.get('/inventory/items/search', queryParameters: anyNamed('queryParameters'))).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/items/search'),
          ),
        );

        // Act
        final result = await repository.searchItems('Test');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, hasLength(1));
        expect(result.data.first.name, 'Test Item');
      });
    });

    group('getItemsByCategory', () {
      test('should return success with category items', () async {
        // Arrange
        final mockItems = [
          {
            'id': '1',
            'name': 'Electronics Item',
            'sku': 'SKU001',
            'price': 10.0,
            'cost': 5.0,
            'stockQuantity': 100,
            'category': 'Electronics',
            'minStockLevel': 10,
            'maxStockLevel': 200,
            'createdAt': '2023-01-01T00:00:00Z',
            'updatedAt': '2023-01-01T00:00:00Z',
          },
        ];

        final apiResponse = ApiResponse<List<dynamic>>(
          success: true,
          message: 'Success',
          data: mockItems,
        );

        when(mockDio.get('/inventory/items', queryParameters: anyNamed('queryParameters'))).thenAnswer(
          (_) async => Response(
            data: apiResponse.toJson(),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/inventory/items'),
          ),
        );

        // Act
        final result = await repository.getItemsByCategory('Electronics');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, hasLength(1));
        expect(result.data.first.category, 'Electronics');
      });
    });
  });
} 