import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/env_provider.dart';

class EnvDebugScreen extends ConsumerWidget {
  const EnvDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiUrl = ref.watch(apiBaseUrlProvider);
    final appName = ref.watch(appNameProvider);
    final isDebug = ref.watch(isDebugModeProvider);
    final isBarcodeEnabled = ref.watch(isBarcodeScanningEnabledProvider);
    final configAsync = ref.watch(environmentConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Environment Debug'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Environment Settings',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('API Base URL', apiUrl),
                    _buildInfoRow('App Name', appName),
                    _buildInfoRow('Debug Mode', isDebug.toString()),
                    _buildInfoRow('Barcode Scanning', isBarcodeEnabled.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Configuration',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    configAsync.when(
                      data: (config) => Column(
                        children: config.entries.map((entry) {
                          return _buildInfoRow(entry.key, entry.value.toString());
                        }).toList(),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Text(
                        'Error loading config: $error',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Environment Files',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    const Text('Available environment files:'),
                    const SizedBox(height: 8),
                    const Text('• .env (default)'),
                    const Text('• .env.development'),
                    const Text('• .env.staging'),
                    const Text('• .env.production'),
                    const SizedBox(height: 8),
                    Text(
                      'To switch environments, set the ENVIRONMENT variable:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'flutter run --dart-define=ENVIRONMENT=development',
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
} 