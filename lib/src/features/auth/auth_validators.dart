/// Utility class for authentication form validation
class AuthValidators {
  /// Validates email addresses
  /// 
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Email is required';
    }
    
    // Use a robust regex that allows + in local part
    final emailRegex = RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email';
    }
    
    // Reject consecutive dots in local or domain part
    final parts = trimmed.split('@');
    if (parts.length != 2 || parts[0].contains('..') || parts[1].contains('..')) {
      return 'Please enter a valid email';
    }
    
    // Reject domains that start with a dot
    if (parts[1].startsWith('.')) {
      return 'Please enter a valid email';
    }
    
    // Reject local parts that start with a dot
    if (parts[0].startsWith('.')) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  /// Validates passwords
  /// 
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates business slugs
  /// 
  /// Returns null if valid, error message if invalid
  static String? validateBusinessSlug(String? value) {
    if (value == null || value.isEmpty) {
      return 'Business slug is required';
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Business slug is required';
    }
    return null;
  }
} 