import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation_service.dart';

/// Centralized error handling service
class ErrorService {
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  /// Handle API errors
  static void handleApiError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    String message = customMessage ?? _getErrorMessage(error);
    
    // Check if it's an authentication error
    if (_isAuthError(error)) {
      _handleAuthError(context);
      return;
    }

    // Check if it's a network error
    if (_isNetworkError(error)) {
      _showNetworkErrorDialog(context, message, onRetry);
      return;
    }

    // Show generic error dialog
    _showErrorDialog(context, message, onRetry);
  }

  /// Handle general errors
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    String message = customMessage ?? _getErrorMessage(error);
    _showErrorDialog(context, message, onRetry);
  }

  /// Handle validation errors
  static void handleValidationError(
    BuildContext context,
    Map<String, dynamic> errors, {
    String? customMessage,
  }) {
    String message = customMessage ?? _formatValidationErrors(errors);
    _showErrorDialog(context, message, null);
  }

  /// Get user-friendly error message
  static String _getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    }

    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return 'Network connection error. Please check your internet connection and try again.';
    }

    if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }

    if (error.toString().contains('401') ||
        error.toString().contains('Unauthorized')) {
      return 'Authentication failed. Please log in again.';
    }

    if (error.toString().contains('403') ||
        error.toString().contains('Forbidden')) {
      return 'You don\'t have permission to perform this action.';
    }

    if (error.toString().contains('404') ||
        error.toString().contains('Not Found')) {
      return 'The requested resource was not found.';
    }

    if (error.toString().contains('500') ||
        error.toString().contains('Internal Server Error')) {
      return 'Server error. Please try again later.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Check if error is authentication related
  static bool _isAuthError(dynamic error) {
    return error.toString().contains('401') ||
           error.toString().contains('Unauthorized') ||
           error.toString().contains('Token expired') ||
           error.toString().contains('Invalid token');
  }

  /// Check if error is network related
  static bool _isNetworkError(dynamic error) {
    return error.toString().contains('SocketException') ||
           error.toString().contains('NetworkException') ||
           error.toString().contains('Connection refused') ||
           error.toString().contains('No internet connection');
  }

  /// Handle authentication errors
  static void _handleAuthError(BuildContext context) {
    // Show message using navigation service
    NavigationService.showSnackBar(
      context,
      message: 'Please log in again to continue.',
      duration: const Duration(seconds: 3),
    );
  }

  /// Show network error dialog
  static void _showNetworkErrorDialog(
    BuildContext context,
    String message,
    VoidCallback? onRetry,
  ) {
    NavigationService.showCustomDialog(
      context,
      AlertDialog(
        title: const Text('Network Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => NavigationService.goBack(context),
            child: const Text('Close'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                NavigationService.goBack(context);
                onRetry();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Show error dialog
  static void _showErrorDialog(
    BuildContext context,
    String message,
    VoidCallback? onRetry,
  ) {
    NavigationService.showCustomDialog(
      context,
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => NavigationService.goBack(context),
            child: const Text('Close'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                NavigationService.goBack(context);
                onRetry();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Format validation errors
  static String _formatValidationErrors(Map<String, dynamic> errors) {
    if (errors.isEmpty) {
      return 'Please check your input and try again.';
    }

    final List<String> errorMessages = [];
    
    errors.forEach((field, messages) {
      if (messages is List) {
        for (final message in messages) {
          errorMessages.add('${_formatFieldName(field)}: $message');
        }
      } else if (messages is String) {
        errorMessages.add('${_formatFieldName(field)}: $messages');
      }
    });

    return errorMessages.join('\n');
  }

  /// Format field name for display
  static String _formatFieldName(String field) {
    return field
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: duration,
      ),
    );
  }

  /// Log error for debugging
  static void logError(
    String context,
    dynamic error, {
    StackTrace? stackTrace,
  }) {
    // Error logging would be implemented here in production
    // For now, we'll just ignore the error to avoid print statements
  }
}

/// Error handling provider
final errorServiceProvider = Provider<ErrorService>((ref) {
  return ErrorService();
}); 