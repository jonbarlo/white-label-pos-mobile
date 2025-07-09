import 'package:dio/dio.dart';
import '../../errors/app_exception.dart';

/// Interceptor to handle common network errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException to AppException
    final appException = _convertToAppException(err);
    
    // You could add logging here
    // Logger().e('Network Error: ${appException.message}', appException.originalError);
    
    handler.next(err);
  }

  AppException _convertToAppException(DioException err) {
    final statusCode = err.response?.statusCode;
    final message = err.response?.data?['message'] ?? err.message ?? 'Network error occurred';
    final endpoint = err.requestOptions.path;

    switch (statusCode) {
      case 400:
        return ValidationException(
          message,
          statusCode: statusCode,
          endpoint: endpoint,
          originalError: err,
        );
      case 401:
        return AuthenticationException(
          message,
          statusCode: statusCode,
          endpoint: endpoint,
          originalError: err,
        );
      case 403:
        return BusinessException(
          'Access denied',
          statusCode: statusCode,
          endpoint: endpoint,
          originalError: err,
        );
      case 404:
        return NetworkException(
          'Resource not found',
          statusCode: statusCode,
          endpoint: endpoint,
          originalError: err,
        );
      case 500:
      case 502:
      case 503:
        return NetworkException(
          'Server error occurred',
          statusCode: statusCode,
          endpoint: endpoint,
          originalError: err,
        );
      default:
        return NetworkException(
          message,
          statusCode: statusCode,
          endpoint: endpoint,
          originalError: err,
        );
    }
  }
} 