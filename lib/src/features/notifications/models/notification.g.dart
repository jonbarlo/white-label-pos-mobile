// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileNotification _$MobileNotificationFromJson(Map<String, dynamic> json) =>
    MobileNotification(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      status: $enumDecode(_$NotificationStatusEnumMap, json['status']),
      target: $enumDecode(_$NotificationTargetEnumMap, json['target']),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MobileNotificationToJson(MobileNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'title': instance.title,
      'message': instance.message,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'status': _$NotificationStatusEnumMap[instance.status]!,
      'target': _$NotificationTargetEnumMap[instance.target]!,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'actionUrl': instance.actionUrl,
      'metadata': instance.metadata,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.promotion: 'promotion',
  NotificationType.recipe: 'recipe',
  NotificationType.general: 'general',
  NotificationType.system: 'system',
  NotificationType.order: 'order',
};

const _$NotificationStatusEnumMap = {
  NotificationStatus.draft: 'draft',
  NotificationStatus.scheduled: 'scheduled',
  NotificationStatus.sent: 'sent',
  NotificationStatus.failed: 'failed',
};

const _$NotificationTargetEnumMap = {
  NotificationTarget.all: 'all',
  NotificationTarget.kitchen: 'kitchen',
  NotificationTarget.waitstaff: 'waitstaff',
  NotificationTarget.customers: 'customers',
  NotificationTarget.managers: 'managers',
};

NotificationStats _$NotificationStatsFromJson(Map<String, dynamic> json) =>
    NotificationStats(
      totalNotifications: (json['totalNotifications'] as num).toInt(),
      sentNotifications: (json['sentNotifications'] as num).toInt(),
      scheduledNotifications: (json['scheduledNotifications'] as num).toInt(),
      draftNotifications: (json['draftNotifications'] as num).toInt(),
      notificationsByType:
          (json['notificationsByType'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$NotificationTypeEnumMap, k), (e as num).toInt()),
      ),
      notificationsByTarget:
          (json['notificationsByTarget'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$NotificationTargetEnumMap, k), (e as num).toInt()),
      ),
      averageOpenRate: (json['averageOpenRate'] as num).toDouble(),
      mostEngagedNotifications:
          (json['mostEngagedNotifications'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$NotificationStatsToJson(NotificationStats instance) =>
    <String, dynamic>{
      'totalNotifications': instance.totalNotifications,
      'sentNotifications': instance.sentNotifications,
      'scheduledNotifications': instance.scheduledNotifications,
      'draftNotifications': instance.draftNotifications,
      'notificationsByType': instance.notificationsByType
          .map((k, e) => MapEntry(_$NotificationTypeEnumMap[k]!, e)),
      'notificationsByTarget': instance.notificationsByTarget
          .map((k, e) => MapEntry(_$NotificationTargetEnumMap[k]!, e)),
      'averageOpenRate': instance.averageOpenRate,
      'mostEngagedNotifications': instance.mostEngagedNotifications,
    };
