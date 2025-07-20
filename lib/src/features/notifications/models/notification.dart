import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

enum NotificationType { promotion, recipe, general, system, order }
enum NotificationStatus { draft, scheduled, sent, failed }
enum NotificationTarget { all, kitchen, waitstaff, customers, managers }

@JsonSerializable()
class MobileNotification {
  final int id;
  final int businessId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationStatus status;
  final NotificationTarget target;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final String? imageUrl;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MobileNotification({
    required this.id,
    required this.businessId,
    required this.title,
    required this.message,
    required this.type,
    required this.status,
    required this.target,
    this.scheduledAt,
    this.sentAt,
    this.imageUrl,
    this.actionUrl,
    this.metadata,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MobileNotification.fromJson(Map<String, dynamic> json) => _$MobileNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$MobileNotificationToJson(this);

  bool get isScheduled => status == NotificationStatus.scheduled && scheduledAt != null;
  bool get isSent => status == NotificationStatus.sent;
  bool get isDraft => status == NotificationStatus.draft;

  String get statusDisplay {
    switch (status) {
      case NotificationStatus.draft:
        return 'Draft';
      case NotificationStatus.scheduled:
        return 'Scheduled';
      case NotificationStatus.sent:
        return 'Sent';
      case NotificationStatus.failed:
        return 'Failed';
    }
  }

  String get typeDisplay {
    switch (type) {
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.recipe:
        return 'Recipe';
      case NotificationType.general:
        return 'General';
      case NotificationType.system:
        return 'System';
      case NotificationType.order:
        return 'Order';
    }
  }

  String get targetDisplay {
    switch (target) {
      case NotificationTarget.all:
        return 'All Users';
      case NotificationTarget.kitchen:
        return 'Kitchen Staff';
      case NotificationTarget.waitstaff:
        return 'Wait Staff';
      case NotificationTarget.customers:
        return 'Customers';
      case NotificationTarget.managers:
        return 'Managers';
    }
  }

  MobileNotification copyWith({
    int? id,
    int? businessId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationStatus? status,
    NotificationTarget? target,
    DateTime? scheduledAt,
    DateTime? sentAt,
    String? imageUrl,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MobileNotification(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      target: target ?? this.target,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      sentAt: sentAt ?? this.sentAt,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class NotificationStats {
  final int totalNotifications;
  final int sentNotifications;
  final int scheduledNotifications;
  final int draftNotifications;
  final Map<NotificationType, int> notificationsByType;
  final Map<NotificationTarget, int> notificationsByTarget;
  final double averageOpenRate;
  final List<String> mostEngagedNotifications;

  const NotificationStats({
    required this.totalNotifications,
    required this.sentNotifications,
    required this.scheduledNotifications,
    required this.draftNotifications,
    required this.notificationsByType,
    required this.notificationsByTarget,
    required this.averageOpenRate,
    required this.mostEngagedNotifications,
  });

  factory NotificationStats.fromJson(Map<String, dynamic> json) => _$NotificationStatsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationStatsToJson(this);
} 