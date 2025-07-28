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
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Kitchen Orders',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
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
                  size: 24,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              );
            },
          ),
          const SizedBox(width: 8),
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
                      size: 120, // Much larger icon
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'No Active Orders',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 36, // Much larger text
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'All caught up! 🎉',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 24, // Larger text
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // Optimized grid layout for kitchen displays - prioritize readability
                int crossAxisCount = 3; // Default for most kitchen screens
                
                // Adjust based on screen size - prioritize readability over quantity
                if (constraints.maxWidth > 1600) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth < 1200) {
                  crossAxisCount = 2;
                } else if (constraints.maxWidth < 800) {
                  crossAxisCount = 1;
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(24), // Increased padding
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24, // Increased spacing
                    mainAxisSpacing: 24, // Increased spacing
                    childAspectRatio: 0.85, // Taller cards for better content display
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
                  strokeWidth: 6,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 32),
                Text(
                  'Loading kitchen orders...',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 24, // Larger loading text
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 120, // Much larger error icon
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Error Loading Orders',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 32, // Larger error text
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please check your connection and try again',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 20, // Larger subtitle
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(kitchenOrdersProvider);
                    },
                    icon: const Icon(Icons.refresh, size: 24),
                    label: Text(
                      'Retry',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KitchenOrderCard extends StatelessWidget {
  final KitchenOrder order;
  final Function(KitchenOrder) onStatusChanged;

  const KitchenOrderCard({
    required this.order,
    required this.onStatusChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(order.status ?? 'pending');
    final urgencyLevel = _getUrgencyLevel(order.createdAt);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor,
          width: 3, // Thicker border for better visibility
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header with enhanced visibility
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ORDER #${order.orderNumber}',
                      style: TextStyle(
                        fontSize: 26, // Increased from 14-16px
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (urgencyLevel > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'URGENT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Status with larger text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                (order.status ?? 'pending').toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Increased from 10px
                  letterSpacing: 1.0,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Items List with much larger, more readable text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ITEMS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: order.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Quantity - Large and prominent
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 24, // Much larger quantity
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Item name - Large and readable
                              Expanded(
                                child: Text(
                                  item.itemName,
                                  style: TextStyle(
                                    fontSize: 22, // Increased from 11px to 22px
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Table and Time info with better readability
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (order.tableNumber != null) ...[
                    Icon(
                      Icons.table_restaurant,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Table ${order.tableNumber}',
                      style: TextStyle(
                        fontSize: 18, // Increased from 10px
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                  ],
                  Icon(
                    Icons.schedule,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(order.createdAt),
                    style: TextStyle(
                      fontSize: 18, // Increased from 10px
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Status buttons with larger text and better touch targets
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusButton(
                    context,
                    'Prepare',
                    'preparing',
                    Colors.blue.shade600,
                    Icons.play_arrow,
                  ),
                  const SizedBox(width: 12),
                  _buildStatusButton(
                    context,
                    'Ready',
                    'ready',
                    Colors.green.shade600,
                    Icons.check_circle,
                  ),
                  const SizedBox(width: 12),
                  _buildStatusButton(
                    context,
                    'Complete',
                    'completed',
                    Colors.grey.shade600,
                    Icons.done_all,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String label,
    String status,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = order.status == status;
    
    return ElevatedButton.icon(
      onPressed: () {
                 if (!isSelected) {
           final updatedOrder = KitchenOrder(
             id: order.id,
             businessId: order.businessId,
             orderId: order.orderId,
             orderNumber: order.orderNumber,
             tableNumber: order.tableNumber,
             items: order.items,
             status: status,
             createdAt: order.createdAt,
             updatedAt: DateTime.now().toIso8601String(),
           );
           onStatusChanged(updatedOrder);
         }
      },
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16, // Increased from 12px
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : color.withValues(alpha: 0.1),
        foregroundColor: isSelected ? Colors.white : color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Larger touch target
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color, width: 2),
        ),
        elevation: isSelected ? 4 : 0,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade600;
      case 'preparing':
        return Colors.blue.shade600;
      case 'ready':
        return Colors.green.shade600;
      case 'completed':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
  
  int _getUrgencyLevel(String? timeString) {
    if (timeString == null) return 0;
    try {
      final time = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(time).inMinutes;
      
      // Mark as urgent if order is older than 15 minutes
      if (difference > 15) return 1;
      return 0;
    } catch (e) {
      return 0;
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return 'N/A';
    try {
      final time = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(time).inMinutes;
      
      if (difference < 60) {
        return '${difference}m ago';
      } else {
        final hours = difference ~/ 60;
        final minutes = difference % 60;
        return '${hours}h ${minutes}m ago';
      }
    } catch (e) {
      return 'N/A';
    }
  }
} 