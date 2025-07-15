import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_repository.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/cart_item.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/sale.dart';

import 'pos_repository_test.mocks.dart';

@GenerateMocks([PosRepository])
void main() {
  late MockPosRepository mockPosRepository;

  setUp(() {
    mockPosRepository = MockPosRepository();
  });

  group('PosRepository', () {
    group('searchItems', () {
      test('returns list of items matching search query', () async {
        const searchQuery = 'apple';
        final expectedItems = [
          const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1),
          const CartItem(id: '2', name: 'Apple Juice', price: 2.99, quantity: 1),
        ];

        when(mockPosRepository.searchItems(searchQuery))
            .thenAnswer((_) async => expectedItems);

        final result = await mockPosRepository.searchItems(searchQuery);

        expect(result, expectedItems);
        expect(result.length, 2);
        expect(result.first.name, 'Apple');
      });

      test('returns empty list when no items match', () async {
        const searchQuery = 'nonexistent';

        when(mockPosRepository.searchItems(searchQuery))
            .thenAnswer((_) async => []);

        final result = await mockPosRepository.searchItems(searchQuery);

        expect(result, isEmpty);
      });

      test('throws exception on network error', () async {
        const searchQuery = 'apple';

        when(mockPosRepository.searchItems(searchQuery))
            .thenThrow(Exception('Network error'));

        expect(
          () async => await mockPosRepository.searchItems(searchQuery),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getItemByBarcode', () {
      test('returns item when barcode exists', () async {
        const barcode = '123456789';
        const expectedItem = CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1);

        when(mockPosRepository.getItemByBarcode(barcode))
            .thenAnswer((_) async => expectedItem);

        final result = await mockPosRepository.getItemByBarcode(barcode);

        expect(result, expectedItem);
        expect(result?.name, 'Apple');
      });

      test('returns null when barcode not found', () async {
        const barcode = '999999999';

        when(mockPosRepository.getItemByBarcode(barcode))
            .thenAnswer((_) async => null);

        final result = await mockPosRepository.getItemByBarcode(barcode);

        expect(result, isNull);
      });
    });

    group('createSale', () {
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

        when(mockPosRepository.createSale(items: items, paymentMethod: paymentMethod))
            .thenAnswer((_) async => expectedSale);

        final result = await mockPosRepository.createSale(
          items: items,
          paymentMethod: paymentMethod,
        );

        expect(result, expectedSale);
        expect(result.id, 'sale_123');
        expect(result.total, 4.97);
        expect(result.paymentMethod, PaymentMethod.cash);
      });

      test('throws exception when sale creation fails', () async {
        final items = [const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1)];
        const paymentMethod = PaymentMethod.card;

        when(mockPosRepository.createSale(items: items, paymentMethod: paymentMethod))
            .thenThrow(Exception('Sale creation failed'));

        expect(
          () async => await mockPosRepository.createSale(
            items: items,
            paymentMethod: paymentMethod,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getRecentSales', () {
      test('returns list of recent sales', () async {
        final expectedSales = [
          Sale(
            id: 'sale_1',
            items: [const CartItem(id: '1', name: 'Apple', price: 1.99, quantity: 1)],
            total: 1.99,
            paymentMethod: PaymentMethod.cash,
            createdAt: DateTime.now(),
          ),
          Sale(
            id: 'sale_2',
            items: [const CartItem(id: '2', name: 'Banana', price: 0.99, quantity: 2)],
            total: 1.98,
            paymentMethod: PaymentMethod.card,
            createdAt: DateTime.now(),
          ),
        ];

        when(mockPosRepository.getRecentSales(limit: 10))
            .thenAnswer((_) async => expectedSales);

        final result = await mockPosRepository.getRecentSales(limit: 10);

        expect(result, expectedSales);
        expect(result.length, 2);
        expect(result.first.id, 'sale_1');
      });

      test('returns empty list when no sales exist', () async {
        when(mockPosRepository.getRecentSales(limit: 10))
            .thenAnswer((_) async => []);

        final result = await mockPosRepository.getRecentSales(limit: 10);

        expect(result, isEmpty);
      });
    });
  });
} 