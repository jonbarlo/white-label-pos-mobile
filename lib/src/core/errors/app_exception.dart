import 'package:dio/dio.dart';

/// Custom application exception class
class AppException implements Exception {
  final String message;
  final String? code;
  final AppExceptionType type;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    required this.type,
    this.originalError,
  });

  /// Create from DioException
  factory AppException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          message: 'Connection timeout. Please check your internet connection.',
          type: AppExceptionType.network,
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        if (statusCode == 401) {
          return AppException(
            message: 'Authentication failed. Please login again.',
            code: 'UNAUTHORIZED',
            type: AppExceptionType.unauthorized,
            originalError: e,
          );
        } else if (statusCode == 403) {
          return AppException(
            message: 'Access denied. You don\'t have permission to perform this action.',
            code: 'FORBIDDEN',
            type: AppExceptionType.forbidden,
            originalError: e,
          );
        } else if (statusCode == 404) {
          return AppException(
            message: 'Resource not found.',
            code: 'NOT_FOUND',
            type: AppExceptionType.notFound,
            originalError: e,
          );
        } else if (statusCode == 422) {
          final message = _extractValidationMessage(data);
          return AppException(
            message: message,
            code: 'VALIDATION_ERROR',
            type: AppExceptionType.validation,
            originalError: e,
          );
        } else if (statusCode! >= 500) {
          return AppException(
            message: 'Server error. Please try again later.',
            code: 'SERVER_ERROR',
            type: AppExceptionType.server,
            originalError: e,
          );
        } else {
          return AppException(
            message: _extractErrorMessage(data) ?? 'An error occurred.',
            code: 'HTTP_ERROR',
            type: AppExceptionType.http,
            originalError: e,
          );
        }
      case DioExceptionType.cancel:
        return AppException(
          message: 'Request was cancelled.',
          type: AppExceptionType.cancelled,
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return AppException(
          message: 'No internet connection. Please check your network settings.',
          type: AppExceptionType.network,
          originalError: e,
        );
      case DioExceptionType.badCertificate:
        return AppException(
          message: 'SSL certificate error. Please contact support.',
          type: AppExceptionType.ssl,
          originalError: e,
        );
      case DioExceptionType.unknown:
      default:
        return AppException(
          message: 'An unexpected error occurred.',
          type: AppExceptionType.unknown,
          originalError: e,
        );
    }
  }

  /// Create from general exception
  factory AppException.fromException(dynamic error) {
    if (error is AppException) {
      return error;
    } else if (error is DioException) {
      return AppException.fromDioException(error);
    } else {
      return AppException(
        message: error.toString(),
        type: AppExceptionType.unknown,
        originalError: error,
      );
    }
  }

  /// Create network exception
  factory AppException.network(String message) {
    return AppException(
      message: message,
      type: AppExceptionType.network,
    );
  }

  /// Create validation exception
  factory AppException.validation(String message) {
    return AppException(
      message: message,
      type: AppExceptionType.validation,
    );
  }

  /// Create unauthorized exception
  factory AppException.unauthorized(String message) {
    return AppException(
      message: message,
      type: AppExceptionType.unauthorized,
    );
  }

  /// Create forbidden exception
  factory AppException.forbidden(String message) {
    return AppException(
      message: message,
      type: AppExceptionType.forbidden,
    );
  }

  /// Create not found exception
  factory AppException.notFound(String message) {
    return AppException(
      message: message,
      type: AppExceptionType.notFound,
    );
  }

  /// Create server exception
  factory AppException.server(String message) {
    return AppException(
      message: message,
      type: AppExceptionType.server,
    );
  }

  /// Create unknown exception
  factory AppException.unknown(String message) {
    return AppException(
      message: message,
      type: AppExceptionType.unknown,
    );
  }

  /// Extract error message from response data
  static String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String?;
    } else if (data is String) {
      return data;
    }
    return null;
  }

  /// Extract validation error message from response data
  static String _extractValidationMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        } else if (firstError is String) {
          return firstError;
        }
      }
      return data['message'] as String? ?? 'Validation failed';
    }
    return 'Validation failed';
  }

  String get userFriendlyMessage {
    switch (type) {
      case AppExceptionType.network:
        return 'Network error. Please check your connection and try again.';
      case AppExceptionType.unauthorized:
        return 'Authentication failed. Please log in again.';
      case AppExceptionType.forbidden:
        return 'You don\'t have permission to perform this action.';
      case AppExceptionType.validation:
        return 'Please check your input and try again.';
      case AppExceptionType.server:
        return 'Server error. Please try again later.';
      case AppExceptionType.notFound:
        return 'Resource not found.';
      case AppExceptionType.http:
        return 'Request failed. Please try again.';
      case AppExceptionType.ssl:
        return 'SSL certificate error. Please contact support.';
      case AppExceptionType.cancelled:
        return 'Request was cancelled.';
      case AppExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  String toString() {
    return 'AppException: $message (${type.name})';
  }
}

/// Types of application exceptions
enum AppExceptionType {
  network,
  validation,
  unauthorized,
  forbidden,
  notFound,
  server,
  http,
  ssl,
  cancelled,
  unknown,
} 