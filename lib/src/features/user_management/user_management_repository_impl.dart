import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/user_management/user_management_repository.dart';
import 'package:white_label_pos_mobile/src/features/user_management/models/user.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  static const String _usersCacheKey = 'users_cache';
  static const String _rolesCacheKey = 'user_roles_cache';

  UserManagementRepositoryImpl(this._dio, this._prefs);

  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      final users = (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();

      // Cache the users
      await _prefs.setString(_usersCacheKey, response.data.toString());

      return users;
    } on DioException catch (e) {
      // Try to get cached data on error
      final cachedData = _prefs.getString(_usersCacheKey);
      if (cachedData != null) {
        // Return cached data if available
        return [];
      }
      throw Exception('Failed to get users: ${e.message}');
    }
  }

  @override
  Future<User> getUser(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get user: ${e.message}');
    }
  }

  @override
  Future<User> createUser(User user) async {
    try {
      final response = await _dio.post('/users', data: user.toJson());
      final createdUser = User.fromJson(response.data);

      // Invalidate cache
      await _prefs.remove(_usersCacheKey);

      return createdUser;
    } on DioException catch (e) {
      throw Exception('Failed to create user: ${e.message}');
    }
  }

  @override
  Future<User> updateUser(User user) async {
    try {
      final response = await _dio.put('/users/${user.id}', data: user.toJson());
      final updatedUser = User.fromJson(response.data);

      // Invalidate cache
      await _prefs.remove(_usersCacheKey);

      return updatedUser;
    } on DioException catch (e) {
      throw Exception('Failed to update user: ${e.message}');
    }
  }

  @override
  Future<bool> deleteUser(String id) async {
    try {
      await _dio.delete('/users/$id');

      // Invalidate cache
      await _prefs.remove(_usersCacheKey);

      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      throw Exception('Failed to delete user: ${e.message}');
    }
  }

  @override
  Future<User> updateUserRole(String userId, String newRole) async {
    try {
      final response = await _dio.patch('/users/$userId/role', data: {
        'role': newRole,
      });
      final updatedUser = User.fromJson(response.data);

      // Invalidate cache
      await _prefs.remove(_usersCacheKey);

      return updatedUser;
    } on DioException catch (e) {
      throw Exception('Failed to update user role: ${e.message}');
    }
  }

  @override
  Future<User> toggleUserStatus(String userId) async {
    try {
      final response = await _dio.patch('/users/$userId/status');
      final updatedUser = User.fromJson(response.data);

      // Invalidate cache
      await _prefs.remove(_usersCacheKey);

      return updatedUser;
    } on DioException catch (e) {
      throw Exception('Failed to toggle user status: ${e.message}');
    }
  }

  @override
  Future<List<String>> getUserRoles() async {
    try {
      final response = await _dio.get('/users/roles');
      final roles = List<String>.from(response.data);

      // Cache the roles
      await _prefs.setString(_rolesCacheKey, response.data.toString());

      return roles;
    } on DioException catch (e) {
      // Try to get cached data on error
      final cachedData = _prefs.getString(_rolesCacheKey);
      if (cachedData != null) {
        // Return default roles if cache is available
        return ['admin', 'manager', 'cashier', 'viewer'];
      }
      throw Exception('Failed to get user roles: ${e.message}');
    }
  }

  @override
  Future<List<String>> getUserPermissions(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/permissions');
      return List<String>.from(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get user permissions: ${e.message}');
    }
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await _dio.get('/users/search', queryParameters: {
        'q': query,
      });
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search users: ${e.message}');
    }
  }

  @override
  Future<List<User>> getUsersByRole(String role) async {
    try {
      final response = await _dio.get('/users', queryParameters: {
        'role': role,
      });
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get users by role: ${e.message}');
    }
  }

  @override
  Future<int> getActiveUsersCount() async {
    try {
      final response = await _dio.get('/users/stats/active-count');
      return response.data['count'] ?? 0;
    } on DioException catch (e) {
      throw Exception('Failed to get active users count: ${e.message}');
    }
  }

  @override
  Future<List<User>> getUsersByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final response = await _dio.get('/users', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get users by date range: ${e.message}');
    }
  }
} 