import 'package:dio/dio.dart';
import 'business_repository.dart';
import 'models/business.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final Dio _dio;

  BusinessRepositoryImpl(this._dio);

  @override
  Future<List<Business>> getBusinesses() async {
    try {
      final response = await _dio.get('/businesses');
      final responseData = response.data;
      
      List<dynamic> data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        data = responseData['data'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        data = responseData;
      } else {
        throw Exception('Unexpected response format');
      }
      
      return data.map((json) => Business.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch businesses: ${e.message}');
    }
  }

  @override
  Future<Business?> getBusiness(int businessId) async {
    try {
      final response = await _dio.get('/businesses/$businessId');
      return Business.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Failed to fetch business: ${e.message}');
    }
  }

  @override
  Future<Business> createBusiness(Business business) async {
    try {
      final response = await _dio.post('/businesses', data: business.toJson());
      return Business.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to create business: ${e.message}');
    }
  }

  @override
  Future<Business> updateBusiness(Business business) async {
    try {
      final response = await _dio.put('/businesses/${business.id}', data: business.toJson());
      return Business.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to update business: ${e.message}');
    }
  }

  @override
  Future<void> deleteBusiness(int businessId) async {
    try {
      await _dio.delete('/businesses/$businessId');
    } on DioException catch (e) {
      throw Exception('Failed to delete business: ${e.message}');
    }
  }
} 