import 'package:dio/dio.dart';

/// Interceptor for logging network requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🔍 DEBUG: Dio Request: ${options.method} ${options.uri}');
    print('🔍 DEBUG: Dio Request Headers: ${options.headers}');
    if (options.data != null) {
      print('🔍 DEBUG: Dio Request Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('🔍 DEBUG: Dio Response: ${response.statusCode} ${response.requestOptions.uri}');
    print('🔍 DEBUG: Dio Response Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('🔍 DEBUG: Dio Error: ${err.type} ${err.message}');
    print('🔍 DEBUG: Dio Error URL: ${err.requestOptions.uri}');
    print('🔍 DEBUG: Dio Error Response: ${err.response?.data}');
    handler.next(err);
  }
} 