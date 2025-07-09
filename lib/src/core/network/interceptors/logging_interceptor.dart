import 'package:dio/dio.dart';
import '../../config/env_config.dart';

/// Interceptor for logging network requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvConfig.isDebugMode) {
      print('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
      print('🌐 Headers: ${options.headers}');
      if (options.data != null) {
        print('🌐 Data: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (EnvConfig.isDebugMode) {
      print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      print('✅ Data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (EnvConfig.isDebugMode) {
      print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      print('❌ Message: ${err.message}');
      print('❌ Data: ${err.response?.data}');
    }
    handler.next(err);
  }
} 