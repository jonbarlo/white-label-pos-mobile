import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';

class MessagingRepository {
  final Dio dio;
  MessagingRepository(this.dio);

  Future<List<Map<String, dynamic>>> getMessages({
    String? type,
    bool? isRead,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('💬 MESSAGING: Fetching messages');
      if (type != null) print('💬 MESSAGING: Type filter: $type');
      if (isRead != null) print('💬 MESSAGING: Read filter: $isRead');
    }

    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (isRead != null) queryParams['isRead'] = isRead;

    final response = await dio.get('/messages', queryParameters: queryParams);

    if (EnvConfig.isDebugMode) {
      print('💬 MESSAGING: Found ${response.data['data']?.length ?? 0} messages');
    }

    return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
  }

  Future<Map<String, dynamic>> sendMessage({
    required String content,
    required String type,
    String? recipientId,
    String? tableId,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('💬 MESSAGING: Sending message');
      print('💬 MESSAGING: Type: $type');
      print('💬 MESSAGING: Content: $content');
    }

    final messageData = {
      'content': content,
      'type': type,
      if (recipientId != null) 'recipientId': recipientId,
      if (tableId != null) 'tableId': tableId,
    };

    final response = await dio.post('/messages', data: messageData);

    if (EnvConfig.isDebugMode) {
      print('💬 MESSAGING: Message sent successfully');
    }

    return response.data;
  }

  Future<Map<String, dynamic>> markMessageAsRead(String messageId) async {
    if (EnvConfig.isDebugMode) {
      print('💬 MESSAGING: Marking message $messageId as read');
    }

    final response = await dio.put('/messages/$messageId/read');

    return response.data;
  }

  Future<Map<String, dynamic>> deleteMessage(String messageId) async {
    if (EnvConfig.isDebugMode) {
      print('💬 MESSAGING: Deleting message $messageId');
    }

    final response = await dio.delete('/messages/$messageId');

    return response.data;
  }

  Future<List<Map<String, dynamic>>> getPromotions({
    bool? isActive,
    String? category,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('🎉 PROMOTIONS: Fetching promotions');
      if (isActive != null) print('🎉 PROMOTIONS: Active filter: $isActive');
      if (category != null) print('🎉 PROMOTIONS: Category filter: $category');
    }

    final queryParams = <String, dynamic>{};
    if (isActive != null) queryParams['isActive'] = isActive;
    if (category != null) queryParams['category'] = category;

    final response = await dio.get('/promotions', queryParameters: queryParams);

    if (EnvConfig.isDebugMode) {
      print('🎉 PROMOTIONS: Found ${response.data['data']?.length ?? 0} promotions');
    }

    return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
  }

  Future<Map<String, dynamic>> createPromotion({
    required String title,
    required String description,
    required String discount,
    required String category,
    required DateTime validUntil,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('🎉 PROMOTIONS: Creating promotion: $title');
    }

    final promotionData = {
      'title': title,
      'description': description,
      'discount': discount,
      'category': category,
      'validUntil': validUntil.toIso8601String(),
      'isActive': true,
    };

    final response = await dio.post('/promotions', data: promotionData);

    if (EnvConfig.isDebugMode) {
      print('🎉 PROMOTIONS: Promotion created successfully');
    }

    return response.data;
  }

  Future<Map<String, dynamic>> updatePromotion({
    required String promotionId,
    String? title,
    String? description,
    String? discount,
    String? category,
    DateTime? validUntil,
    bool? isActive,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('🎉 PROMOTIONS: Updating promotion $promotionId');
    }

    final updateData = <String, dynamic>{};
    if (title != null) updateData['title'] = title;
    if (description != null) updateData['description'] = description;
    if (discount != null) updateData['discount'] = discount;
    if (category != null) updateData['category'] = category;
    if (validUntil != null) updateData['validUntil'] = validUntil.toIso8601String();
    if (isActive != null) updateData['isActive'] = isActive;

    final response = await dio.put('/promotions/$promotionId', data: updateData);

    return response.data;
  }

  Future<Map<String, dynamic>> deletePromotion(String promotionId) async {
    if (EnvConfig.isDebugMode) {
      print('🎉 PROMOTIONS: Deleting promotion $promotionId');
    }

    final response = await dio.delete('/promotions/$promotionId');

    return response.data;
  }

  Future<Map<String, dynamic>> callKitchen() async {
    if (EnvConfig.isDebugMode) {
      print('📞 CALL: Calling kitchen');
    }

    final response = await dio.post('/calls/kitchen');

    return response.data;
  }

  Future<Map<String, dynamic>> callManager() async {
    if (EnvConfig.isDebugMode) {
      print('📞 CALL: Calling manager');
    }

    final response = await dio.post('/calls/manager');

    return response.data;
  }

  Future<Map<String, dynamic>> emergencyCall() async {
    if (EnvConfig.isDebugMode) {
      print('🚨 EMERGENCY: Making emergency call');
    }

    final response = await dio.post('/calls/emergency');

    return response.data;
  }

  Future<Map<String, dynamic>> getDailyReport() async {
    if (EnvConfig.isDebugMode) {
      print('📊 REPORT: Fetching daily report');
    }

    final response = await dio.get('/reports/daily');

    return response.data;
  }

  Future<Map<String, dynamic>> getInventoryStatus() async {
    if (EnvConfig.isDebugMode) {
      print('📦 INVENTORY: Checking inventory status');
    }

    final response = await dio.get('/inventory/status');

    return response.data;
  }
} 