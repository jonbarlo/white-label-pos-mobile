import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/language_service.dart';
import '../../core/services/navigation_service.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageNotifierProvider);
    final languageNotifier = ref.read(languageNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Settings'),
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
                      'Language Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Current Language: ${LanguageService.getLanguageDisplayName(currentLanguage)}'),
                    const SizedBox(height: 4),
                    Text('Native Name: ${LanguageService.getLanguageNativeName(currentLanguage)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Language Options
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Language',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ...LanguageService.getSupportedLanguages().map((language) {
                      final isSelected = language['code'] == currentLanguage;
                      return ListTile(
                        leading: Radio<String>(
                          value: language['code']!,
                          groupValue: currentLanguage,
                          onChanged: (value) async {
                            if (value != null) {
                              await languageNotifier.setLanguage(value);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Language changes saved'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        title: Text(language['name']!),
                        subtitle: Text(language['nativeName']!),
                        trailing: isSelected 
                          ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                          : null,
                        onTap: () async {
                          await languageNotifier.setLanguage(language['code']!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Language changes saved'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Language Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Mobile POS supports Spanish and English. '
                      'Default language is Spanish (Costa Rica).',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Language changes will be saved and applied immediately.',
                      style: TextStyle(fontSize: 16),
                    ),
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