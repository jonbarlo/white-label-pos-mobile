import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/core/localization/app_localizations.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('AppLocalizations should provide Spanish translations by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es', 'CR'),
            home: const TestLocalizationWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show Spanish by default (es_CR is main locale)
      expect(find.text('¡Bienvenido de Vuelta :)'), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('Correo Electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
    });

    testWidgets('AppLocalizations should provide English translations when locale is set', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en', 'US'),
            home: const TestLocalizationWidget(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Should show English when locale is set to en_US
      expect(find.text('Welcome Back :)'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });
}

class TestLocalizationWidget extends StatelessWidget {
  const TestLocalizationWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          Text(l10n.welcomeBack),
          Text(l10n.login),
          Text(l10n.email),
          Text(l10n.password),
        ],
      ),
    );
  }
} 