import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_provider.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_repository.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_screen.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';
import '../../../helpers/riverpod_test_helper.dart';

import 'reports_screen_test.mocks.dart';

@GenerateMocks([ReportsRepository])
void main() {
  late MockReportsRepository mockReportsRepository;

  setUp(() {
    mockReportsRepository = MockReportsRepository();
    RiverpodTestHelper.setUpContainer([
      reportsRepositoryProvider.overrideWithValue(mockReportsRepository),
    ]);
  });

  tearDown(() async {
    await RiverpodTestHelper.tearDownContainer();
  });

  group('ReportsScreen', () {
    testWidgets('displays reports screen with title', (WidgetTester tester) async {
      when(mockReportsRepository.getSalesReport(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => SalesReport(
        totalSales: 0.0,
        totalTransactions: 0,
        averageTransactionValue: 0.0,
        topSellingItems: [],
        salesByHour: {},
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ));

      await RiverpodTestHelper.pumpWidget(tester, const ReportsScreen());

      expect(find.text('Reports'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays tab navigation', (WidgetTester tester) async {
      when(mockReportsRepository.getSalesReport(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => SalesReport(
        totalSales: 0.0,
        totalTransactions: 0,
        averageTransactionValue: 0.0,
        topSellingItems: [],
        salesByHour: {},
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ));

      await RiverpodTestHelper.pumpWidget(tester, const ReportsScreen());

      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('Inventory'), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('shows loading state initially', (WidgetTester tester) async {
      when(mockReportsRepository.getSalesReport(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return SalesReport(
          totalSales: 0.0,
          totalTransactions: 0,
          averageTransactionValue: 0.0,
          topSellingItems: [],
          salesByHour: {},
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        );
      });

      await tester.pumpWidget(RiverpodTestHelper.createTestWidget(const ReportsScreen()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays sales data when loaded', (WidgetTester tester) async {
      final salesReport = SalesReport(
        totalSales: 1500.0,
        totalTransactions: 25,
        averageTransactionValue: 60.0,
        topSellingItems: ['Apple', 'Banana'],
        salesByHour: {'9': 200.0, '10': 300.0},
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
      );

      when(mockReportsRepository.getSalesReport(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => salesReport);

      await RiverpodTestHelper.pumpWidget(tester, const ReportsScreen());

      expect(find.text('\$1,500.00'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('\$60.00'), findsOneWidget);
    });

    testWidgets('displays error state when API fails', (WidgetTester tester) async {
      when(mockReportsRepository.getSalesReport(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenThrow(Exception('Network error'));

      await RiverpodTestHelper.pumpWidget(tester, const ReportsScreen());

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('has date range picker', (WidgetTester tester) async {
      when(mockReportsRepository.getSalesReport(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => SalesReport(
        totalSales: 0.0,
        totalTransactions: 0,
        averageTransactionValue: 0.0,
        topSellingItems: [],
        salesByHour: {},
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ));

      await RiverpodTestHelper.pumpWidget(tester, const ReportsScreen());

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('has export button', (WidgetTester tester) async {
      when(mockReportsRepository.getSalesReport(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => SalesReport(
        totalSales: 0.0,
        totalTransactions: 0,
        averageTransactionValue: 0.0,
        topSellingItems: [],
        salesByHour: {},
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ));

      await RiverpodTestHelper.pumpWidget(tester, const ReportsScreen());

      expect(find.byIcon(Icons.download), findsOneWidget);
    });
  });
} 