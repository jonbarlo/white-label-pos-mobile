import 'package:dio/dio.dart';
import '../../config/env_config.dart';

/// Interceptor for logging network requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvConfig.isDebugMode) {
      final fullUrl = _buildFullUrl(options);
      print('🌐 REQUEST[${options.method}] => FULL URL: $fullUrl');
      print('🌐 Headers: ${options.headers}');
      if (options.data != null) {
        print('🌐 Request Data: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('🌐 Query Parameters: ${options.queryParameters}');
      }
      print('🌐 Timeout: ${options.connectTimeout?.inSeconds}s');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (EnvConfig.isDebugMode) {
      final fullUrl = _buildFullUrl(response.requestOptions);
      print('✅ RESPONSE[${response.statusCode}] => FULL URL: $fullUrl');
      print('✅ Response Time: ${response.requestOptions.responseType}');
      if (response.data != null) {
        print('✅ Response Data: ${response.data}');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (EnvConfig.isDebugMode) {
      final fullUrl = _buildFullUrl(err.requestOptions);
      print('❌ ERROR[${err.response?.statusCode}] => FULL URL: $fullUrl');
      print('❌ Error Type: ${err.type}');
      print('❌ Error Message: ${err.message}');
      if (err.response?.data != null) {
        print('❌ Error Response Data: ${err.response?.data}');
      }
      print('❌ Error Details: ${err.toString()}');
    }
    handler.next(err);
  }

  /// Build the full URL including protocol, domain, and path
  String _buildFullUrl(RequestOptions options) {
    final scheme = options.uri.scheme;
    final host = options.uri.host;
    final port = options.uri.port;
    final path = options.uri.path;
    final query = options.uri.query;
    
    String fullUrl = '$scheme://$host';
    if (port != 80 && port != 443) {
      fullUrl += ':$port';
    }
    fullUrl += path;
    if (query.isNotEmpty) {
      fullUrl += '?$query';
    }
    
    return fullUrl;
  }
} 