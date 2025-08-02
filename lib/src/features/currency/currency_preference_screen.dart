import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/currency/currency_provider.dart';
import 'package:white_label_pos_mobile/src/features/currency/models/currency.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/app_image.dart';

class CurrencyPreferenceScreen extends ConsumerStatefulWidget {
  const CurrencyPreferenceScreen({super.key});

  @override
  ConsumerState<CurrencyPreferenceScreen> createState() => _CurrencyPreferenceScreenState();
}

class _CurrencyPreferenceScreenState extends ConsumerState<CurrencyPreferenceScreen> {
  Currency? selectedCurrency;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default currency as initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultCurrency = ref.read(defaultCurrencyProvider);
      if (defaultCurrency != null) {
        setState(() {
          selectedCurrency = defaultCurrency;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(currencyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Preference'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: currenciesAsync.when(
        data: (result) {
          if (result.isSuccess) {
            final currencies = result.data ?? [];
            return _buildCurrencySelection(context, currencies);
          } else {
            return _buildErrorWidget(context, result.errorMessage ?? 'Unknown error');
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(context, error.toString()),
      ),
    );
  }

  Widget _buildCurrencySelection(BuildContext context, List<Currency> currencies) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select Your Preferred Currency',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will be used for displaying prices and calculations throughout the app.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = selectedCurrency?.id == currency.id;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: isSelected ? 4 : 1,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : null,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCurrency = currency;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Text(
                                currency.symbol,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currency.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currency.code} • ${currency.symbol}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                if (currency.isDefault) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Default',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedCurrency != null && !isLoading
                  ? () => _saveCurrencyPreference(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save Preference',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCurrencyPreference(BuildContext context) async {
    if (selectedCurrency == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      // TODO: Implement API call to save currency preference
      // The API supports: PUT /customers/{customerId}/currency-preference
      // We need to determine if this should be:
      // - PUT /users/{userId}/currency-preference (if user preference)
      // - PUT /businesses/{businessId}/currency-preference (if business preference)
      // - PUT /customers/{customerId}/currency-preference (if customer preference)
      
      // For now, we'll just show a success message
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Currency preference updated to ${selectedCurrency!.name}',
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update currency preference: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load currencies',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(currencyNotifierProvider.notifier).refreshCurrencies();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
} 