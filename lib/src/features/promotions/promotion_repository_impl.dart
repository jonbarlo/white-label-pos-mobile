import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'promotion_repository.dart';
import 'models/promotion.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';

final promotionRepositoryProvider = Provider<PromotionRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PromotionRepositoryImpl(dio, ref);
});

class PromotionRepositoryImpl implements PromotionRepository {
  final Dio _dio;
  final Ref _ref;

  PromotionRepositoryImpl(this._dio, this._ref);

  @override
  Future<List<Promotion>> getPromotions() async {
    try {
      final response = await _dio.get('/promotions');
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as List<dynamic>
          : responseData as List<dynamic>;
      
      return data.map((json) => Promotion.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to get promotions: $e');
    }
  }

  @override
  Future<Promotion?> getPromotion(int id) async {
    try {
      final response = await _dio.get('/promotions/$id');
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;
      
      return Promotion.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get promotion: $e');
    }
  }

  @override
  Future<Promotion> createPromotion(Promotion promotion) async {
    try {
      final response = await _dio.post('/promotions', data: promotion.toJson());
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;
      
      return Promotion.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create promotion: $e');
    }
  }

  @override
  Future<Promotion> updatePromotion(Promotion promotion) async {
    try {
      final response = await _dio.put('/promotions/${promotion.id}', data: promotion.toJson());
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;
      
      return Promotion.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update promotion: $e');
    }
  }

  @override
  Future<void> deletePromotion(int id) async {
    try {
      await _dio.delete('/promotions/$id');
    } catch (e) {
      throw Exception('Failed to delete promotion: $e');
    }
  }

  @override
  Future<List<Promotion>> getActivePromotions() async {
    try {
      final response = await _dio.get('/promotions', queryParameters: {
        'status': 'active',
        'isActive': true,
      });
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as List<dynamic>
          : responseData as List<dynamic>;
      
      return data.map((json) => Promotion.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to get active promotions: $e');
    }
  }

  @override
  Future<List<Promotion>> getPromotionsByType(String type) async {
    try {
      final response = await _dio.get('/promotions', queryParameters: {
        'type': type,
      });
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as List<dynamic>
          : responseData as List<dynamic>;
      
      return data.map((json) => Promotion.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to get promotions by type: $e');
    }
  }
} 