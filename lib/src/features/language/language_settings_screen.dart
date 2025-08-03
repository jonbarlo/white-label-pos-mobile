import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'language_provider.dart';
import 'models/language.dart';
import 'package:go_router/go_router.dart';

class LanguageSettingsScreen extends ConsumerStatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  ConsumerState<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends ConsumerState<LanguageSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load language settings when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(languageNotifierProvider.notifier).loadLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageState = ref.watch(languageNotifierProvider);
    final supportedLanguages = ref.watch(supportedLanguagesProvider);
    final currentLanguageCode = ref.watch(currentLanguageCodeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: languageState.when(
        data: (languageResponse) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Language',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose your preferred language for the application',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Language list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: supportedLanguages.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                  itemBuilder: (context, index) {
                    final language = supportedLanguages[index];
                    final isSelected = language.code == currentLanguageCode;
                    
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: _buildLanguageFlag(language.code),
                      title: Text(
                        language.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        language.nativeName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                              size: 24,
                            )
                          : null,
                      onTap: () => _updateLanguage(language.code),
                      selected: isSelected,
                      selectedTileColor: theme.colorScheme.primary.withOpacity(0.05),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.language_outlined,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to load languages',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your connection and try again',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(languageNotifierProvider.notifier).loadLanguage();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageFlag(String languageCode) {
    // Simple flag emoji approach for better cross-platform compatibility
    String flag = '';
    switch (languageCode) {
      case 'en-US':
        flag = '🇺🇸';
        break;
      case 'es-CR':
        flag = '🇨🇷';
        break;
      default:
        flag = '🌐';
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          flag,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  void _updateLanguage(String languageCode) async {
    final notifier = ref.read(languageNotifierProvider.notifier);
    await notifier.updateLanguage(languageCode);
    
    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Language changed to ${_getLanguageName(languageCode)}'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      
      // Show dialog to restart app for complete language change
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Language Updated'),
          content: Text(
            'Your language has been updated to ${_getLanguageName(languageCode)}. '
            'Some changes may require a restart to take full effect.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Trigger a hot restart to apply language changes
                // In a real app, you might want to restart the entire app
                // For now, we'll just navigate back to refresh the UI
                context.go('/dashboard');
              },
              child: const Text('Restart App'),
            ),
          ],
        ),
      );
    }
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en-US':
        return 'English';
      case 'es-CR':
        return 'Español';
      default:
        return languageCode;
    }
  }
} 