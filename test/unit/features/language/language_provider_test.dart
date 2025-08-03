import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/language/language_provider.dart';
import 'package:white_label_pos_mobile/src/features/language/language_repository.dart';
import 'package:white_label_pos_mobile/src/features/language/models/language.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';

import '../../../helpers/riverpod_test_helper.dart';
import 'language_provider_test.mocks.dart';

@GenerateMocks([LanguageRepository])
void main() {
  group('Language Provider Tests', () {
    late ProviderContainer container;
    late MockLanguageRepository mockRepository;

    setUp(() {
      mockRepository = MockLanguageRepository();
      container = ProviderContainer(
        overrides: [
          languageRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('LanguageNotifier', () {
      test('should load language successfully', () async {
        // Arrange
        final languageResponse = LanguageResponse(
          currentLanguage: 'es-CR',
          supportedLanguages: [
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
          ],
        );

        when(mockRepository.getLanguage()).thenAnswer(
          (_) async => Result.success(languageResponse),
        );

        // Act
        final notifier = container.read(languageNotifierProvider.notifier);
        await notifier.loadLanguage();

        // Assert
        final state = container.read(languageNotifierProvider);
        expect(state.hasValue, isTrue);
        expect(state.value?.currentLanguage, equals('es-CR'));
        expect(state.value?.supportedLanguages, hasLength(2));
        expect(state.value?.supportedLanguages.first.code, equals('es-CR'));
        expect(state.value?.supportedLanguages.first.isDefault, isTrue);
      });

      test('should handle language loading error', () async {
        // Arrange
        when(mockRepository.getLanguage()).thenAnswer(
          (_) async => Result.failure('Failed to load language'),
        );

        // Act
        final notifier = container.read(languageNotifierProvider.notifier);
        await notifier.loadLanguage();

        // Assert
        final state = container.read(languageNotifierProvider);
        expect(state.hasError, isTrue);
        expect(state.error.toString(), contains('Failed to load language'));
      });

      test('should update language successfully', () async {
        // Arrange
        when(mockRepository.updateLanguage('en-US')).thenAnswer(
          (_) async => Result.success(null),
        );

        when(mockRepository.getLanguage()).thenAnswer(
          (_) async => Result.success(
            LanguageResponse(
              currentLanguage: 'en-US',
              supportedLanguages: [
                const Language(
                  code: 'en-US',
                  name: 'English',
                  nativeName: 'English',
                  isDefault: false,
                ),
              ],
            ),
          ),
        );

        // Act
        final notifier = container.read(languageNotifierProvider.notifier);
        await notifier.updateLanguage('en-US');

        // Assert
        verify(mockRepository.updateLanguage('en-US')).called(1);
        verify(mockRepository.getLanguage()).called(1);
      });

      test('should handle language update error', () async {
        // Arrange
        when(mockRepository.updateLanguage('invalid')).thenAnswer(
          (_) async => Result.failure('Invalid language code'),
        );

        // Act
        final notifier = container.read(languageNotifierProvider.notifier);
        await notifier.updateLanguage('invalid');

        // Assert
        final state = container.read(languageNotifierProvider);
        expect(state.hasError, isTrue);
        expect(state.error.toString(), contains('Invalid language code'));
      });

      test('should test language switching', () async {
        // Arrange
        when(mockRepository.updateLanguage('en-US')).thenAnswer(
          (_) async => Result.success(null),
        );
        when(mockRepository.updateLanguage('es-CR')).thenAnswer(
          (_) async => Result.success(null),
        );
        when(mockRepository.getLanguage()).thenAnswer(
          (_) async => Result.success(
            LanguageResponse(
              currentLanguage: 'es-CR',
              supportedLanguages: [
                const Language(
                  code: 'es-CR',
                  name: 'Spanish',
                  nativeName: 'Español',
                  isDefault: true,
                ),
              ],
            ),
          ),
        );

        // Act
        final notifier = container.read(languageNotifierProvider.notifier);
        await notifier.testLanguageSwitching();

        // Assert
        verify(mockRepository.updateLanguage('en-US')).called(1);
        verify(mockRepository.updateLanguage('es-CR')).called(1);
        verify(mockRepository.getLanguage()).called(greaterThan(0));
      });
    });

    group('Current Language Code Provider', () {
      test('should return default Spanish language when no language loaded', () {
        // Act
        final currentLanguage = container.read(currentLanguageCodeProvider);

        // Assert
        expect(currentLanguage, equals('es-CR'));
      });

      test('should return loaded language when available', () async {
        // Arrange
        final languageResponse = LanguageResponse(
          currentLanguage: 'en-US',
          supportedLanguages: [
            const Language(
              code: 'en-US',
              name: 'English',
              nativeName: 'English',
              isDefault: false,
            ),
          ],
        );

        when(mockRepository.getLanguage()).thenAnswer(
          (_) async => Result.success(languageResponse),
        );

        // Act
        final notifier = container.read(languageNotifierProvider.notifier);
        await notifier.loadLanguage();

        final currentLanguage = container.read(currentLanguageCodeProvider);

        // Assert
        expect(currentLanguage, equals('en-US'));
      });
    });

    group('Supported Languages Provider', () {
      test('should return default supported languages when no language loaded', () {
        // Act
        final supportedLanguages = container.read(supportedLanguagesProvider);

        // Assert
        expect(supportedLanguages, hasLength(2));
        expect(supportedLanguages.first.code, equals('es-CR'));
        expect(supportedLanguages.first.isDefault, isTrue);
        expect(supportedLanguages.last.code, equals('en-US'));
        expect(supportedLanguages.last.isDefault, isFalse);
      });

      test('should return loaded supported languages when available', () async {
        // Arrange
        final languageResponse = LanguageResponse(
          currentLanguage: 'es-CR',
          supportedLanguages: [
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
            const Language(
              code: 'fr-FR',
              name: 'French',
              nativeName: 'Français',
              isDefault: false,
            ),
          ],
        );

        when(mockRepository.getLanguage()).thenAnswer(
          (_) async => Result.success(languageResponse),
        );

        // Act
        final notifier = container.read(languageNotifierProvider.notifier);
        await notifier.loadLanguage();

        final supportedLanguages = container.read(supportedLanguagesProvider);

        // Assert
        expect(supportedLanguages, hasLength(3));
        expect(supportedLanguages.first.code, equals('es-CR'));
        expect(supportedLanguages.first.isDefault, isTrue);
      });
    });

    group('Language Test Notifier', () {
      test('should test default language correctly', () async {
        // Act
        final notifier = container.read(languageTestNotifierProvider.notifier);
        await notifier.testDefaultLanguage();

        // Assert
        // This test mainly checks that the method doesn't throw
        expect(true, isTrue);
      });

      test('should test error messages', () async {
        // Act
        final notifier = container.read(languageTestNotifierProvider.notifier);
        await notifier.testErrorMessages();

        // Assert
        // This test mainly checks that the method doesn't throw
        expect(true, isTrue);
      });

      test('should test success messages', () async {
        // Act
        final notifier = container.read(languageTestNotifierProvider.notifier);
        await notifier.testSuccessMessages();

        // Assert
        // This test mainly checks that the method doesn't throw
        expect(true, isTrue);
      });
    });
  });
} 