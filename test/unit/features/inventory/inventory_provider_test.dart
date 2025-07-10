import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_provider.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';

import 'inventory_provider_test.mocks.dart';

@GenerateMocks([InventoryRepository])
void main() {
  late MockInventoryRepository mockInventoryRepository;
  late ProviderContainer container;

  setUp(() {
    mockInventoryRepository = MockInventoryRepository();
    container = ProviderContainer(
      overrides: [
        inventoryRepositoryProvider.overrideWithValue(mockInventoryRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('InventoryProvider', () {
    group('inventoryItemsProvider', () {
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
            .thenAnswer((_) async => Result.success(expectedItems));

        final result = await container.read(inventoryItemsProvider.future);

        expect(result, expectedItems);
        expect(result.length, 2);
        expect(result.first.name, 'Apple');
        expect(result.last.name, 'Banana');
      });

      test('returns empty list when no items exist', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success(<InventoryItem>[]));

        final result = await container.read(inventoryItemsProvider.future);

        expect(result, isEmpty);
      });

      test('throws exception on error', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.failure('Network error'));

        expect(
          () async => await container.read(inventoryItemsProvider.future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('lowStockItemsProvider', () {
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
            .thenAnswer((_) async => Result.success(lowStockItems));

        final result = await container.read(lowStockItemsProvider.future);

        expect(result, lowStockItems);
        expect(result.length, 1);
        expect(result.first.stockQuantity, 5);
      });

      test('returns empty list when no low stock items', () async {
        when(mockInventoryRepository.getLowStockItems())
            .thenAnswer((_) async => Result.success(<InventoryItem>[]));

        final result = await container.read(lowStockItemsProvider.future);

        expect(result, isEmpty);
      });
    });

    group('categoriesProvider', () {
      test('returns list of categories', () async {
        final categories = ['Fruits', 'Vegetables', 'Dairy', 'Beverages'];

        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => Result.success(categories));

        final result = await container.read(categoriesProvider.future);

        expect(result, categories);
        expect(result.length, 4);
        expect(result.contains('Fruits'), isTrue);
      });

      test('returns empty list when no categories exist', () async {
        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => Result.success(<String>[]));

        final result = await container.read(categoriesProvider.future);

        expect(result, isEmpty);
      });
    });

    group('inventoryProvider', () {
      test('loads inventory items on initialization', () async {
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
        ];

        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success(expectedItems));

        final provider = container.read(inventoryProvider.notifier);
        await provider.loadInventoryItems();

        final state = container.read(inventoryProvider);
        expect(state.items, expectedItems);
        expect(state.isLoading, false);
        expect(state.error, isNull);
      });

      test('handles loading state correctly', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async {
          await Future.delayed(Duration(milliseconds: 100));
          return Result.success(<InventoryItem>[]);
        });

        final provider = container.read(inventoryProvider.notifier);
        final future = provider.loadInventoryItems();

        // Check loading state
        final loadingState = container.read(inventoryProvider);
        expect(loadingState.isLoading, true);

        // Wait for completion
        await future;

        // Check final state
        final finalState = container.read(inventoryProvider);
        expect(finalState.isLoading, false);
        expect(finalState.items, isEmpty);
      });

      test('handles error state correctly', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.failure('Network error'));

        final provider = container.read(inventoryProvider.notifier);
        await provider.loadInventoryItems();

        final state = container.read(inventoryProvider);
        expect(state.isLoading, false);
        expect(state.error, 'Network error');
        expect(state.items, isEmpty);
      });

      test('creates inventory item successfully', () async {
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

        final createdItem = InventoryItem(
          id: '3',
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

        // Use a local variable to track the inventory
        List<InventoryItem> inventory = [];
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success(List<InventoryItem>.from(inventory)));
        when(mockInventoryRepository.createInventoryItem(newItem))
            .thenAnswer((_) async {
              inventory.add(createdItem);
              return Result.success(createdItem);
            });

        final provider = container.read(inventoryProvider.notifier);
        await provider.createInventoryItem(newItem);
        await provider.loadInventoryItems();

        final state = container.read(inventoryProvider);
        expect(state.items.length, 1);
        expect(state.items.first.name, 'Orange');
        expect(state.error, isNull);
      });

      test('updates inventory item successfully', () async {
        final originalItem = InventoryItem(
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

        final updatedItem = InventoryItem(
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

        // Use a local variable to track the inventory
        List<InventoryItem> inventory = [originalItem];
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success(List<InventoryItem>.from(inventory)));
        when(mockInventoryRepository.updateInventoryItem(updatedItem))
            .thenAnswer((_) async {
              inventory[0] = updatedItem;
              return Result.success(updatedItem);
            });

        final provider = container.read(inventoryProvider.notifier);
        await provider.updateInventoryItem(updatedItem);
        await provider.loadInventoryItems();

        final state = container.read(inventoryProvider);
        expect(state.items.length, 1);
        expect(state.items.first.name, 'Apple Updated');
        expect(state.items.first.price, 2.99);
        expect(state.error, isNull);
      });

      test('deletes inventory item successfully', () async {
        when(mockInventoryRepository.deleteInventoryItem('1'))
            .thenAnswer((_) async => Result.success(true));
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success(<InventoryItem>[]));

        final provider = container.read(inventoryProvider.notifier);
        await provider.deleteInventoryItem('1');

        final state = container.read(inventoryProvider);
        expect(state.items, isEmpty);
        expect(state.error, isNull);
      });

      test('updates stock level successfully', () async {
        final originalItem = InventoryItem(
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

        final updatedItem = InventoryItem(
          id: '1',
          name: 'Apple',
          sku: 'APP001',
          price: 1.99,
          cost: 1.50,
          stockQuantity: 200,
          category: 'Fruits',
          barcode: '123456789',
          imageUrl: 'https://example.com/apple.jpg',
          description: 'Fresh red apples',
          minStockLevel: 10,
          maxStockLevel: 200,
        );

        // Use a local variable to track the inventory
        List<InventoryItem> inventory = [originalItem];
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => Result.success(List<InventoryItem>.from(inventory)));
        when(mockInventoryRepository.updateStockLevel('1', 200))
            .thenAnswer((_) async {
              inventory[0] = updatedItem;
              return Result.success(updatedItem);
            });

        final provider = container.read(inventoryProvider.notifier);
        await provider.updateStockLevel('1', 200);
        await provider.loadInventoryItems();

        final state = container.read(inventoryProvider);
        expect(state.items.length, 1);
        expect(state.items.first.stockQuantity, 200);
        expect(state.error, isNull);
      });

      test('searches items successfully', () async {
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

        final provider = container.read(inventoryProvider.notifier);
        await provider.searchItems('apple');

        final state = container.read(inventoryProvider);
        expect(state.searchResults, searchResults);
        expect(state.searchResults.length, 1);
        expect(state.searchResults.first.name, 'Apple');
        expect(state.error, isNull);
      });

      test('filters items by category successfully', () async {
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

        final provider = container.read(inventoryProvider.notifier);
        await provider.filterByCategory('Fruits');

        final state = container.read(inventoryProvider);
        expect(state.filteredItems, categoryItems);
        expect(state.filteredItems.length, 1);
        expect(state.filteredItems.first.category, 'Fruits');
        expect(state.error, isNull);
      });
    });
  });
} 