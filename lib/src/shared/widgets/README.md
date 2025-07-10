# MessageDialog Component

A reusable message dialog component following Flutter Material Design conventions.

## Features

- **Multiple message types**: Success, Error, Warning, Info, Question
- **Customizable**: Icons, colors, actions, titles
- **Easy to use**: Static methods for common use cases
- **Accessible**: Follows Flutter accessibility guidelines
- **Consistent**: Uses app theme colors and styling

## Usage Examples

### Show an Error Dialog
```dart
MessageDialogExtension.showError(
  context,
  title: 'Login Failed',
  message: 'Invalid email or password. Please try again.',
);
```

### Show a Success Dialog
```dart
MessageDialogExtension.showSuccess(
  context,
  title: 'Success',
  message: 'Your profile has been updated successfully.',
);
```

### Show a Warning Dialog
```dart
MessageDialogExtension.showWarning(
  context,
  title: 'Warning',
  message: 'This action cannot be undone. Are you sure?',
);
```

### Show an Info Dialog
```dart
MessageDialogExtension.showInfo(
  context,
  title: 'Information',
  message: 'Your session will expire in 5 minutes.',
);
```

### Show a Confirmation Dialog
```dart
final confirmed = await MessageDialogExtension.showConfirmation(
  context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
);

if (confirmed == true) {
  // User confirmed the action
  deleteItem();
}
```

### Custom Dialog
```dart
showDialog(
  context: context,
  builder: (context) => MessageDialog(
    title: 'Custom Title',
    message: 'This is a custom message with custom actions.',
    type: MessageType.info,
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          // Perform action
        },
        child: const Text('Continue'),
      ),
    ],
  ),
);
```

## Message Types

- `MessageType.success` - Green checkmark icon
- `MessageType.error` - Red error icon
- `MessageType.warning` - Orange warning icon
- `MessageType.info` - Blue info icon
- `MessageType.question` - Purple question icon

## Best Practices

1. **Use appropriate message types** for different scenarios
2. **Keep messages concise** and user-friendly
3. **Provide clear action buttons** when needed
4. **Use consistent titles** across your app
5. **Handle dialog dismissal** properly in your logic

## Integration with State Management

When using with Riverpod or other state management:

```dart
// In your widget
final authState = ref.watch(authNotifierProvider);

// Show error dialog when state changes
if (authState.status == AuthStatus.error && authState.errorMessage != null) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    MessageDialogExtension.showError(
      context,
      title: 'Error',
      message: authState.errorMessage!,
    );
  });
}
``` 