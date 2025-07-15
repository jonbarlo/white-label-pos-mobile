import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class that manages environment variables
class EnvConfig {
  static const String _defaultApiUrl = 'https://api.pos-engine.com';
  static const int _defaultTimeout = 30000;
  static const int _defaultRetryAttempts = 3;

  /// Initialize environment configuration
  /// Loads the appropriate .env file based on the environment
  static Future<void> initialize({String? environment}) async {
    final env = environment ?? const String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    
    try {
      await dotenv.load(fileName: '.env.$env');
    } catch (e) {
      // Fallback to default .env file if environment-specific file doesn't exist
      try {
        await dotenv.load(fileName: '.env');
      } catch (e) {
        // If no .env file exists, use default values
      }
    }
  }

  /// Get the API base URL
  static String get apiBaseUrl {
    try {
      final url = dotenv.env['API_BASE_URL'] ?? _defaultApiUrl;
      return url;
    } catch (e) {
      return _defaultApiUrl;
    }
  }

  /// Get the API timeout in milliseconds
  static int get apiTimeout {
    try {
      final timeout = dotenv.env['API_TIMEOUT'];
      return timeout != null ? int.tryParse(timeout) ?? _defaultTimeout : _defaultTimeout;
    } catch (e) {
      return _defaultTimeout;
    }
  }

  /// Get the number of API retry attempts
  static int get apiRetryAttempts {
    try {
      final retries = dotenv.env['API_RETRY_ATTEMPTS'];
      return retries != null ? int.tryParse(retries) ?? _defaultRetryAttempts : _defaultRetryAttempts;
    } catch (e) {
      return _defaultRetryAttempts;
    }
  }

  /// Get the app name
  static String get appName {
    try {
      return dotenv.env['APP_NAME'] ?? 'White Label POS';
    } catch (e) {
      return 'White Label POS';
    }
  }

  /// Get the app version
  static String get appVersion {
    try {
      return dotenv.env['APP_VERSION'] ?? '1.0.0';
    } catch (e) {
      return '1.0.0';
    }
  }

  /// Check if debug mode is enabled
  static bool get isDebugMode {
    try {
      final debug = dotenv.env['DEBUG_MODE'];
      return debug != null ? debug.toLowerCase() == 'true' : true;
    } catch (e) {
      return true;
    }
  }

  /// Check if barcode scanning is enabled
  static bool get isBarcodeScanningEnabled {
    try {
      final enabled = dotenv.env['ENABLE_BARCODE_SCANNING'];
      return enabled != null ? enabled.toLowerCase() == 'true' : true;
    } catch (e) {
      return true;
    }
  }

  /// Check if push notifications are enabled
  static bool get isPushNotificationsEnabled {
    try {
      final enabled = dotenv.env['ENABLE_PUSH_NOTIFICATIONS'];
      return enabled != null ? enabled.toLowerCase() == 'true' : true;
    } catch (e) {
      return true;
    }
  }

  /// Check if analytics is enabled
  static bool get isAnalyticsEnabled {
    try {
      final enabled = dotenv.env['ANALYTICS_ENABLED'];
      return enabled != null ? enabled.toLowerCase() == 'true' : true;
    } catch (e) {
      return true;
    }
  }

  /// Check if crash reporting is enabled
  static bool get isCrashReportingEnabled {
    try {
      final enabled = dotenv.env['CRASH_REPORTING_ENABLED'];
      return enabled != null ? enabled.toLowerCase() == 'true' : true;
    } catch (e) {
      return true;
    }
  }

  /// Get all environment variables as a map (for debugging)
  static Map<String, String> getAllVariables() {
    try {
      return dotenv.env;
    } catch (e) {
      return {};
    }
  }

  /// Validate that required environment variables are present
  static List<String> validateRequiredVariables() {
    final required = ['API_BASE_URL'];
    final missing = <String>[];
    
    try {
      for (final variable in required) {
        if (dotenv.env[variable] == null || dotenv.env[variable]!.isEmpty) {
          missing.add(variable);
        }
      }
    } catch (e) {
      // If dotenv is not initialized, all required variables are missing
      missing.addAll(required);
    }
    
    return missing;
  }
} 