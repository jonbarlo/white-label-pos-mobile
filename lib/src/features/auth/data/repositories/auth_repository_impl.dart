import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/models/api_response.dart';
import '../../../../shared/models/result.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/user.dart';
import '../../../business/models/business.dart';
import 'auth_repository.dart';
import 'package:flutter/foundation.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepositoryImpl(dio);
});

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Result<LoginResponse>> login(String email, String password, String businessSlug) async {
    try {
      debugPrint('🔵 AuthRepository: Making login request');
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
        'businessSlug': businessSlug,
      });

      debugPrint('🔵 AuthRepository: Response received: ${response.data}');
      
      // Backend returns direct response, not wrapped in ApiResponse
      final responseData = response.data as Map<String, dynamic>;
      
      debugPrint('🔵 AuthRepository: Response data: $responseData');
      
      if (responseData['message'] == 'Login successful' && 
          responseData['user'] != null && 
          responseData['token'] != null &&
          responseData['business'] != null) {
        
                 debugPrint('🔵 AuthRepository: Parsing user data');
         final userData = responseData['user'] as Map<String, dynamic>;
         debugPrint('🔵 AuthRepository: User data: $userData');
         
         // Debug each required field in User
         debugPrint('🔵 AuthRepository: User.id = ${userData['id']}');
         debugPrint('🔵 AuthRepository: User.businessId = ${userData['businessId']}');
         debugPrint('🔵 AuthRepository: User.name = ${userData['name']}');
         debugPrint('🔵 AuthRepository: User.email = ${userData['email']}');
         debugPrint('🔵 AuthRepository: User.role = ${userData['role']}');
         debugPrint('🔵 AuthRepository: User.isActive = ${userData['isActive']}');
         debugPrint('🔵 AuthRepository: User.createdAt = ${userData['createdAt']}');
         debugPrint('🔵 AuthRepository: User.updatedAt = ${userData['updatedAt']}');
         
         debugPrint('🔵 AuthRepository: Parsing business data');
         final businessData = responseData['business'] as Map<String, dynamic>;
         debugPrint('🔵 AuthRepository: Business data: $businessData');
         
         // Debug each required field in Business
         debugPrint('🔵 AuthRepository: Business.id = ${businessData['id']}');
         debugPrint('🔵 AuthRepository: Business.name = ${businessData['name']}');
         debugPrint('🔵 AuthRepository: Business.slug = ${businessData['slug']}');
         debugPrint('🔵 AuthRepository: Business.taxRate = ${businessData['taxRate']}');
         debugPrint('🔵 AuthRepository: Business.currencyId = ${businessData['currencyId']}');
         debugPrint('🔵 AuthRepository: Business.timezone = ${businessData['timezone']}');
         
         // Create LoginResponse with business from the response
         final loginResponse = LoginResponse(
           user: User.fromJson(userData),
           token: responseData['token'] as String,
           business: Business.fromJson(businessData),
         );
        
        debugPrint('🔵 AuthRepository: Login response created successfully');
        return Result.success(loginResponse);
      } else {
        debugPrint('🔴 AuthRepository: Login failed - invalid response structure');
        return Result.failure(
          responseData['message'] ?? 'Login failed',
          responseData['errors'],
        );
      }
    } on DioException catch (e) {
      debugPrint('🔴 AuthRepository: DioException: ${e.message}');
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      debugPrint('🔴 AuthRepository: Unexpected error: $e');
      debugPrint('🔴 AuthRepository: Error type: ${e.runtimeType}');
      return Result.failure(
        'An unexpected error occurred during login',
        e,
      );
    }
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        if (phone != null) 'phone': phone,
      });

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Registration failed',
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
        'An unexpected error occurred during registration',
        e,
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _dio.post('/auth/logout');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred during logout',
        e,
      );
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to get current user',
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
        'An unexpected error occurred while getting current user',
        e,
      );
    }
  }

  @override
  Future<Result<void>> refreshToken() async {
    try {
      await _dio.post('/auth/refresh');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while refreshing token',
        e,
      );
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/forgot-password', data: {
        'email': email,
      });
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while processing forgot password',
        e,
      );
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dio.post('/auth/reset-password', data: {
        'token': token,
        'newPassword': newPassword,
      });
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while resetting password',
        e,
      );
    }
  }

  @override
  Future<Result<User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (phone != null) data['phone'] = phone;
      if (avatar != null) data['avatar'] = avatar;

      final response = await _dio.put('/auth/profile', data: data);

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Failed to update profile',
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
        'An unexpected error occurred while updating profile',
        e,
      );
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.put('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(
        AppException.fromDioException(e).message,
        e,
      );
    } catch (e) {
      return Result.failure(
        'An unexpected error occurred while changing password',
        e,
      );
    }
  }

  @override
  Future<void> clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('business_slug');
    await prefs.remove('user_id');
    await prefs.remove('business_id');
  }
} 