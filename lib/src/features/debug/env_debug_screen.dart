import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/env_provider.dart';
import '../../core/localization/app_localizations.dart';

class EnvDebugScreen extends ConsumerWidget {
  const EnvDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiUrl = ref.watch(apiBaseUrlProvider);
    final appName = ref.watch(appNameProvider);
    final isDebug = ref.watch(isDebugModeProvider);
    final isBarcodeEnabled = ref.watch(isBarcodeScanningEnabledProvider);
    final configAsync = ref.watch(environmentConfigProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.environmentDebug),
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
                      l10n.currentEnvironmentSettings,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(l10n.apiBaseUrl, apiUrl),
                    _buildInfoRow(l10n.appName, appName),
                    _buildInfoRow(l10n.debugMode, isDebug.toString()),
                    _buildInfoRow(l10n.barcodeScanning, isBarcodeEnabled.toString()),
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
                      l10n.fullConfiguration,
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
                        '${l10n.errorLoadingConfig}: $error',
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
                      l10n.environmentFiles,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.availableEnvironmentFiles),
                    const SizedBox(height: 8),
                    Text(l10n.envDefault),
                    Text(l10n.envDevelopment),
                    Text(l10n.envStaging),
                    Text(l10n.envProduction),
                    const SizedBox(height: 8),
                    Text(
                      l10n.toSwitchEnvironmentsSetEnvironmentVariable,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.flutterRunCommand,
                        style: const TextStyle(fontFamily: 'monospace'),
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
