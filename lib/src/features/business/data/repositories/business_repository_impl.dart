import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/api_response.dart';
import '../../../../shared/models/result.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/business.dart';
import 'business_repository.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return BusinessRepositoryImpl(dio);
});

class BusinessRepositoryImpl implements BusinessRepository {
  final Dio _dio;

  BusinessRepositoryImpl(this._dio);

  @override
  Future<Result<List<Business>>> getBusinesses() async {
    try {
      final response = await _dio.get('/businesses');

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => (json as List).map((item) => Business.fromJson(item as Map<String, dynamic>)).toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        final businesses = apiResponse.data!.cast<Business>();
        return Result.success(businesses);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to get businesses',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while getting businesses',
        e,
      );
    }
  }

  @override
  Future<Result<Business>> getBusiness(int id) async {
    try {
      final response = await _dio.get('/businesses/$id');

      final apiResponse = ApiResponse<Business>.fromJson(
        response.data,
        (json) => Business.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to get business',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while getting business',
        e,
      );
    }
  }

  @override
  Future<Result<Business>> getBusinessBySlug(String slug) async {
    try {
      debugPrint('🔵 BusinessRepository: Making GET request to /public/businesses/slug/$slug');
      final response = await _dio.get('/public/businesses/slug/$slug');
      debugPrint('🔵 BusinessRepository: Response status: ${response.statusCode}');
      debugPrint('🔵 BusinessRepository: Response data: ${response.data}');

      final apiResponse = ApiResponse<Business>.fromJson(
        response.data,
        (json) => Business.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        debugPrint('🔵 BusinessRepository: Success! Business: ${apiResponse.data!.name}');
        return Result.success(apiResponse.data!);
      } else {
        debugPrint('🔵 BusinessRepository: API Error - ${apiResponse.message}');
        return Result.failure(
          apiResponse.message ?? 'Failed to get business by slug',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      debugPrint('🔵 BusinessRepository: DioException - ${e.message}');
      debugPrint('🔵 BusinessRepository: DioException status: ${e.response?.statusCode}');
      debugPrint('🔵 BusinessRepository: DioException data: ${e.response?.data}');
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      debugPrint('🔵 BusinessRepository: Unexpected error: $e');
      return Result.failure(
        'An unexpected error occurred while getting business by slug',
        e,
      );
    }
  }

  @override
  Future<Result<Business>> createBusiness(Business business) async {
    try {
      final response = await _dio.post('/businesses', data: business.toJson());

      final apiResponse = ApiResponse<Business>.fromJson(
        response.data,
        (json) => Business.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to create business',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while creating business',
        e,
      );
    }
  }

  @override
  Future<Result<Business>> updateBusiness(Business business) async {
    try {
      final response = await _dio.put('/businesses/${business.id}', data: business.toJson());

      final apiResponse = ApiResponse<Business>.fromJson(
        response.data,
        (json) => Business.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to update business',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while updating business',
        e,
      );
    }
  }

  @override
  Future<Result<void>> deleteBusiness(int id) async {
    try {
      await _dio.delete('/businesses/$id');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while deleting business',
        e,
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getBusinessStats(int businessId) async {
    try {
      final response = await _dio.get('/businesses/$businessId/stats');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to get business stats',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while getting business stats',
        e,
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getBusinessSettings(int businessId) async {
    try {
      final response = await _dio.get('/businesses/$businessId/settings');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to get business settings',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while getting business settings',
        e,
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> updateBusinessSettings(
    int businessId,
    Map<String, dynamic> settings,
  ) async {
    try {
      final response = await _dio.put('/businesses/$businessId/settings', data: settings);

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to update business settings',
          apiResponse.errors,
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while updating business settings',
        e,
      );
    }
  }
} 