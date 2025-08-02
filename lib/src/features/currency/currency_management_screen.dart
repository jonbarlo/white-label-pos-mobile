import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/currency/currency_provider.dart';
import 'package:white_label_pos_mobile/src/features/currency/models/currency.dart';

class CurrencyManagementScreen extends ConsumerWidget {
  const CurrencyManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currencyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Management'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: currenciesAsync.when(
        data: (result) {
          if (result.isSuccess) {
            final currencies = result.data ?? [];
            return _buildCurrenciesList(context, currencies, ref);
          } else {
            return _buildErrorWidget(context, result.errorMessage ?? 'Unknown error');
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(context, error.toString()),
      ),
    );
  }

  Widget _buildCurrenciesList(BuildContext context, List<Currency> currencies, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(currencyNotifierProvider.notifier).refreshCurrencies();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          final currency = currencies[index];
          return _buildCurrencyCard(context, currency, ref);
        },
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context, Currency currency, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: currency.isDefault 
              ? theme.colorScheme.primary 
              : theme.colorScheme.secondary,
          child: Text(
            currency.symbol,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          currency.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${currency.code} • ${currency.symbol}${currency.isDefault ? ' (Default)' : ''}',
          style: TextStyle(
            color: currency.isDefault 
                ? theme.colorScheme.primary 
                : theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: currency.isActive 
                ? Colors.green.withOpacity(0.1) 
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            currency.isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: currency.isActive ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          _buildExchangeRatesList(context, currency, ref),
        ],
      ),
    );
  }

  Widget _buildExchangeRatesList(BuildContext context, Currency currency, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(currencyNotifierProvider.notifier).getExchangeRates(currency.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error loading exchange rates: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final result = snapshot.data;
        if (result == null || !result.isSuccess) {
                      return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                result?.errorMessage ?? 'Failed to load exchange rates',
                style: const TextStyle(color: Colors.red),
              ),
            );
        }

        final exchangeRates = result.data ?? [];
        
        if (exchangeRates.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No exchange rates available',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          );
        }

        return Column(
          children: exchangeRates.map((rate) {
            return ListTile(
              dense: true,
              leading: const Icon(Icons.currency_exchange, size: 20),
              title: Text('1 ${currency.code} = ${rate.rate.toStringAsFixed(6)}'),
              subtitle: Text('Updated: ${_formatDate(rate.createdAt)}'),
              trailing: rate.isActive 
                  ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
                  : const Icon(Icons.cancel, color: Colors.red, size: 16),
            );
          }).toList(),
        );
      },
    );
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
              // Refresh currencies
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 