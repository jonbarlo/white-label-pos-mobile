import 'package:dio/dio.dart';
import '../../errors/app_exception.dart';

/// Interceptor to handle common network errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException to AppException for logging/debugging
    final appException = _convertToAppException(err);
    
    // You could add logging here
    // Logger().e('Network Error: ${appException.message}', appException.originalError);
    
    // For now, just pass the error through
    handler.next(err);
  }

  AppException _convertToAppException(DioException err) {
    // Use the factory constructor from AppException
    return AppException.fromDioException(err);
  }
} 