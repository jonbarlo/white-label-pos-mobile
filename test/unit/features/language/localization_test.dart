import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/core/services/language_service.dart';
import 'package:white_label_pos_mobile/src/core/localization/app_localizations.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('should display Spanish (Costa Rica) as default', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  body: Text(l10n.appTitle),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('POS Móvil'), findsOneWidget);
    });

    testWidgets('should display English when locale is changed', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  body: Text(l10n.appTitle),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Mobile POS'), findsOneWidget);
    });

    testWidgets('should handle language switching', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  body: Column(
                    children: [
                      Text(l10n.appTitle),
                      Text(l10n.login),
                      Text(l10n.dashboard),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Check Spanish translations
      expect(find.text('POS Móvil'), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('Panel Principal'), findsOneWidget);

      // Switch to English
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  body: Column(
                    children: [
                      Text(l10n.appTitle),
                      Text(l10n.login),
                      Text(l10n.dashboard),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Check English translations
      expect(find.text('Mobile POS'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });

  group('LanguageService Tests', () {
    test('should return correct locale for es_CR', () {
      final locale = LanguageService.getLocaleFromLanguageCode('es_CR');
      expect(locale.languageCode, 'es');
      expect(locale.countryCode, 'CR');
    });

    test('should return correct locale for en', () {
      final locale = LanguageService.getLocaleFromLanguageCode('en');
      expect(locale.languageCode, 'en');
      expect(locale.countryCode, isNull);
    });

    test('should return correct language code for es_CR locale', () {
      final languageCode = LanguageService.getLanguageCodeFromLocale(const Locale('es', 'CR'));
      expect(languageCode, 'es_CR');
    });

    test('should return correct language code for en locale', () {
      final languageCode = LanguageService.getLanguageCodeFromLocale(const Locale('en'));
      expect(languageCode, 'en');
    });

    test('should return correct display name for es_CR', () {
      final displayName = LanguageService.getLanguageDisplayName('es_CR');
      expect(displayName, 'Español (Costa Rica)');
    });

    test('should return correct display name for en', () {
      final displayName = LanguageService.getLanguageDisplayName('en');
      expect(displayName, 'English');
    });

    test('should return correct native name for es_CR', () {
      final nativeName = LanguageService.getLanguageNativeName('es_CR');
      expect(nativeName, 'Español');
    });

    test('should return correct native name for en', () {
      final nativeName = LanguageService.getLanguageNativeName('en');
      expect(nativeName, 'English');
    });

    test('should return supported languages list', () {
      final supportedLanguages = LanguageService.getSupportedLanguages();
      expect(supportedLanguages.length, 2);
      
      final esCR = supportedLanguages.firstWhere((lang) => lang['code'] == 'es_CR');
      expect(esCR['name'], 'Español (Costa Rica)');
      expect(esCR['nativeName'], 'Español');
      
      final en = supportedLanguages.firstWhere((lang) => lang['code'] == 'en');
      expect(en['name'], 'English');
      expect(en['nativeName'], 'English');
    });
  });
} 