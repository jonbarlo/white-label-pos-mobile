import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_screen.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_provider.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/category.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';
import 'package:white_label_pos_mobile/src/core/theme/app_theme.dart';

import 'inventory_screen_test.mocks.dart';

class StubAuthNotifier extends AuthNotifier {
  final AuthState _stubState;
  StubAuthNotifier(this._stubState) : super();
  @override
  AuthState build() => _stubState;
}

@GenerateMocks([InventoryRepository])
void main() {
  group('InventoryScreen', () {
    late MockInventoryRepository mockInventoryRepository;
    late User mockUser;
    late Business mockBusiness;
    late AuthState mockAuthState;

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

      mockAuthState = AuthState(
        status: AuthStatus.authenticated,
        user: mockUser,
        business: mockBusiness,
        token: 'test-token',
      );
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          inventoryRepositoryProvider.overrideWithValue(mockInventoryRepository),
          authNotifierProvider.overrideWith(() => StubAuthNotifier(mockAuthState)),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const InventoryScreen(),
        ),
      );
    }

    testWidgets('displays loading state initially', (WidgetTester tester) async {
      // Use a delayed response to catch the loading state
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return Result.success(<InventoryItem>[]);
          });
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(<Category>[]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Initial build
      
      // Should show loading indicator while data is being fetched
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays inventory items when loaded successfully', (WidgetTester tester) async {
      final testItems = [
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
          .thenAnswer((_) async => Result.success(testItems));
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(<Category>[]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Stock: 100'), findsOneWidget); // Stock quantity with label
      expect(find.text('Stock: 50'), findsOneWidget); // Stock quantity with label
    });

    testWidgets('displays empty state when no items exist', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => Result.success(<InventoryItem>[]));
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(<Category>[]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No inventory items found'), findsOneWidget);
      expect(find.text('Add your first item to get started'), findsOneWidget);
    });

    testWidgets('displays error state when loading fails', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => Result.failure('Network error'));
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(<Category>[]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Error loading inventory'), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('displays low stock items in low stock tab', (WidgetTester tester) async {
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

      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => Result.success(lowStockItems));
      when(mockInventoryRepository.getLowStockItems())
          .thenAnswer((_) async => Result.success(lowStockItems));
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(<Category>[]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on Low Stock tab
      await tester.tap(find.text('Low Stock'));
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Stock: 5'), findsOneWidget); // Low stock quantity with label
    });

    testWidgets('displays categories in categories tab', (WidgetTester tester) async {
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
      ];

      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => Result.success(<InventoryItem>[]));
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(categories));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on Categories tab
      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      expect(find.text('Fruits'), findsOneWidget);
      expect(find.text('Vegetables'), findsOneWidget);
    });

    testWidgets('shows floating action button for adding items', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => Result.success(<InventoryItem>[]));
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(<Category>[]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows search and filter buttons in app bar', (WidgetTester tester) async {
      when(mockInventoryRepository.getInventoryItems())
          .thenAnswer((_) async => Result.success(<InventoryItem>[]));
      when(mockInventoryRepository.getCategories(businessId: 1))
          .thenAnswer((_) async => Result.success(<Category>[]));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });
  });
} 