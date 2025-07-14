// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffMessageImpl _$$StaffMessageImplFromJson(Map<String, dynamic> json) =>
    _$StaffMessageImpl(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      senderId: (json['senderId'] as num).toInt(),
      senderName: json['senderName'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      messageType: json['messageType'] as String,
      recipientType: json['recipientType'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      recipientIds: (json['recipientIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      readBy:
          (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      acknowledgedBy: (json['acknowledgedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      expiresAt: json['expiresAt'] as String?,
      isRead: json['isRead'] as bool?,
      readAt: json['readAt'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$StaffMessageImplToJson(_$StaffMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'title': instance.title,
      'content': instance.content,
      'messageType': instance.messageType,
      'recipientType': instance.recipientType,
      'priority': instance.priority,
      'status': instance.status,
      'recipientIds': instance.recipientIds,
      'readBy': instance.readBy,
      'acknowledgedBy': instance.acknowledgedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'expiresAt': instance.expiresAt,
      'isRead': instance.isRead,
      'readAt': instance.readAt,
      'metadata': instance.metadata,
    };
