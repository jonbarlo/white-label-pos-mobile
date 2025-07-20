import 'package:dio/dio.dart';
import 'promotion_repository.dart';
import 'models/promotion.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  final Dio _dio;
  final Ref _ref;

  PromotionRepositoryImpl(this._dio, this._ref);

  @override
  Future<List<Promotion>> getPromotions({int? businessId}) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final effectiveBusinessId = businessId ?? authState.business?.id;
      
      if (effectiveBusinessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/promotions', queryParameters: {
        'businessId': effectiveBusinessId,
      });

      final responseData = response.data;
      List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        data = responseData['data'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        data = responseData;
      } else {
        throw Exception('Unexpected response format');
      }
      
      return data.map((json) => Promotion.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get promotions: ${e.message}');
    }
  }

  @override
  Future<Promotion> getPromotion(int promotionId) async {
    try {
      final response = await _dio.get('/promotions/$promotionId');
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return Promotion.fromJson(responseData['data']);
      } else {
        return Promotion.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to get promotion: ${e.message}');
    }
  }

  @override
  Future<Promotion> createPromotion(Promotion promotion) async {
    try {
      final response = await _dio.post('/promotions', data: promotion.toJson());
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return Promotion.fromJson(responseData['data']);
      } else {
        return Promotion.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to create promotion: ${e.message}');
    }
  }

  @override
  Future<Promotion> updatePromotion(int promotionId, Promotion promotion) async {
    try {
      final response = await _dio.put('/promotions/$promotionId', data: promotion.toJson());
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return Promotion.fromJson(responseData['data']);
      } else {
        return Promotion.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to update promotion: ${e.message}');
    }
  }

  @override
  Future<void> deletePromotion(int promotionId) async {
    try {
      await _dio.delete('/promotions/$promotionId');
    } on DioException catch (e) {
      throw Exception('Failed to delete promotion: ${e.message}');
    }
  }

  @override
  Future<List<Promotion>> getActivePromotions({int? businessId}) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final effectiveBusinessId = businessId ?? authState.business?.id;
      
      if (effectiveBusinessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/promotions/active', queryParameters: {
        'businessId': effectiveBusinessId,
      });

      final responseData = response.data;
      List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        data = responseData['data'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        data = responseData;
      } else {
        throw Exception('Unexpected response format');
      }
      
      return data.map((json) => Promotion.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get active promotions: ${e.message}');
    }
  }

  @override
  Future<PromotionStats> getPromotionStats({int? businessId}) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final effectiveBusinessId = businessId ?? authState.business?.id;
      
      if (effectiveBusinessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/promotions/stats', queryParameters: {
        'businessId': effectiveBusinessId,
      });

      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return PromotionStats.fromJson(responseData['data']);
      } else {
        return PromotionStats.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to get promotion stats: ${e.message}');
    }
  }
} 