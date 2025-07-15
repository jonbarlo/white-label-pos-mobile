import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_screen.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_provider.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_repository.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/cart_item.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/sale.dart';
import '../../../helpers/riverpod_test_helper.dart';

import 'pos_screen_test.mocks.dart';

@GenerateMocks([PosRepository])
void main() {
  late MockPosRepository mockPosRepository;

  setUp(() {
    mockPosRepository = MockPosRepository();
    RiverpodTestHelper.setUpContainer([
      posRepositoryProvider.overrideWithValue(mockPosRepository),
    ]);
  });

  tearDown(() async {
    await RiverpodTestHelper.tearDownContainer();
  });

  group('PosScreen', () {
    testWidgets('displays POS screen with search bar and cart', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check for main POS screen elements
      expect(find.text('POS'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search bar
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Total: \$0.00'), findsOneWidget);
      // Checkout button is not visible when cart is empty
      expect(find.text('Checkout'), findsNothing);
    });

    testWidgets('displays empty cart initially', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check for empty cart state
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add items to get started'), findsOneWidget);
    });

    testWidgets('shows search placeholder text', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check for search placeholder
      expect(find.text('Search for items to add to cart'), findsOneWidget);
    });

    testWidgets('has tabs for Sales and Recent Sales', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check for tab labels
      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('Recent Sales'), findsOneWidget);
    });

    testWidgets('shows search results when searching', (tester) async {
      final searchResults = [
        const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1),
        const CartItem(id: '2', name: 'Apple Juice', price: 2.99, quantity: 1),
      ];

      when(mockPosRepository.searchItems('apple'))
          .thenAnswer((_) async => searchResults);

      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Enter search query
      await tester.enterText(find.byType(TextField), 'apple');
      await tester.pump();

      // Wait for search to complete
      await tester.pump(const Duration(milliseconds: 500));

      // Check that search results are displayed
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Apple Juice'), findsOneWidget);
      expect(find.text('\$1.99'), findsOneWidget);
      expect(find.text('\$2.99'), findsOneWidget);
    });

    testWidgets('shows empty state when no search results', (tester) async {
      when(mockPosRepository.searchItems('nonexistent'))
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Enter search query
      await tester.enterText(find.byType(TextField), 'nonexistent');
      await tester.pump();

      // Wait for search to complete
      await tester.pump(const Duration(milliseconds: 500));

      // Check that empty state is shown
      expect(find.text('Search for items to add to cart'), findsOneWidget);
    });

    testWidgets('shows recent sales when tab is selected', (tester) async {
      final recentSales = [
        Sale(
          id: 'sale_1',
          items: [const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1)],
          total: 1.99,
          paymentMethod: PaymentMethod.cash,
          createdAt: DateTime.now(),
        ),
      ];

      when(mockPosRepository.getRecentSales(limit: 10))
          .thenAnswer((_) async => recentSales);

      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Tap recent sales tab
      await tester.tap(find.text('Recent Sales'));
      await tester.pump();

      // Wait for sales to load
      await tester.pump(const Duration(seconds: 1));

      // Check that recent sales are displayed
      expect(find.text('Sale #sale_1'), findsOneWidget);
      expect(find.text('\$1.99'), findsOneWidget);
      expect(find.text('1 items • cash'), findsOneWidget);
    });

    testWidgets('shows no recent sales when empty', (tester) async {
      when(mockPosRepository.getRecentSales(limit: 10))
          .thenAnswer((_) async => []);

      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Tap recent sales tab
      await tester.tap(find.text('Recent Sales'));
      await tester.pump();

      // Wait for sales to load
      await tester.pump(const Duration(seconds: 1));

      // Check that empty state is shown
      expect(find.text('No recent sales'), findsOneWidget);
    });

    testWidgets('search bar has correct hint text', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check for search hint
      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, 'Search items...');
    });

    testWidgets('search bar has search icon', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check for search icon
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('cart section has correct styling', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check for cart header
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Total: \$0.00'), findsOneWidget);
    });

    testWidgets('checkout button is disabled when cart is empty', (tester) async {
      await RiverpodTestHelper.pumpWidget(tester, const PosScreen());

      // Check that checkout button is not visible when cart is empty
      expect(find.text('Checkout'), findsNothing);
    });
  });
} 