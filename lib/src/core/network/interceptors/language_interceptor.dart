import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/language/language_provider.dart';

class LanguageInterceptor extends Interceptor {
  final Ref _ref;

  LanguageInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get current language from provider, default to Spanish (es-CR) as per backend
    final currentLanguage = _ref.read(currentLanguageCodeProvider);
    
    // Add Accept-Language header for proper language negotiation
    options.headers['Accept-Language'] = currentLanguage;
    
    // Add language as query parameter for endpoints that support it
    if (options.path.contains('/auth/') || 
        options.path.contains('/language/preference') ||
        options.path.contains('/users') ||
        options.path.contains('/businesses')) {
      options.queryParameters['lang'] = currentLanguage;
    }
    
    // For authentication endpoints, ensure language is included
    if (options.path.contains('/auth/login') || options.path.contains('/auth/register')) {
      options.queryParameters['lang'] = currentLanguage;
    }
    
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log language-related responses for debugging
    if (response.requestOptions.path.contains('/language/') || 
        response.requestOptions.path.contains('/auth/')) {
      print('🌐 Language Response: ${response.requestOptions.path} - Status: ${response.statusCode}');
    }
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log language-related errors for debugging
    if (err.requestOptions.path.contains('/language/') || 
        err.requestOptions.path.contains('/auth/')) {
      print('🌐 Language Error: ${err.requestOptions.path} - ${err.message}');
    }
    
    handler.next(err);
  }
} 