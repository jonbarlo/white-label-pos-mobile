import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_provider.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_repository.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';

import 'reports_provider_test.mocks.dart';

@GenerateMocks([ReportsRepository])
void main() {
  late MockReportsRepository mockReportsRepository;
  late ProviderContainer container;

  setUp(() {
    mockReportsRepository = MockReportsRepository();
    container = ProviderContainer(
      overrides: [
        reportsRepositoryProvider.overrideWithValue(mockReportsRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ReportsProvider', () {
    group('salesReportProvider', () {
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

        final result = await container.read(salesReportProvider(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        ).future);

        expect(result, equals(expectedReport));
        expect(result.totalSales, equals(1500.0));
        expect(result.totalTransactions, equals(25));
        verify(mockReportsRepository.getSalesReport(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        )).called(1);
      });

      test('handles error when repository fails', () async {
        when(mockReportsRepository.getSalesReport(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        )).thenThrow(Exception('Network error'));

        final provider = salesReportProvider(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        );

        expect(
          () => container.read(provider.future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('revenueReportProvider', () {
      test('returns revenue report for given date range', () async {
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

        final result = await container.read(revenueReportProvider(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        ).future);

        expect(result, equals(expectedReport));
        expect(result.totalRevenue, equals(2500.0));
        expect(result.grossProfit, equals(1000.0));
        verify(mockReportsRepository.getRevenueReport(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        )).called(1);
      });
    });

    group('inventoryReportProvider', () {
      test('returns inventory report', () async {
        final expectedReport = {
          'totalItems': 150,
          'lowStockItems': 5,
          'outOfStockItems': 2,
          'totalValue': 5000.0,
        };

        when(mockReportsRepository.getInventoryReport())
            .thenAnswer((_) async => expectedReport);

        final result = await container.read(inventoryReportProvider.future);

        expect(result, equals(expectedReport));
        expect(result['totalItems'], equals(150));
        expect(result['lowStockItems'], equals(5));
        verify(mockReportsRepository.getInventoryReport()).called(1);
      });
    });

    group('topSellingItemsProvider', () {
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

        final result = await container.read(topSellingItemsProvider(
          limit: 10,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        ).future);

        expect(result, equals(expectedItems));
        expect(result.length, equals(3));
        expect(result.first['name'], equals('Apple'));
        verify(mockReportsRepository.getTopSellingItems(
          limit: 10,
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        )).called(1);
      });
    });

    group('salesTrendsProvider', () {
      test('returns sales trends', () async {
        final expectedTrends = {
          '2024-01-01': 100.0,
          '2024-01-02': 150.0,
          '2024-01-03': 200.0,
        };

        when(mockReportsRepository.getSalesTrends(
          period: anyNamed('period'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        )).thenAnswer((_) async => expectedTrends);

        final result = await container.read(salesTrendsProvider(
          period: 'daily',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        ).future);

        expect(result, equals(expectedTrends));
        expect(result.length, equals(3));
        verify(mockReportsRepository.getSalesTrends(
          period: 'daily',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
        )).called(1);
      });
    });
  });
} 