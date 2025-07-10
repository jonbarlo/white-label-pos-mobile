import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env_config.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Centralized Dio client provider
final dioClientProvider = Provider<Dio>((ref) {
  final baseUrl = EnvConfig.apiBaseUrl;
  
  if (EnvConfig.isDebugMode) {
    print('🔧 DIO CLIENT CONFIGURATION:');
    print('🔧 Base URL: $baseUrl');
    print('🔧 Connect Timeout: ${EnvConfig.apiTimeout}ms');
    print('🔧 Debug Mode: ${EnvConfig.isDebugMode}');
    print('🔧 App Name: ${EnvConfig.appName}');
  }
  
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(milliseconds: EnvConfig.apiTimeout),
    receiveTimeout: Duration(milliseconds: EnvConfig.apiTimeout),
    sendTimeout: Duration(milliseconds: EnvConfig.apiTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'WhiteLabelPOS-Mobile/${EnvConfig.appName}',
    },
  ));

  // Add interceptors
  dio.interceptors.addAll([
    LoggingInterceptor(),
    AuthInterceptor(ref),
    ErrorInterceptor(),
  ]);

  if (EnvConfig.isDebugMode) {
    print('🔧 DIO CLIENT READY - Interceptors added: ${dio.interceptors.length}');
  }

  return dio;
}); 