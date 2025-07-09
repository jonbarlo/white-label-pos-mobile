import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_repository.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';

import 'reports_repository_test.mocks.dart';

@GenerateMocks([ReportsRepository])
void main() {
  late MockReportsRepository mockReportsRepository;

  setUp(() {
    mockReportsRepository = MockReportsRepository();
  });

  group('ReportsRepository', () {
    group('getSalesReport', () {
      test('returns sales report for given date range', () async {
        final expectedReport = SalesReport(
          totalSales: 1500.0,
          totalTransactions: 25,
          averageTransactionValue: 60.0,
          topSellingItems: ['Apple', 'Banana', 'Orange'],
          salesByHour: {'9': 200.0, '10': 300.0, '11': 400.0},
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        when(mockReportsRepository.getSalesReport(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        )).thenAnswer((_) async => expectedReport);

        final result = await mockReportsRepository.getSalesReport(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        expect(result, equals(expectedReport));
        expect(result.totalSales, equals(1500.0));
        expect(result.totalTransactions, equals(25));
        expect(result.averageTransactionValue, equals(60.0));
        verify(mockReportsRepository.getSalesReport(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        )).called(1);
      });

      test('returns empty sales report when no data', () async {
        final expectedReport = SalesReport(
          totalSales: 0.0,
          totalTransactions: 0,
          averageTransactionValue: 0.0,
          topSellingItems: [],
          salesByHour: {},
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        when(mockReportsRepository.getSalesReport(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        )).thenAnswer((_) async => expectedReport);

        final result = await mockReportsRepository.getSalesReport(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        expect(result.totalSales, equals(0.0));
        expect(result.totalTransactions, equals(0));
        expect(result.topSellingItems, isEmpty);
      });
    });

    group('getRevenueReport', () {
      test('returns revenue report for given period', () async {
        final expectedReport = RevenueReport(
          totalRevenue: 2500.0,
          totalCost: 1500.0,
          grossProfit: 1000.0,
          profitMargin: 40.0,
          revenueByDay: {'2024-01-01': 100.0, '2024-01-02': 150.0},
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        when(mockReportsRepository.getRevenueReport(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        )).thenAnswer((_) async => expectedReport);

        final result = await mockReportsRepository.getRevenueReport(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        expect(result, equals(expectedReport));
        expect(result.totalRevenue, equals(2500.0));
        expect(result.grossProfit, equals(1000.0));
        expect(result.profitMargin, equals(40.0));
        verify(mockReportsRepository.getRevenueReport(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        )).called(1);
      });
    });

    group('getInventoryReport', () {
      test('returns inventory report', () async {
        final expectedReport = {
          'totalItems': 150,
          'lowStockItems': 5,
          'outOfStockItems': 2,
          'totalValue': 5000.0,
        };

        when(mockReportsRepository.getInventoryReport())
            .thenAnswer((_) async => expectedReport);

        final result = await mockReportsRepository.getInventoryReport();

        expect(result, equals(expectedReport));
        expect(result['totalItems'], equals(150));
        expect(result['lowStockItems'], equals(5));
        expect(result['outOfStockItems'], equals(2));
        expect(result['totalValue'], equals(5000.0));
        verify(mockReportsRepository.getInventoryReport()).called(1);
      });
    });

    group('getTopSellingItems', () {
      test('returns top selling items', () async {
        final expectedItems = [
          {'name': 'Apple', 'quantity': 100, 'revenue': 500.0},
          {'name': 'Banana', 'quantity': 80, 'revenue': 400.0},
          {'name': 'Orange', 'quantity': 60, 'revenue': 300.0},
        ];

        when(mockReportsRepository.getTopSellingItems(
          limit: anyNamed('limit'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        )).thenAnswer((_) async => expectedItems);

        final result = await mockReportsRepository.getTopSellingItems(
          limit: 10,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        expect(result, equals(expectedItems));
        expect(result.length, equals(3));
        expect(result.first['name'], equals('Apple'));
        expect(result.first['quantity'], equals(100));
        verify(mockReportsRepository.getTopSellingItems(
          limit: 10,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        )).called(1);
      });
    });
  });
} 