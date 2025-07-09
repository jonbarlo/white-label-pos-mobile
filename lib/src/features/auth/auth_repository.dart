import 'models/user.dart';
import '../business/models/business.dart';

class LoginResponse {
  final String message;
  final User user;
  final Business business;
  final String token;

  LoginResponse({
    required this.message,
    required this.user,
    required this.business,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}

abstract class AuthRepository {
  Future<LoginResponse> login({
    required String email,
    required String password,
    required String businessSlug,
  });
  
  Future<void> logout();
  Future<bool> isLoggedIn();
} 