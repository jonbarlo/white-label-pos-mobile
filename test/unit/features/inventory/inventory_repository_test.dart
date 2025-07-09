import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';

import 'inventory_repository_test.mocks.dart';

@GenerateMocks([InventoryRepository])
void main() {
  late MockInventoryRepository mockInventoryRepository;

  setUp(() {
    mockInventoryRepository = MockInventoryRepository();
  });

  group('InventoryRepository', () {
    group('getInventoryItems', () {
      test('returns list of inventory items', () async {
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
            .thenAnswer((_) async => expectedItems);

        final result = await mockInventoryRepository.getInventoryItems();

        expect(result, expectedItems);
        expect(result.length, 2);
        expect(result.first.name, 'Apple');
        expect(result.last.name, 'Banana');
      });

      test('returns empty list when no items exist', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => []);

        final result = await mockInventoryRepository.getInventoryItems();

        expect(result, isEmpty);
      });

      test('throws exception on network error', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenThrow(Exception('Network error'));

        expect(
          () async => await mockInventoryRepository.getInventoryItems(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getInventoryItem', () {
      test('returns item when id exists', () async {
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
            .thenAnswer((_) async => expectedItem);

        final result = await mockInventoryRepository.getInventoryItem('1');

        expect(result, expectedItem);
        expect(result.name, 'Apple');
        expect(result.sku, 'APP001');
      });

      test('throws exception when item not found', () async {
        when(mockInventoryRepository.getInventoryItem('999'))
            .thenThrow(Exception('Item not found'));

        expect(
          () async => await mockInventoryRepository.getInventoryItem('999'),
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

        final createdItem = newItem.copyWith(id: '3');

        when(mockInventoryRepository.createInventoryItem(newItem))
            .thenAnswer((_) async => createdItem);

        final result = await mockInventoryRepository.createInventoryItem(newItem);

        expect(result, createdItem);
        expect(result.id, '3');
        expect(result.name, 'Orange');
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

        when(mockInventoryRepository.createInventoryItem(newItem))
            .thenThrow(Exception('Creation failed'));

        expect(
          () async => await mockInventoryRepository.createInventoryItem(newItem),
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

        when(mockInventoryRepository.updateInventoryItem(updatedItem))
            .thenAnswer((_) async => updatedItem);

        final result = await mockInventoryRepository.updateInventoryItem(updatedItem);

        expect(result, updatedItem);
        expect(result.name, 'Apple Updated');
        expect(result.price, 2.49);
      });

      test('throws exception when update fails', () async {
        final updatedItem = InventoryItem(
          id: '999',
          name: 'Non-existent Item',
          sku: 'NON001',
          price: 1.00,
          cost: 0.80,
          stockQuantity: 10,
          category: 'Test',
          barcode: '000000000',
          imageUrl: 'https://example.com/test.jpg',
          description: 'Test item',
          minStockLevel: 1,
          maxStockLevel: 20,
        );

        when(mockInventoryRepository.updateInventoryItem(updatedItem))
            .thenThrow(Exception('Update failed'));

        expect(
          () async => await mockInventoryRepository.updateInventoryItem(updatedItem),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteInventoryItem', () {
      test('deletes item successfully', () async {
        when(mockInventoryRepository.deleteInventoryItem('1'))
            .thenAnswer((_) async => true);

        final result = await mockInventoryRepository.deleteInventoryItem('1');

        expect(result, isTrue);
      });

      test('returns false when item not found', () async {
        when(mockInventoryRepository.deleteInventoryItem('999'))
            .thenAnswer((_) async => false);

        final result = await mockInventoryRepository.deleteInventoryItem('999');

        expect(result, isFalse);
      });
    });

    group('updateStockLevel', () {
      test('updates stock level successfully', () async {
        final updatedItem = InventoryItem(
          id: '1',
          name: 'Apple',
          sku: 'APP001',
          price: 1.99,
          cost: 1.50,
          stockQuantity: 90, // Updated from 100
          category: 'Fruits',
          barcode: '123456789',
          imageUrl: 'https://example.com/apple.jpg',
          description: 'Fresh red apples',
          minStockLevel: 10,
          maxStockLevel: 200,
        );

        when(mockInventoryRepository.updateStockLevel('1', 90))
            .thenAnswer((_) async => updatedItem);

        final result = await mockInventoryRepository.updateStockLevel('1', 90);

        expect(result, updatedItem);
        expect(result.stockQuantity, 90);
      });

      test('throws exception when item not found', () async {
        when(mockInventoryRepository.updateStockLevel('999', 50))
            .thenThrow(Exception('Item not found'));

        expect(
          () async => await mockInventoryRepository.updateStockLevel('999', 50),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getLowStockItems', () {
      test('returns items with low stock', () async {
        final lowStockItems = [
          InventoryItem(
            id: '1',
            name: 'Apple',
            sku: 'APP001',
            price: 1.99,
            cost: 1.50,
            stockQuantity: 5, // Below min stock level
            category: 'Fruits',
            barcode: '123456789',
            imageUrl: 'https://example.com/apple.jpg',
            description: 'Fresh red apples',
            minStockLevel: 10,
            maxStockLevel: 200,
          ),
        ];

        when(mockInventoryRepository.getLowStockItems())
            .thenAnswer((_) async => lowStockItems);

        final result = await mockInventoryRepository.getLowStockItems();

        expect(result, lowStockItems);
        expect(result.length, 1);
        expect(result.first.stockQuantity, 5);
      });

      test('returns empty list when no low stock items', () async {
        when(mockInventoryRepository.getLowStockItems())
            .thenAnswer((_) async => []);

        final result = await mockInventoryRepository.getLowStockItems();

        expect(result, isEmpty);
      });
    });

    group('getCategories', () {
      test('returns list of categories', () async {
        final categories = ['Fruits', 'Vegetables', 'Dairy', 'Beverages'];

        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => categories);

        final result = await mockInventoryRepository.getCategories();

        expect(result, categories);
        expect(result.length, 4);
        expect(result.contains('Fruits'), isTrue);
      });

      test('returns empty list when no categories exist', () async {
        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => []);

        final result = await mockInventoryRepository.getCategories();

        expect(result, isEmpty);
      });
    });
  });
} 