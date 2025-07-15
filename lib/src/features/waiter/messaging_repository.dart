import 'package:dio/dio.dart';

class MessagingRepository {
  final Dio dio;
  MessagingRepository(this.dio);

  Future<List<Map<String, dynamic>>> getMessages({
    String? type,
    bool? isRead,
  }) async {
    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (isRead != null) queryParams['isRead'] = isRead;

    final response = await dio.get('/messages', queryParameters: queryParams);

    // Handle both response formats: direct array or wrapped in data field
    final responseData = response.data;
    List<dynamic> messagesData;
    
    if (responseData is List) {
      // Direct array response
      messagesData = responseData;
    } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      // Wrapped in data field
      messagesData = responseData['data'] as List<dynamic>? ?? [];
    } else {
      messagesData = [];
    }

    return List<Map<String, dynamic>>.from(messagesData);
  }

  Future<Map<String, dynamic>> sendMessage({
    required String content,
    required String type,
    String? recipientId,
    String? tableId,
  }) async {
    final messageData = {
      'content': content,
      'type': type,
      if (recipientId != null) 'recipientId': recipientId,
      if (tableId != null) 'tableId': tableId,
    };

    final response = await dio.post('/messages', data: messageData);

    return response.data;
  }

  Future<Map<String, dynamic>> markMessageAsRead(String messageId) async {
    final response = await dio.put('/messages/$messageId/read');

    return response.data;
  }

  Future<Map<String, dynamic>> deleteMessage(String messageId) async {
    final response = await dio.delete('/messages/$messageId');

    return response.data;
  }

  Future<List<Map<String, dynamic>>> getPromotions({
    bool? isActive,
    String? category,
  }) async {
    final queryParams = <String, dynamic>{};
    if (isActive != null) queryParams['isActive'] = isActive;
    if (category != null) queryParams['category'] = category;

    final response = await dio.get('/promotions', queryParameters: queryParams);

    // Handle both response formats: direct array or wrapped in data field
    final responseData = response.data;
    List<dynamic> promotionsData;
    
    if (responseData is List) {
      // Direct array response
      promotionsData = responseData;
    } else if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      // Wrapped in data field
      promotionsData = responseData['data'] as List<dynamic>? ?? [];
    } else {
      promotionsData = [];
    }

    return List<Map<String, dynamic>>.from(promotionsData);
  }

  Future<Map<String, dynamic>> createPromotion({
    required String title,
    required String description,
    required String discount,
    required String category,
    required DateTime validUntil,
  }) async {
    final promotionData = {
      'title': title,
      'description': description,
      'discount': discount,
      'category': category,
      'validUntil': validUntil.toIso8601String(),
      'isActive': true,
    };

    final response = await dio.post('/promotions', data: promotionData);

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
    final response = await dio.delete('/promotions/$promotionId');

    return response.data;
  }

  Future<Map<String, dynamic>> callKitchen() async {
    final response = await dio.post('/calls/kitchen');

    return response.data;
  }

  Future<Map<String, dynamic>> callManager() async {
    final response = await dio.post('/calls/manager');

    return response.data;
  }

  Future<Map<String, dynamic>> emergencyCall() async {
    final response = await dio.post('/calls/emergency');

    return response.data;
  }

  Future<Map<String, dynamic>> getDailyReport() async {
    final response = await dio.get('/reports/daily');

    return response.data;
  }

  Future<Map<String, dynamic>> getInventoryStatus() async {
    final response = await dio.get('/inventory/status');

    return response.data;
  }
} 