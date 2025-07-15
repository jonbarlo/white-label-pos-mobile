import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kitchen_order_provider.dart';
import 'kitchen_order.dart';
import '../../shared/widgets/theme_toggle_button.dart';

class KitchenScreenManager extends ConsumerWidget {
  const KitchenScreenManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(kitchenOrdersProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Kitchen Orders - Manager',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 28,
              color: isDark ? Colors.white : Colors.black,
            ),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 80,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Active Orders',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'All caught up! 🎉',
                      style: TextStyle(
                        fontSize: 24,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // Calculate number of columns for large displays
                int crossAxisCount = (constraints.maxWidth / 400).floor();
                if (crossAxisCount < 1) crossAxisCount = 1;
                if (crossAxisCount > 3) crossAxisCount = 3; // Max 3 columns for readability
                
                return GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return KitchenOrderCardManager(
                      order: order,
                      isDark: isDark,
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
                  strokeWidth: 4,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 24),
                Text(
                  'Loading kitchen orders...',
                  style: TextStyle(
                    fontSize: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
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
                  size: 80,
                  color: isDark ? Colors.red[300] : Colors.red[600],
                ),
                const SizedBox(height: 24),
                Text(
                  'Error loading orders',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(kitchenOrdersProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
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

class KitchenOrderCardManager extends StatefulWidget {
  final KitchenOrder order;
  final bool isDark;
  final void Function(KitchenOrder) onStatusChanged;

  const KitchenOrderCardManager({
    required this.order,
    required this.isDark,
    required this.onStatusChanged,
    super.key,
  });

  @override
  State<KitchenOrderCardManager> createState() => _KitchenOrderCardManagerState();
}

class _KitchenOrderCardManagerState extends State<KitchenOrderCardManager> {
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
    final completedItems = _items.where((item) => item.status == 'completed').length;
    final totalItems = _items.length;
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;

    return Card(
      elevation: widget.isDark ? 8 : 4,
      color: widget.isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${widget.order.orderNumber}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.order.status ?? 'pending', widget.isDark),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (widget.order.status ?? 'pending').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: widget.isDark ? Colors.grey[700]! : Colors.grey[300]!,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatusColor(widget.order.status ?? 'pending', widget.isDark),
              ),
              minHeight: 8,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              '$completedItems of $totalItems items completed',
              style: TextStyle(
                fontSize: 16,
                color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Items List with Interactive Buttons
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isCompleted = item.status == 'completed';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? (widget.isDark ? Colors.green[900]! : Colors.green[50]!)
                          : (widget.isDark ? Colors.grey[800]! : Colors.grey[100]!),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCompleted 
                            ? (widget.isDark ? Colors.green[600]! : Colors.green[300]!)
                            : (widget.isDark ? Colors.grey[600]! : Colors.grey[300]!),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Interactive Status Toggle Button
                        GestureDetector(
                          onTap: () => _toggleItemStatus(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCompleted 
                                  ? (widget.isDark ? Colors.green[600] : Colors.green[500])
                                  : (widget.isDark ? Colors.orange[600] : Colors.orange[500]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isCompleted ? Icons.check_circle : Icons.pending,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.quantity}x ${item.itemName}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: widget.isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              if (item.specialInstructions?.isNotEmpty == true)
                                Text(
                                  'Note: ${item.specialInstructions}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Status Text
                        Text(
                          isCompleted ? 'DONE' : 'PENDING',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                                                      color: isCompleted 
                              ? (widget.isDark ? Colors.green[300]! : Colors.green[600]!)
                              : (widget.isDark ? Colors.orange[300]! : Colors.orange[600]!),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateOrderStatus(context, 'preparing'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isDark ? Colors.blue[600] : Colors.blue[500],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('PREPARING'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateOrderStatus(context, 'ready'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isDark ? Colors.green[600] : Colors.green[500],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('READY'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Order Details
            if (widget.order.tableNumber != null) ...[
              _buildDetailRow(
                icon: Icons.table_restaurant,
                label: 'Table',
                value: widget.order.tableNumber.toString(),
                isDark: widget.isDark,
              ),
            ],
            
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Time',
              value: _formatTime(widget.order.createdAt),
              isDark: widget.isDark,
            ),
            
            if (widget.order.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isDark ? Colors.blue[900]! : Colors.blue[50]!,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isDark ? Colors.blue[600]! : Colors.blue[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note,
                      color: widget.isDark ? Colors.blue[300]! : Colors.blue[600]!,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.order.notes!,
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.isDark ? Colors.blue[200] : Colors.blue[800],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, bool isDark) {
    switch (status.toLowerCase()) {
      case 'pending':
        return isDark ? Colors.orange[600]! : Colors.orange[500]!;
      case 'preparing':
        return isDark ? Colors.blue[600]! : Colors.blue[500]!;
      case 'ready':
        return isDark ? Colors.green[600]! : Colors.green[500]!;
      case 'completed':
        return isDark ? Colors.green[600]! : Colors.green[500]!;
      default:
        return isDark ? Colors.grey[600]! : Colors.grey[500]!;
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

  void _updateOrderStatus(BuildContext context, String newStatus) {
    // For now, just show a snackbar - the actual API call can be implemented later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order status updated to $newStatus'),
        backgroundColor: _getStatusColor(newStatus, widget.isDark),
      ),
    );
  }
} 