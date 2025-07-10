import '../../../../shared/models/result.dart';
import '../../models/user.dart';
import '../../../business/models/business.dart';

/// Response object for login operations
class LoginResponse {
  final User user;
  final String token;
  final Business business;

  const LoginResponse({
    required this.user,
    required this.token,
    required this.business,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
    );
  }
}

/// Abstract interface for authentication repository
abstract class AuthRepository {
  /// Login with email and password and business slug
  Future<Result<LoginResponse>> login(String email, String password, String businessSlug);

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

  /// Clear all stored authentication data
  Future<void> clearStoredAuth();
} 