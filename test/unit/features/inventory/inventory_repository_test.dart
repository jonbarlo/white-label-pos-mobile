import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';

import 'inventory_repository_test.mocks.dart';

@GenerateMocks([InventoryRepository])
void main() {
  late MockInventoryRepository mockInventoryRepository;

  setUp(() {
    mockInventoryRepository = MockInventoryRepository();
  });

  group('InventoryRepository', () {
    group('getInventoryItems', () {
      test('returns success with list of inventory items', () async {
        final expectedItems = [
          InventoryItem(
            id: '1',
            name: 'Apple',
            sku: 'APP001',
            price: 1.99,
            cost: 1.50,
            stockQuantity: 100,
            category: 'Fruits',
            barcode: '123456789',
            imageUrl: 'https://example.com/apple.jpg',
            description: 'Fresh red apples',
            minStockLevel: 10,
            maxStockLevel: 200,
          ),
          InventoryItem(
            id: '2',
            name: 'Banana',
            sku: 'BAN001',
            price: 0.99,
            cost: 0.75,
            stockQuantity: 50,
            category: 'Fruits',
            barcode: '987654321',
            imageUrl: 'https://example.com/banana.jpg',
            description: 'Yellow bananas',
            minStockLevel: 5,
            maxStockLevel: 100,
          ),
        ];

        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success(expectedItems));

        final result = await mockInventoryRepository.getInventoryItems();

        expect(result.isSuccess, isTrue);
        expect(result.data, expectedItems);
        expect(result.data!.length, 2);
        expect(result.data!.first.name, 'Apple');
        expect(result.data!.last.name, 'Banana');
      });

      test('returns success with empty list when no items exist', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success([]));

        final result = await mockInventoryRepository.getInventoryItems();

        expect(result.isSuccess, isTrue);
        expect(result.data, isEmpty);
      });

      test('returns failure on network error', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.failure('Network error'));

        final result = await mockInventoryRepository.getInventoryItems();

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, 'Network error');
      });
    });

    group('getInventoryItem', () {
      test('returns success with item when id exists', () async {
        final expectedItem = InventoryItem(
          id: '1',
          name: 'Apple',
          sku: 'APP001',
          price: 1.99,
          cost: 1.50,
          stockQuantity: 100,
          category: 'Fruits',
          barcode: '123456789',
          imageUrl: 'https://example.com/apple.jpg',
          description: 'Fresh red apples',
          minStockLevel: 10,
          maxStockLevel: 200,
        );

        when(mockInventoryRepository.getInventoryItem('1'))
            .thenAnswer((_) async => Result.success(expectedItem));

        final result = await mockInventoryRepository.getInventoryItem('1');

        expect(result.isSuccess, isTrue);
        expect(result.data, expectedItem);
        expect(result.data!.name, 'Apple');
        expect(result.data!.sku, 'APP001');
      });

      test('returns failure when item not found', () async {
        when(mockInventoryRepository.getInventoryItem('999'))
            .thenAnswer((_) async => Result.failure('Item not found'));

        final result = await mockInventoryRepository.getInventoryItem('999');

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, 'Item not found');
      });
    });

    group('createInventoryItem', () {
      test('returns success with created item', () async {
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

        final createdItem = newItem.copyWith(id: '3');

        when(mockInventoryRepository.createInventoryItem(newItem))
            .thenAnswer((_) async => Result.success(createdItem));

        final result = await mockInventoryRepository.createInventoryItem(newItem);

        expect(result.isSuccess, isTrue);
        expect(result.data, createdItem);
        expect(result.data!.id, '3');
        expect(result.data!.name, 'Orange');
      });

      test('returns failure when creation fails', () async {
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

        when(mockInventoryRepository.createInventoryItem(newItem))
            .thenAnswer((_) async => Result.failure('Creation failed'));

        final result = await mockInventoryRepository.createInventoryItem(newItem);

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, 'Creation failed');
      });
    });

    group('updateInventoryItem', () {
      test('returns success with updated item', () async {
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

        when(mockInventoryRepository.updateInventoryItem(updatedItem))
            .thenAnswer((_) async => Result.success(updatedItem));

        final result = await mockInventoryRepository.updateInventoryItem(updatedItem);

        expect(result.isSuccess, isTrue);
        expect(result.data, updatedItem);
        expect(result.data!.name, 'Apple Updated');
        expect(result.data!.price, 2.49);
      });

      test('returns failure when update fails', () async {
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

        when(mockInventoryRepository.updateInventoryItem(updatedItem))
            .thenAnswer((_) async => Result.failure('Update failed'));

        final result = await mockInventoryRepository.updateInventoryItem(updatedItem);

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, 'Update failed');
      });
    });

    group('deleteInventoryItem', () {
      test('returns success when item is deleted', () async {
        when(mockInventoryRepository.deleteInventoryItem('1'))
            .thenAnswer((_) async => Result.success(true));

        final result = await mockInventoryRepository.deleteInventoryItem('1');

        expect(result.isSuccess, isTrue);
        expect(result.data, isTrue);
      });

      test('returns failure when deletion fails', () async {
        when(mockInventoryRepository.deleteInventoryItem('999'))
            .thenAnswer((_) async => Result.failure('Item not found'));

        final result = await mockInventoryRepository.deleteInventoryItem('999');

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, 'Item not found');
      });
    });

    group('updateStockLevel', () {
      test('returns success with updated item', () async {
        final updatedItem = InventoryItem(
          id: '1',
          name: 'Apple',
          sku: 'APP001',
          price: 1.99,
          cost: 1.50,
          stockQuantity: 90,
          category: 'Fruits',
          barcode: '123456789',
          imageUrl: 'https://example.com/apple.jpg',
          description: 'Fresh red apples',
          minStockLevel: 10,
          maxStockLevel: 200,
        );

        when(mockInventoryRepository.updateStockLevel('1', 90))
            .thenAnswer((_) async => Result.success(updatedItem));

        final result = await mockInventoryRepository.updateStockLevel('1', 90);

        expect(result.isSuccess, isTrue);
        expect(result.data, updatedItem);
        expect(result.data!.stockQuantity, 90);
      });

      test('returns failure when stock update fails', () async {
        when(mockInventoryRepository.updateStockLevel('999', 90))
            .thenAnswer((_) async => Result.failure('Item not found'));

        final result = await mockInventoryRepository.updateStockLevel('999', 90);

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, 'Item not found');
      });
    });

    group('getLowStockItems', () {
      test('returns success with low stock items', () async {
        final lowStockItems = [
          InventoryItem(
            id: '1',
            name: 'Apple',
            sku: 'APP001',
            price: 1.99,
            cost: 1.50,
            stockQuantity: 5,
            category: 'Fruits',
            barcode: '123456789',
            imageUrl: 'https://example.com/apple.jpg',
            description: 'Fresh red apples',
            minStockLevel: 10,
            maxStockLevel: 200,
          ),
        ];

        when(mockInventoryRepository.getLowStockItems())
            .thenAnswer((_) async => Result.success(lowStockItems));

        final result = await mockInventoryRepository.getLowStockItems();

        expect(result.isSuccess, isTrue);
        expect(result.data, lowStockItems);
        expect(result.data!.length, 1);
        expect(result.data!.first.stockQuantity, 5);
      });

      test('returns success with empty list when no low stock items', () async {
        when(mockInventoryRepository.getLowStockItems())
            .thenAnswer((_) async => Result.success([]));

        final result = await mockInventoryRepository.getLowStockItems();

        expect(result.isSuccess, isTrue);
        expect(result.data, isEmpty);
      });
    });

    group('getCategories', () {
      test('returns success with categories', () async {
        final categories = ['Fruits', 'Vegetables', 'Dairy', 'Meat'];

        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => Result.success(categories));

        final result = await mockInventoryRepository.getCategories();

        expect(result.isSuccess, isTrue);
        expect(result.data, categories);
        expect(result.data!.length, 4);
        expect(result.data!.contains('Fruits'), isTrue);
      });

      test('returns failure when categories cannot be loaded', () async {
        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => Result.failure('Failed to load categories'));

        final result = await mockInventoryRepository.getCategories();

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, 'Failed to load categories');
      });
    });

    group('searchItems', () {
      test('returns success with search results', () async {
        final searchResults = [
          InventoryItem(
            id: '1',
            name: 'Apple',
            sku: 'APP001',
            price: 1.99,
            cost: 1.50,
            stockQuantity: 100,
            category: 'Fruits',
            barcode: '123456789',
            imageUrl: 'https://example.com/apple.jpg',
            description: 'Fresh red apples',
            minStockLevel: 10,
            maxStockLevel: 200,
          ),
        ];

        when(mockInventoryRepository.searchItems('apple'))
            .thenAnswer((_) async => Result.success(searchResults));

        final result = await mockInventoryRepository.searchItems('apple');

        expect(result.isSuccess, isTrue);
        expect(result.data, searchResults);
        expect(result.data!.length, 1);
        expect(result.data!.first.name, 'Apple');
      });

      test('returns success with empty list when no search results', () async {
        when(mockInventoryRepository.searchItems('nonexistent'))
            .thenAnswer((_) async => Result.success([]));

        final result = await mockInventoryRepository.searchItems('nonexistent');

        expect(result.isSuccess, isTrue);
        expect(result.data, isEmpty);
      });
    });

    group('getItemsByCategory', () {
      test('returns success with items in category', () async {
        final categoryItems = [
          InventoryItem(
            id: '1',
            name: 'Apple',
            sku: 'APP001',
            price: 1.99,
            cost: 1.50,
            stockQuantity: 100,
            category: 'Fruits',
            barcode: '123456789',
            imageUrl: 'https://example.com/apple.jpg',
            description: 'Fresh red apples',
            minStockLevel: 10,
            maxStockLevel: 200,
          ),
        ];

        when(mockInventoryRepository.getItemsByCategory('Fruits'))
            .thenAnswer((_) async => Result.success(categoryItems));

        final result = await mockInventoryRepository.getItemsByCategory('Fruits');

        expect(result.isSuccess, isTrue);
        expect(result.data, categoryItems);
        expect(result.data!.length, 1);
        expect(result.data!.first.category, 'Fruits');
      });

      test('returns success with empty list when no items in category', () async {
        when(mockInventoryRepository.getItemsByCategory('Nonexistent'))
            .thenAnswer((_) async => Result.success([]));

        final result = await mockInventoryRepository.getItemsByCategory('Nonexistent');

        expect(result.isSuccess, isTrue);
        expect(result.data, isEmpty);
      });
    });
  });
} 