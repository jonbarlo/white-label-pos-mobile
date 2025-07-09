/// Application-wide constants
class AppConstants {
  // API Constants
  static const String apiVersion = 'v1';
  static const String contentType = 'application/json';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const int defaultTimeout = 30000; // milliseconds
  static const int shortTimeout = 10000; // milliseconds
  static const int longTimeout = 60000; // milliseconds
  
  // Cache
  static const int defaultCacheDuration = 300; // seconds
  static const int longCacheDuration = 3600; // seconds
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 16.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration defaultAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String businessIdKey = 'business_id';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Error Messages
  static const String networkErrorMessage = 'Network error occurred. Please check your connection.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String logoutSuccessMessage = 'Logged out successfully!';
  static const String saveSuccessMessage = 'Saved successfully!';
  static const String deleteSuccessMessage = 'Deleted successfully!';
  
  // Validation Messages
  static const String requiredFieldMessage = 'This field is required.';
  static const String invalidEmailMessage = 'Please enter a valid email address.';
  static const String invalidPasswordMessage = 'Password must be at least 8 characters long.';
  static const String passwordMismatchMessage = 'Passwords do not match.';
  
  // POS Constants
  static const String defaultCurrency = 'USD';
  static const double defaultTaxRate = 0.0;
  static const int maxCartItems = 100;
  static const double maxDiscountPercentage = 100.0;
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  
  // File Extensions
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> supportedDocumentFormats = ['pdf', 'doc', 'docx'];
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  
  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );
} 