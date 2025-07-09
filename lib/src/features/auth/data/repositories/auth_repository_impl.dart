import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/api_response.dart';
import '../../../../shared/models/result.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/user.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepositoryImpl(dio);
});

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(
          apiResponse.message ?? 'Login failed',
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
} 