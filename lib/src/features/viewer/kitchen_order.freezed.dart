// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kitchen_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KitchenOrderItem _$KitchenOrderItemFromJson(Map<String, dynamic> json) {
  return _KitchenOrderItem.fromJson(json);
}

/// @nodoc
mixin _$KitchenOrderItem {
  int get id => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  List<String>? get modifications => throw _privateConstructorUsedError;
  List<String>? get allergens => throw _privateConstructorUsedError;
  int? get preparationTime => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get readyTime => throw _privateConstructorUsedError;
  String? get servedTime => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get assignedToName => throw _privateConstructorUsedError;
  String? get station => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get allergies => throw _privateConstructorUsedError;
  List<String>? get dietaryRestrictions => throw _privateConstructorUsedError;

  /// Serializes this KitchenOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KitchenOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KitchenOrderItemCopyWith<KitchenOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KitchenOrderItemCopyWith<$Res> {
  factory $KitchenOrderItemCopyWith(
          KitchenOrderItem value, $Res Function(KitchenOrderItem) then) =
      _$KitchenOrderItemCopyWithImpl<$Res, KitchenOrderItem>;
  @useResult
  $Res call(
      {int id,
      String itemName,
      int quantity,
      String? status,
      String? specialInstructions,
      List<String>? modifications,
      List<String>? allergens,
      int? preparationTime,
      String? startTime,
      String? readyTime,
      String? servedTime,
      String? assignedTo,
      String? assignedToName,
      String? station,
      String? notes,
      List<String>? allergies,
      List<String>? dietaryRestrictions});
}

/// @nodoc
class _$KitchenOrderItemCopyWithImpl<$Res, $Val extends KitchenOrderItem>
    implements $KitchenOrderItemCopyWith<$Res> {
  _$KitchenOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KitchenOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? status = freezed,
    Object? specialInstructions = freezed,
    Object? modifications = freezed,
    Object? allergens = freezed,
    Object? preparationTime = freezed,
    Object? startTime = freezed,
    Object? readyTime = freezed,
    Object? servedTime = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? station = freezed,
    Object? notes = freezed,
    Object? allergies = freezed,
    Object? dietaryRestrictions = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      modifications: freezed == modifications
          ? _value.modifications
          : modifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      preparationTime: freezed == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      readyTime: freezed == readyTime
          ? _value.readyTime
          : readyTime // ignore: cast_nullable_to_non_nullable
              as String?,
      servedTime: freezed == servedTime
          ? _value.servedTime
          : servedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      station: freezed == station
          ? _value.station
          : station // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KitchenOrderItemImplCopyWith<$Res>
    implements $KitchenOrderItemCopyWith<$Res> {
  factory _$$KitchenOrderItemImplCopyWith(_$KitchenOrderItemImpl value,
          $Res Function(_$KitchenOrderItemImpl) then) =
      __$$KitchenOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String itemName,
      int quantity,
      String? status,
      String? specialInstructions,
      List<String>? modifications,
      List<String>? allergens,
      int? preparationTime,
      String? startTime,
      String? readyTime,
      String? servedTime,
      String? assignedTo,
      String? assignedToName,
      String? station,
      String? notes,
      List<String>? allergies,
      List<String>? dietaryRestrictions});
}

/// @nodoc
class __$$KitchenOrderItemImplCopyWithImpl<$Res>
    extends _$KitchenOrderItemCopyWithImpl<$Res, _$KitchenOrderItemImpl>
    implements _$$KitchenOrderItemImplCopyWith<$Res> {
  __$$KitchenOrderItemImplCopyWithImpl(_$KitchenOrderItemImpl _value,
      $Res Function(_$KitchenOrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of KitchenOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? status = freezed,
    Object? specialInstructions = freezed,
    Object? modifications = freezed,
    Object? allergens = freezed,
    Object? preparationTime = freezed,
    Object? startTime = freezed,
    Object? readyTime = freezed,
    Object? servedTime = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? station = freezed,
    Object? notes = freezed,
    Object? allergies = freezed,
    Object? dietaryRestrictions = freezed,
  }) {
    return _then(_$KitchenOrderItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      modifications: freezed == modifications
          ? _value._modifications
          : modifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      allergens: freezed == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      preparationTime: freezed == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      readyTime: freezed == readyTime
          ? _value.readyTime
          : readyTime // ignore: cast_nullable_to_non_nullable
              as String?,
      servedTime: freezed == servedTime
          ? _value.servedTime
          : servedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      station: freezed == station
          ? _value.station
          : station // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value._dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KitchenOrderItemImpl implements _KitchenOrderItem {
  const _$KitchenOrderItemImpl(
      {required this.id,
      required this.itemName,
      required this.quantity,
      this.status,
      this.specialInstructions,
      final List<String>? modifications,
      final List<String>? allergens,
      this.preparationTime,
      this.startTime,
      this.readyTime,
      this.servedTime,
      this.assignedTo,
      this.assignedToName,
      this.station,
      this.notes,
      final List<String>? allergies,
      final List<String>? dietaryRestrictions})
      : _modifications = modifications,
        _allergens = allergens,
        _allergies = allergies,
        _dietaryRestrictions = dietaryRestrictions;

  factory _$KitchenOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$KitchenOrderItemImplFromJson(json);

  @override
  final int id;
  @override
  final String itemName;
  @override
  final int quantity;
  @override
  final String? status;
  @override
  final String? specialInstructions;
  final List<String>? _modifications;
  @override
  List<String>? get modifications {
    final value = _modifications;
    if (value == null) return null;
    if (_modifications is EqualUnmodifiableListView) return _modifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _allergens;
  @override
  List<String>? get allergens {
    final value = _allergens;
    if (value == null) return null;
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? preparationTime;
  @override
  final String? startTime;
  @override
  final String? readyTime;
  @override
  final String? servedTime;
  @override
  final String? assignedTo;
  @override
  final String? assignedToName;
  @override
  final String? station;
  @override
  final String? notes;
  final List<String>? _allergies;
  @override
  List<String>? get allergies {
    final value = _allergies;
    if (value == null) return null;
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _dietaryRestrictions;
  @override
  List<String>? get dietaryRestrictions {
    final value = _dietaryRestrictions;
    if (value == null) return null;
    if (_dietaryRestrictions is EqualUnmodifiableListView)
      return _dietaryRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'KitchenOrderItem(id: $id, itemName: $itemName, quantity: $quantity, status: $status, specialInstructions: $specialInstructions, modifications: $modifications, allergens: $allergens, preparationTime: $preparationTime, startTime: $startTime, readyTime: $readyTime, servedTime: $servedTime, assignedTo: $assignedTo, assignedToName: $assignedToName, station: $station, notes: $notes, allergies: $allergies, dietaryRestrictions: $dietaryRestrictions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KitchenOrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            const DeepCollectionEquality()
                .equals(other._modifications, _modifications) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.readyTime, readyTime) ||
                other.readyTime == readyTime) &&
            (identical(other.servedTime, servedTime) ||
                other.servedTime == servedTime) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            (identical(other.station, station) || other.station == station) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRestrictions, _dietaryRestrictions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      itemName,
      quantity,
      status,
      specialInstructions,
      const DeepCollectionEquality().hash(_modifications),
      const DeepCollectionEquality().hash(_allergens),
      preparationTime,
      startTime,
      readyTime,
      servedTime,
      assignedTo,
      assignedToName,
      station,
      notes,
      const DeepCollectionEquality().hash(_allergies),
      const DeepCollectionEquality().hash(_dietaryRestrictions));

  /// Create a copy of KitchenOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KitchenOrderItemImplCopyWith<_$KitchenOrderItemImpl> get copyWith =>
      __$$KitchenOrderItemImplCopyWithImpl<_$KitchenOrderItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KitchenOrderItemImplToJson(
      this,
    );
  }
}

abstract class _KitchenOrderItem implements KitchenOrderItem {
  const factory _KitchenOrderItem(
      {required final int id,
      required final String itemName,
      required final int quantity,
      final String? status,
      final String? specialInstructions,
      final List<String>? modifications,
      final List<String>? allergens,
      final int? preparationTime,
      final String? startTime,
      final String? readyTime,
      final String? servedTime,
      final String? assignedTo,
      final String? assignedToName,
      final String? station,
      final String? notes,
      final List<String>? allergies,
      final List<String>? dietaryRestrictions}) = _$KitchenOrderItemImpl;

  factory _KitchenOrderItem.fromJson(Map<String, dynamic> json) =
      _$KitchenOrderItemImpl.fromJson;

  @override
  int get id;
  @override
  String get itemName;
  @override
  int get quantity;
  @override
  String? get status;
  @override
  String? get specialInstructions;
  @override
  List<String>? get modifications;
  @override
  List<String>? get allergens;
  @override
  int? get preparationTime;
  @override
  String? get startTime;
  @override
  String? get readyTime;
  @override
  String? get servedTime;
  @override
  String? get assignedTo;
  @override
  String? get assignedToName;
  @override
  String? get station;
  @override
  String? get notes;
  @override
  List<String>? get allergies;
  @override
  List<String>? get dietaryRestrictions;

  /// Create a copy of KitchenOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KitchenOrderItemImplCopyWith<_$KitchenOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KitchenOrder _$KitchenOrderFromJson(Map<String, dynamic> json) {
  return _KitchenOrder.fromJson(json);
}

/// @nodoc
mixin _$KitchenOrder {
  int get id => throw _privateConstructorUsedError;
  int get businessId => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String? get tableNumber => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get orderType => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get estimatedPrepTime => throw _privateConstructorUsedError;
  int? get actualPrepTime => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get readyTime => throw _privateConstructorUsedError;
  String? get servedTime => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  List<String>? get allergies => throw _privateConstructorUsedError;
  List<String>? get dietaryRestrictions => throw _privateConstructorUsedError;
  List<KitchenOrderItem> get items => throw _privateConstructorUsedError;
  int? get totalItems => throw _privateConstructorUsedError;
  int? get completedItems => throw _privateConstructorUsedError;
  int? get assignedTo => throw _privateConstructorUsedError;
  String? get assignedToName => throw _privateConstructorUsedError;
  String? get station => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get chefId => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this KitchenOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KitchenOrderCopyWith<KitchenOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KitchenOrderCopyWith<$Res> {
  factory $KitchenOrderCopyWith(
          KitchenOrder value, $Res Function(KitchenOrder) then) =
      _$KitchenOrderCopyWithImpl<$Res, KitchenOrder>;
  @useResult
  $Res call(
      {int id,
      int businessId,
      int orderId,
      String orderNumber,
      String? tableNumber,
      String? customerName,
      String? orderType,
      String? priority,
      String? status,
      int? estimatedPrepTime,
      int? actualPrepTime,
      String? startTime,
      String? readyTime,
      String? servedTime,
      String? specialInstructions,
      List<String>? allergies,
      List<String>? dietaryRestrictions,
      List<KitchenOrderItem> items,
      int? totalItems,
      int? completedItems,
      int? assignedTo,
      String? assignedToName,
      String? station,
      String? notes,
      int? chefId,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$KitchenOrderCopyWithImpl<$Res, $Val extends KitchenOrder>
    implements $KitchenOrderCopyWith<$Res> {
  _$KitchenOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? orderId = null,
    Object? orderNumber = null,
    Object? tableNumber = freezed,
    Object? customerName = freezed,
    Object? orderType = freezed,
    Object? priority = freezed,
    Object? status = freezed,
    Object? estimatedPrepTime = freezed,
    Object? actualPrepTime = freezed,
    Object? startTime = freezed,
    Object? readyTime = freezed,
    Object? servedTime = freezed,
    Object? specialInstructions = freezed,
    Object? allergies = freezed,
    Object? dietaryRestrictions = freezed,
    Object? items = null,
    Object? totalItems = freezed,
    Object? completedItems = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? station = freezed,
    Object? notes = freezed,
    Object? chefId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      businessId: null == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      tableNumber: freezed == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      orderType: freezed == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedPrepTime: freezed == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      actualPrepTime: freezed == actualPrepTime
          ? _value.actualPrepTime
          : actualPrepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      readyTime: freezed == readyTime
          ? _value.readyTime
          : readyTime // ignore: cast_nullable_to_non_nullable
              as String?,
      servedTime: freezed == servedTime
          ? _value.servedTime
          : servedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<KitchenOrderItem>,
      totalItems: freezed == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int?,
      completedItems: freezed == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      station: freezed == station
          ? _value.station
          : station // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      chefId: freezed == chefId
          ? _value.chefId
          : chefId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KitchenOrderImplCopyWith<$Res>
    implements $KitchenOrderCopyWith<$Res> {
  factory _$$KitchenOrderImplCopyWith(
          _$KitchenOrderImpl value, $Res Function(_$KitchenOrderImpl) then) =
      __$$KitchenOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int businessId,
      int orderId,
      String orderNumber,
      String? tableNumber,
      String? customerName,
      String? orderType,
      String? priority,
      String? status,
      int? estimatedPrepTime,
      int? actualPrepTime,
      String? startTime,
      String? readyTime,
      String? servedTime,
      String? specialInstructions,
      List<String>? allergies,
      List<String>? dietaryRestrictions,
      List<KitchenOrderItem> items,
      int? totalItems,
      int? completedItems,
      int? assignedTo,
      String? assignedToName,
      String? station,
      String? notes,
      int? chefId,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$$KitchenOrderImplCopyWithImpl<$Res>
    extends _$KitchenOrderCopyWithImpl<$Res, _$KitchenOrderImpl>
    implements _$$KitchenOrderImplCopyWith<$Res> {
  __$$KitchenOrderImplCopyWithImpl(
      _$KitchenOrderImpl _value, $Res Function(_$KitchenOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? orderId = null,
    Object? orderNumber = null,
    Object? tableNumber = freezed,
    Object? customerName = freezed,
    Object? orderType = freezed,
    Object? priority = freezed,
    Object? status = freezed,
    Object? estimatedPrepTime = freezed,
    Object? actualPrepTime = freezed,
    Object? startTime = freezed,
    Object? readyTime = freezed,
    Object? servedTime = freezed,
    Object? specialInstructions = freezed,
    Object? allergies = freezed,
    Object? dietaryRestrictions = freezed,
    Object? items = null,
    Object? totalItems = freezed,
    Object? completedItems = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? station = freezed,
    Object? notes = freezed,
    Object? chefId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$KitchenOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      businessId: null == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      tableNumber: freezed == tableNumber
          ? _value.tableNumber
          : tableNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      orderType: freezed == orderType
          ? _value.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedPrepTime: freezed == estimatedPrepTime
          ? _value.estimatedPrepTime
          : estimatedPrepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      actualPrepTime: freezed == actualPrepTime
          ? _value.actualPrepTime
          : actualPrepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      readyTime: freezed == readyTime
          ? _value.readyTime
          : readyTime // ignore: cast_nullable_to_non_nullable
              as String?,
      servedTime: freezed == servedTime
          ? _value.servedTime
          : servedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value._dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<KitchenOrderItem>,
      totalItems: freezed == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int?,
      completedItems: freezed == completedItems
          ? _value.completedItems
          : completedItems // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      station: freezed == station
          ? _value.station
          : station // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      chefId: freezed == chefId
          ? _value.chefId
          : chefId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KitchenOrderImpl implements _KitchenOrder {
  const _$KitchenOrderImpl(
      {required this.id,
      required this.businessId,
      required this.orderId,
      required this.orderNumber,
      this.tableNumber,
      this.customerName,
      this.orderType,
      this.priority,
      this.status,
      this.estimatedPrepTime,
      this.actualPrepTime,
      this.startTime,
      this.readyTime,
      this.servedTime,
      this.specialInstructions,
      final List<String>? allergies,
      final List<String>? dietaryRestrictions,
      required final List<KitchenOrderItem> items,
      this.totalItems,
      this.completedItems,
      this.assignedTo,
      this.assignedToName,
      this.station,
      this.notes,
      this.chefId,
      this.createdAt,
      this.updatedAt})
      : _allergies = allergies,
        _dietaryRestrictions = dietaryRestrictions,
        _items = items;

  factory _$KitchenOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$KitchenOrderImplFromJson(json);

  @override
  final int id;
  @override
  final int businessId;
  @override
  final int orderId;
  @override
  final String orderNumber;
  @override
  final String? tableNumber;
  @override
  final String? customerName;
  @override
  final String? orderType;
  @override
  final String? priority;
  @override
  final String? status;
  @override
  final int? estimatedPrepTime;
  @override
  final int? actualPrepTime;
  @override
  final String? startTime;
  @override
  final String? readyTime;
  @override
  final String? servedTime;
  @override
  final String? specialInstructions;
  final List<String>? _allergies;
  @override
  List<String>? get allergies {
    final value = _allergies;
    if (value == null) return null;
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _dietaryRestrictions;
  @override
  List<String>? get dietaryRestrictions {
    final value = _dietaryRestrictions;
    if (value == null) return null;
    if (_dietaryRestrictions is EqualUnmodifiableListView)
      return _dietaryRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<KitchenOrderItem> _items;
  @override
  List<KitchenOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int? totalItems;
  @override
  final int? completedItems;
  @override
  final int? assignedTo;
  @override
  final String? assignedToName;
  @override
  final String? station;
  @override
  final String? notes;
  @override
  final int? chefId;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'KitchenOrder(id: $id, businessId: $businessId, orderId: $orderId, orderNumber: $orderNumber, tableNumber: $tableNumber, customerName: $customerName, orderType: $orderType, priority: $priority, status: $status, estimatedPrepTime: $estimatedPrepTime, actualPrepTime: $actualPrepTime, startTime: $startTime, readyTime: $readyTime, servedTime: $servedTime, specialInstructions: $specialInstructions, allergies: $allergies, dietaryRestrictions: $dietaryRestrictions, items: $items, totalItems: $totalItems, completedItems: $completedItems, assignedTo: $assignedTo, assignedToName: $assignedToName, station: $station, notes: $notes, chefId: $chefId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KitchenOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedPrepTime, estimatedPrepTime) ||
                other.estimatedPrepTime == estimatedPrepTime) &&
            (identical(other.actualPrepTime, actualPrepTime) ||
                other.actualPrepTime == actualPrepTime) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.readyTime, readyTime) ||
                other.readyTime == readyTime) &&
            (identical(other.servedTime, servedTime) ||
                other.servedTime == servedTime) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies) &&
            const DeepCollectionEquality()
                .equals(other._dietaryRestrictions, _dietaryRestrictions) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.completedItems, completedItems) ||
                other.completedItems == completedItems) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            (identical(other.station, station) || other.station == station) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.chefId, chefId) || other.chefId == chefId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        businessId,
        orderId,
        orderNumber,
        tableNumber,
        customerName,
        orderType,
        priority,
        status,
        estimatedPrepTime,
        actualPrepTime,
        startTime,
        readyTime,
        servedTime,
        specialInstructions,
        const DeepCollectionEquality().hash(_allergies),
        const DeepCollectionEquality().hash(_dietaryRestrictions),
        const DeepCollectionEquality().hash(_items),
        totalItems,
        completedItems,
        assignedTo,
        assignedToName,
        station,
        notes,
        chefId,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KitchenOrderImplCopyWith<_$KitchenOrderImpl> get copyWith =>
      __$$KitchenOrderImplCopyWithImpl<_$KitchenOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KitchenOrderImplToJson(
      this,
    );
  }
}

abstract class _KitchenOrder implements KitchenOrder {
  const factory _KitchenOrder(
      {required final int id,
      required final int businessId,
      required final int orderId,
      required final String orderNumber,
      final String? tableNumber,
      final String? customerName,
      final String? orderType,
      final String? priority,
      final String? status,
      final int? estimatedPrepTime,
      final int? actualPrepTime,
      final String? startTime,
      final String? readyTime,
      final String? servedTime,
      final String? specialInstructions,
      final List<String>? allergies,
      final List<String>? dietaryRestrictions,
      required final List<KitchenOrderItem> items,
      final int? totalItems,
      final int? completedItems,
      final int? assignedTo,
      final String? assignedToName,
      final String? station,
      final String? notes,
      final int? chefId,
      final String? createdAt,
      final String? updatedAt}) = _$KitchenOrderImpl;

  factory _KitchenOrder.fromJson(Map<String, dynamic> json) =
      _$KitchenOrderImpl.fromJson;

  @override
  int get id;
  @override
  int get businessId;
  @override
  int get orderId;
  @override
  String get orderNumber;
  @override
  String? get tableNumber;
  @override
  String? get customerName;
  @override
  String? get orderType;
  @override
  String? get priority;
  @override
  String? get status;
  @override
  int? get estimatedPrepTime;
  @override
  int? get actualPrepTime;
  @override
  String? get startTime;
  @override
  String? get readyTime;
  @override
  String? get servedTime;
  @override
  String? get specialInstructions;
  @override
  List<String>? get allergies;
  @override
  List<String>? get dietaryRestrictions;
  @override
  List<KitchenOrderItem> get items;
  @override
  int? get totalItems;
  @override
  int? get completedItems;
  @override
  int? get assignedTo;
  @override
  String? get assignedToName;
  @override
  String? get station;
  @override
  String? get notes;
  @override
  int? get chefId;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of KitchenOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KitchenOrderImplCopyWith<_$KitchenOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
