// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Table _$TableFromJson(Map<String, dynamic> json) {
  return _Table.fromJson(json);
}

/// @nodoc
mixin _$Table {
  int get id => throw _privateConstructorUsedError;
  int get businessId => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // Changed from tableNumber to name as per API
  TableStatus get status => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  String? get location =>
      throw _privateConstructorUsedError; // Changed from section to location as per API
  int? get currentOrderId => throw _privateConstructorUsedError;
  int? get serverId => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Legacy fields for backward compatibility
  String? get currentOrderNumber => throw _privateConstructorUsedError;
  double? get currentOrderTotal => throw _privateConstructorUsedError;
  int? get currentOrderItemCount => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get lastActivity => throw _privateConstructorUsedError;
  DateTime? get reservationTime => throw _privateConstructorUsedError;
  String? get assignedWaiter => throw _privateConstructorUsedError;
  int? get assignedWaiterId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Table to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Table
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TableCopyWith<Table> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableCopyWith<$Res> {
  factory $TableCopyWith(Table value, $Res Function(Table) then) =
      _$TableCopyWithImpl<$Res, Table>;
  @useResult
  $Res call(
      {int id,
      int businessId,
      String name,
      TableStatus status,
      int capacity,
      String? location,
      int? currentOrderId,
      int? serverId,
      bool? isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? currentOrderNumber,
      double? currentOrderTotal,
      int? currentOrderItemCount,
      String? customerName,
      String? notes,
      DateTime? lastActivity,
      DateTime? reservationTime,
      String? assignedWaiter,
      int? assignedWaiterId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$TableCopyWithImpl<$Res, $Val extends Table>
    implements $TableCopyWith<$Res> {
  _$TableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Table
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? status = null,
    Object? capacity = null,
    Object? location = freezed,
    Object? currentOrderId = freezed,
    Object? serverId = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? currentOrderNumber = freezed,
    Object? currentOrderTotal = freezed,
    Object? currentOrderItemCount = freezed,
    Object? customerName = freezed,
    Object? notes = freezed,
    Object? lastActivity = freezed,
    Object? reservationTime = freezed,
    Object? assignedWaiter = freezed,
    Object? assignedWaiterId = freezed,
    Object? metadata = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TableStatus,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      currentOrderId: freezed == currentOrderId
          ? _value.currentOrderId
          : currentOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentOrderNumber: freezed == currentOrderNumber
          ? _value.currentOrderNumber
          : currentOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      currentOrderTotal: freezed == currentOrderTotal
          ? _value.currentOrderTotal
          : currentOrderTotal // ignore: cast_nullable_to_non_nullable
              as double?,
      currentOrderItemCount: freezed == currentOrderItemCount
          ? _value.currentOrderItemCount
          : currentOrderItemCount // ignore: cast_nullable_to_non_nullable
              as int?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastActivity: freezed == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reservationTime: freezed == reservationTime
          ? _value.reservationTime
          : reservationTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assignedWaiter: freezed == assignedWaiter
          ? _value.assignedWaiter
          : assignedWaiter // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedWaiterId: freezed == assignedWaiterId
          ? _value.assignedWaiterId
          : assignedWaiterId // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TableImplCopyWith<$Res> implements $TableCopyWith<$Res> {
  factory _$$TableImplCopyWith(
          _$TableImpl value, $Res Function(_$TableImpl) then) =
      __$$TableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int businessId,
      String name,
      TableStatus status,
      int capacity,
      String? location,
      int? currentOrderId,
      int? serverId,
      bool? isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? currentOrderNumber,
      double? currentOrderTotal,
      int? currentOrderItemCount,
      String? customerName,
      String? notes,
      DateTime? lastActivity,
      DateTime? reservationTime,
      String? assignedWaiter,
      int? assignedWaiterId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$TableImplCopyWithImpl<$Res>
    extends _$TableCopyWithImpl<$Res, _$TableImpl>
    implements _$$TableImplCopyWith<$Res> {
  __$$TableImplCopyWithImpl(
      _$TableImpl _value, $Res Function(_$TableImpl) _then)
      : super(_value, _then);

  /// Create a copy of Table
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? status = null,
    Object? capacity = null,
    Object? location = freezed,
    Object? currentOrderId = freezed,
    Object? serverId = freezed,
    Object? isActive = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? currentOrderNumber = freezed,
    Object? currentOrderTotal = freezed,
    Object? currentOrderItemCount = freezed,
    Object? customerName = freezed,
    Object? notes = freezed,
    Object? lastActivity = freezed,
    Object? reservationTime = freezed,
    Object? assignedWaiter = freezed,
    Object? assignedWaiterId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$TableImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      businessId: null == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TableStatus,
      capacity: null == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      currentOrderId: freezed == currentOrderId
          ? _value.currentOrderId
          : currentOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentOrderNumber: freezed == currentOrderNumber
          ? _value.currentOrderNumber
          : currentOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      currentOrderTotal: freezed == currentOrderTotal
          ? _value.currentOrderTotal
          : currentOrderTotal // ignore: cast_nullable_to_non_nullable
              as double?,
      currentOrderItemCount: freezed == currentOrderItemCount
          ? _value.currentOrderItemCount
          : currentOrderItemCount // ignore: cast_nullable_to_non_nullable
              as int?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastActivity: freezed == lastActivity
          ? _value.lastActivity
          : lastActivity // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reservationTime: freezed == reservationTime
          ? _value.reservationTime
          : reservationTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assignedWaiter: freezed == assignedWaiter
          ? _value.assignedWaiter
          : assignedWaiter // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedWaiterId: freezed == assignedWaiterId
          ? _value.assignedWaiterId
          : assignedWaiterId // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TableImpl implements _Table {
  const _$TableImpl(
      {required this.id,
      required this.businessId,
      required this.name,
      required this.status,
      required this.capacity,
      this.location,
      this.currentOrderId,
      this.serverId,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.currentOrderNumber,
      this.currentOrderTotal,
      this.currentOrderItemCount,
      this.customerName,
      this.notes,
      this.lastActivity,
      this.reservationTime,
      this.assignedWaiter,
      this.assignedWaiterId,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$TableImpl.fromJson(Map<String, dynamic> json) =>
      _$$TableImplFromJson(json);

  @override
  final int id;
  @override
  final int businessId;
  @override
  final String name;
// Changed from tableNumber to name as per API
  @override
  final TableStatus status;
  @override
  final int capacity;
  @override
  final String? location;
// Changed from section to location as per API
  @override
  final int? currentOrderId;
  @override
  final int? serverId;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Legacy fields for backward compatibility
  @override
  final String? currentOrderNumber;
  @override
  final double? currentOrderTotal;
  @override
  final int? currentOrderItemCount;
  @override
  final String? customerName;
  @override
  final String? notes;
  @override
  final DateTime? lastActivity;
  @override
  final DateTime? reservationTime;
  @override
  final String? assignedWaiter;
  @override
  final int? assignedWaiterId;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Table(id: $id, businessId: $businessId, name: $name, status: $status, capacity: $capacity, location: $location, currentOrderId: $currentOrderId, serverId: $serverId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, currentOrderNumber: $currentOrderNumber, currentOrderTotal: $currentOrderTotal, currentOrderItemCount: $currentOrderItemCount, customerName: $customerName, notes: $notes, lastActivity: $lastActivity, reservationTime: $reservationTime, assignedWaiter: $assignedWaiter, assignedWaiterId: $assignedWaiterId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.currentOrderId, currentOrderId) ||
                other.currentOrderId == currentOrderId) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currentOrderNumber, currentOrderNumber) ||
                other.currentOrderNumber == currentOrderNumber) &&
            (identical(other.currentOrderTotal, currentOrderTotal) ||
                other.currentOrderTotal == currentOrderTotal) &&
            (identical(other.currentOrderItemCount, currentOrderItemCount) ||
                other.currentOrderItemCount == currentOrderItemCount) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.lastActivity, lastActivity) ||
                other.lastActivity == lastActivity) &&
            (identical(other.reservationTime, reservationTime) ||
                other.reservationTime == reservationTime) &&
            (identical(other.assignedWaiter, assignedWaiter) ||
                other.assignedWaiter == assignedWaiter) &&
            (identical(other.assignedWaiterId, assignedWaiterId) ||
                other.assignedWaiterId == assignedWaiterId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        businessId,
        name,
        status,
        capacity,
        location,
        currentOrderId,
        serverId,
        isActive,
        createdAt,
        updatedAt,
        currentOrderNumber,
        currentOrderTotal,
        currentOrderItemCount,
        customerName,
        notes,
        lastActivity,
        reservationTime,
        assignedWaiter,
        assignedWaiterId,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of Table
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TableImplCopyWith<_$TableImpl> get copyWith =>
      __$$TableImplCopyWithImpl<_$TableImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TableImplToJson(
      this,
    );
  }
}

abstract class _Table implements Table {
  const factory _Table(
      {required final int id,
      required final int businessId,
      required final String name,
      required final TableStatus status,
      required final int capacity,
      final String? location,
      final int? currentOrderId,
      final int? serverId,
      final bool? isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? currentOrderNumber,
      final double? currentOrderTotal,
      final int? currentOrderItemCount,
      final String? customerName,
      final String? notes,
      final DateTime? lastActivity,
      final DateTime? reservationTime,
      final String? assignedWaiter,
      final int? assignedWaiterId,
      final Map<String, dynamic>? metadata}) = _$TableImpl;

  factory _Table.fromJson(Map<String, dynamic> json) = _$TableImpl.fromJson;

  @override
  int get id;
  @override
  int get businessId;
  @override
  String get name; // Changed from tableNumber to name as per API
  @override
  TableStatus get status;
  @override
  int get capacity;
  @override
  String? get location; // Changed from section to location as per API
  @override
  int? get currentOrderId;
  @override
  int? get serverId;
  @override
  bool? get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Legacy fields for backward compatibility
  @override
  String? get currentOrderNumber;
  @override
  double? get currentOrderTotal;
  @override
  int? get currentOrderItemCount;
  @override
  String? get customerName;
  @override
  String? get notes;
  @override
  DateTime? get lastActivity;
  @override
  DateTime? get reservationTime;
  @override
  String? get assignedWaiter;
  @override
  int? get assignedWaiterId;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Table
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TableImplCopyWith<_$TableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
