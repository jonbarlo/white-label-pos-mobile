import 'package:intl/intl.dart';

/// Extensions for String class
extension StringExtensions on String {
  /// Capitalize first letter of each word
  String get toTitleCase {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Capitalize first letter only
  String get toSentenceCase {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Remove extra whitespace and normalize
  String get normalize {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Check if string is a valid email
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isPhone {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Truncate string to specified length
  String truncate(int length, {String suffix = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$suffix';
  }

  /// Extract initials from name
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Format as currency
  String toCurrency({String symbol = '\$', int decimalPlaces = 2}) {
    try {
      final number = double.parse(this);
      return NumberFormat.currency(
        symbol: symbol,
        decimalDigits: decimalPlaces,
      ).format(number);
    } catch (_) {
      return this;
    }
  }

  /// Format as percentage
  String toPercentage({int decimalPlaces = 1}) {
    try {
      final number = double.parse(this);
      return NumberFormat.decimalPercentPattern(
        decimalDigits: decimalPlaces,
      ).format(number / 100);
    } catch (_) {
      return this;
    }
  }

  /// Convert to slug (URL-friendly)
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  /// Check if string contains only digits
  bool get isNumeric {
    return RegExp(r'^\d+$').hasMatch(this);
  }

  /// Check if string contains only letters
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  }

  /// Check if string contains only letters and numbers
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(this);
  }

  /// Reverse string
  String get reversed {
    return split('').reversed.join();
  }

  /// Count words
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  /// Check if string is palindrome
  bool get isPalindrome {
    final clean = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return clean == clean.reversed;
  }

  /// Check if string is a valid integer
  bool get isInteger {
    return RegExp(r'^-?\d+$').hasMatch(this);
  }

  /// Check if string is a valid decimal number
  bool get isDecimal {
    return RegExp(r'^-?\d*\.?\d+$').hasMatch(this);
  }
} 