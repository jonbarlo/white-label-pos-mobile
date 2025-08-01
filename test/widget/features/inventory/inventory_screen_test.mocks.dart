// Mocks generated by Mockito 5.4.5 from annotations
// in white_label_pos_mobile/test/widget/features/inventory/inventory_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart'
    as _i3;
import 'package:white_label_pos_mobile/src/features/inventory/models/category.dart'
    as _i6;
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart'
    as _i5;
import 'package:white_label_pos_mobile/src/shared/models/result.dart' as _i2;

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

class _FakeResult_0<T> extends _i1.SmartFake implements _i2.Result<T> {
  _FakeResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [InventoryRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockInventoryRepository extends _i1.Mock
    implements _i3.InventoryRepository {
  MockInventoryRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Result<List<_i5.InventoryItem>>> getInventoryItems() =>
      (super.noSuchMethod(
        Invocation.method(
          #getInventoryItems,
          [],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.InventoryItem>>>.value(
            _FakeResult_0<List<_i5.InventoryItem>>(
          this,
          Invocation.method(
            #getInventoryItems,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.InventoryItem>>>);

  @override
  _i4.Future<_i2.Result<_i5.InventoryItem>> getInventoryItem(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getInventoryItem,
          [id],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.InventoryItem>>.value(
            _FakeResult_0<_i5.InventoryItem>(
          this,
          Invocation.method(
            #getInventoryItem,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.InventoryItem>>);

  @override
  _i4.Future<_i2.Result<_i5.InventoryItem>> createInventoryItem(
          _i5.InventoryItem? item) =>
      (super.noSuchMethod(
        Invocation.method(
          #createInventoryItem,
          [item],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.InventoryItem>>.value(
            _FakeResult_0<_i5.InventoryItem>(
          this,
          Invocation.method(
            #createInventoryItem,
            [item],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.InventoryItem>>);

  @override
  _i4.Future<_i2.Result<_i5.InventoryItem>> updateInventoryItem(
          _i5.InventoryItem? item) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateInventoryItem,
          [item],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.InventoryItem>>.value(
            _FakeResult_0<_i5.InventoryItem>(
          this,
          Invocation.method(
            #updateInventoryItem,
            [item],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.InventoryItem>>);

  @override
  _i4.Future<_i2.Result<bool>> deleteInventoryItem(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteInventoryItem,
          [id],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #deleteInventoryItem,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);

  @override
  _i4.Future<_i2.Result<_i5.InventoryItem>> updateStockLevel(
    String? id,
    int? newQuantity,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateStockLevel,
          [
            id,
            newQuantity,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.InventoryItem>>.value(
            _FakeResult_0<_i5.InventoryItem>(
          this,
          Invocation.method(
            #updateStockLevel,
            [
              id,
              newQuantity,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.InventoryItem>>);

  @override
  _i4.Future<_i2.Result<List<_i5.InventoryItem>>> getLowStockItems() =>
      (super.noSuchMethod(
        Invocation.method(
          #getLowStockItems,
          [],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.InventoryItem>>>.value(
            _FakeResult_0<List<_i5.InventoryItem>>(
          this,
          Invocation.method(
            #getLowStockItems,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.InventoryItem>>>);

  @override
  _i4.Future<_i2.Result<List<_i6.Category>>> getCategories(
          {required int? businessId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCategories,
          [],
          {#businessId: businessId},
        ),
        returnValue: _i4.Future<_i2.Result<List<_i6.Category>>>.value(
            _FakeResult_0<List<_i6.Category>>(
          this,
          Invocation.method(
            #getCategories,
            [],
            {#businessId: businessId},
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i6.Category>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.InventoryItem>>> searchItems(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchItems,
          [query],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.InventoryItem>>>.value(
            _FakeResult_0<List<_i5.InventoryItem>>(
          this,
          Invocation.method(
            #searchItems,
            [query],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.InventoryItem>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.InventoryItem>>> getItemsByCategory(
          String? category) =>
      (super.noSuchMethod(
        Invocation.method(
          #getItemsByCategory,
          [category],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.InventoryItem>>>.value(
            _FakeResult_0<List<_i5.InventoryItem>>(
          this,
          Invocation.method(
            #getItemsByCategory,
            [category],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.InventoryItem>>>);
}
