import '../../../../shared/models/result.dart';
import '../../models/user.dart';

/// Abstract interface for authentication repository
abstract class AuthRepository {
  /// Login with email and password
  Future<Result<User>> login(String email, String password);

  /// Register a new user
  Future<Result<User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });

  /// Logout the current user
  Future<Result<void>> logout();

  /// Get the current authenticated user
  Future<Result<User>> getCurrentUser();

  /// Refresh the authentication token
  Future<Result<void>> refreshToken();

  /// Request password reset
  Future<Result<void>> forgotPassword(String email);

  /// Reset password with token
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Update user profile
  Future<Result<User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
  });

  /// Change user password
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
} 