import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'app_button.dart';

/// Custom error widget for consistent error display
class AppErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final IconData? icon;
  final bool showAction;

  const AppErrorWidget({
    super.key,
    this.title,
    this.message,
    this.actionText,
    this.onActionPressed,
    this.icon,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.smallPadding),
            ],
            if (message != null) ...[
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ],
            if (showAction && actionText != null && onActionPressed != null) ...[
              AppButton(
                text: actionText!,
                onPressed: onActionPressed,
                type: AppButtonType.primary,
                size: AppButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: 'Network Error',
      message: message ?? AppConstants.networkErrorMessage,
      actionText: 'Retry',
      onActionPressed: onRetry,
      icon: Icons.wifi_off,
    );
  }
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: 'Server Error',
      message: message ?? AppConstants.serverErrorMessage,
      actionText: 'Retry',
      onActionPressed: onRetry,
      icon: Icons.cloud_off,
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.actionText,
    this.onActionPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: theme.textTheme.bodySmall?.color,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.smallPadding),
            ],
            if (message != null) ...[
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ],
            if (actionText != null && onActionPressed != null) ...[
              AppButton(
                text: actionText!,
                onPressed: onActionPressed,
                type: AppButtonType.primary,
                size: AppButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Permission denied widget
class PermissionDeniedWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRequestPermission;

  const PermissionDeniedWidget({
    super.key,
    this.message,
    this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      title: 'Permission Required',
      message: message ?? 'This feature requires permission to access your device.',
      actionText: 'Grant Permission',
      onActionPressed: onRequestPermission,
      icon: Icons.lock_outline,
    );
  }
}

/// Error dialog widget
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (actionText != null && onActionPressed != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onActionPressed!();
            },
            child: Text(actionText!),
          ),
      ],
    );
  }
}

/// Show error dialog
Future<void> showErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? actionText,
  VoidCallback? onActionPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) => ErrorDialog(
      title: title,
      message: message,
      actionText: actionText,
      onActionPressed: onActionPressed,
    ),
  );
}

/// Show network error dialog
Future<void> showNetworkErrorDialog(
  BuildContext context, {
  String? message,
  VoidCallback? onRetry,
}) {
  return showErrorDialog(
    context,
    title: 'Network Error',
    message: message ?? AppConstants.networkErrorMessage,
    actionText: 'Retry',
    onActionPressed: onRetry,
  );
}

/// Show server error dialog
Future<void> showServerErrorDialog(
  BuildContext context, {
  String? message,
  VoidCallback? onRetry,
}) {
  return showErrorDialog(
    context,
    title: 'Server Error',
    message: message ?? AppConstants.serverErrorMessage,
    actionText: 'Retry',
    onActionPressed: onRetry,
  );
} 