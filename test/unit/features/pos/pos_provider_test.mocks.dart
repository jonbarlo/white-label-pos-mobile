// Mocks generated by Mockito 5.4.5 from annotations
// in white_label_pos_mobile/test/unit/features/pos/pos_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:white_label_pos_mobile/src/features/pos/models/analytics.dart'
    as _i3;
import 'package:white_label_pos_mobile/src/features/pos/models/cart_item.dart'
    as _i7;
import 'package:white_label_pos_mobile/src/features/pos/models/sale.dart'
    as _i2;
import 'package:white_label_pos_mobile/src/features/pos/models/split_payment.dart'
    as _i4;
import 'package:white_label_pos_mobile/src/features/pos/pos_repository.dart'
    as _i5;

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

class _FakeSale_0 extends _i1.SmartFake implements _i2.Sale {
  _FakeSale_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeItemAnalytics_1 extends _i1.SmartFake implements _i3.ItemAnalytics {
  _FakeItemAnalytics_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRevenueAnalytics_2 extends _i1.SmartFake
    implements _i3.RevenueAnalytics {
  _FakeRevenueAnalytics_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStaffAnalytics_3 extends _i1.SmartFake
    implements _i3.StaffAnalytics {
  _FakeStaffAnalytics_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCustomerAnalytics_4 extends _i1.SmartFake
    implements _i3.CustomerAnalytics {
  _FakeCustomerAnalytics_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeInventoryAnalytics_5 extends _i1.SmartFake
    implements _i3.InventoryAnalytics {
  _FakeInventoryAnalytics_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSplitSaleResponse_6 extends _i1.SmartFake
    implements _i4.SplitSaleResponse {
  _FakeSplitSaleResponse_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSplitSale_7 extends _i1.SmartFake implements _i4.SplitSale {
  _FakeSplitSale_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSplitBillingStats_8 extends _i1.SmartFake
    implements _i4.SplitBillingStats {
  _FakeSplitBillingStats_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PosRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPosRepository extends _i1.Mock implements _i5.PosRepository {
  MockPosRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<List<_i7.CartItem>> searchItems(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchItems,
          [query],
        ),
        returnValue: _i6.Future<List<_i7.CartItem>>.value(<_i7.CartItem>[]),
      ) as _i6.Future<List<_i7.CartItem>>);

  @override
  _i6.Future<_i7.CartItem?> getItemByBarcode(String? barcode) =>
      (super.noSuchMethod(
        Invocation.method(
          #getItemByBarcode,
          [barcode],
        ),
        returnValue: _i6.Future<_i7.CartItem?>.value(),
      ) as _i6.Future<_i7.CartItem?>);

  @override
  _i6.Future<_i2.Sale> createSale({
    required List<_i7.CartItem>? items,
    required _i2.PaymentMethod? paymentMethod,
    String? customerName,
    String? customerEmail,
    int? existingOrderId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createSale,
          [],
          {
            #items: items,
            #paymentMethod: paymentMethod,
            #customerName: customerName,
            #customerEmail: customerEmail,
            #existingOrderId: existingOrderId,
          },
        ),
        returnValue: _i6.Future<_i2.Sale>.value(_FakeSale_0(
          this,
          Invocation.method(
            #createSale,
            [],
            {
              #items: items,
              #paymentMethod: paymentMethod,
              #customerName: customerName,
              #customerEmail: customerEmail,
              #existingOrderId: existingOrderId,
            },
          ),
        )),
      ) as _i6.Future<_i2.Sale>);

  @override
  _i6.Future<List<_i2.Sale>> getRecentSales({int? limit = 50}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRecentSales,
          [],
          {#limit: limit},
        ),
        returnValue: _i6.Future<List<_i2.Sale>>.value(<_i2.Sale>[]),
      ) as _i6.Future<List<_i2.Sale>>);

  @override
  _i6.Future<_i2.Sale?> getSaleWithItems(String? saleId) => (super.noSuchMethod(
        Invocation.method(
          #getSaleWithItems,
          [saleId],
        ),
        returnValue: _i6.Future<_i2.Sale?>.value(),
      ) as _i6.Future<_i2.Sale?>);

  @override
  _i6.Future<Map<String, dynamic>> getSalesSummary({
    required DateTime? startDate,
    required DateTime? endDate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSalesSummary,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
          },
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);

  @override
  _i6.Future<List<_i7.CartItem>> getTopSellingItems({int? limit = 10}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTopSellingItems,
          [],
          {#limit: limit},
        ),
        returnValue: _i6.Future<List<_i7.CartItem>>.value(<_i7.CartItem>[]),
      ) as _i6.Future<List<_i7.CartItem>>);

  @override
  _i6.Future<void> updateStockLevels(List<_i7.CartItem>? items) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateStockLevels,
          [items],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i3.ItemAnalytics> getItemAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getItemAnalytics,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
            #limit: limit,
          },
        ),
        returnValue: _i6.Future<_i3.ItemAnalytics>.value(_FakeItemAnalytics_1(
          this,
          Invocation.method(
            #getItemAnalytics,
            [],
            {
              #startDate: startDate,
              #endDate: endDate,
              #limit: limit,
            },
          ),
        )),
      ) as _i6.Future<_i3.ItemAnalytics>);

  @override
  _i6.Future<_i3.RevenueAnalytics> getRevenueAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? period,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRevenueAnalytics,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
            #period: period,
          },
        ),
        returnValue:
            _i6.Future<_i3.RevenueAnalytics>.value(_FakeRevenueAnalytics_2(
          this,
          Invocation.method(
            #getRevenueAnalytics,
            [],
            {
              #startDate: startDate,
              #endDate: endDate,
              #period: period,
            },
          ),
        )),
      ) as _i6.Future<_i3.RevenueAnalytics>);

  @override
  _i6.Future<_i3.StaffAnalytics> getStaffAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getStaffAnalytics,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
            #limit: limit,
          },
        ),
        returnValue: _i6.Future<_i3.StaffAnalytics>.value(_FakeStaffAnalytics_3(
          this,
          Invocation.method(
            #getStaffAnalytics,
            [],
            {
              #startDate: startDate,
              #endDate: endDate,
              #limit: limit,
            },
          ),
        )),
      ) as _i6.Future<_i3.StaffAnalytics>);

  @override
  _i6.Future<_i3.CustomerAnalytics> getCustomerAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCustomerAnalytics,
          [],
          {
            #startDate: startDate,
            #endDate: endDate,
            #limit: limit,
          },
        ),
        returnValue:
            _i6.Future<_i3.CustomerAnalytics>.value(_FakeCustomerAnalytics_4(
          this,
          Invocation.method(
            #getCustomerAnalytics,
            [],
            {
              #startDate: startDate,
              #endDate: endDate,
              #limit: limit,
            },
          ),
        )),
      ) as _i6.Future<_i3.CustomerAnalytics>);

  @override
  _i6.Future<_i3.InventoryAnalytics> getInventoryAnalytics({int? limit}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getInventoryAnalytics,
          [],
          {#limit: limit},
        ),
        returnValue:
            _i6.Future<_i3.InventoryAnalytics>.value(_FakeInventoryAnalytics_5(
          this,
          Invocation.method(
            #getInventoryAnalytics,
            [],
            {#limit: limit},
          ),
        )),
      ) as _i6.Future<_i3.InventoryAnalytics>);

  @override
  _i6.Future<_i4.SplitSaleResponse> createSplitSale(
          _i4.SplitSaleRequest? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #createSplitSale,
          [request],
        ),
        returnValue:
            _i6.Future<_i4.SplitSaleResponse>.value(_FakeSplitSaleResponse_6(
          this,
          Invocation.method(
            #createSplitSale,
            [request],
          ),
        )),
      ) as _i6.Future<_i4.SplitSaleResponse>);

  @override
  _i6.Future<_i4.SplitSale> addPaymentToSale(
    int? saleId,
    _i4.AddPaymentRequest? request,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addPaymentToSale,
          [
            saleId,
            request,
          ],
        ),
        returnValue: _i6.Future<_i4.SplitSale>.value(_FakeSplitSale_7(
          this,
          Invocation.method(
            #addPaymentToSale,
            [
              saleId,
              request,
            ],
          ),
        )),
      ) as _i6.Future<_i4.SplitSale>);

  @override
  _i6.Future<_i4.SplitSale> refundSplitPayment(
    int? saleId,
    _i4.RefundRequest? request,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #refundSplitPayment,
          [
            saleId,
            request,
          ],
        ),
        returnValue: _i6.Future<_i4.SplitSale>.value(_FakeSplitSale_7(
          this,
          Invocation.method(
            #refundSplitPayment,
            [
              saleId,
              request,
            ],
          ),
        )),
      ) as _i6.Future<_i4.SplitSale>);

  @override
  _i6.Future<_i4.SplitBillingStats> getSplitBillingStats() =>
      (super.noSuchMethod(
        Invocation.method(
          #getSplitBillingStats,
          [],
        ),
        returnValue:
            _i6.Future<_i4.SplitBillingStats>.value(_FakeSplitBillingStats_8(
          this,
          Invocation.method(
            #getSplitBillingStats,
            [],
          ),
        )),
      ) as _i6.Future<_i4.SplitBillingStats>);

  @override
  _i6.Future<List<String>> getCategories() => (super.noSuchMethod(
        Invocation.method(
          #getCategories,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);

  @override
  _i6.Future<List<_i7.CartItem>> getItemsByCategory(String? category) =>
      (super.noSuchMethod(
        Invocation.method(
          #getItemsByCategory,
          [category],
        ),
        returnValue: _i6.Future<List<_i7.CartItem>>.value(<_i7.CartItem>[]),
      ) as _i6.Future<List<_i7.CartItem>>);

  @override
  _i6.Future<List<_i7.CartItem>> getAllItems() => (super.noSuchMethod(
        Invocation.method(
          #getAllItems,
          [],
        ),
        returnValue: _i6.Future<List<_i7.CartItem>>.value(<_i7.CartItem>[]),
      ) as _i6.Future<List<_i7.CartItem>>);

  @override
  _i6.Future<List<Map<String, dynamic>>> getTableOrdersReadyToCharge() =>
      (super.noSuchMethod(
        Invocation.method(
          #getTableOrdersReadyToCharge,
          [],
        ),
        returnValue: _i6.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i6.Future<List<Map<String, dynamic>>>);

  @override
  _i6.Future<List<Map<String, dynamic>>> getRestaurantOrders() =>
      (super.noSuchMethod(
        Invocation.method(
          #getRestaurantOrders,
          [],
        ),
        returnValue: _i6.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i6.Future<List<Map<String, dynamic>>>);

  @override
  _i6.Future<List<Map<String, dynamic>>> getDailyTransactions() =>
      (super.noSuchMethod(
        Invocation.method(
          #getDailyTransactions,
          [],
        ),
        returnValue: _i6.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i6.Future<List<Map<String, dynamic>>>);

  @override
  _i6.Future<List<Map<String, dynamic>>> getInventoryStatus() =>
      (super.noSuchMethod(
        Invocation.method(
          #getInventoryStatus,
          [],
        ),
        returnValue: _i6.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i6.Future<List<Map<String, dynamic>>>);
}
