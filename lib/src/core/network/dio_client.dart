import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../config/env_config.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Centralized Dio client provider
final dioClientProvider = Provider<Dio>((ref) {
  print('🔍 DEBUG: dioClientProvider: Creating Dio client');
  final baseUrl = EnvConfig.apiBaseUrl;
  print('🔍 DEBUG: dioClientProvider: Base URL = $baseUrl');
  
  // Base headers that work across all platforms
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Only add User-Agent header for non-web platforms
  if (!kIsWeb) {
    headers['User-Agent'] = 'WhiteLabelPOS-Mobile/${EnvConfig.appName}';
  }
  
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(milliseconds: EnvConfig.apiTimeout),
    receiveTimeout: Duration(milliseconds: EnvConfig.apiTimeout),
    sendTimeout: Duration(milliseconds: EnvConfig.apiTimeout),
    headers: headers,
    // Web-specific settings
    validateStatus: (status) => status != null && status < 500,
  ));

  // Add interceptors
  dio.interceptors.addAll([
    LoggingInterceptor(),
    AuthInterceptor(ref),
    ErrorInterceptor(),
  ]);

  print('🔍 DEBUG: dioClientProvider: Dio client created successfully');
  return dio;
}); 