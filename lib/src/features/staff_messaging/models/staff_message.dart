import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_message.freezed.dart';
part 'staff_message.g.dart';

@freezed
class StaffMessage with _$StaffMessage {
  const factory StaffMessage({
    required int id,
    required int businessId,
    required String title,
    required String content,
    required String messageType,
    required String priority,
    required String status,
    required List<String> targetRoles,
    List<int>? targetUserIds,
    required String createdAt,
    String? updatedAt,
    String? expiresAt,
    bool? isRead,
    bool? isAcknowledged,
    String? readAt,
    String? acknowledgedAt,
    int? readByUserId,
    int? acknowledgedByUserId,
    Map<String, dynamic>? metadata,
  }) = _StaffMessage;

  factory StaffMessage.fromJson(Map<String, dynamic> json) => _$StaffMessageFromJson(json);
}

enum MessageType {
  announcement,
  promotion,
  inventoryAlert,
  discount,
  urgent,
  general,
}

enum MessagePriority {
  low,
  normal,
  high,
  urgent,
}

enum MessageStatus {
  active,
  inactive,
  expired,
  deleted,
} 