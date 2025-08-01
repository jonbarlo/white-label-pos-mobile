// Mocks generated by Mockito 5.4.5 from annotations
// in white_label_pos_mobile/test/unit/features/reports/reports_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart'
    as _i3;
import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart'
    as _i2;
import 'package:white_label_pos_mobile/src/features/reports/reports_repository.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSalesReport_0 extends _i1.SmartFake implements _i2.SalesReport {
  _FakeSalesReport_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRevenueReport_1 extends _i1.SmartFake implements _i3.RevenueReport {
  _FakeRevenueReport_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ReportsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockReportsRepository extends _i1.Mock implements _i4.ReportsRepository {
  MockReportsRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.SalesReport> getSalesReport({
    required DateTime? startDate,
    required DateTime? endDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSalesReport,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
          },
        ),
        returnValue: _i5.Future<_i2.SalesReport>.value(_FakeSalesReport_0(
          this,
          Invocation.method(
            #getSalesReport,
            [],
            {
              #startDate: startDate,
              #endDate: endDate,
            },
          ),
        )),
      ) as _i5.Future<_i2.SalesReport>);

  @override
  _i5.Future<_i3.RevenueReport> getRevenueReport({
    required DateTime? startDate,
    required DateTime? endDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRevenueReport,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
          },
        ),
        returnValue: _i5.Future<_i3.RevenueReport>.value(_FakeRevenueReport_1(
          this,
          Invocation.method(
            #getRevenueReport,
            [],
            {
              #startDate: startDate,
              #endDate: endDate,
            },
          ),
        )),
      ) as _i5.Future<_i3.RevenueReport>);

  @override
  _i5.Future<List<Map<String, dynamic>>> getDetailedTransactions({
    required DateTime? startDate,
    required DateTime? endDate,
    int? page = 1,
    int? limit = 50,
    String? status,
    String? paymentMethod,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDetailedTransactions,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
            #page: page,
            #limit: limit,
            #status: status,
            #paymentMethod: paymentMethod,
          },
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i5.Future<List<Map<String, dynamic>>>);

  @override
  _i5.Future<Map<String, dynamic>> getInventoryReport() => (super.noSuchMethod(
        Invocation.method(
          #getInventoryReport,
          [],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<List<Map<String, dynamic>>> getTopSellingItems({
    int? limit = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTopSellingItems,
          [],
          {
            #limit: limit,
            #startDate: startDate,
            #endDate: endDate,
          },
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i5.Future<List<Map<String, dynamic>>>);

  @override
  _i5.Future<Map<String, double>> getSalesTrends({
    required String? period,
    required DateTime? startDate,
    required DateTime? endDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSalesTrends,
          [],
          {
            #period: period,
            #startDate: startDate,
            #endDate: endDate,
          },
        ),
        returnValue: _i5.Future<Map<String, double>>.value(<String, double>{}),
      ) as _i5.Future<Map<String, double>>);

  @override
  _i5.Future<Map<String, dynamic>> getCustomerAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCustomerAnalytics,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<String> exportReport({
    required String? reportType,
    required DateTime? startDate,
    required DateTime? endDate,
    String? format = 'csv',
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #exportReport,
          [],
          {
            #reportType: reportType,
            #startDate: startDate,
            #endDate: endDate,
            #format: format,
          },
        ),
        returnValue: _i5.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #exportReport,
            [],
            {
              #reportType: reportType,
              #startDate: startDate,
              #endDate: endDate,
              #format: format,
            },
          ),
        )),
      ) as _i5.Future<String>);
}
