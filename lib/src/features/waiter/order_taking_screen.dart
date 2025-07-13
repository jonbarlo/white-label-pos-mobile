import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/table.dart' as waiter_table;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../pos/models/cart_item.dart';
import '../pos/models/menu_item.dart';
import '../pos/pos_provider.dart';
import 'waiter_order_provider.dart';
import 'table_provider.dart';

class OrderTakingScreen extends ConsumerStatefulWidget {
  final waiter_table.Table table;
  
  const OrderTakingScreen({
    Key? key,
    required this.table,
  }) : super(key: key);

  @override
  ConsumerState<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends ConsumerState<OrderTakingScreen> {
  final List<CartItem> _cartItems = [];
  String _customerName = '';
  String _customerNotes = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill customer name if available
    _customerName = widget.table.customerName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Order - Table ${widget.table.tableNumber}'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: const [
          ThemeToggleButton(),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Table info header
          _buildTableInfo(),
          
          // Customer details
          _buildCustomerDetails(),
          
          // Menu items and cart
          Expanded(
            child: Row(
              children: [
                // Menu items (left side)
                Expanded(
                  flex: 2,
                  child: _buildMenuItems(),
                ),
                
                // Cart (right side)
                Expanded(
                  flex: 1,
                  child: _buildCart(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildTableInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.table.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getStatusColor(widget.table.status).withOpacity(0.3),
              ),
            ),
            child: Text(
              widget.table.status.displayName,
              style: TextStyle(
                color: _getStatusColor(widget.table.status),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.people, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '${widget.table.capacity} seats',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const Spacer(),
          if (widget.table.assignedWaiter != null) ...[
            Icon(Icons.person, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              widget.table.assignedWaiter!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    hintText: 'Enter customer name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _customerName = value,
                  controller: TextEditingController(text: _customerName),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Special Instructions',
              hintText: 'Allergies, preferences, etc.',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            onChanged: (value) => _customerNotes = value,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    // Use real menu items from the POS provider
    final menuItemsAsync = ref.watch(menuItemsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Menu Items',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: menuItemsAsync.when(
            data: (menuItems) {
              if (menuItems.isEmpty) {
                return const Center(
                  child: Text('No menu items available'),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildMenuItemCard(item);
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading menu items',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(menuItemsProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemCard(MenuItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (item.isAvailable) ...[
                  ElevatedButton.icon(
                    onPressed: () => _addToCart(item),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Unavailable',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCart() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Order Items (${_cartItems.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items in cart',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItemCard(_cartItems[index]);
                    },
                  ),
          ),
          if (_cartItems.isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '\$${_getSubtotal().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax (8.5%):',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '\$${_getTax().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_getTotal().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\$${item.price.toStringAsFixed(2)} each',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _decreaseQuantity(item),
              icon: const Icon(Icons.remove, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                minimumSize: const Size(32, 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _increaseQuantity(item),
              icon: const Icon(Icons.add, size: 16),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(32, 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting || _cartItems.isEmpty ? null : _submitOrder,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_isSubmitting ? 'Submitting...' : 'Submit Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(MenuItem item) {
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == item.id.toString());
    
    if (existingIndex >= 0) {
      setState(() {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + 1,
        );
      });
    } else {
      setState(() {
        _cartItems.add(CartItem(
          id: item.id.toString(),
          name: item.name,
          price: item.price,
          quantity: 1,
        ));
      });
    }
  }

  void _increaseQuantity(CartItem item) {
    setState(() {
      final index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
      if (index >= 0) {
        _cartItems[index] = _cartItems[index].copyWith(
          quantity: _cartItems[index].quantity + 1,
        );
      }
    });
  }

  void _decreaseQuantity(CartItem item) {
    setState(() {
      final index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
      if (index >= 0) {
        if (_cartItems[index].quantity > 1) {
          _cartItems[index] = _cartItems[index].copyWith(
            quantity: _cartItems[index].quantity - 1,
          );
        } else {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  double _getSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double _getTax() {
    return _getSubtotal() * 0.085; // 8.5% tax
  }

  double _getTotal() {
    return _getSubtotal() + _getTax();
  }

  void _submitOrder() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Submit order using the waiter order provider
      final result = await ref.read(submitTableOrderProvider((
        tableId: widget.table.id,
        customerName: _customerName.isNotEmpty ? _customerName : 'Guest',
        customerNotes: _customerNotes,
        items: _cartItems,
        subtotal: _getSubtotal(),
        tax: _getTax(),
        total: _getTotal(),
      )).future);
      
      // Invalidate tables provider so the tables list refreshes
      ref.invalidate(tablesProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order submitted! Table is now occupied.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Color _getStatusColor(waiter_table.TableStatus status) {
    switch (status) {
      case waiter_table.TableStatus.available:
        return Colors.green;
      case waiter_table.TableStatus.occupied:
        return Colors.orange;
      case waiter_table.TableStatus.reserved:
        return Colors.blue;
      case waiter_table.TableStatus.cleaning:
        return Colors.grey;
      case waiter_table.TableStatus.outOfService:
        return Colors.red;
    }
  }
} 