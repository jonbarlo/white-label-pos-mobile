import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_provider.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_screen.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import '../../../helpers/riverpod_test_helper.dart';

import 'inventory_screen_test.mocks.dart';

@GenerateMocks([InventoryRepository])
void main() {
  late MockInventoryRepository mockInventoryRepository;

  setUp(() {
    mockInventoryRepository = MockInventoryRepository();
    RiverpodTestHelper.setUpContainer([
      inventoryRepositoryProvider.overrideWithValue(mockInventoryRepository),
    ]);
  });

  tearDown(() async {
    await RiverpodTestHelper.tearDownContainer();
  });

  group('InventoryScreen', () {
    testWidgets('displays inventory screen with title', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.text('Inventory'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays loading indicator when loading', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      await tester.pumpWidget(RiverpodTestHelper.createTestWidget(const InventoryScreen()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays inventory items when loaded', (WidgetTester tester) async {
      final items = [
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
          .thenAnswer((_) async => items);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('APP001'), findsOneWidget);
      expect(find.text('BAN001'), findsOneWidget);
      expect(find.text('\$1.99'), findsOneWidget);
      expect(find.text('\$0.99'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('displays empty state when no items', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.text('No inventory items found'), findsOneWidget);
      expect(find.text('Add your first item to get started'), findsOneWidget);
    });

    testWidgets('displays error message when error occurs', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenThrow(Exception('Network error'));

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.text('Error loading inventory'), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('has search functionality', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('has add item button', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('has filter by category functionality', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);
      when(mockInventoryRepository.getCategories())
          .thenAnswer((_) async => ['Fruits', 'Vegetables']);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('displays low stock indicator for items with low stock', (WidgetTester tester) async {
      final items = [
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

      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => items);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      // Should show low stock indicator
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('displays out of stock indicator for items with zero stock', (WidgetTester tester) async {
      final items = [
        const InventoryItem(
          id: '1',
          name: 'Apple',
          sku: 'APP001',
          price: 1.99,
          cost: 1.50,
          stockQuantity: 0, // Out of stock
          category: 'Fruits',
          barcode: '123456789',
          imageUrl: 'https://example.com/apple.jpg',
          description: 'Fresh red apples',
          minStockLevel: 10,
          maxStockLevel: 200,
        ),
      ];

      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => items);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      // Should show out of stock indicator
      expect(find.text('Out of Stock'), findsOneWidget);
    });

    testWidgets('has refresh functionality', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      // Pull to refresh should be available
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('displays item details in list tile', (WidgetTester tester) async {
      final items = [
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
          .thenAnswer((_) async => items);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Fruits'), findsOneWidget); // Category
    });

    testWidgets('has tab navigation for different views', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('All Items'), findsOneWidget);
      expect(find.text('Low Stock'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('shows low stock items in low stock tab', (WidgetTester tester) async {
      final items = [
        const InventoryItem(
          id: '1',
          name: 'Apple',
          sku: 'APP001',
          price: 1.99,
          cost: 1.50,
          stockQuantity: 5, // Low stock
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
          stockQuantity: 50, // Normal stock
          category: 'Fruits',
          barcode: '987654321',
          imageUrl: 'https://example.com/banana.jpg',
          description: 'Yellow bananas',
          minStockLevel: 5,
          maxStockLevel: 100,
        ),
      ];

      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => items);
      when(mockInventoryRepository.getLowStockItems())
          .thenAnswer((_) async => [items[0]]);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      // Tap on Low Stock tab
      await tester.tap(find.text('Low Stock'));
      await RiverpodTestHelper.pumpAndSettle(tester);

      // Should only show low stock items
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('shows categories in categories tab', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => []);
      when(mockInventoryRepository.getCategories())
          .thenAnswer((_) async => ['Fruits', 'Vegetables', 'Dairy']);

      await RiverpodTestHelper.pumpWidget(tester, const InventoryScreen());

      // Tap on Categories tab
      await tester.tap(find.text('Categories'));
      await RiverpodTestHelper.pumpAndSettle(tester);

      expect(find.text('Fruits'), findsOneWidget);
      expect(find.text('Vegetables'), findsOneWidget);
      expect(find.text('Dairy'), findsOneWidget);
    });
  });
} 