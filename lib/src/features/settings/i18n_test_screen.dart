import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/language_service.dart';
import '../../core/services/navigation_service.dart';

class I18nTestScreen extends ConsumerWidget {
  const I18nTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageNotifierProvider);
    final languageNotifier = ref.read(languageNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('i18n Test Screen'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.goBack(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Language Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Language Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Language Code: $currentLanguage'),
                    Text('Display Name: ${LanguageService.getLanguageDisplayName(currentLanguage)}'),
                    Text('Native Name: ${LanguageService.getLanguageNativeName(currentLanguage)}'),
                    Text('Locale: ${LanguageService.getLocaleFromLanguageCode(currentLanguage)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Language Switching Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language Switching Test',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await languageNotifier.setLanguage('es_CR');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Switched to Spanish'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentLanguage == 'es_CR' 
                                ? Colors.green 
                                : null,
                            ),
                            child: const Text('Spanish (es-CR)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await languageNotifier.setLanguage('en_US');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Switched to English'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentLanguage == 'en_US' 
                                ? Colors.green 
                                : null,
                            ),
                            child: const Text('English (en-US)'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Translation Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Translation Test',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('Current Language: ${currentLanguage == 'es_CR' ? 'Español' : 'English'}'),
                    const SizedBox(height: 8),
                    Text('Login: ${currentLanguage == 'es_CR' ? 'Iniciar Sesión' : 'Login'}'),
                    Text('Email: ${currentLanguage == 'es_CR' ? 'Correo Electrónico' : 'Email'}'),
                    Text('Password: ${currentLanguage == 'es_CR' ? 'Contraseña' : 'Password'}'),
                    Text('Dashboard: ${currentLanguage == 'es_CR' ? 'Panel Principal' : 'Dashboard'}'),
                    Text('Settings: ${currentLanguage == 'es_CR' ? 'Configuración' : 'Settings'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This screen demonstrates the i18n system functionality.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Features tested:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('• Language switching'),
                    const Text('• Language persistence'),
                    const Text('• Locale management'),
                    const Text('• Translation display'),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Back Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => NavigationService.goBack(context),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
