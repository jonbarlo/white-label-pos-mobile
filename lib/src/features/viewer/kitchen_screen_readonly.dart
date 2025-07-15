import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kitchen_order_provider.dart';
import 'kitchen_order.dart';
import '../../shared/widgets/theme_toggle_button.dart';

class KitchenScreenReadOnly extends ConsumerWidget {
  const KitchenScreenReadOnly({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(kitchenOrdersProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Kitchen Orders - Read Only',
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
                    childAspectRatio: 1.05, // More square
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return KitchenOrderCardReadOnly(
                      order: order,
                      isDark: isDark,
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

class KitchenOrderCardReadOnly extends StatelessWidget {
  final KitchenOrder order;
  final bool isDark;

  const KitchenOrderCardReadOnly({
    required this.order,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedItems = order.items.where((item) => item.status == 'completed').length;
    final totalItems = order.items.length;
    final progress = totalItems > 0 ? completedItems / totalItems : 0.0;

    return Card(
      elevation: isDark ? 8 : 4,
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
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
                    'Order #${order.orderNumber}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status ?? 'pending', isDark),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (order.status ?? 'pending').toUpperCase(),
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
              backgroundColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatusColor(order.status ?? 'pending', isDark),
              ),
              minHeight: 8,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              '$completedItems of $totalItems items completed',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                final isCompleted = item.status == 'completed';
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCompleted 
                        ? (isDark ? Colors.green[900]! : Colors.green[50]!)
                        : (isDark ? Colors.grey[800]! : Colors.grey[100]!),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCompleted 
                          ? (isDark ? Colors.green[600]! : Colors.green[300]!)
                          : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.pending,
                        color: isCompleted 
                            ? (isDark ? Colors.green[300]! : Colors.green[600]!)
                            : (isDark ? Colors.orange[300]! : Colors.orange[600]!),
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.quantity}x ${item.itemName}',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            if (item.specialInstructions?.isNotEmpty == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  'Note: ${item.specialInstructions}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Order Details
            if (order.tableNumber != null) ...[
              _buildDetailRow(
                icon: Icons.table_restaurant,
                label: 'Table',
                value: order.tableNumber.toString(),
                isDark: isDark,
              ),
            ],
            
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Time',
              value: _formatTime(order.createdAt),
              isDark: isDark,
            ),
            
            if (order.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue[900]! : Colors.blue[50]!,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.blue[600]! : Colors.blue[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                                         Icon(
                       Icons.note,
                       color: isDark ? Colors.blue[300]! : Colors.blue[600]!,
                       size: 20,
                     ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.notes!,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.blue[200] : Colors.blue[800],
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
} 