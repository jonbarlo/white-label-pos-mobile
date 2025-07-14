import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_message.freezed.dart';
part 'staff_message.g.dart';

@freezed
class StaffMessage with _$StaffMessage {
  const factory StaffMessage({
    required int id,
    required int businessId,
    required int senderId,
    required String senderName,
    required String title,
    required String content,
    required String messageType,
    required String recipientType,
    required String priority,
    required String status,
    List<int>? recipientIds,
    List<String>? readBy,
    List<String>? acknowledgedBy,
    required String createdAt,
    String? updatedAt,
    String? expiresAt,
    bool? isRead,
    String? readAt,
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