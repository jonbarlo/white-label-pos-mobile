import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/navigation_service.dart';
import 'language_provider.dart';

class LanguageTestScreen extends ConsumerWidget {
  const LanguageTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languageNotifierProvider);
    final currentLanguage = ref.watch(currentLanguageCodeProvider);
    final supportedLanguages = ref.watch(supportedLanguagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Testing'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(languageNotifierProvider.notifier).loadLanguage();
            },
            tooltip: 'Refresh Language',
          ),
        ],
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
                    Text('Current Language: $currentLanguage'),
                    const SizedBox(height: 4),
                    Text('Language State: ${languageState.toString()}'),
                    if (languageState.hasError)
                      Text(
                        'Error: ${languageState.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Language Switching Tests
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language Switching Tests',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(languageNotifierProvider.notifier).updateLanguage('es-CR');
                            },
                            child: const Text('Switch to Spanish'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(languageNotifierProvider.notifier).updateLanguage('en-US');
                            },
                            child: const Text('Switch to English'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(languageNotifierProvider.notifier).testLanguageSwitching();
                        },
                        child: const Text('Test Language Switching'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Backend Integration Tests
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Backend Integration Tests',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(languageTestNotifierProvider.notifier).testDefaultLanguage();
                        },
                        child: const Text('Test Default Language (Spanish)'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(languageTestNotifierProvider.notifier).testErrorMessages();
                        },
                        child: const Text('Test Error Messages (Spanish)'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(languageTestNotifierProvider.notifier).testSuccessMessages();
                        },
                        child: const Text('Test Success Messages (Spanish)'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Supported Languages
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supported Languages',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...supportedLanguages.map((language) => ListTile(
                      title: Text('${language.name} (${language.nativeName})'),
                      subtitle: Text(language.code),
                      trailing: language.isDefault 
                        ? const Chip(label: Text('Default'), backgroundColor: Colors.green)
                        : null,
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 