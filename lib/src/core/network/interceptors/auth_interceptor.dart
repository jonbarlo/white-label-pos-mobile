import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_provider.dart';

/// Interceptor to add authentication headers
class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authState = _ref.read(authNotifierProvider);
    
    if (authState.token != null) {
      options.headers['Authorization'] = 'Bearer ${authState.token}';
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized - could trigger logout
      _ref.read(authNotifierProvider.notifier).logout();
    }
    
    handler.next(err);
  }
} 