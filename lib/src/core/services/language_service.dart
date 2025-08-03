import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language service to manage app language switching
class LanguageService {
  static const String _languageKey = 'app_language';
  static const String _defaultLanguage = 'es_CR';
  
  /// Get the current language from SharedPreferences
  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? _defaultLanguage;
  }
  
  /// Set the current language and save to SharedPreferences
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  /// Get the Locale from language code
  static Locale getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'es_CR':
        return const Locale('es', 'CR');
      case 'en_US':
        return const Locale('en', 'US');
      default:
        return const Locale('es', 'CR'); // Default to Spanish
    }
  }
  
  /// Get language code from Locale
  static String getLanguageCodeFromLocale(Locale locale) {
    if (locale.languageCode == 'es' && locale.countryCode == 'CR') {
      return 'es_CR';
    } else if (locale.languageCode == 'en' && locale.countryCode == 'US') {
      return 'en_US';
    }
    return _defaultLanguage;
  }
  
  /// Get display name for language code
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'es_CR':
        return 'Español (Costa Rica)';
      case 'en_US':
        return 'English (US)';
      default:
        return 'Español (Costa Rica)';
    }
  }
  
  /// Get native name for language code
  static String getLanguageNativeName(String languageCode) {
    switch (languageCode) {
      case 'es_CR':
        return 'Español';
      case 'en_US':
        return 'English';
      default:
        return 'Español';
    }
  }
  
  /// Get supported languages
  static List<Map<String, String>> getSupportedLanguages() {
    return [
      {
        'code': 'es_CR',
        'name': 'Español (Costa Rica)',
        'nativeName': 'Español',
      },
      {
        'code': 'en_US',
        'name': 'English (US)',
        'nativeName': 'English',
      },
    ];
  }
}

/// Provider for current language
final currentLanguageProvider = StateProvider<String>((ref) {
  return LanguageService._defaultLanguage;
});

/// Provider for current locale
final currentLocaleProvider = StateProvider<Locale>((ref) {
  final languageCode = ref.watch(currentLanguageProvider);
  return LanguageService.getLocaleFromLanguageCode(languageCode);
});

/// Provider for language service
final languageServiceProvider = Provider<LanguageService>((ref) {
  return LanguageService();
});

/// Notifier for language management
class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super(LanguageService._defaultLanguage) {
    loadLanguage();
  }
  
  Future<void> loadLanguage() async {
    final language = await LanguageService.getCurrentLanguage();
    state = language;
  }
  
  Future<void> setLanguage(String languageCode) async {
    await LanguageService.setLanguage(languageCode);
    state = languageCode;
  }
  
  Future<void> setLanguageFromLocale(Locale locale) async {
    final languageCode = LanguageService.getLanguageCodeFromLocale(locale);
    await setLanguage(languageCode);
  }
  
  String get currentLanguage => state;
  
  Locale get currentLocale => LanguageService.getLocaleFromLanguageCode(state);
  
  List<Map<String, String>> get supportedLanguages => LanguageService.getSupportedLanguages();
}

/// Provider for language notifier
final languageNotifierProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
}); 