import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_provider.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_repository.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/cart_item.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/sale.dart';

import 'pos_provider_test.mocks.dart';

@GenerateMocks([PosRepository])
void main() {
  late MockPosRepository mockPosRepository;
  late ProviderContainer container;

  setUp(() {
    mockPosRepository = MockPosRepository();
    container = ProviderContainer(
      overrides: [
        posRepositoryProvider.overrideWith((ref) => mockPosRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PosProvider', () {
    group('cartNotifierProvider', () {
      test('initial state is empty cart', () {
        final cart = container.read(cartNotifierProvider);
        expect(cart, isEmpty);
      });

      test('addItem adds item to cart', () {
        const item = CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1);
        
        container.read(cartNotifierProvider.notifier).addItem(item);
        
        final cart = container.read(cartNotifierProvider);
        expect(cart.length, 1);
        expect(cart.first.name, 'Apple');
      });

      test('addItem increases quantity if item already exists', () {
        const item = CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1);
        
        container.read(cartNotifierProvider.notifier).addItem(item);
        container.read(cartNotifierProvider.notifier).addItem(item);
        
        final cart = container.read(cartNotifierProvider);
        expect(cart.length, 1);
        expect(cart.first.quantity, 2);
        expect(cart.first.total, 3.98);
      });

      test('removeItem removes item from cart', () {
        const item = CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1);
        
        container.read(cartNotifierProvider.notifier).addItem(item);
        container.read(cartNotifierProvider.notifier).removeItem('1');
        
        final cart = container.read(cartNotifierProvider);
        expect(cart, isEmpty);
      });

      test('updateItemQuantity updates item quantity', () {
        const item = CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1);
        
        container.read(cartNotifierProvider.notifier).addItem(item);
        container.read(cartNotifierProvider.notifier).updateItemQuantity('1', 3);
        
        final cart = container.read(cartNotifierProvider);
        expect(cart.first.quantity, 3);
        expect(cart.first.total, 5.97);
      });

      test('clearCart removes all items', () {
        const item1 = CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1);
        const item2 = CartItem(id: '2', name: 'Banana', price: 0.99, quantity: 1);
        
        container.read(cartNotifierProvider.notifier).addItem(item1);
        container.read(cartNotifierProvider.notifier).addItem(item2);
        container.read(cartNotifierProvider.notifier).clearCart();
        
        final cart = container.read(cartNotifierProvider);
        expect(cart, isEmpty);
      });

      test('cartTotal calculates total correctly', () {
        const item1 = CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 2);
        const item2 = CartItem(id: '2', name: 'Banana', price: 0.99, quantity: 1);
        
        container.read(cartNotifierProvider.notifier).addItem(item1);
        container.read(cartNotifierProvider.notifier).addItem(item2);
        
        final total = container.read(cartTotalProvider);
        expect(total, 4.97); // (1.99 * 2) + (0.99 * 1)
      });
    });

    group('searchNotifierProvider', () {
      test('initial state is empty', () {
        final results = container.read(searchNotifierProvider);
        expect(results, isEmpty);
      });

      test('searchItems updates search results', () async {
        const query = 'apple';
        final expectedItems = [
          const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1),
          const CartItem(id: '2', name: 'Apple Juice', price: 2.99, quantity: 1),
        ];

        when(mockPosRepository.searchItems(query))
            .thenAnswer((_) async => expectedItems);

        await container.read(searchNotifierProvider.notifier).searchItems(query);

        final results = container.read(searchNotifierProvider);
        expect(results.length, 2);
        expect(results.first.name, 'Apple');
      });

      test('searchItems handles empty results', () async {
        const query = 'nonexistent';

        when(mockPosRepository.searchItems(query))
            .thenAnswer((_) async => []);

        await container.read(searchNotifierProvider.notifier).searchItems(query);

        final results = container.read(searchNotifierProvider);
        expect(results, isEmpty);
      });

      test('searchItems handles errors', () async {
        const query = 'apple';

        when(mockPosRepository.searchItems(query))
            .thenThrow(Exception('Network error'));

        await container.read(searchNotifierProvider.notifier).searchItems(query);

        final results = container.read(searchNotifierProvider);
        expect(results, isEmpty);
      });
    });

    group('recentSalesNotifierProvider', () {
      test('initial state is empty', () {
        final sales = container.read(recentSalesNotifierProvider);
        expect(sales, isEmpty);
      });

      test('loadRecentSales updates sales list', () async {
        final expectedSales = [
          Sale(
            id: 'sale_1',
            items: [const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1)],
            total: 1.99,
            paymentMethod: PaymentMethod.cash,
            createdAt: DateTime.now(),
          ),
        ];

        when(mockPosRepository.getRecentSales(limit: 10))
            .thenAnswer((_) async => expectedSales);

        await container.read(recentSalesNotifierProvider.notifier).loadRecentSales();

        final sales = container.read(recentSalesNotifierProvider);
        expect(sales.length, 1);
        expect(sales.first.id, 'sale_1');
      });
    });

    group('createSaleProvider', () {
      test('creates sale successfully', () async {
        final items = [
          const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 2),
          const CartItem(id: '2', name: 'Banana', price: 0.99, quantity: 1),
        ];
        const paymentMethod = PaymentMethod.cash;
        final expectedSale = Sale(
          id: 'sale_123',
          items: items,
          total: 4.97,
          paymentMethod: paymentMethod,
          createdAt: DateTime.now(),
        );

        when(mockPosRepository.createSale(
          items: items,
          paymentMethod: paymentMethod,
        )).thenAnswer((_) async => expectedSale);

        // Add items to cart first
        for (final item in items) {
          container.read(cartNotifierProvider.notifier).addItem(item);
        }

        final result = await container.read(createSaleProvider(paymentMethod).future);

        expect(result, expectedSale);
        expect(result.id, 'sale_123');
        expect(result.total, 4.97);
      });

      test('throws exception when sale creation fails', () async {
        final items = [const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1)];
        const paymentMethod = PaymentMethod.card;

        when(mockPosRepository.createSale(
          items: items,
          paymentMethod: paymentMethod,
        )).thenThrow(Exception('Sale creation failed'));

        // Add item to cart first
        container.read(cartNotifierProvider.notifier).addItem(items.first);

        expect(
          () async => await container.read(createSaleProvider(paymentMethod).future),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
} 