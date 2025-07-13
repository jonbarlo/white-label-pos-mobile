// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffMessage _$StaffMessageFromJson(Map<String, dynamic> json) {
  return _StaffMessage.fromJson(json);
}

/// @nodoc
mixin _$StaffMessage {
  int get id => throw _privateConstructorUsedError;
  int get businessId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<String> get targetRoles => throw _privateConstructorUsedError;
  List<int>? get targetUserIds => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get expiresAt => throw _privateConstructorUsedError;
  bool? get isRead => throw _privateConstructorUsedError;
  bool? get isAcknowledged => throw _privateConstructorUsedError;
  String? get readAt => throw _privateConstructorUsedError;
  String? get acknowledgedAt => throw _privateConstructorUsedError;
  int? get readByUserId => throw _privateConstructorUsedError;
  int? get acknowledgedByUserId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this StaffMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffMessageCopyWith<StaffMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffMessageCopyWith<$Res> {
  factory $StaffMessageCopyWith(
          StaffMessage value, $Res Function(StaffMessage) then) =
      _$StaffMessageCopyWithImpl<$Res, StaffMessage>;
  @useResult
  $Res call(
      {int id,
      int businessId,
      String title,
      String content,
      String messageType,
      String priority,
      String status,
      List<String> targetRoles,
      List<int>? targetUserIds,
      String createdAt,
      String? updatedAt,
      String? expiresAt,
      bool? isRead,
      bool? isAcknowledged,
      String? readAt,
      String? acknowledgedAt,
      int? readByUserId,
      int? acknowledgedByUserId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$StaffMessageCopyWithImpl<$Res, $Val extends StaffMessage>
    implements $StaffMessageCopyWith<$Res> {
  _$StaffMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? title = null,
    Object? content = null,
    Object? messageType = null,
    Object? priority = null,
    Object? status = null,
    Object? targetRoles = null,
    Object? targetUserIds = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? expiresAt = freezed,
    Object? isRead = freezed,
    Object? isAcknowledged = freezed,
    Object? readAt = freezed,
    Object? acknowledgedAt = freezed,
    Object? readByUserId = freezed,
    Object? acknowledgedByUserId = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      targetRoles: null == targetRoles
          ? _value.targetRoles
          : targetRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetUserIds: freezed == targetUserIds
          ? _value.targetUserIds
          : targetUserIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: freezed == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAcknowledged: freezed == isAcknowledged
          ? _value.isAcknowledged
          : isAcknowledged // ignore: cast_nullable_to_non_nullable
              as bool?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
      acknowledgedAt: freezed == acknowledgedAt
          ? _value.acknowledgedAt
          : acknowledgedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      readByUserId: freezed == readByUserId
          ? _value.readByUserId
          : readByUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      acknowledgedByUserId: freezed == acknowledgedByUserId
          ? _value.acknowledgedByUserId
          : acknowledgedByUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffMessageImplCopyWith<$Res>
    implements $StaffMessageCopyWith<$Res> {
  factory _$$StaffMessageImplCopyWith(
          _$StaffMessageImpl value, $Res Function(_$StaffMessageImpl) then) =
      __$$StaffMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int businessId,
      String title,
      String content,
      String messageType,
      String priority,
      String status,
      List<String> targetRoles,
      List<int>? targetUserIds,
      String createdAt,
      String? updatedAt,
      String? expiresAt,
      bool? isRead,
      bool? isAcknowledged,
      String? readAt,
      String? acknowledgedAt,
      int? readByUserId,
      int? acknowledgedByUserId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$StaffMessageImplCopyWithImpl<$Res>
    extends _$StaffMessageCopyWithImpl<$Res, _$StaffMessageImpl>
    implements _$$StaffMessageImplCopyWith<$Res> {
  __$$StaffMessageImplCopyWithImpl(
      _$StaffMessageImpl _value, $Res Function(_$StaffMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of StaffMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? title = null,
    Object? content = null,
    Object? messageType = null,
    Object? priority = null,
    Object? status = null,
    Object? targetRoles = null,
    Object? targetUserIds = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? expiresAt = freezed,
    Object? isRead = freezed,
    Object? isAcknowledged = freezed,
    Object? readAt = freezed,
    Object? acknowledgedAt = freezed,
    Object? readByUserId = freezed,
    Object? acknowledgedByUserId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$StaffMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      businessId: null == businessId
          ? _value.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      targetRoles: null == targetRoles
          ? _value._targetRoles
          : targetRoles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetUserIds: freezed == targetUserIds
          ? _value._targetUserIds
          : targetUserIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: freezed == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAcknowledged: freezed == isAcknowledged
          ? _value.isAcknowledged
          : isAcknowledged // ignore: cast_nullable_to_non_nullable
              as bool?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
      acknowledgedAt: freezed == acknowledgedAt
          ? _value.acknowledgedAt
          : acknowledgedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      readByUserId: freezed == readByUserId
          ? _value.readByUserId
          : readByUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      acknowledgedByUserId: freezed == acknowledgedByUserId
          ? _value.acknowledgedByUserId
          : acknowledgedByUserId // ignore: cast_nullable_to_non_nullable
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
class _$StaffMessageImpl implements _StaffMessage {
  const _$StaffMessageImpl(
      {required this.id,
      required this.businessId,
      required this.title,
      required this.content,
      required this.messageType,
      required this.priority,
      required this.status,
      required final List<String> targetRoles,
      final List<int>? targetUserIds,
      required this.createdAt,
      this.updatedAt,
      this.expiresAt,
      this.isRead,
      this.isAcknowledged,
      this.readAt,
      this.acknowledgedAt,
      this.readByUserId,
      this.acknowledgedByUserId,
      final Map<String, dynamic>? metadata})
      : _targetRoles = targetRoles,
        _targetUserIds = targetUserIds,
        _metadata = metadata;

  factory _$StaffMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffMessageImplFromJson(json);

  @override
  final int id;
  @override
  final int businessId;
  @override
  final String title;
  @override
  final String content;
  @override
  final String messageType;
  @override
  final String priority;
  @override
  final String status;
  final List<String> _targetRoles;
  @override
  List<String> get targetRoles {
    if (_targetRoles is EqualUnmodifiableListView) return _targetRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetRoles);
  }

  final List<int>? _targetUserIds;
  @override
  List<int>? get targetUserIds {
    final value = _targetUserIds;
    if (value == null) return null;
    if (_targetUserIds is EqualUnmodifiableListView) return _targetUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String createdAt;
  @override
  final String? updatedAt;
  @override
  final String? expiresAt;
  @override
  final bool? isRead;
  @override
  final bool? isAcknowledged;
  @override
  final String? readAt;
  @override
  final String? acknowledgedAt;
  @override
  final int? readByUserId;
  @override
  final int? acknowledgedByUserId;
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
    return 'StaffMessage(id: $id, businessId: $businessId, title: $title, content: $content, messageType: $messageType, priority: $priority, status: $status, targetRoles: $targetRoles, targetUserIds: $targetUserIds, createdAt: $createdAt, updatedAt: $updatedAt, expiresAt: $expiresAt, isRead: $isRead, isAcknowledged: $isAcknowledged, readAt: $readAt, acknowledgedAt: $acknowledgedAt, readByUserId: $readByUserId, acknowledgedByUserId: $acknowledgedByUserId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._targetRoles, _targetRoles) &&
            const DeepCollectionEquality()
                .equals(other._targetUserIds, _targetUserIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isAcknowledged, isAcknowledged) ||
                other.isAcknowledged == isAcknowledged) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.acknowledgedAt, acknowledgedAt) ||
                other.acknowledgedAt == acknowledgedAt) &&
            (identical(other.readByUserId, readByUserId) ||
                other.readByUserId == readByUserId) &&
            (identical(other.acknowledgedByUserId, acknowledgedByUserId) ||
                other.acknowledgedByUserId == acknowledgedByUserId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        businessId,
        title,
        content,
        messageType,
        priority,
        status,
        const DeepCollectionEquality().hash(_targetRoles),
        const DeepCollectionEquality().hash(_targetUserIds),
        createdAt,
        updatedAt,
        expiresAt,
        isRead,
        isAcknowledged,
        readAt,
        acknowledgedAt,
        readByUserId,
        acknowledgedByUserId,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of StaffMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffMessageImplCopyWith<_$StaffMessageImpl> get copyWith =>
      __$$StaffMessageImplCopyWithImpl<_$StaffMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffMessageImplToJson(
      this,
    );
  }
}

abstract class _StaffMessage implements StaffMessage {
  const factory _StaffMessage(
      {required final int id,
      required final int businessId,
      required final String title,
      required final String content,
      required final String messageType,
      required final String priority,
      required final String status,
      required final List<String> targetRoles,
      final List<int>? targetUserIds,
      required final String createdAt,
      final String? updatedAt,
      final String? expiresAt,
      final bool? isRead,
      final bool? isAcknowledged,
      final String? readAt,
      final String? acknowledgedAt,
      final int? readByUserId,
      final int? acknowledgedByUserId,
      final Map<String, dynamic>? metadata}) = _$StaffMessageImpl;

  factory _StaffMessage.fromJson(Map<String, dynamic> json) =
      _$StaffMessageImpl.fromJson;

  @override
  int get id;
  @override
  int get businessId;
  @override
  String get title;
  @override
  String get content;
  @override
  String get messageType;
  @override
  String get priority;
  @override
  String get status;
  @override
  List<String> get targetRoles;
  @override
  List<int>? get targetUserIds;
  @override
  String get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get expiresAt;
  @override
  bool? get isRead;
  @override
  bool? get isAcknowledged;
  @override
  String? get readAt;
  @override
  String? get acknowledgedAt;
  @override
  int? get readByUserId;
  @override
  int? get acknowledgedByUserId;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of StaffMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffMessageImplCopyWith<_$StaffMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
