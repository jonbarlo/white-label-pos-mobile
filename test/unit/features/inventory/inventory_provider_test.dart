import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_provider.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';

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
            .thenAnswer((_) async => expectedItems);

        final result = await container.read(inventoryItemsProvider.future);

        expect(result, expectedItems);
        expect(result.length, 2);
        expect(result.first.name, 'Apple');
        expect(result.last.name, 'Banana');
      });

      test('returns empty list when no items exist', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => []);

        final result = await container.read(inventoryItemsProvider.future);

        expect(result, isEmpty);
      });

      test('throws exception on error', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenThrow(Exception('Network error'));

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
            .thenAnswer((_) async => lowStockItems);

        final result = await container.read(lowStockItemsProvider.future);

        expect(result, lowStockItems);
        expect(result.length, 1);
        expect(result.first.stockQuantity, 5);
      });

      test('returns empty list when no low stock items', () async {
        when(mockInventoryRepository.getLowStockItems())
            .thenAnswer((_) async => []);

        final result = await container.read(lowStockItemsProvider.future);

        expect(result, isEmpty);
      });
    });

    group('categoriesProvider', () {
      test('returns list of categories', () async {
        final categories = ['Fruits', 'Vegetables', 'Dairy', 'Beverages'];

        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => categories);

        final result = await container.read(categoriesProvider.future);

        expect(result, categories);
        expect(result.length, 4);
        expect(result.contains('Fruits'), isTrue);
      });

      test('returns empty list when no categories exist', () async {
        when(mockInventoryRepository.getCategories())
            .thenAnswer((_) async => []);

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
            .thenAnswer((_) async => expectedItems);

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
          return [];
        });

        final provider = container.read(inventoryProvider.notifier);
        final future = provider.loadInventoryItems();

        // Check loading state
        final loadingState = container.read(inventoryProvider);
        expect(loadingState.isLoading, true);

        await future;

        // Check final state
        final finalState = container.read(inventoryProvider);
        expect(finalState.isLoading, false);
      });

      test('handles error state correctly', () async {
        when(mockInventoryRepository.getInventoryItems())
            .thenThrow(Exception('Network error'));

        final provider = container.read(inventoryProvider.notifier);
        await provider.loadInventoryItems();

        final state = container.read(inventoryProvider);
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, isNotNull);
        expect(state.error!.contains('Network error'), isTrue);
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

        final createdItem = newItem.copyWith(id: '3');

        when(mockInventoryRepository.createInventoryItem(newItem))
            .thenAnswer((_) async => createdItem);
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => [createdItem]);

        final provider = container.read(inventoryProvider.notifier);
        await provider.createInventoryItem(newItem);

        final state = container.read(inventoryProvider);
        expect(state.items.length, 1);
        expect(state.items.first.name, 'Orange');
        expect(state.error, isNull);
      });

      test('updates inventory item successfully', () async {
        final existingItem = InventoryItem(
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

        final updatedItem = existingItem.copyWith(
          name: 'Apple Updated',
          price: 2.49,
        );

        when(mockInventoryRepository.updateInventoryItem(updatedItem))
            .thenAnswer((_) async => updatedItem);
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => [updatedItem]);

        final provider = container.read(inventoryProvider.notifier);
        await provider.updateInventoryItem(updatedItem);

        final state = container.read(inventoryProvider);
        expect(state.items.length, 1);
        expect(state.items.first.name, 'Apple Updated');
        expect(state.items.first.price, 2.49);
        expect(state.error, isNull);
      });

      test('deletes inventory item successfully', () async {
        final itemToDelete = InventoryItem(
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

        when(mockInventoryRepository.deleteInventoryItem('1'))
            .thenAnswer((_) async => true);
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => []);

        final provider = container.read(inventoryProvider.notifier);
        await provider.deleteInventoryItem('1');

        final state = container.read(inventoryProvider);
        expect(state.items, isEmpty);
        expect(state.error, isNull);
      });

      test('updates stock level successfully', () async {
        final item = InventoryItem(
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

        final updatedItem = item.copyWith(stockQuantity: 90);

        when(mockInventoryRepository.updateStockLevel('1', 90))
            .thenAnswer((_) async => updatedItem);
        when(mockInventoryRepository.getInventoryItems())
            .thenAnswer((_) async => [updatedItem]);

        final provider = container.read(inventoryProvider.notifier);
        await provider.updateStockLevel('1', 90);

        final state = container.read(inventoryProvider);
        expect(state.items.length, 1);
        expect(state.items.first.stockQuantity, 90);
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
            .thenAnswer((_) async => searchResults);

        final provider = container.read(inventoryProvider.notifier);
        await provider.searchItems('apple');

        final state = container.read(inventoryProvider);
        expect(state.searchResults, searchResults);
        expect(state.searchQuery, 'apple');
        expect(state.error, isNull);
      });

      test('clears search results', () async {
        final provider = container.read(inventoryProvider.notifier);
        provider.clearSearch();

        final state = container.read(inventoryProvider);
        expect(state.searchResults, isEmpty);
        expect(state.searchQuery, isEmpty);
      });

      test('filters items by category', () async {
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
            .thenAnswer((_) async => categoryItems);

        final provider = container.read(inventoryProvider.notifier);
        await provider.filterByCategory('Fruits');

        final state = container.read(inventoryProvider);
        expect(state.filteredItems, categoryItems);
        expect(state.selectedCategory, 'Fruits');
        expect(state.error, isNull);
      });

      test('clears category filter', () async {
        final provider = container.read(inventoryProvider.notifier);
        provider.clearCategoryFilter();

        final state = container.read(inventoryProvider);
        expect(state.filteredItems, isEmpty);
        expect(state.selectedCategory, isNull);
      });
    });
  });
} 