import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../waiter/models/table.dart' as waiter_table;
import 'models/cart_item.dart';
import 'split_billing_provider.dart' as split_billing;
import 'pos_provider.dart';
import 'models/split_payment.dart';

class SplitBillingScreen extends ConsumerWidget {
  final waiter_table.Table table;
  final List<CartItem> cartItems;

  const SplitBillingScreen({
    Key? key,
    required this.table,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splitState = ref.watch(split_billing.splitBillingProvider(cartItems));
    final splitNotifier = ref.read(split_billing.splitBillingProvider(cartItems).notifier);
    final isLoading = ref.watch(_splitSaleLoadingProvider);

    Future<void> _finalizeSplit() async {
      ref.read(_splitSaleLoadingProvider.notifier).state = true;
      try {
        // Prepare payload for /sales/split
        final splits = splitState.splits;
        final payments = splits.expand((s) => s.payments).toList();
        final items = splits.expand((s) => s.items.map((i) => SplitSaleItem(
          itemId: int.tryParse(i.id) ?? 0,
          quantity: i.quantity,
          unitPrice: i.price,
        ))).toList();
        final totalAmount = splits.fold(0.0, (sum, s) => sum + s.subtotal);
        final userId = 1; // TODO: get from auth provider
        final request = SplitSaleRequest(
          userId: userId,
          totalAmount: totalAmount,
          items: items,
          payments: payments,
        );
        await ref.read(createSplitSaleProvider(request).future);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Split sale completed!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        ref.read(_splitSaleLoadingProvider.notifier).state = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Split Billing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Table: ${table.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: splitNotifier.addSplit,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Split'),
                ),
                const SizedBox(width: 8),
                if (splitState.splits.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      if (splitState.splits.isNotEmpty) {
                        splitNotifier.removeSplit(splitState.splits.last.id);
                      }
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('Remove Last Split'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (splitState.unassignedItems.isNotEmpty) ...[
              const Text('Unassigned Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: splitState.unassignedItems.map((item) => Chip(
                  label: Text('${item.name} x${item.quantity}'),
                  onDeleted: null,
                )).toList(),
              ),
              const SizedBox(height: 8),
              if (splitState.splits.isNotEmpty)
                DropdownButton<int>(
                  hint: const Text('Assign item to split'),
                  items: splitState.splits.map((split) => DropdownMenuItem(
                    value: split.id,
                    child: Text('Split ${split.id}'),
                  )).toList(),
                  onChanged: (splitId) {
                    if (splitId != null && splitState.unassignedItems.isNotEmpty) {
                      splitNotifier.assignItemToSplit(splitState.unassignedItems.first, splitId);
                    }
                  },
                ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: splitState.splits.length,
                itemBuilder: (context, idx) {
                  final split = splitState.splits[idx];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Split ${split.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          if (split.items.isEmpty)
                            const Text('No items assigned.'),
                          if (split.items.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              children: split.items.map((item) => Chip(
                                label: Text('${item.name} x${item.quantity}'),
                                onDeleted: () => splitNotifier.unassignItemFromSplit(item, split.id),
                              )).toList(),
                            ),
                          const SizedBox(height: 8),
                          Text('Subtotal: ${split.subtotal.toStringAsFixed(2)}'),
                          Text('Paid: ${split.paid.toStringAsFixed(2)}'),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  decoration: const InputDecoration(labelText: 'Amount'),
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (val) {
                                    final amount = double.tryParse(val) ?? 0;
                                    if (amount > 0) {
                                      splitNotifier.updatePayment(split.id, SplitPayment(amount: amount, method: 'cash'));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: 'cash',
                                items: const [
                                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                                  DropdownMenuItem(value: 'card', child: Text('Card')),
                                  DropdownMenuItem(value: 'mobile', child: Text('Mobile')),
                                ],
                                onChanged: (_) {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total splits: ${splitState.splits.length}'),
                ElevatedButton(
                  onPressed: (splitState.splits.isNotEmpty && splitState.unassignedItems.isEmpty && !isLoading)
                      ? _finalizeSplit
                      : null,
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Finalize Split'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final _splitSaleLoadingProvider = StateProvider<bool>((ref) => false); 