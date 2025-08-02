import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/currency/currency_provider.dart';
import 'package:white_label_pos_mobile/src/features/currency/models/currency.dart';

class CurrencyCrudScreen extends ConsumerStatefulWidget {
  const CurrencyCrudScreen({super.key});

  @override
  ConsumerState<CurrencyCrudScreen> createState() => _CurrencyCrudScreenState();
}

class _CurrencyCrudScreenState extends ConsumerState<CurrencyCrudScreen> {
  Currency? selectedCurrencyForEdit;

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(currencyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Management'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCurrencyDialog(context),
            tooltip: 'Add Currency',
          ),
        ],
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
          return _buildCurrencyCard(context, currency);
        },
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context, Currency currency) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currency.code} • ${currency.symbol}${currency.isDefault ? ' (Default)' : ''}',
              style: TextStyle(
                color: currency.isDefault 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: currency.isActive 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    currency.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: currency.isActive ? Colors.green : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${currency.decimalPlaces} decimal places',
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditCurrencyDialog(context, currency);
                break;
              case 'delete':
                _showDeleteConfirmationDialog(context, currency);
                break;
              case 'toggle':
                _toggleCurrencyStatus(context, currency);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    currency.isActive ? Icons.visibility_off : Icons.visibility,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(currency.isActive ? 'Deactivate' : 'Activate'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCurrencyDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final symbolController = TextEditingController();
    final decimalPlacesController = TextEditingController(text: '2');
    bool isActive = true;
    bool isDefault = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Currency'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Currency Name',
                    hintText: 'e.g., US Dollar',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Currency Code',
                    hintText: 'e.g., USD',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: symbolController,
                  decoration: const InputDecoration(
                    labelText: 'Currency Symbol',
                    hintText: 'e.g., \$',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: decimalPlacesController,
                  decoration: const InputDecoration(
                    labelText: 'Decimal Places',
                    hintText: 'e.g., 2',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isActive,
                      onChanged: (value) => setState(() => isActive = value ?? false),
                    ),
                    const Text('Active'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isDefault,
                      onChanged: (value) => setState(() => isDefault = value ?? false),
                    ),
                    const Text('Default Currency'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || 
                    codeController.text.isEmpty || 
                    symbolController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all required fields')),
                  );
                  return;
                }

                final currencyData = {
                  'name': nameController.text,
                  'code': codeController.text.toUpperCase(),
                  'symbol': symbolController.text,
                  'decimalPlaces': int.tryParse(decimalPlacesController.text) ?? 2,
                  'isActive': isActive,
                  'isDefault': isDefault,
                };

                final result = await ref.read(currencyNotifierProvider.notifier)
                    .createCurrency(currencyData);

                if (result.isSuccess) {
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Currency created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create currency: ${result.errorMessage}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCurrencyDialog(BuildContext context, Currency currency) {
    final nameController = TextEditingController(text: currency.name);
    final codeController = TextEditingController(text: currency.code);
    final symbolController = TextEditingController(text: currency.symbol);
    final decimalPlacesController = TextEditingController(text: currency.decimalPlaces.toString());
    bool isActive = currency.isActive;
    bool isDefault = currency.isDefault;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Currency'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Currency Name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Currency Code',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: symbolController,
                  decoration: const InputDecoration(
                    labelText: 'Currency Symbol',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: decimalPlacesController,
                  decoration: const InputDecoration(
                    labelText: 'Decimal Places',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isActive,
                      onChanged: (value) => setState(() => isActive = value ?? false),
                    ),
                    const Text('Active'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isDefault,
                      onChanged: (value) => setState(() => isDefault = value ?? false),
                    ),
                    const Text('Default Currency'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || 
                    codeController.text.isEmpty || 
                    symbolController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all required fields')),
                  );
                  return;
                }

                final currencyData = {
                  'name': nameController.text,
                  'code': codeController.text.toUpperCase(),
                  'symbol': symbolController.text,
                  'decimalPlaces': int.tryParse(decimalPlacesController.text) ?? 2,
                  'isActive': isActive,
                  'isDefault': isDefault,
                };

                final result = await ref.read(currencyNotifierProvider.notifier)
                    .updateCurrency(currency.id, currencyData);

                if (result.isSuccess) {
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Currency updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update currency: ${result.errorMessage}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Currency currency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Currency'),
        content: Text(
          'Are you sure you want to delete ${currency.name} (${currency.code})? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              final result = await ref.read(currencyNotifierProvider.notifier)
                  .deleteCurrency(currency.id);

              if (result.isSuccess) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Currency deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete currency: ${result.errorMessage}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleCurrencyStatus(BuildContext context, Currency currency) async {
    final currencyData = {
      'name': currency.name,
      'code': currency.code,
      'symbol': currency.symbol,
      'decimalPlaces': currency.decimalPlaces,
      'isActive': !currency.isActive,
      'isDefault': currency.isDefault,
    };

    final result = await ref.read(currencyNotifierProvider.notifier)
        .updateCurrency(currency.id, currencyData);

    if (result.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Currency ${!currency.isActive ? 'activated' : 'deactivated'} successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update currency status: ${result.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
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