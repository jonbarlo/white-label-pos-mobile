// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'split_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SplitPayment _$SplitPaymentFromJson(Map<String, dynamic> json) {
  return _SplitPayment.fromJson(json);
}

/// @nodoc
mixin _$SplitPayment {
  double get amount => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;

  /// Serializes this SplitPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplitPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplitPaymentCopyWith<SplitPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitPaymentCopyWith<$Res> {
  factory $SplitPaymentCopyWith(
          SplitPayment value, $Res Function(SplitPayment) then) =
      _$SplitPaymentCopyWithImpl<$Res, SplitPayment>;
  @useResult
  $Res call(
      {double amount,
      String method,
      String? customerName,
      String? customerPhone,
      String? reference,
      DateTime? paidAt});
}

/// @nodoc
class _$SplitPaymentCopyWithImpl<$Res, $Val extends SplitPayment>
    implements $SplitPaymentCopyWith<$Res> {
  _$SplitPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplitPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? method = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? reference = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplitPaymentImplCopyWith<$Res>
    implements $SplitPaymentCopyWith<$Res> {
  factory _$$SplitPaymentImplCopyWith(
          _$SplitPaymentImpl value, $Res Function(_$SplitPaymentImpl) then) =
      __$$SplitPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String method,
      String? customerName,
      String? customerPhone,
      String? reference,
      DateTime? paidAt});
}

/// @nodoc
class __$$SplitPaymentImplCopyWithImpl<$Res>
    extends _$SplitPaymentCopyWithImpl<$Res, _$SplitPaymentImpl>
    implements _$$SplitPaymentImplCopyWith<$Res> {
  __$$SplitPaymentImplCopyWithImpl(
      _$SplitPaymentImpl _value, $Res Function(_$SplitPaymentImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplitPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? method = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? reference = freezed,
    Object? paidAt = freezed,
  }) {
    return _then(_$SplitPaymentImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplitPaymentImpl implements _SplitPayment {
  const _$SplitPaymentImpl(
      {required this.amount,
      required this.method,
      this.customerName,
      this.customerPhone,
      this.reference,
      this.paidAt});

  factory _$SplitPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplitPaymentImplFromJson(json);

  @override
  final double amount;
  @override
  final String method;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? reference;
  @override
  final DateTime? paidAt;

  @override
  String toString() {
    return 'SplitPayment(amount: $amount, method: $method, customerName: $customerName, customerPhone: $customerPhone, reference: $reference, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplitPaymentImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, method, customerName,
      customerPhone, reference, paidAt);

  /// Create a copy of SplitPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplitPaymentImplCopyWith<_$SplitPaymentImpl> get copyWith =>
      __$$SplitPaymentImplCopyWithImpl<_$SplitPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplitPaymentImplToJson(
      this,
    );
  }
}

abstract class _SplitPayment implements SplitPayment {
  const factory _SplitPayment(
      {required final double amount,
      required final String method,
      final String? customerName,
      final String? customerPhone,
      final String? reference,
      final DateTime? paidAt}) = _$SplitPaymentImpl;

  factory _SplitPayment.fromJson(Map<String, dynamic> json) =
      _$SplitPaymentImpl.fromJson;

  @override
  double get amount;
  @override
  String get method;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get reference;
  @override
  DateTime? get paidAt;

  /// Create a copy of SplitPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplitPaymentImplCopyWith<_$SplitPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SplitSaleRequest _$SplitSaleRequestFromJson(Map<String, dynamic> json) {
  return _SplitSaleRequest.fromJson(json);
}

/// @nodoc
mixin _$SplitSaleRequest {
  int get userId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get customerEmail => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<SplitSaleItem>? get items => throw _privateConstructorUsedError;
  List<SplitPayment> get payments => throw _privateConstructorUsedError;

  /// Serializes this SplitSaleRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplitSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplitSaleRequestCopyWith<SplitSaleRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitSaleRequestCopyWith<$Res> {
  factory $SplitSaleRequestCopyWith(
          SplitSaleRequest value, $Res Function(SplitSaleRequest) then) =
      _$SplitSaleRequestCopyWithImpl<$Res, SplitSaleRequest>;
  @useResult
  $Res call(
      {int userId,
      double totalAmount,
      String? customerName,
      String? customerPhone,
      String? customerEmail,
      String? notes,
      List<SplitSaleItem>? items,
      List<SplitPayment> payments});
}

/// @nodoc
class _$SplitSaleRequestCopyWithImpl<$Res, $Val extends SplitSaleRequest>
    implements $SplitSaleRequestCopyWith<$Res> {
  _$SplitSaleRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplitSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalAmount = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? notes = freezed,
    Object? items = freezed,
    Object? payments = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SplitSaleItem>?,
      payments: null == payments
          ? _value.payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<SplitPayment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplitSaleRequestImplCopyWith<$Res>
    implements $SplitSaleRequestCopyWith<$Res> {
  factory _$$SplitSaleRequestImplCopyWith(_$SplitSaleRequestImpl value,
          $Res Function(_$SplitSaleRequestImpl) then) =
      __$$SplitSaleRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int userId,
      double totalAmount,
      String? customerName,
      String? customerPhone,
      String? customerEmail,
      String? notes,
      List<SplitSaleItem>? items,
      List<SplitPayment> payments});
}

/// @nodoc
class __$$SplitSaleRequestImplCopyWithImpl<$Res>
    extends _$SplitSaleRequestCopyWithImpl<$Res, _$SplitSaleRequestImpl>
    implements _$$SplitSaleRequestImplCopyWith<$Res> {
  __$$SplitSaleRequestImplCopyWithImpl(_$SplitSaleRequestImpl _value,
      $Res Function(_$SplitSaleRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplitSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalAmount = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? notes = freezed,
    Object? items = freezed,
    Object? payments = null,
  }) {
    return _then(_$SplitSaleRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SplitSaleItem>?,
      payments: null == payments
          ? _value._payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<SplitPayment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplitSaleRequestImpl implements _SplitSaleRequest {
  const _$SplitSaleRequestImpl(
      {required this.userId,
      required this.totalAmount,
      this.customerName,
      this.customerPhone,
      this.customerEmail,
      this.notes,
      final List<SplitSaleItem>? items,
      required final List<SplitPayment> payments})
      : _items = items,
        _payments = payments;

  factory _$SplitSaleRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplitSaleRequestImplFromJson(json);

  @override
  final int userId;
  @override
  final double totalAmount;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? customerEmail;
  @override
  final String? notes;
  final List<SplitSaleItem>? _items;
  @override
  List<SplitSaleItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SplitPayment> _payments;
  @override
  List<SplitPayment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  String toString() {
    return 'SplitSaleRequest(userId: $userId, totalAmount: $totalAmount, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, notes: $notes, items: $items, payments: $payments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplitSaleRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._payments, _payments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalAmount,
      customerName,
      customerPhone,
      customerEmail,
      notes,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_payments));

  /// Create a copy of SplitSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplitSaleRequestImplCopyWith<_$SplitSaleRequestImpl> get copyWith =>
      __$$SplitSaleRequestImplCopyWithImpl<_$SplitSaleRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplitSaleRequestImplToJson(
      this,
    );
  }
}

abstract class _SplitSaleRequest implements SplitSaleRequest {
  const factory _SplitSaleRequest(
      {required final int userId,
      required final double totalAmount,
      final String? customerName,
      final String? customerPhone,
      final String? customerEmail,
      final String? notes,
      final List<SplitSaleItem>? items,
      required final List<SplitPayment> payments}) = _$SplitSaleRequestImpl;

  factory _SplitSaleRequest.fromJson(Map<String, dynamic> json) =
      _$SplitSaleRequestImpl.fromJson;

  @override
  int get userId;
  @override
  double get totalAmount;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get customerEmail;
  @override
  String? get notes;
  @override
  List<SplitSaleItem>? get items;
  @override
  List<SplitPayment> get payments;

  /// Create a copy of SplitSaleRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplitSaleRequestImplCopyWith<_$SplitSaleRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SplitSaleItem _$SplitSaleItemFromJson(Map<String, dynamic> json) {
  return _SplitSaleItem.fromJson(json);
}

/// @nodoc
mixin _$SplitSaleItem {
  int get itemId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;

  /// Serializes this SplitSaleItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplitSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplitSaleItemCopyWith<SplitSaleItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitSaleItemCopyWith<$Res> {
  factory $SplitSaleItemCopyWith(
          SplitSaleItem value, $Res Function(SplitSaleItem) then) =
      _$SplitSaleItemCopyWithImpl<$Res, SplitSaleItem>;
  @useResult
  $Res call({int itemId, int quantity, double unitPrice});
}

/// @nodoc
class _$SplitSaleItemCopyWithImpl<$Res, $Val extends SplitSaleItem>
    implements $SplitSaleItemCopyWith<$Res> {
  _$SplitSaleItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplitSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? quantity = null,
    Object? unitPrice = null,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplitSaleItemImplCopyWith<$Res>
    implements $SplitSaleItemCopyWith<$Res> {
  factory _$$SplitSaleItemImplCopyWith(
          _$SplitSaleItemImpl value, $Res Function(_$SplitSaleItemImpl) then) =
      __$$SplitSaleItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int itemId, int quantity, double unitPrice});
}

/// @nodoc
class __$$SplitSaleItemImplCopyWithImpl<$Res>
    extends _$SplitSaleItemCopyWithImpl<$Res, _$SplitSaleItemImpl>
    implements _$$SplitSaleItemImplCopyWith<$Res> {
  __$$SplitSaleItemImplCopyWithImpl(
      _$SplitSaleItemImpl _value, $Res Function(_$SplitSaleItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplitSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? quantity = null,
    Object? unitPrice = null,
  }) {
    return _then(_$SplitSaleItemImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplitSaleItemImpl implements _SplitSaleItem {
  const _$SplitSaleItemImpl(
      {required this.itemId, required this.quantity, required this.unitPrice});

  factory _$SplitSaleItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplitSaleItemImplFromJson(json);

  @override
  final int itemId;
  @override
  final int quantity;
  @override
  final double unitPrice;

  @override
  String toString() {
    return 'SplitSaleItem(itemId: $itemId, quantity: $quantity, unitPrice: $unitPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplitSaleItemImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemId, quantity, unitPrice);

  /// Create a copy of SplitSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplitSaleItemImplCopyWith<_$SplitSaleItemImpl> get copyWith =>
      __$$SplitSaleItemImplCopyWithImpl<_$SplitSaleItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplitSaleItemImplToJson(
      this,
    );
  }
}

abstract class _SplitSaleItem implements SplitSaleItem {
  const factory _SplitSaleItem(
      {required final int itemId,
      required final int quantity,
      required final double unitPrice}) = _$SplitSaleItemImpl;

  factory _SplitSaleItem.fromJson(Map<String, dynamic> json) =
      _$SplitSaleItemImpl.fromJson;

  @override
  int get itemId;
  @override
  int get quantity;
  @override
  double get unitPrice;

  /// Create a copy of SplitSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplitSaleItemImplCopyWith<_$SplitSaleItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SplitSaleResponse _$SplitSaleResponseFromJson(Map<String, dynamic> json) {
  return _SplitSaleResponse.fromJson(json);
}

/// @nodoc
mixin _$SplitSaleResponse {
  String get message => throw _privateConstructorUsedError;
  SplitSale get sale => throw _privateConstructorUsedError;

  /// Serializes this SplitSaleResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplitSaleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplitSaleResponseCopyWith<SplitSaleResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitSaleResponseCopyWith<$Res> {
  factory $SplitSaleResponseCopyWith(
          SplitSaleResponse value, $Res Function(SplitSaleResponse) then) =
      _$SplitSaleResponseCopyWithImpl<$Res, SplitSaleResponse>;
  @useResult
  $Res call({String message, SplitSale sale});

  $SplitSaleCopyWith<$Res> get sale;
}

/// @nodoc
class _$SplitSaleResponseCopyWithImpl<$Res, $Val extends SplitSaleResponse>
    implements $SplitSaleResponseCopyWith<$Res> {
  _$SplitSaleResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplitSaleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? sale = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sale: null == sale
          ? _value.sale
          : sale // ignore: cast_nullable_to_non_nullable
              as SplitSale,
    ) as $Val);
  }

  /// Create a copy of SplitSaleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SplitSaleCopyWith<$Res> get sale {
    return $SplitSaleCopyWith<$Res>(_value.sale, (value) {
      return _then(_value.copyWith(sale: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SplitSaleResponseImplCopyWith<$Res>
    implements $SplitSaleResponseCopyWith<$Res> {
  factory _$$SplitSaleResponseImplCopyWith(_$SplitSaleResponseImpl value,
          $Res Function(_$SplitSaleResponseImpl) then) =
      __$$SplitSaleResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, SplitSale sale});

  @override
  $SplitSaleCopyWith<$Res> get sale;
}

/// @nodoc
class __$$SplitSaleResponseImplCopyWithImpl<$Res>
    extends _$SplitSaleResponseCopyWithImpl<$Res, _$SplitSaleResponseImpl>
    implements _$$SplitSaleResponseImplCopyWith<$Res> {
  __$$SplitSaleResponseImplCopyWithImpl(_$SplitSaleResponseImpl _value,
      $Res Function(_$SplitSaleResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplitSaleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? sale = null,
  }) {
    return _then(_$SplitSaleResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sale: null == sale
          ? _value.sale
          : sale // ignore: cast_nullable_to_non_nullable
              as SplitSale,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplitSaleResponseImpl implements _SplitSaleResponse {
  const _$SplitSaleResponseImpl({required this.message, required this.sale});

  factory _$SplitSaleResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplitSaleResponseImplFromJson(json);

  @override
  final String message;
  @override
  final SplitSale sale;

  @override
  String toString() {
    return 'SplitSaleResponse(message: $message, sale: $sale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplitSaleResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.sale, sale) || other.sale == sale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, sale);

  /// Create a copy of SplitSaleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplitSaleResponseImplCopyWith<_$SplitSaleResponseImpl> get copyWith =>
      __$$SplitSaleResponseImplCopyWithImpl<_$SplitSaleResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplitSaleResponseImplToJson(
      this,
    );
  }
}

abstract class _SplitSaleResponse implements SplitSaleResponse {
  const factory _SplitSaleResponse(
      {required final String message,
      required final SplitSale sale}) = _$SplitSaleResponseImpl;

  factory _SplitSaleResponse.fromJson(Map<String, dynamic> json) =
      _$SplitSaleResponseImpl.fromJson;

  @override
  String get message;
  @override
  SplitSale get sale;

  /// Create a copy of SplitSaleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplitSaleResponseImplCopyWith<_$SplitSaleResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SplitSale _$SplitSaleFromJson(Map<String, dynamic> json) {
  return _SplitSale.fromJson(json);
}

/// @nodoc
mixin _$SplitSale {
  int get id => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<SplitPayment> get payments => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get customerEmail => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  double? get totalPaid => throw _privateConstructorUsedError;
  double? get remainingAmount => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SplitSale to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplitSale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplitSaleCopyWith<SplitSale> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitSaleCopyWith<$Res> {
  factory $SplitSaleCopyWith(SplitSale value, $Res Function(SplitSale) then) =
      _$SplitSaleCopyWithImpl<$Res, SplitSale>;
  @useResult
  $Res call(
      {int id,
      double totalAmount,
      String status,
      List<SplitPayment> payments,
      DateTime createdAt,
      String? customerName,
      String? customerPhone,
      String? customerEmail,
      String? notes,
      double? totalPaid,
      double? remainingAmount,
      DateTime? updatedAt});
}

/// @nodoc
class _$SplitSaleCopyWithImpl<$Res, $Val extends SplitSale>
    implements $SplitSaleCopyWith<$Res> {
  _$SplitSaleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplitSale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? payments = null,
    Object? createdAt = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? notes = freezed,
    Object? totalPaid = freezed,
    Object? remainingAmount = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      payments: null == payments
          ? _value.payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<SplitPayment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPaid: freezed == totalPaid
          ? _value.totalPaid
          : totalPaid // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplitSaleImplCopyWith<$Res>
    implements $SplitSaleCopyWith<$Res> {
  factory _$$SplitSaleImplCopyWith(
          _$SplitSaleImpl value, $Res Function(_$SplitSaleImpl) then) =
      __$$SplitSaleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      double totalAmount,
      String status,
      List<SplitPayment> payments,
      DateTime createdAt,
      String? customerName,
      String? customerPhone,
      String? customerEmail,
      String? notes,
      double? totalPaid,
      double? remainingAmount,
      DateTime? updatedAt});
}

/// @nodoc
class __$$SplitSaleImplCopyWithImpl<$Res>
    extends _$SplitSaleCopyWithImpl<$Res, _$SplitSaleImpl>
    implements _$$SplitSaleImplCopyWith<$Res> {
  __$$SplitSaleImplCopyWithImpl(
      _$SplitSaleImpl _value, $Res Function(_$SplitSaleImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplitSale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? payments = null,
    Object? createdAt = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? notes = freezed,
    Object? totalPaid = freezed,
    Object? remainingAmount = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SplitSaleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      payments: null == payments
          ? _value._payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<SplitPayment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPaid: freezed == totalPaid
          ? _value.totalPaid
          : totalPaid // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplitSaleImpl implements _SplitSale {
  const _$SplitSaleImpl(
      {required this.id,
      required this.totalAmount,
      required this.status,
      required final List<SplitPayment> payments,
      required this.createdAt,
      this.customerName,
      this.customerPhone,
      this.customerEmail,
      this.notes,
      this.totalPaid,
      this.remainingAmount,
      this.updatedAt})
      : _payments = payments;

  factory _$SplitSaleImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplitSaleImplFromJson(json);

  @override
  final int id;
  @override
  final double totalAmount;
  @override
  final String status;
  final List<SplitPayment> _payments;
  @override
  List<SplitPayment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  final DateTime createdAt;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? customerEmail;
  @override
  final String? notes;
  @override
  final double? totalPaid;
  @override
  final double? remainingAmount;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SplitSale(id: $id, totalAmount: $totalAmount, status: $status, payments: $payments, createdAt: $createdAt, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, notes: $notes, totalPaid: $totalPaid, remainingAmount: $remainingAmount, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplitSaleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.totalPaid, totalPaid) ||
                other.totalPaid == totalPaid) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      totalAmount,
      status,
      const DeepCollectionEquality().hash(_payments),
      createdAt,
      customerName,
      customerPhone,
      customerEmail,
      notes,
      totalPaid,
      remainingAmount,
      updatedAt);

  /// Create a copy of SplitSale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplitSaleImplCopyWith<_$SplitSaleImpl> get copyWith =>
      __$$SplitSaleImplCopyWithImpl<_$SplitSaleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplitSaleImplToJson(
      this,
    );
  }
}

abstract class _SplitSale implements SplitSale {
  const factory _SplitSale(
      {required final int id,
      required final double totalAmount,
      required final String status,
      required final List<SplitPayment> payments,
      required final DateTime createdAt,
      final String? customerName,
      final String? customerPhone,
      final String? customerEmail,
      final String? notes,
      final double? totalPaid,
      final double? remainingAmount,
      final DateTime? updatedAt}) = _$SplitSaleImpl;

  factory _SplitSale.fromJson(Map<String, dynamic> json) =
      _$SplitSaleImpl.fromJson;

  @override
  int get id;
  @override
  double get totalAmount;
  @override
  String get status;
  @override
  List<SplitPayment> get payments;
  @override
  DateTime get createdAt;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get customerEmail;
  @override
  String? get notes;
  @override
  double? get totalPaid;
  @override
  double? get remainingAmount;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SplitSale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplitSaleImplCopyWith<_$SplitSaleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddPaymentRequest _$AddPaymentRequestFromJson(Map<String, dynamic> json) {
  return _AddPaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$AddPaymentRequest {
  double get amount => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;

  /// Serializes this AddPaymentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddPaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddPaymentRequestCopyWith<AddPaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddPaymentRequestCopyWith<$Res> {
  factory $AddPaymentRequestCopyWith(
          AddPaymentRequest value, $Res Function(AddPaymentRequest) then) =
      _$AddPaymentRequestCopyWithImpl<$Res, AddPaymentRequest>;
  @useResult
  $Res call(
      {double amount,
      String method,
      String? customerName,
      String? customerPhone,
      String? reference});
}

/// @nodoc
class _$AddPaymentRequestCopyWithImpl<$Res, $Val extends AddPaymentRequest>
    implements $AddPaymentRequestCopyWith<$Res> {
  _$AddPaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddPaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? method = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? reference = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddPaymentRequestImplCopyWith<$Res>
    implements $AddPaymentRequestCopyWith<$Res> {
  factory _$$AddPaymentRequestImplCopyWith(_$AddPaymentRequestImpl value,
          $Res Function(_$AddPaymentRequestImpl) then) =
      __$$AddPaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String method,
      String? customerName,
      String? customerPhone,
      String? reference});
}

/// @nodoc
class __$$AddPaymentRequestImplCopyWithImpl<$Res>
    extends _$AddPaymentRequestCopyWithImpl<$Res, _$AddPaymentRequestImpl>
    implements _$$AddPaymentRequestImplCopyWith<$Res> {
  __$$AddPaymentRequestImplCopyWithImpl(_$AddPaymentRequestImpl _value,
      $Res Function(_$AddPaymentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddPaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? method = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? reference = freezed,
  }) {
    return _then(_$AddPaymentRequestImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddPaymentRequestImpl implements _AddPaymentRequest {
  const _$AddPaymentRequestImpl(
      {required this.amount,
      required this.method,
      this.customerName,
      this.customerPhone,
      this.reference});

  factory _$AddPaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddPaymentRequestImplFromJson(json);

  @override
  final double amount;
  @override
  final String method;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? reference;

  @override
  String toString() {
    return 'AddPaymentRequest(amount: $amount, method: $method, customerName: $customerName, customerPhone: $customerPhone, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPaymentRequestImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.reference, reference) ||
                other.reference == reference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, amount, method, customerName, customerPhone, reference);

  /// Create a copy of AddPaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPaymentRequestImplCopyWith<_$AddPaymentRequestImpl> get copyWith =>
      __$$AddPaymentRequestImplCopyWithImpl<_$AddPaymentRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddPaymentRequestImplToJson(
      this,
    );
  }
}

abstract class _AddPaymentRequest implements AddPaymentRequest {
  const factory _AddPaymentRequest(
      {required final double amount,
      required final String method,
      final String? customerName,
      final String? customerPhone,
      final String? reference}) = _$AddPaymentRequestImpl;

  factory _AddPaymentRequest.fromJson(Map<String, dynamic> json) =
      _$AddPaymentRequestImpl.fromJson;

  @override
  double get amount;
  @override
  String get method;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  String? get reference;

  /// Create a copy of AddPaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddPaymentRequestImplCopyWith<_$AddPaymentRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) {
  return _RefundRequest.fromJson(json);
}

/// @nodoc
mixin _$RefundRequest {
  int get paymentIndex => throw _privateConstructorUsedError;
  double get refundAmount => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this RefundRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefundRequestCopyWith<RefundRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefundRequestCopyWith<$Res> {
  factory $RefundRequestCopyWith(
          RefundRequest value, $Res Function(RefundRequest) then) =
      _$RefundRequestCopyWithImpl<$Res, RefundRequest>;
  @useResult
  $Res call({int paymentIndex, double refundAmount, String? reason});
}

/// @nodoc
class _$RefundRequestCopyWithImpl<$Res, $Val extends RefundRequest>
    implements $RefundRequestCopyWith<$Res> {
  _$RefundRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentIndex = null,
    Object? refundAmount = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      paymentIndex: null == paymentIndex
          ? _value.paymentIndex
          : paymentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      refundAmount: null == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefundRequestImplCopyWith<$Res>
    implements $RefundRequestCopyWith<$Res> {
  factory _$$RefundRequestImplCopyWith(
          _$RefundRequestImpl value, $Res Function(_$RefundRequestImpl) then) =
      __$$RefundRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int paymentIndex, double refundAmount, String? reason});
}

/// @nodoc
class __$$RefundRequestImplCopyWithImpl<$Res>
    extends _$RefundRequestCopyWithImpl<$Res, _$RefundRequestImpl>
    implements _$$RefundRequestImplCopyWith<$Res> {
  __$$RefundRequestImplCopyWithImpl(
      _$RefundRequestImpl _value, $Res Function(_$RefundRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentIndex = null,
    Object? refundAmount = null,
    Object? reason = freezed,
  }) {
    return _then(_$RefundRequestImpl(
      paymentIndex: null == paymentIndex
          ? _value.paymentIndex
          : paymentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      refundAmount: null == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as double,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefundRequestImpl implements _RefundRequest {
  const _$RefundRequestImpl(
      {required this.paymentIndex, required this.refundAmount, this.reason});

  factory _$RefundRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefundRequestImplFromJson(json);

  @override
  final int paymentIndex;
  @override
  final double refundAmount;
  @override
  final String? reason;

  @override
  String toString() {
    return 'RefundRequest(paymentIndex: $paymentIndex, refundAmount: $refundAmount, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefundRequestImpl &&
            (identical(other.paymentIndex, paymentIndex) ||
                other.paymentIndex == paymentIndex) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paymentIndex, refundAmount, reason);

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefundRequestImplCopyWith<_$RefundRequestImpl> get copyWith =>
      __$$RefundRequestImplCopyWithImpl<_$RefundRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefundRequestImplToJson(
      this,
    );
  }
}

abstract class _RefundRequest implements RefundRequest {
  const factory _RefundRequest(
      {required final int paymentIndex,
      required final double refundAmount,
      final String? reason}) = _$RefundRequestImpl;

  factory _RefundRequest.fromJson(Map<String, dynamic> json) =
      _$RefundRequestImpl.fromJson;

  @override
  int get paymentIndex;
  @override
  double get refundAmount;
  @override
  String? get reason;

  /// Create a copy of RefundRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefundRequestImplCopyWith<_$RefundRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SplitBillingStats _$SplitBillingStatsFromJson(Map<String, dynamic> json) {
  return _SplitBillingStats.fromJson(json);
}

/// @nodoc
mixin _$SplitBillingStats {
  int get totalSplitSales => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get averageSplitAmount => throw _privateConstructorUsedError;
  double get averagePaymentsPerSale => throw _privateConstructorUsedError;

  /// Serializes this SplitBillingStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplitBillingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplitBillingStatsCopyWith<SplitBillingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplitBillingStatsCopyWith<$Res> {
  factory $SplitBillingStatsCopyWith(
          SplitBillingStats value, $Res Function(SplitBillingStats) then) =
      _$SplitBillingStatsCopyWithImpl<$Res, SplitBillingStats>;
  @useResult
  $Res call(
      {int totalSplitSales,
      double totalAmount,
      double averageSplitAmount,
      double averagePaymentsPerSale});
}

/// @nodoc
class _$SplitBillingStatsCopyWithImpl<$Res, $Val extends SplitBillingStats>
    implements $SplitBillingStatsCopyWith<$Res> {
  _$SplitBillingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplitBillingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSplitSales = null,
    Object? totalAmount = null,
    Object? averageSplitAmount = null,
    Object? averagePaymentsPerSale = null,
  }) {
    return _then(_value.copyWith(
      totalSplitSales: null == totalSplitSales
          ? _value.totalSplitSales
          : totalSplitSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averageSplitAmount: null == averageSplitAmount
          ? _value.averageSplitAmount
          : averageSplitAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averagePaymentsPerSale: null == averagePaymentsPerSale
          ? _value.averagePaymentsPerSale
          : averagePaymentsPerSale // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplitBillingStatsImplCopyWith<$Res>
    implements $SplitBillingStatsCopyWith<$Res> {
  factory _$$SplitBillingStatsImplCopyWith(_$SplitBillingStatsImpl value,
          $Res Function(_$SplitBillingStatsImpl) then) =
      __$$SplitBillingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalSplitSales,
      double totalAmount,
      double averageSplitAmount,
      double averagePaymentsPerSale});
}

/// @nodoc
class __$$SplitBillingStatsImplCopyWithImpl<$Res>
    extends _$SplitBillingStatsCopyWithImpl<$Res, _$SplitBillingStatsImpl>
    implements _$$SplitBillingStatsImplCopyWith<$Res> {
  __$$SplitBillingStatsImplCopyWithImpl(_$SplitBillingStatsImpl _value,
      $Res Function(_$SplitBillingStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplitBillingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSplitSales = null,
    Object? totalAmount = null,
    Object? averageSplitAmount = null,
    Object? averagePaymentsPerSale = null,
  }) {
    return _then(_$SplitBillingStatsImpl(
      totalSplitSales: null == totalSplitSales
          ? _value.totalSplitSales
          : totalSplitSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averageSplitAmount: null == averageSplitAmount
          ? _value.averageSplitAmount
          : averageSplitAmount // ignore: cast_nullable_to_non_nullable
              as double,
      averagePaymentsPerSale: null == averagePaymentsPerSale
          ? _value.averagePaymentsPerSale
          : averagePaymentsPerSale // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplitBillingStatsImpl implements _SplitBillingStats {
  const _$SplitBillingStatsImpl(
      {required this.totalSplitSales,
      required this.totalAmount,
      required this.averageSplitAmount,
      required this.averagePaymentsPerSale});

  factory _$SplitBillingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplitBillingStatsImplFromJson(json);

  @override
  final int totalSplitSales;
  @override
  final double totalAmount;
  @override
  final double averageSplitAmount;
  @override
  final double averagePaymentsPerSale;

  @override
  String toString() {
    return 'SplitBillingStats(totalSplitSales: $totalSplitSales, totalAmount: $totalAmount, averageSplitAmount: $averageSplitAmount, averagePaymentsPerSale: $averagePaymentsPerSale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplitBillingStatsImpl &&
            (identical(other.totalSplitSales, totalSplitSales) ||
                other.totalSplitSales == totalSplitSales) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.averageSplitAmount, averageSplitAmount) ||
                other.averageSplitAmount == averageSplitAmount) &&
            (identical(other.averagePaymentsPerSale, averagePaymentsPerSale) ||
                other.averagePaymentsPerSale == averagePaymentsPerSale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalSplitSales, totalAmount,
      averageSplitAmount, averagePaymentsPerSale);

  /// Create a copy of SplitBillingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplitBillingStatsImplCopyWith<_$SplitBillingStatsImpl> get copyWith =>
      __$$SplitBillingStatsImplCopyWithImpl<_$SplitBillingStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplitBillingStatsImplToJson(
      this,
    );
  }
}

abstract class _SplitBillingStats implements SplitBillingStats {
  const factory _SplitBillingStats(
      {required final int totalSplitSales,
      required final double totalAmount,
      required final double averageSplitAmount,
      required final double averagePaymentsPerSale}) = _$SplitBillingStatsImpl;

  factory _SplitBillingStats.fromJson(Map<String, dynamic> json) =
      _$SplitBillingStatsImpl.fromJson;

  @override
  int get totalSplitSales;
  @override
  double get totalAmount;
  @override
  double get averageSplitAmount;
  @override
  double get averagePaymentsPerSale;

  /// Create a copy of SplitBillingStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplitBillingStatsImplCopyWith<_$SplitBillingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
