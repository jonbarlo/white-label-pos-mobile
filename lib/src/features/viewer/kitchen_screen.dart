import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kitchen_order_provider.dart';
import 'kitchen_order.dart';
import '../../core/theme/app_theme.dart';
import 'package:collection/collection.dart';

class KitchenScreen extends ConsumerWidget {
  const KitchenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(kitchenOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Orders'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(kitchenOrdersProvider);
        },
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Active Orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All caught up! 🎉',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _KitchenOrderCard(
                  order: order,
                  onStatusChanged: () {
                    // Refresh the orders after status change
                    ref.invalidate(kitchenOrdersProvider);
                  },
                );
              },
            );
          },
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading kitchen orders...'),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading orders',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(kitchenOrdersProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KitchenOrderCard extends StatelessWidget {
  final KitchenOrder order;
  final VoidCallback onStatusChanged;

  const _KitchenOrderCard({
    required this.order,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Dish names with quantity
    final dishNames = order.items.map((item) => '${item.quantity}x ${item.itemName}').join(', ');
    final orderNotes = order.notes ?? '';
    final orderInstructions = order.specialInstructions ?? '';
    final allergies = order.allergies?.join(', ');
    final dietary = order.dietaryRestrictions?.join(', ');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish names (very prominent)
            if (order.items.isNotEmpty) ...[
              Text(
                dishNames,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
            ] else ...[
              Text(
                'Order #${order.orderNumber}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
            ],
            // Order-level notes and special instructions
            if (orderInstructions.isNotEmpty) ...[
              Text(
                orderInstructions,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (orderNotes.isNotEmpty) ...[
              Text(
                orderNotes,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
            ],
            // Allergies and dietary restrictions
            if (allergies != null && allergies.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.warning, color: theme.colorScheme.error, size: 18),
                  const SizedBox(width: 4),
                  Text('Allergies: $allergies', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 2),
            ],
            if (dietary != null && dietary.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.tertiary, size: 18),
                  const SizedBox(width: 4),
                  Text('Dietary: $dietary', style: TextStyle(color: theme.colorScheme.tertiary, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 2),
            ],
            // Header with order number and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _StatusChip(status: order.status ?? ''),
                    ],
                  ),
                ),
                _PriorityBadge(priority: order.priority ?? 'normal'),
              ],
            ),
            const SizedBox(height: 12),
            // Item breakdown
            if (order.items.isNotEmpty) ...[
              Text('Items:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              ...order.items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${item.quantity}x ', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text(item.itemName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 2),
                          child: Text(item.specialInstructions!, style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                        ),
                      if (item.modifications != null && item.modifications!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 2),
                          child: Text('Mods: ${item.modifications!.join(', ')}', style: theme.textTheme.bodySmall),
                        ),
                      if (item.allergens != null && item.allergens!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 2),
                          child: Text('Allergens: ${item.allergens!.join(', ')}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
                        ),
                    ],
                  ),
                );
              }),
            ],
            
            const SizedBox(height: 16),
            
            // Progress section
            _ProgressSection(order: order),
            
            const SizedBox(height: 16),
            
            // Action buttons - Compact Apple-style
            _ActionButtonsSection(
              order: order,
              onStatusChanged: onStatusChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    IconData icon;
    
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = theme.colorScheme.primary;
        icon = Icons.schedule;
        break;
      case 'preparing':
        color = theme.colorScheme.primary;
        icon = Icons.restaurant;
        break;
      case 'ready':
        color = theme.colorScheme.tertiary;
        icon = Icons.check_circle;
        break;
      case 'served':
        color = theme.colorScheme.surfaceVariant ?? Colors.grey;
        icon = Icons.done_all;
        break;
      default:
        color = theme.colorScheme.surfaceVariant ?? Colors.grey;
        icon = Icons.info;
    }

    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    String text;
    
    switch (priority.toLowerCase()) {
      case 'high':
        color = theme.colorScheme.tertiary;
        text = 'HIGH';
        break;
      case 'normal':
        color = theme.colorScheme.primary;
        text = 'NORMAL';
        break;
      case 'low':
        color = theme.colorScheme.surfaceVariant ?? Colors.grey;
        text = 'LOW';
        break;
      default:
        color = theme.colorScheme.surfaceVariant ?? Colors.grey;
        text = priority.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _OrderDetailsSection extends StatelessWidget {
  final KitchenOrder order;

  const _OrderDetailsSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (order.customerName != null) ...[
          _DetailRow(
            icon: Icons.person,
            label: 'Customer',
            value: order.customerName!,
          ),
        ],
        if (order.tableNumber != null) ...[
          _DetailRow(
            icon: Icons.table_restaurant,
            label: 'Table',
            value: order.tableNumber.toString(),
          ),
        ],
        _DetailRow(
          icon: Icons.delivery_dining,
          label: 'Type',
          value: order.orderType ?? 'dine_in',
        ),
        if (order.estimatedPrepTime != null) ...[
          _DetailRow(
            icon: Icons.timer,
            label: 'Est. Prep Time',
            value: '${order.estimatedPrepTime} min',
          ),
        ],
        if (order.specialInstructions != null && order.specialInstructions!.isNotEmpty) ...[
          _DetailRow(
            icon: Icons.note,
            label: 'Special Instructions',
            value: order.specialInstructions!,
          ),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final KitchenOrderItem item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main item info
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
                      item.itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    if (item.notes != null && item.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.notes!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          // Allergies and dietary restrictions (if available)
          if (item.allergies != null && item.allergies!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.red[700]),
                  const SizedBox(width: 4),
                  Text(
                    'Allergies: ${item.allergies!.join(', ')}',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          if (item.dietaryRestrictions != null && item.dietaryRestrictions!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, size: 16, color: Colors.orange[700]),
                  const SizedBox(width: 4),
                  Text(
                    'Dietary: ${item.dietaryRestrictions!.join(', ')}',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final KitchenOrder order;

  const _ProgressSection({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalItems = order.totalItems ?? 0;
    final completedItems = order.completedItems ?? 0;
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$completedItems/$totalItems items',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.surfaceVariant ?? Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  final KitchenOrder order;
  final VoidCallback onStatusChanged;

  const _ActionButtonsSection({
    required this.order,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentStatus = order.status?.toLowerCase() ?? '';
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (currentStatus == 'confirmed') ...[
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => _updateOrderStatus(context, 'preparing'),
              icon: const Icon(Icons.restaurant, size: 18),
              label: const Text('Start Preparing', style: TextStyle(fontSize: 14)),
              style: AppTheme.neutralButtonStyle,
            ),
          ),
          const SizedBox(width: 12),
        ] else if (currentStatus == 'preparing') ...[
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => _updateOrderStatus(context, 'ready'),
              icon: const Icon(Icons.check_circle, size: 18),
              label: const Text('Mark Ready', style: TextStyle(fontSize: 14)),
              style: AppTheme.neutralButtonStyle,
            ),
          ),
          const SizedBox(width: 12),
        ],
        SizedBox(
          height: 44,
          child: OutlinedButton.icon(
            onPressed: () => _showOrderDetails(context),
            icon: const Icon(Icons.info, size: 18),
            label: const Text('Details', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateOrderStatus(BuildContext context, String newStatus) {
    // TODO: Implement API call to update order status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order status updated to $newStatus'),
        backgroundColor: AppTheme.neutralButtonColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    onStatusChanged();
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order ${order.orderNumber}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status: ${order.status}'),
              Text('Priority: ${order.priority ?? 'normal'}'),
              Text('Type: ${order.orderType ?? 'dine_in'}'),
              if (order.specialInstructions != null && order.specialInstructions!.isNotEmpty)
                Text('Special Instructions: ${order.specialInstructions}'),
              if (order.notes != null && order.notes!.isNotEmpty)
                Text('Notes: ${order.notes}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 