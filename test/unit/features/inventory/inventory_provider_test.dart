import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_provider.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/category.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';

import 'inventory_provider_test.mocks.dart';

class StubAuthNotifier extends AuthNotifier {
  final AuthState _stubState;
  StubAuthNotifier(this._stubState) : super();
  @override
  AuthState build() => _stubState;
}

@GenerateMocks([InventoryRepository])
void main() {
  group('InventoryProvider', () {
    late ProviderContainer container;
    late MockInventoryRepository mockInventoryRepository;
    late User mockUser;
    late Business mockBusiness;

    setUp(() {
      mockInventoryRepository = MockInventoryRepository();
      
      mockUser = User(
        id: 1,
        businessId: 1,
        name: 'Test User',
        email: 'test@example.com',
        role: UserRole.admin,
        isActive: true,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );
      
      mockBusiness = Business(
        id: 1,
        name: 'Test Business',
        slug: 'test-business',
        type: BusinessType.restaurant,
        taxRate: 8.5,
        currency: 'USD',
        timezone: 'America/New_York',
        isActive: true,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );

      final mockAuthState = AuthState(
        status: AuthStatus.authenticated,
        user: mockUser,
        business: mockBusiness,
        token: 'test-token',
      );

      container = ProviderContainer(
        overrides: [
          inventoryRepositoryProvider.overrideWithValue(mockInventoryRepository),
          authNotifierProvider.overrideWith(() => StubAuthNotifier(mockAuthState)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('inventoryItemsProvider', () {
      test('returns list of inventory items', () async {
        final expectedItems = [
          const InventoryItem(
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
          const InventoryItem(
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
          const InventoryItem(
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
        final categories = [
          Category(
            id: 1,
            businessId: 1,
            name: 'Fruits',
            displayOrder: 1,
            isActive: true,
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime(2023, 1, 1),
          ),
          Category(
            id: 2,
            businessId: 1,
            name: 'Vegetables',
            displayOrder: 2,
            isActive: true,
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime(2023, 1, 1),
          ),
          Category(
            id: 3,
            businessId: 1,
            name: 'Dairy',
            displayOrder: 3,
            isActive: true,
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime(2023, 1, 1),
          ),
          Category(
            id: 4,
            businessId: 1,
            name: 'Beverages',
            displayOrder: 4,
            isActive: true,
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime(2023, 1, 1),
          ),
        ];

        when(mockInventoryRepository.getCategories(businessId: 1))
            .thenAnswer((_) async => Result.success(categories));

        final result = await container.read(categoriesProvider.future);

        expect(result, categories);
        expect(result.length, 4);
        expect(result.any((c) => c.name == 'Fruits'), isTrue);
      });

      test('returns empty list when no categories exist', () async {
        when(mockInventoryRepository.getCategories(businessId: 1))
            .thenAnswer((_) async => Result.success(<Category>[]));

        final result = await container.read(categoriesProvider.future);

        expect(result, isEmpty);
      });
    });

    group('inventoryProvider', () {
      test('loads inventory items on initialization', () async {
        final expectedItems = [
          const InventoryItem(
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
          await Future.delayed(const Duration(milliseconds: 100));
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

        const createdItem = InventoryItem(
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
        const originalItem = InventoryItem(
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
        const originalItem = InventoryItem(
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

        const updatedItem = InventoryItem(
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
          const InventoryItem(
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
          const InventoryItem(
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