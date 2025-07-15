import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kitchen_order_provider.dart';
import 'kitchen_order.dart';
import '../../shared/widgets/theme_toggle_button.dart';

class KitchenScreen extends ConsumerWidget {
  const KitchenScreen({super.key});

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(kitchenOrdersProvider);
            },
            tooltip: 'Refresh Orders',
          ),
          const ThemeToggleButton(),
        ],
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

            return LayoutBuilder(
              builder: (context, constraints) {
                // Calculate number of columns so each card is ~25% of width
                int crossAxisCount = (constraints.maxWidth / 350).floor();
                if (crossAxisCount < 1) crossAxisCount = 1;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return KitchenOrderCard(
                      order: order,
                      onStatusChanged: (updatedOrder) {
                        // Refresh the orders after status change
                        ref.invalidate(kitchenOrdersProvider);
                      },
                    );
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

class KitchenOrderCard extends StatefulWidget {
  final KitchenOrder order;
  final void Function(KitchenOrder) onStatusChanged;

  const KitchenOrderCard({
    required this.order,
    required this.onStatusChanged,
    super.key,
  });

  @override
  State<KitchenOrderCard> createState() => _KitchenOrderCardState();
}

class _KitchenOrderCardState extends State<KitchenOrderCard> {
  late List<KitchenOrderItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List<KitchenOrderItem>.from(widget.order.items);
  }

  void _toggleItemStatus(int index) {
    setState(() {
      final item = _items[index];
      final isCompleted = item.status == 'completed';
      _items[index] = item.copyWith(status: isCompleted ? 'pending' : 'completed');
    });
    // Call onStatusChanged with updated order
    final completedItems = _items.where((item) => item.status == 'completed').length;
    widget.onStatusChanged(widget.order.copyWith(
      items: _items,
      completedItems: completedItems,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dishNames = _items.map((item) => '${item.quantity}x ${item.itemName}').join(', ');
    final orderNotes = widget.order.notes ?? '';
    final orderInstructions = widget.order.specialInstructions ?? '';
    final allergies = widget.order.allergies?.join(', ');
    final dietary = widget.order.dietaryRestrictions?.join(', ');
    bool showMore = orderNotes.length > 40 || orderInstructions.length > 40;
    final totalItems = _items.length;
    final completedItems = _items.where((item) => item.status == 'completed').length;
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish names (very prominent)
            if (_items.isNotEmpty) ...[
              Text(
                dishNames,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
            ],
            // Order number
            Text(
              widget.order.orderNumber,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Status and priority
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusChip(status: widget.order.status ?? ''),
                _PriorityBadge(priority: widget.order.priority ?? 'normal'),
              ],
            ),
            const SizedBox(height: 6),
            // Items summary
            if (_items.isNotEmpty) ...[
              Text('Items:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              // List items vertically with switches
              ..._items.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Row(
                  children: [
                    Expanded(child: Text('${item.quantity}x ${item.itemName}')),
                    Switch(
                      value: item.status == 'completed',
                      onChanged: (_) => _toggleItemStatus(idx),
                    ),
                  ],
                );
              }),
            ],
            // Allergies and dietary restrictions (icons only if present)
            if (allergies != null && allergies.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.warning, color: theme.colorScheme.error, size: 16),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text('Allergies', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            if (dietary != null && dietary.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.tertiary, size: 16),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text('Dietary', style: TextStyle(color: theme.colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            // Notes and instructions (truncated)
            if (orderInstructions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  orderInstructions,
                  style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (orderNotes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  orderNotes,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.tertiary, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (showMore)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(40, 24)),
                  onPressed: () => _showOrderDetails(context),
                  child: const Text('More', style: TextStyle(fontSize: 12)),
                ),
              ),
            const Spacer(),
            // Progress section (compact)
            Column(
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
                  backgroundColor: theme.colorScheme.surfaceContainerHighest ?? Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Action buttons
            _ActionButtonsSection(
              order: widget.order,
              onStatusChanged: widget.onStatusChanged,
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order ${widget.order.orderNumber}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status: ${widget.order.status}'),
              Text('Priority: ${widget.order.priority ?? 'normal'}'),
              Text('Type: ${widget.order.orderType ?? 'dine_in'}'),
              if (widget.order.specialInstructions != null && widget.order.specialInstructions!.isNotEmpty)
                Text('Special Instructions: ${widget.order.specialInstructions}'),
              if (widget.order.notes != null && widget.order.notes!.isNotEmpty)
                Text('Notes: ${widget.order.notes}'),
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

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final lowerStatus = status.toLowerCase();
    Color color;
    Color textColor = Colors.white;
    IconData icon;

    switch (lowerStatus) {
      case 'confirmed':
        color = const Color(0xFF0176d3); // Blue
        icon = Icons.check_circle_outline;
        break;
      case 'preparing':
        color = const Color(0xFFfe9339); // Orange
        icon = Icons.restaurant;
        break;
      case 'ready':
        color = const Color(0xFF2e844a); // Green
        icon = Icons.check_circle;
        break;
      case 'served':
        color = const Color(0xFF747474); // Gray
        icon = Icons.done_all;
        textColor = const Color(0x000fffff); // White for contrast
        break;
      case 'cancelled':
        color = const Color(0xFFea001e); // Red
        icon = Icons.cancel;
        break;
      case 'pending':
        color = const Color(0xFFfed850); // Yellow
        icon = Icons.hourglass_empty;
        textColor = const Color(0xFF181818); // Dark text for yellow
        break;
      default:
        color = const Color(0xFFc3c3c3); // Light gray
        icon = Icons.info_outline;
        textColor = const Color(0xFF181818); // Dark text for neutral
    }

    return Chip(
      avatar: Icon(icon, color: textColor, size: 16),
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
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
        color = Colors.red[600]!;
        text = 'HIGH';
        break;
      case 'normal':
        color = Colors.orange[600]!;
        text = 'NORMAL';
        break;
      case 'low':
        color = Colors.grey[500]!;
        text = 'LOW';
        break;
      default:
        color = Colors.grey[500]!;
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
          backgroundColor: theme.colorScheme.surfaceContainerHighest ?? Colors.grey[300],
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
  final void Function(KitchenOrder) onStatusChanged;

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
        if (currentStatus == 'confirmed' || currentStatus == 'pending') ...[
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => _updateOrderStatus(context, 'preparing'),
              icon: const Icon(Icons.restaurant, size: 18),
              label: const Text('Start Preparing', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
    // Use the provider to update the order status
    final container = ProviderScope.containerOf(context);
    container.read(updateOrderStatusProvider((orderId: order.id, status: newStatus))).when(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to $newStatus'),
            backgroundColor: Colors.orange[600],
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        onStatusChanged(order);
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Updating order status...'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: ${error.toString()}'),
            backgroundColor: Colors.red[600],
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
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