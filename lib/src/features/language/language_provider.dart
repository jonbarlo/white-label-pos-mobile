import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';
import 'language_repository.dart';
import 'language_repository_impl.dart';
import 'models/language.dart';

part 'language_provider.g.dart';

@riverpod
LanguageRepository languageRepository(LanguageRepositoryRef ref) {
  final dio = ref.watch(dioClientProvider);
  return LanguageRepositoryImpl(dio);
}

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  @override
  Future<LanguageResponse?> build() async {
    return null;
  }

  Future<void> loadLanguage() async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(languageRepositoryProvider);
      final result = await repository.getLanguage();
      
      if (result.isSuccess) {
        state = AsyncValue.data(result.data);
        print('🌐 Language loaded: ${result.data?.currentLanguage}');
      } else {
        print('🌐 Language load failed: ${result.errorMessage}');
        state = AsyncValue.error(result.errorMessage ?? 'Failed to load language', StackTrace.current);
      }
    } catch (e, stack) {
      print('🌐 Language load error: $e');
      state = AsyncValue.error('Unexpected error loading language: $e', stack);
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(languageRepositoryProvider);
      final result = await repository.updateLanguage(languageCode);
      
      if (result.isSuccess) {
        print('🌐 Language updated to: $languageCode');
        // Reload language settings after update
        await loadLanguage();
        
        // Trigger app refresh by invalidating providers that depend on language
        ref.invalidate(currentLanguageCodeProvider);
        ref.invalidate(supportedLanguagesProvider);
        
        // You can add more providers to invalidate here if needed
        // For example, if you have text providers that depend on language
      } else {
        print('🌐 Language update failed: ${result.errorMessage}');
        state = AsyncValue.error(result.errorMessage ?? 'Failed to update language', StackTrace.current);
      }
    } catch (e, stack) {
      print('🌐 Language update error: $e');
      state = AsyncValue.error('Unexpected error updating language: $e', stack);
    }
  }

  // Method to initialize language on app startup
  Future<void> initializeLanguage() async {
    print('🌐 Initializing language system...');
    await loadLanguage();
  }

  // Method to test language switching
  Future<void> testLanguageSwitching() async {
    print('🌐 Testing language switching...');
    
    // Test switching to English
    await updateLanguage('en-US');
    await Future.delayed(const Duration(seconds: 1));
    
    // Test switching to Spanish
    await updateLanguage('es-CR');
    await Future.delayed(const Duration(seconds: 1));
    
    print('🌐 Language switching test completed');
  }
}

// Provider for current language code - defaults to Spanish as per backend
@riverpod
String currentLanguageCode(CurrentLanguageCodeRef ref) {
  final languageState = ref.watch(languageNotifierProvider);
  
  if (languageState.hasValue && languageState.value != null) {
    return languageState.value!.currentLanguage;
  }
  // Default to Spanish as per backend changes
  return 'es-CR';
}

// Provider for supported languages
@riverpod
List<Language> supportedLanguages(SupportedLanguagesRef ref) {
  final languageState = ref.watch(languageNotifierProvider);
  
  if (languageState.hasValue && languageState.value != null) {
    return languageState.value!.supportedLanguages;
  }
  // Return default supported languages
  return [
    const Language(
      code: 'es-CR',
      name: 'Spanish',
      nativeName: 'Español',
      isDefault: true,
    ),
    const Language(
      code: 'en-US',
      name: 'English',
      nativeName: 'English',
      isDefault: false,
    ),
  ];
}

// Provider to trigger app refresh when language changes
@riverpod
bool shouldRefreshApp(ShouldRefreshAppRef ref) {
  final languageState = ref.watch(languageNotifierProvider);
  return languageState.hasValue && languageState.value != null;
}

// Provider for language testing utilities
@riverpod
class LanguageTestNotifier extends _$LanguageTestNotifier {
  @override
  Future<void> build() async {}

  Future<void> testDefaultLanguage() async {
    print('🌐 Testing default language (Spanish)...');
    final currentLang = ref.read(currentLanguageCodeProvider);
    print('🌐 Current language: $currentLang');
    
    // Verify it defaults to Spanish
    if (currentLang != 'es-CR') {
      print('⚠️ Warning: Default language is not Spanish (es-CR)');
    } else {
      print('✅ Default language is correctly set to Spanish');
    }
  }

  Future<void> testErrorMessages() async {
    print('🌐 Testing error messages in Spanish...');
    // This would be called when testing invalid operations
    // The backend should return Spanish error messages
  }

  Future<void> testSuccessMessages() async {
    print('🌐 Testing success messages in Spanish...');
    // This would be called when testing valid operations
    // The backend should return Spanish success messages
  }
} 
