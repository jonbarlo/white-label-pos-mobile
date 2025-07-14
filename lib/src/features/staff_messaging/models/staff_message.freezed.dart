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
  int get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  String get recipientType => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<int>? get recipientIds => throw _privateConstructorUsedError;
  List<String>? get readBy => throw _privateConstructorUsedError;
  List<String>? get acknowledgedBy => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get expiresAt => throw _privateConstructorUsedError;
  bool? get isRead => throw _privateConstructorUsedError;
  String? get readAt => throw _privateConstructorUsedError;
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
      int senderId,
      String senderName,
      String title,
      String content,
      String messageType,
      String recipientType,
      String priority,
      String status,
      List<int>? recipientIds,
      List<String>? readBy,
      List<String>? acknowledgedBy,
      String createdAt,
      String? updatedAt,
      String? expiresAt,
      bool? isRead,
      String? readAt,
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
    Object? senderId = null,
    Object? senderName = null,
    Object? title = null,
    Object? content = null,
    Object? messageType = null,
    Object? recipientType = null,
    Object? priority = null,
    Object? status = null,
    Object? recipientIds = freezed,
    Object? readBy = freezed,
    Object? acknowledgedBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? expiresAt = freezed,
    Object? isRead = freezed,
    Object? readAt = freezed,
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
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
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
      recipientType: null == recipientType
          ? _value.recipientType
          : recipientType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recipientIds: freezed == recipientIds
          ? _value.recipientIds
          : recipientIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      readBy: freezed == readBy
          ? _value.readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      acknowledgedBy: freezed == acknowledgedBy
          ? _value.acknowledgedBy
          : acknowledgedBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
      int senderId,
      String senderName,
      String title,
      String content,
      String messageType,
      String recipientType,
      String priority,
      String status,
      List<int>? recipientIds,
      List<String>? readBy,
      List<String>? acknowledgedBy,
      String createdAt,
      String? updatedAt,
      String? expiresAt,
      bool? isRead,
      String? readAt,
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
    Object? senderId = null,
    Object? senderName = null,
    Object? title = null,
    Object? content = null,
    Object? messageType = null,
    Object? recipientType = null,
    Object? priority = null,
    Object? status = null,
    Object? recipientIds = freezed,
    Object? readBy = freezed,
    Object? acknowledgedBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? expiresAt = freezed,
    Object? isRead = freezed,
    Object? readAt = freezed,
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
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
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
      recipientType: null == recipientType
          ? _value.recipientType
          : recipientType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recipientIds: freezed == recipientIds
          ? _value._recipientIds
          : recipientIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      readBy: freezed == readBy
          ? _value._readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      acknowledgedBy: freezed == acknowledgedBy
          ? _value._acknowledgedBy
          : acknowledgedBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
      required this.senderId,
      required this.senderName,
      required this.title,
      required this.content,
      required this.messageType,
      required this.recipientType,
      required this.priority,
      required this.status,
      final List<int>? recipientIds,
      final List<String>? readBy,
      final List<String>? acknowledgedBy,
      required this.createdAt,
      this.updatedAt,
      this.expiresAt,
      this.isRead,
      this.readAt,
      final Map<String, dynamic>? metadata})
      : _recipientIds = recipientIds,
        _readBy = readBy,
        _acknowledgedBy = acknowledgedBy,
        _metadata = metadata;

  factory _$StaffMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffMessageImplFromJson(json);

  @override
  final int id;
  @override
  final int businessId;
  @override
  final int senderId;
  @override
  final String senderName;
  @override
  final String title;
  @override
  final String content;
  @override
  final String messageType;
  @override
  final String recipientType;
  @override
  final String priority;
  @override
  final String status;
  final List<int>? _recipientIds;
  @override
  List<int>? get recipientIds {
    final value = _recipientIds;
    if (value == null) return null;
    if (_recipientIds is EqualUnmodifiableListView) return _recipientIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _readBy;
  @override
  List<String>? get readBy {
    final value = _readBy;
    if (value == null) return null;
    if (_readBy is EqualUnmodifiableListView) return _readBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _acknowledgedBy;
  @override
  List<String>? get acknowledgedBy {
    final value = _acknowledgedBy;
    if (value == null) return null;
    if (_acknowledgedBy is EqualUnmodifiableListView) return _acknowledgedBy;
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
  final String? readAt;
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
    return 'StaffMessage(id: $id, businessId: $businessId, senderId: $senderId, senderName: $senderName, title: $title, content: $content, messageType: $messageType, recipientType: $recipientType, priority: $priority, status: $status, recipientIds: $recipientIds, readBy: $readBy, acknowledgedBy: $acknowledgedBy, createdAt: $createdAt, updatedAt: $updatedAt, expiresAt: $expiresAt, isRead: $isRead, readAt: $readAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.recipientType, recipientType) ||
                other.recipientType == recipientType) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._recipientIds, _recipientIds) &&
            const DeepCollectionEquality().equals(other._readBy, _readBy) &&
            const DeepCollectionEquality()
                .equals(other._acknowledgedBy, _acknowledgedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        businessId,
        senderId,
        senderName,
        title,
        content,
        messageType,
        recipientType,
        priority,
        status,
        const DeepCollectionEquality().hash(_recipientIds),
        const DeepCollectionEquality().hash(_readBy),
        const DeepCollectionEquality().hash(_acknowledgedBy),
        createdAt,
        updatedAt,
        expiresAt,
        isRead,
        readAt,
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
      required final int senderId,
      required final String senderName,
      required final String title,
      required final String content,
      required final String messageType,
      required final String recipientType,
      required final String priority,
      required final String status,
      final List<int>? recipientIds,
      final List<String>? readBy,
      final List<String>? acknowledgedBy,
      required final String createdAt,
      final String? updatedAt,
      final String? expiresAt,
      final bool? isRead,
      final String? readAt,
      final Map<String, dynamic>? metadata}) = _$StaffMessageImpl;

  factory _StaffMessage.fromJson(Map<String, dynamic> json) =
      _$StaffMessageImpl.fromJson;

  @override
  int get id;
  @override
  int get businessId;
  @override
  int get senderId;
  @override
  String get senderName;
  @override
  String get title;
  @override
  String get content;
  @override
  String get messageType;
  @override
  String get recipientType;
  @override
  String get priority;
  @override
  String get status;
  @override
  List<int>? get recipientIds;
  @override
  List<String>? get readBy;
  @override
  List<String>? get acknowledgedBy;
  @override
  String get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get expiresAt;
  @override
  bool? get isRead;
  @override
  String? get readAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of StaffMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffMessageImplCopyWith<_$StaffMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
