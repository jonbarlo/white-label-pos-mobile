import 'package:flutter/material.dart';

/// A reusable message dialog component following Flutter Material Design conventions.
/// 
/// This dialog can be used to show various types of messages to users:
/// - Success messages
/// - Error messages  
/// - Warning messages
/// - Information messages
/// - Confirmation dialogs
class MessageDialog extends StatelessWidget {
  /// The title of the dialog
  final String? title;
  
  /// The main message content
  final String message;
  
  /// The type of message to display
  final MessageType type;
  
  /// Optional action buttons
  final List<Widget>? actions;
  
  /// Whether to show a close button (X) in the app bar
  final bool showCloseButton;
  
  /// Whether the dialog can be dismissed by tapping outside
  final bool barrierDismissible;
  
  /// Custom icon to display
  final IconData? customIcon;
  
  /// Custom color for the icon
  final Color? customIconColor;

  const MessageDialog({
    super.key,
    this.title,
    required this.message,
    this.type = MessageType.info,
    this.actions,
    this.showCloseButton = true,
    this.barrierDismissible = true,
    this.customIcon,
    this.customIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: title != null ? Text(title!) : null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            customIcon ?? _getIconForType(),
            size: 48,
            color: customIconColor ?? _getColorForType(theme),
          ),
          const SizedBox(height: 16),
          
          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      actions: actions ?? [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  IconData _getIconForType() {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle_outline;
      case MessageType.error:
        return Icons.error_outline;
      case MessageType.warning:
        return Icons.warning_amber_outlined;
      case MessageType.info:
        return Icons.info_outline;
      case MessageType.question:
        return Icons.help_outline;
    }
  }

  Color _getColorForType(ThemeData theme) {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return theme.colorScheme.error;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.info:
        return theme.colorScheme.primary;
      case MessageType.question:
        return theme.colorScheme.secondary;
    }
  }
}

/// Types of messages that can be displayed
enum MessageType {
  success,
  error,
  warning,
  info,
  question,
}

/// Extension to provide convenient static methods for showing dialogs
extension MessageDialogExtension on MessageDialog {
  /// Show a success message dialog
  static Future<void> showSuccess(
    BuildContext context, {
    String? title,
    required String message,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MessageDialog(
        title: title,
        message: message,
        type: MessageType.success,
        actions: actions,
      ),
    );
  }

  /// Show an error message dialog
  static Future<void> showError(
    BuildContext context, {
    String? title,
    required String message,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MessageDialog(
        title: title ?? 'Error',
        message: message,
        type: MessageType.error,
        actions: actions,
      ),
    );
  }

  /// Show a warning message dialog
  static Future<void> showWarning(
    BuildContext context, {
    String? title,
    required String message,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MessageDialog(
        title: title ?? 'Warning',
        message: message,
        type: MessageType.warning,
        actions: actions,
      ),
    );
  }

  /// Show an info message dialog
  static Future<void> showInfo(
    BuildContext context, {
    String? title,
    required String message,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MessageDialog(
        title: title ?? 'Information',
        message: message,
        type: MessageType.info,
        actions: actions,
      ),
    );
  }

  /// Show a confirmation dialog
  static Future<bool?> showConfirmation(
    BuildContext context, {
    String? title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => MessageDialog(
        title: title ?? 'Confirm',
        message: message,
        type: MessageType.question,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
} 