import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _businessSlugKey = 'business_slug';
  static const String _userIdKey = 'user_id';
  static const String _businessIdKey = 'business_id';

  AuthRepositoryImpl(this._dio, this._prefs);

  @override
  Future<LoginResponse> login({required String email, required String password, required String businessSlug}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
        'businessSlug': businessSlug,
      });

      final loginResponse = LoginResponse.fromJson(response.data);
      
      // Store authentication data
      await _prefs.setString(_tokenKey, loginResponse.token);
      await _prefs.setString(_businessSlugKey, businessSlug);
      await _prefs.setInt(_userIdKey, loginResponse.user.id);
      await _prefs.setInt(_businessIdKey, loginResponse.business.id);
      
      return loginResponse;
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_businessSlugKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_businessIdKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = _prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }
} 