import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/performance_service.dart';

/// Centralized navigation service for consistent navigation patterns
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Navigate to a new screen
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    Widget screen, {
    String? routeName,
  }) {
    final performanceService = PerformanceService();
    performanceService.startTimer('navigation_${routeName ?? 'unknown'}');
    
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (context) => screen,
        settings: RouteSettings(name: routeName),
      ),
    ).then((result) {
      performanceService.endTimer('navigation_${routeName ?? 'unknown'}');
      return result;
    });
  }

  /// Navigate to a new screen and replace current screen
  static Future<T?> navigateToReplacement<T extends Object?>(
    BuildContext context,
    Widget screen, {
    String? routeName,
  }) {
    final performanceService = PerformanceService();
    performanceService.startTimer('navigation_replace_${routeName ?? 'unknown'}');
    
    return Navigator.of(context).pushReplacement<T, void>(
      MaterialPageRoute<T>(
        builder: (context) => screen,
        settings: RouteSettings(name: routeName),
      ),
    ).then((result) {
      performanceService.endTimer('navigation_replace_${routeName ?? 'unknown'}');
      return result;
    });
  }

  /// Navigate to a new screen and clear all previous screens
  static Future<T?> navigateToAndClear<T extends Object?>(
    BuildContext context,
    Widget screen, {
    String? routeName,
  }) {
    final performanceService = PerformanceService();
    performanceService.startTimer('navigation_clear_${routeName ?? 'unknown'}');
    
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(
        builder: (context) => screen,
        settings: RouteSettings(name: routeName),
      ),
      (route) => false,
    ).then((result) {
      performanceService.endTimer('navigation_clear_${routeName ?? 'unknown'}');
      return result;
    });
  }

  /// Navigate back
  static void goBack<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    final performanceService = PerformanceService();
    performanceService.startTimer('navigation_back');
    
    Navigator.of(context).pop<T>(result);
    performanceService.endTimer('navigation_back');
  }

  /// Navigate back multiple times
  static void goBackMultiple(
    BuildContext context,
    int count,
  ) {
    final performanceService = PerformanceService();
    performanceService.startTimer('navigation_back_multiple');
    
    for (int i = 0; i < count; i++) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
    
    performanceService.endTimer('navigation_back_multiple');
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// Show a dialog
  static Future<T?> showCustomDialog<T extends Object?>(
    BuildContext context,
    Widget dialog, {
    bool barrierDismissible = true,
  }) {
    final performanceService = PerformanceService();
    performanceService.startTimer('dialog_show');
    
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => dialog,
    ).then((result) {
      performanceService.endTimer('dialog_show');
      return result;
    });
  }

  /// Show a bottom sheet
  static Future<T?> showBottomSheet<T extends Object?>(
    BuildContext context,
    Widget bottomSheet, {
    bool isScrollControlled = false,
    bool enableDrag = true,
  }) {
    final performanceService = PerformanceService();
    performanceService.startTimer('bottom_sheet_show');
    
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      builder: (context) => bottomSheet,
    ).then((result) {
      performanceService.endTimer('bottom_sheet_show');
      return result;
    });
  }

  /// Show a snackbar
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final performanceService = PerformanceService();
    performanceService.startTimer('snackbar_show');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
    
    performanceService.endTimer('snackbar_show');
  }

  /// Show an error dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return showCustomDialog(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(context),
            child: const Text('OK'),
          ),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: () {
                goBack(context);
                onAction();
              },
              child: Text(actionText),
            ),
        ],
      ),
    );
  }

  /// Show a confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showCustomDialog<bool>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => goBack(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  /// Show a loading dialog
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    return showCustomDialog(
      context,
      AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      goBack(context);
    }
  }
}

/// Provider for NavigationService
final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService();
}); 