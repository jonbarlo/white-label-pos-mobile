import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kitchen_order_provider.dart';
import 'kitchen_order.dart';
import '../../core/theme/theme_provider.dart';

class KitchenScreen extends ConsumerWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(kitchenOrdersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Orders'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: () {
              ref.invalidate(kitchenOrdersProvider);
            },
            tooltip: 'Refresh Orders',
          ),
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeModeProvider);
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(kitchenOrdersProvider);
        },
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Active Orders',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All caught up! 🎉',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // 4-column grid for Square POS style
                int crossAxisCount = 4;
                if (constraints.maxWidth < 800) crossAxisCount = 3;
                if (constraints.maxWidth < 600) crossAxisCount = 2;
                if (constraints.maxWidth < 400) crossAxisCount = 1;
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0, // Square cards
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
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading kitchen orders...',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading orders',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodyMedium,
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
    _updateOrder();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStatus = _getCurrentStatus();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${widget.order.orderNumber}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(currentStatus),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 2),
            
            // Status
            Text(
              currentStatus.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getStatusColor(currentStatus),
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Items List - Compact
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._items.take(2).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      '${item.quantity}x ${item.itemName}',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  if (_items.length > 2)
                    Text(
                      '+${_items.length - 2} more',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Table and Time
            if (widget.order.tableNumber != null)
              Text(
                'Table ${widget.order.tableNumber}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            
            Text(
              _formatTime(widget.order.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
            
            // Action Button
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                onPressed: _getActionCallback(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(currentStatus),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _getActionText(currentStatus),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentStatus() {
    final totalItems = _items.length;
    final completedItems = _items.where((item) => item.status == 'completed').length;
    
    if (completedItems == 0) return 'pending';
    if (completedItems < totalItems) return 'preparing';
    if (completedItems == totalItems) return 'ready';
    return 'pending';
  }

  VoidCallback? _getActionCallback() {
    final status = _getCurrentStatus();
    switch (status) {
      case 'pending':
        return () => _startPreparing();
      case 'preparing':
        return () => _markReady();
      case 'ready':
        return () => _markComplete();
      default:
        return null;
    }
  }

  String _getActionText(String status) {
    switch (status) {
      case 'pending':
        return 'START';
      case 'preparing':
        return 'READY';
      case 'ready':
        return 'COMPLETE';
      default:
        return 'DONE';
    }
  }

  void _startPreparing() {
    // Mark first item as completed to start preparing
    if (_items.isNotEmpty) {
      _toggleItemStatus(0);
    }
  }

  void _markReady() {
    // Mark all items as completed
    setState(() {
      for (int i = 0; i < _items.length; i++) {
        _items[i] = _items[i].copyWith(status: 'completed');
      }
    });
    _updateOrder();
  }

  void _markComplete() {
    // Order is already ready, mark as completed
    widget.onStatusChanged(widget.order.copyWith(
      items: _items,
      completedItems: _items.length,
      status: 'completed',
    ));
  }

  void _updateOrder() {
    final completedItems = _items.where((item) => item.status == 'completed').length;
    widget.onStatusChanged(widget.order.copyWith(
      items: _items,
      completedItems: completedItems,
    ));
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return 'N/A';
    try {
      final time = DateTime.parse(timeString);
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
} 