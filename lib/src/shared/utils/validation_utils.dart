import '../../core/extensions/string_extensions.dart';

/// Validation utility class for consistent form validation
class ValidationUtils {
  /// Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.isEmail) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Phone number validation
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!value.isPhone) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    if (!value.isUrl) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Minimum length validation
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }
    return null;
  }

  /// Maximum length validation
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allow empty values for max length validation
    }
    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be no more than $maxLength characters long';
    }
    return null;
  }

  /// Length range validation
  static String? lengthRange(String? value, int minLength, int maxLength, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value.length < minLength || value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be between $minLength and $maxLength characters long';
    }
    return null;
  }

  /// Numeric validation
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (!value.isNumeric) {
      return '${fieldName ?? 'This field'} must be a number';
    }
    return null;
  }

  /// Integer validation
  static String? integer(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (!value.isInteger) {
      return '${fieldName ?? 'This field'} must be a whole number';
    }
    return null;
  }

  /// Decimal validation
  static String? decimal(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (!value.isDecimal) {
      return '${fieldName ?? 'This field'} must be a decimal number';
    }
    return null;
  }

  /// Minimum value validation
  static String? minValue(num? value, num minValue, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value < minValue) {
      return '${fieldName ?? 'This field'} must be at least $minValue';
    }
    return null;
  }

  /// Maximum value validation
  static String? maxValue(num? value, num maxValue, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value > maxValue) {
      return '${fieldName ?? 'This field'} must be no more than $maxValue';
    }
    return null;
  }

  /// Value range validation
  static String? valueRange(num? value, num minValue, num maxValue, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value < minValue || value > maxValue) {
      return '${fieldName ?? 'This field'} must be between $minValue and $maxValue';
    }
    return null;
  }

  /// Positive number validation
  static String? positive(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (!value.isNumeric) {
      return '${fieldName ?? 'This field'} must be a number';
    }
    final numValue = double.tryParse(value);
    if (numValue == null || numValue <= 0) {
      return '${fieldName ?? 'This field'} must be a positive number';
    }
    return null;
  }

  /// Non-negative number validation
  static String? nonNegative(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (!value.isNumeric) {
      return '${fieldName ?? 'This field'} must be a number';
    }
    final numValue = double.tryParse(value);
    if (numValue == null || numValue < 0) {
      return '${fieldName ?? 'This field'} must be a non-negative number';
    }
    return null;
  }

  /// Credit card validation
  static String? creditCard(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Credit card number is required';
    }
    // Remove spaces and dashes
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!cleanValue.isNumeric || cleanValue.length < 13 || cleanValue.length > 19) {
      return 'Please enter a valid credit card number';
    }
    // Luhn algorithm validation
    if (!_isValidLuhn(cleanValue)) {
      return 'Please enter a valid credit card number';
    }
    return null;
  }

  /// Expiry date validation
  static String? expiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expiry date is required';
    }
    // Expected format: MM/YY or MM/YYYY
    final regex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2}|[0-9]{4})$');
    if (!regex.hasMatch(value)) {
      return 'Please enter expiry date in MM/YY or MM/YYYY format';
    }
    
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]);
    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;
    
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Credit card has expired';
    }
    return null;
  }

  /// CVV validation
  static String? cvv(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV is required';
    }
    if (!value.isNumeric || value.length < 3 || value.length > 4) {
      return 'Please enter a valid CVV';
    }
    return null;
  }

  /// Postal code validation (US format)
  static String? postalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }
    final regex = RegExp(r'^\d{5}(-\d{4})?$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid postal code';
    }
    return null;
  }

  /// Social Security Number validation (US format)
  static String? ssn(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'SSN is required';
    }
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
    final regex = RegExp(r'^\d{9}$');
    if (!regex.hasMatch(cleanValue)) {
      return 'Please enter a valid SSN';
    }
    return null;
  }

  /// Custom regex validation
  static String? regex(String? value, RegExp regex, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (!regex.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  /// Custom validation function
  static String? custom(String? value, bool Function(String) validator, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (!validator(value)) {
      return errorMessage;
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(List<String? Function(String?)> validators, String? value) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// Luhn algorithm for credit card validation
  static bool _isValidLuhn(String number) {
    int sum = 0;
    bool alternate = false;
    
    for (int i = number.length - 1; i >= 0; i--) {
      int n = int.parse(number[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    
    return (sum % 10) == 0;
  }
} 