// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffMessageImpl _$$StaffMessageImplFromJson(Map<String, dynamic> json) =>
    _$StaffMessageImpl(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      messageType: json['messageType'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      targetRoles: (json['targetRoles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      targetUserIds: (json['targetUserIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      expiresAt: json['expiresAt'] as String?,
      isRead: json['isRead'] as bool?,
      isAcknowledged: json['isAcknowledged'] as bool?,
      readAt: json['readAt'] as String?,
      acknowledgedAt: json['acknowledgedAt'] as String?,
      readByUserId: (json['readByUserId'] as num?)?.toInt(),
      acknowledgedByUserId: (json['acknowledgedByUserId'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$StaffMessageImplToJson(_$StaffMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'title': instance.title,
      'content': instance.content,
      'messageType': instance.messageType,
      'priority': instance.priority,
      'status': instance.status,
      'targetRoles': instance.targetRoles,
      'targetUserIds': instance.targetUserIds,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'expiresAt': instance.expiresAt,
      'isRead': instance.isRead,
      'isAcknowledged': instance.isAcknowledged,
      'readAt': instance.readAt,
      'acknowledgedAt': instance.acknowledgedAt,
      'readByUserId': instance.readByUserId,
      'acknowledgedByUserId': instance.acknowledgedByUserId,
      'metadata': instance.metadata,
    };
