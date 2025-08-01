import 'package:dio/dio.dart';
import 'models/staff_message.dart';

class StaffMessagingRepository {
  final Dio dio;
  StaffMessagingRepository(this.dio);

  // 1. Create a Staff Message
  Future<StaffMessage> createStaffMessage({
    required String title,
    required String content,
    required String messageType,
    required String priority,
    required List<String> targetRoles,
    List<int>? targetUserIds,
    String? expiresAt,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await dio.post(
      '/staff-messages',
      data: {
        'title': title,
        'content': content,
        'messageType': messageType,
        'priority': priority,
        'targetRoles': targetRoles,
        if (targetUserIds != null) 'targetUserIds': targetUserIds,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (metadata != null) 'metadata': metadata,
      },
    );

    return StaffMessage.fromJson(response.data['data']);
  }

  // 2. Get All Staff Messages for Business
  Future<List<StaffMessage>> getStaffMessages({
    String? messageType,
    String? status,
    String? priority,
  }) async {
    final response = await dio.get(
      '/staff-messages',
      queryParameters: {
        if (messageType != null) 'messageType': messageType,
        if (status != null) 'status': status,
        if (priority != null) 'priority': priority,
      },
    );

    final data = response.data['data'] as List<dynamic>;
    final messages = data.map((json) => StaffMessage.fromJson(json)).toList();

    return messages;
  }

  // 3. Get a Specific Staff Message
  Future<StaffMessage> getStaffMessage(int messageId) async {
    final response = await dio.get('/staff-messages/$messageId');
    return StaffMessage.fromJson(response.data['data']);
  }

  // 4. Update a Staff Message
  Future<StaffMessage> updateStaffMessage(
    int messageId, {
    String? title,
    String? content,
    String? messageType,
    String? priority,
    String? status,
    List<String>? targetRoles,
    List<int>? targetUserIds,
    String? expiresAt,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await dio.put(
      '/staff-messages/$messageId',
      data: {
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (messageType != null) 'messageType': messageType,
        if (priority != null) 'priority': priority,
        if (status != null) 'status': status,
        if (targetRoles != null) 'targetRoles': targetRoles,
        if (targetUserIds != null) 'targetUserIds': targetUserIds,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (metadata != null) 'metadata': metadata,
      },
    );

    return StaffMessage.fromJson(response.data['data']);
  }

  // 5. Delete a Staff Message
  Future<void> deleteStaffMessage(int messageId) async {
    await dio.delete('/staff-messages/$messageId');
  }

  // 6. Get Messages for Current User
  Future<List<StaffMessage>> getUserMessages() async {
    final response = await dio.get('/staff-messages/user/me');
    final data = response.data['data'] as List<dynamic>;
    final messages = data.map((json) => StaffMessage.fromJson(json)).toList();

    return messages;
  }

  // 7. Mark a Message as Read
  Future<void> markMessageAsRead(int messageId) async {
    await dio.post('/staff-messages/$messageId/read');
  }

  // 8. Acknowledge a Message
  Future<void> acknowledgeMessage(int messageId) async {
    await dio.post('/staff-messages/$messageId/acknowledge');
  }

  // 9. Get Unread Message Count for User
  Future<int> getUnreadMessageCount() async {
    final response = await dio.get('/staff-messages/user/me/unread-count');
    return response.data['unreadCount'] as int;
  }

  // 10. Get Active Messages for User Role
  Future<List<StaffMessage>> getActiveMessages() async {
    final response = await dio.get('/staff-messages/active');
    final data = response.data['data'] as List<dynamic>;
    final messages = data.map((json) => StaffMessage.fromJson(json)).toList();

    return messages;
  }
} 