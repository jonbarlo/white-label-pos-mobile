import 'package:white_label_pos_mobile/src/features/user_management/models/user.dart';

abstract class UserManagementRepository {
  /// Get all users
  Future<List<User>> getUsers();

  /// Get a specific user by ID
  Future<User> getUser(String id);

  /// Create a new user
  Future<User> createUser(User user);

  /// Update an existing user
  Future<User> updateUser(User user);

  /// Delete a user
  Future<bool> deleteUser(String id);

  /// Update user role
  Future<User> updateUserRole(String userId, String newRole);

  /// Toggle user active status
  Future<User> toggleUserStatus(String userId);

  /// Get available user roles
  Future<List<String>> getUserRoles();

  /// Get user permissions
  Future<List<String>> getUserPermissions(String userId);

  /// Search users by name or email
  Future<List<User>> searchUsers(String query);

  /// Get users by role
  Future<List<User>> getUsersByRole(String role);

  /// Get active users count
  Future<int> getActiveUsersCount();

  /// Get users created in date range
  Future<List<User>> getUsersByDateRange(DateTime startDate, DateTime endDate);
} 