import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'models/table.dart' as waiter_table;
import '../../shared/widgets/theme_toggle_button.dart';
import '../../shared/widgets/app_image.dart';
import '../pos/models/cart_item.dart';
import '../pos/models/menu_item.dart';
import '../pos/pos_provider.dart';
import '../pos/split_payment_dialog.dart';
import '../auth/auth_provider.dart';
import 'waiter_order_provider.dart' as waiter_order;
import 'table_provider.dart' as waiter;
import 'package:another_flushbar/flushbar.dart';
import '../floor_plan/floor_plan_provider.dart' as fp;
import '../../shared/utils/currency_formatter.dart';
import '../business/business_provider.dart';


class OrderTakingScreen extends ConsumerStatefulWidget {
  final waiter_table.Table table;
  final Map<String, dynamic>? prefillOrder;
  
  const OrderTakingScreen({
    super.key,
    required this.table,
    this.prefillOrder,
  });

  @override
  ConsumerState<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends ConsumerState<OrderTakingScreen> {
  final List<CartItem> _cartItems = [];
  final Set<String> _existingItemIds = {}; // Track existing items from server
  String _customerName = '';
  String _customerNotes = '';
  bool _customerNameEditable = true;
  bool _isSubmitting = false;
  
  // Persistent controllers for customer details
  late TextEditingController _customerNameController;
  late TextEditingController _customerNotesController;

  @override
  void initState() {
    super.initState();
    
    print('🔍 DEBUG: OrderTakingScreen initState called');
    print('🔍 DEBUG: widget.prefillOrder: ${widget.prefillOrder}');
    print('🔍 DEBUG: widget.table: ${widget.table.name}');
    print('🔍 DEBUG: widget.table.customer: ${widget.table.customer}');
    print('🔍 DEBUG: widget.table.customerName: ${widget.table.customerName}');
    print('🔍 DEBUG: widget.table.notes: ${widget.table.notes}');
    
    // Initialize with prefillOrder data first, then fallback to table data
    if (widget.prefillOrder != null) {
      _customerName = widget.prefillOrder!['customerName'] ?? '';
      _customerNotes = widget.prefillOrder!['notes'] ?? '';
      print('🔍 DEBUG: Initialized with prefillOrder - customerName: "$_customerName", notes: "$_customerNotes"');
    } else {
      // Try to get customer data from the table's customer field first
      if (widget.table.customer != null) {
        _customerName = widget.table.customer!.name;
        _customerNotes = widget.table.customer!.notes ?? '';
        print('🔍 DEBUG: Initialized with table.customer - customerName: "$_customerName", notes: "$_customerNotes"');
      } else {
        // Fallback to legacy fields
        _customerName = widget.table.customerName ?? '';
        _customerNotes = widget.table.notes ?? '';
        print('🔍 DEBUG: Initialized with legacy table fields - customerName: "$_customerName", notes: "$_customerNotes"');
      }
    }
    
    // Initialize the controllers with the pre-filled values
    _customerNameController = TextEditingController(text: _customerName);
    _customerNotesController = TextEditingController(text: _customerNotes);
    
    print('🔍 DEBUG: Controllers initialized - customerNameController.text: "${_customerNameController.text}", customerNotesController.text: "${_customerNotesController.text}"');
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Use Riverpod provider for merged table orders
    final mergedOrdersAsync = ref.watch(waiter_order.mergedTableOrdersProvider(widget.table.id));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Order - Table ${widget.table.name}'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print('🔍 DEBUG: Refresh button pressed');
              ref.invalidate(waiter_order.tableOrdersProvider(widget.table.id));
              ref.invalidate(waiter_order.mergedTableOrdersProvider(widget.table.id));
            },
            tooltip: 'Refresh Orders',
          ),
          const ThemeToggleButton(),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted) {
              _navigateBack();
            }
          },
        ),
      ),
      body: mergedOrdersAsync.when(
        data: (mergedData) {
          // Update cart items from merged data
          _updateCartFromMergedData(mergedData);
          
          return Column(
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
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading table orders...'),
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
                  ref.invalidate(waiter_order.mergedTableOrdersProvider(widget.table.id));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  void _updateCartFromMergedData(Map<String, dynamic> mergedData) {
    print('🔍 DEBUG: _updateCartFromMergedData called with mergedData: $mergedData');
    print('🔍 DEBUG: Current _customerName: "$_customerName", _customerNotes: "$_customerNotes"');
    print('🔍 DEBUG: Current _cartItems.length: ${_cartItems.length}');
    
    // Extract customer information from order notes if we don't have it from the table
    // The backend stores customer info in order notes since it doesn't store it in the table record
    if (_customerName.isEmpty && mergedData['customerNotes'] != null) {
      final notes = mergedData['customerNotes'] as String;
      print('🔍 DEBUG: Analyzing order notes for customer info: "$notes"');
      
      // Try to extract customer name from notes
      // Look for patterns like "Customer: [name]" or "[name] - [notes]"
      if (notes.contains('Customer: ')) {
        final customerMatch = RegExp(r'Customer:\s*([^\n]+)').firstMatch(notes);
        if (customerMatch != null) {
          final extractedName = customerMatch.group(1)?.trim() ?? '';
          if (extractedName.isNotEmpty) {
            setState(() {
              _customerName = extractedName;
              _customerNameController.text = _customerName;
              print('🔍 DEBUG: Extracted customer name from notes: "$_customerName"');
            });
          }
        }
      } else if (notes.contains(' - ')) {
        // Try to extract from "name - notes" pattern
        final parts = notes.split(' - ');
        if (parts.length >= 2) {
          final potentialName = parts[0].trim();
          if (potentialName.isNotEmpty && !potentialName.toLowerCase().contains('table')) {
            setState(() {
              _customerName = potentialName;
              _customerNameController.text = _customerName;
              print('🔍 DEBUG: Extracted customer name from notes pattern: "$_customerName"');
            });
          }
        }
      }
    }
    
    // Only update customer data from merged orders if we don't have it from the table
    // The table data should be the source of truth for customer information
    if ((_customerName.isEmpty || _customerNotes.isEmpty) && 
        (mergedData['customerName'] != null || mergedData['customerNotes'] != null)) {
      setState(() {
        // Only update customer name if we don't have it and server has it
        if (_customerName.isEmpty && mergedData['customerName'] != null && 
            mergedData['customerName'].toString().isNotEmpty) {
          _customerName = mergedData['customerName'] ?? '';
          _customerNameController.text = _customerName;
          print('🔍 DEBUG: Updated _customerName from server (fallback): "$_customerName"');
        }
        
        // Only update customer notes if we don't have it and server has it
        if (_customerNotes.isEmpty && mergedData['customerNotes'] != null) {
          _customerNotes = mergedData['customerNotes'] ?? '';
          _customerNotesController.text = _customerNotes;
          print('🔍 DEBUG: Updated _customerNotes from server (fallback): "$_customerNotes"');
        }
        
        _customerNameEditable = false;
      });
    }
    
    // Only update cart items if cart is empty (initial load)
    // This prevents server data from overwriting local cart changes
    if (mergedData['items'] != null && _cartItems.isEmpty) {
      final items = mergedData['items'] as List<dynamic>;
      print('🔍 DEBUG: Updating cart from server data with ${items.length} items');
      
      setState(() {
        _existingItemIds.clear(); // Clear existing items tracking
        for (final item in items) {
          final itemId = item['itemId']?.toString() ?? item['id']?.toString() ?? '';
          _existingItemIds.add(itemId); // Track this as an existing item
          _cartItems.add(CartItem(
            id: itemId,
            name: item['itemName'] ?? item['name'] ?? '',
            price: (item['unitPrice'] ?? item['price'] ?? 0).toDouble(),
            quantity: (item['quantity'] ?? 1) as int,
            imageUrl: item['imageUrl'],
            category: item['category']?.toString(),
          ));
        }
      });
      print('🔍 DEBUG: Updated cart from server data with ${_cartItems.length} items');
      print('🔍 DEBUG: Tracked existing item IDs: $_existingItemIds');
    }
  }

  Widget _buildTableInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.table.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getStatusColor(widget.table.status).withValues(alpha: 0.3),
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
    print('🔍 DEBUG: _buildCustomerDetails called');
    print('🔍 DEBUG: _customerNameController.text: "${_customerNameController.text}"');
    print('🔍 DEBUG: _customerNotesController.text: "${_customerNotesController.text}"');
    print('🔍 DEBUG: _customerName: "$_customerName", _customerNotes: "$_customerNotes"');
    
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
                  controller: _customerNameController,
                  enabled: _customerNameEditable,
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
            controller: _customerNotesController,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    // Try to use waiter menu items first, fallback to POS search
    final waiterMenuItemsAsync = ref.watch(waiter_order.menuItemsProvider(null));
    
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
          child: waiterMenuItemsAsync.when(
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
            error: (error, stack) {
              // Fallback to POS search with empty query to get all items
              // Trigger a search to load all items
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(searchNotifierProvider.notifier).searchItems('');
              });
              
              final posMenuItems = ref.watch(searchNotifierProvider);
              
              if (posMenuItems.isEmpty) {
                return Center(
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
                        'Menu items temporarily unavailable',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Existing order items will still be shown',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(waiter_order.menuItemsProvider(null)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: posMenuItems.length,
                itemBuilder: (context, index) {
                  final item = posMenuItems[index];
                  return _buildMenuItemCardFromPos(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item) {
    final name = item['name'] ?? '';
    final description = item['description'] ?? '';
    final price = (item['price'] ?? 0.0).toDouble();
    final isAvailable = item['isAvailable'] ?? true;
    final imageUrl = item['image'] ?? item['imageUrl'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: AppThumbnail(
          imageUrl: imageUrl,
          size: 80,
          borderRadius: 8,
          fallbackIcon: Icons.restaurant,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  CurrencyFormatter.formatBusinessCurrency(price, ref.watch(currentBusinessCurrencyIdProvider)),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (isAvailable) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      print('🔍 DEBUG: Add button tapped for item: ${item['name']}');
                      _addToCartFromMap(item);
                    },
                    icon: Icon(Icons.add, size: 20),
                    label: Text('Add', style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 48),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Unavailable',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
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

  Widget _buildMenuItemCardFromPos(MenuItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: AppThumbnail(
          imageUrl: item.image,
          size: 80,
          borderRadius: 8,
          fallbackIcon: Icons.restaurant,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  CurrencyFormatter.formatBusinessCurrency(item.price, ref.watch(currentBusinessCurrencyIdProvider)),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (item.isAvailable) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      print('🔍 DEBUG: Add button tapped for item: ${item.name}');
                      _addToCartFromPosItem(item);
                    },
                    icon: Icon(Icons.add, size: 20),
                    label: Text('Add', style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 48),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Unavailable',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
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

  void _addToCartFromPosItem(MenuItem item) {
    print('🔍 DEBUG: _addToCartFromPosItem called with item: ${item.name}');
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == item.id.toString());
    
    if (existingIndex >= 0) {
      print('🔍 DEBUG: Updating existing item quantity');
      setState(() {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + 1,
        );
      });
    } else {
      print('🔍 DEBUG: Adding new item to cart');
      setState(() {
        _cartItems.add(CartItem(
          id: item.id.toString(),
          name: item.name,
          price: item.price,
          quantity: 1,
          imageUrl: item.image,
          category: item.categoryId.toString(),
        ));
      });
    }
    print('🔍 DEBUG: Cart now has ${_cartItems.length} items');
  }

  Widget _buildCart() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
                        CurrencyFormatter.formatBusinessCurrency(_getSubtotal(), ref.watch(currentBusinessCurrencyIdProvider)),
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
                        CurrencyFormatter.formatBusinessCurrency(_getTax(), ref.watch(currentBusinessCurrencyIdProvider)),
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
                        CurrencyFormatter.formatBusinessCurrency(_getTotal(), ref.watch(currentBusinessCurrencyIdProvider)),
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
        leading: AppThumbnail(
          imageUrl: item.imageUrl,
          size: 40,
          borderRadius: 6,
          fallbackIcon: Icons.restaurant,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
                          '${CurrencyFormatter.formatBusinessCurrency(item.price, ref.watch(currentBusinessCurrencyIdProvider))} each',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _decreaseQuantity(item),
                icon: const Icon(Icons.remove, size: 18, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _increaseQuantity(item),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
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
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isSubmitting ? null : () {
                print('🔍 DEBUG: Cancel button pressed');
                if (mounted) {
                  _navigateBack();
                }
              },
              icon: Icon(Icons.cancel, size: 24),
              label: Text('Cancel', style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              )),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[400]!),
                minimumSize: const Size(120, 56),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting || _cartItems.isEmpty ? null : () {
                print('🔍 DEBUG: Submit order button pressed');
                _submitOrder();
              },
              icon: _isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.send, size: 24),
              label: Text(
                _isSubmitting ? 'Submitting...' : 'Submit Order',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(120, 56),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _cartItems.isEmpty ? null : () {
                print('🔍 DEBUG: Split bill button pressed');
                // Show split billing dialog instead of navigation
                showDialog(
                  context: context,
                  builder: (context) => SplitPaymentDialog(
                    totalAmount: _getTotal(),
                    cartItems: List<CartItem>.from(_cartItems),
                    userId: ref.read(authNotifierProvider).user?.id ?? 1,
                  ),
                );
              },
              icon: Icon(Icons.call_split, size: 24),
              label: Text('Split Bill', style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              )),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(120, 56),
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

  void _addToCartFromMap(Map<String, dynamic> item) {
    print('🔍 DEBUG: _addToCartFromMap called with item: ${item['name']}');
    // Use the menu item ID that the backend expects
    final menuItemId = item['id']?.toString() ?? '';
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == menuItemId);
    
    if (existingIndex >= 0) {
      print('🔍 DEBUG: Updating existing item quantity');
      setState(() {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + 1,
        );
      });
    } else {
      print('🔍 DEBUG: Adding new item to cart');
      setState(() {
        _cartItems.add(CartItem(
          id: menuItemId,
          name: item['name'] ?? '',
          price: (item['price'] ?? 0.0).toDouble(),
          quantity: 1,
          imageUrl: item['imageUrl'],
          category: item['category'],
        ));
      });
    }
    print('🔍 DEBUG: Cart now has ${_cartItems.length} items');
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
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add items to the order')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      
      // Check if there's an existing order for this table
      final container = ProviderScope.containerOf(context, listen: false);
      final tableOrders = await container.read(waiter_order.tableOrdersProvider(widget.table.id).future);
      
      if (tableOrders.isNotEmpty) {
        // Add items to existing order
        // Get the order ID from the first order in the table
        final orderId = tableOrders.first['id'].toString();
        
        // Only send new items (not existing ones) to avoid incrementing quantities
        final newItems = _cartItems.where((item) => !_existingItemIds.contains(item.id)).toList();
        print('🔍 DEBUG: Sending ${newItems.length} new items to addItemsToOrder (${_cartItems.length} total in cart)');
        print('🔍 DEBUG: New items: ${newItems.map((item) => '${item.name} (qty: ${item.quantity})').join(', ')}');
        
        if (newItems.isNotEmpty) {
          final result = await ref.read(waiter_order.addItemsToOrderProvider((
            orderId: orderId,
            items: newItems,
          )).future);
        } else {
          print('🔍 DEBUG: No new items to add, skipping addItemsToOrder call');
        }
        
        // Refresh the order data after adding items
        await Future.delayed(const Duration(milliseconds: 500)); // Give backend time to process
        ref.invalidate(waiter_order.tableOrdersProvider(widget.table.id));
        ref.invalidate(waiter_order.mergedTableOrdersProvider(widget.table.id));
        // Refresh table data to update status and order info
        ref.invalidate(waiter.tableProvider);
        ref.invalidate(waiter.tablesProvider);
        // Refresh floor plan data to update table statuses in floor plan viewer
        ref.invalidate(fp.floorPlansWithTablesProvider);
        
      } else {
        // Create new order
        
        final result = await ref.read(waiter_order.submitTableOrderProvider((
          tableId: widget.table.id,
          customerName: _customerName.isNotEmpty ? _customerName : 'Guest',
          customerNotes: _customerNotes,
          items: _cartItems,
          subtotal: _getSubtotal(),
          tax: _getTax(),
          total: _getTotal(),
        )).future);

        // Refresh the order data after creating new order
        await Future.delayed(const Duration(milliseconds: 500)); // Give backend time to process
        ref.invalidate(waiter_order.tableOrdersProvider(widget.table.id));
        ref.invalidate(waiter_order.mergedTableOrdersProvider(widget.table.id));
        // Refresh table data to update status and order info
        ref.invalidate(waiter.tableProvider);
        ref.invalidate(waiter.tablesProvider);
        // Refresh floor plan data to update table statuses in floor plan viewer
        ref.invalidate(fp.floorPlansWithTablesProvider);
      }

      // Reset loading state and clear cart
      setState(() {
        _isSubmitting = false;
        _cartItems.clear(); // Clear the cart after successful submission
      });

      // Show success message (Flutter convention)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Order submitted successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate back
      _navigateBack();
    } catch (e) {
      
      // Check if widget is still mounted before showing error
      if (!mounted) {
        return;
      }

      // Reset loading state first
      setState(() {
        _isSubmitting = false;
      });

      // Show error message in next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        
        Flushbar(
          message: 'Failed to submit order: ${e.toString()}',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error, color: Colors.white),
        ).show(context);
      });
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

  void _navigateBack() {
    if (mounted) {
      // Refresh floor plan data before navigating back
      ref.invalidate(fp.progressiveFloorPlansProvider);
      ref.invalidate(fp.floorPlansWithTablesProvider);
      
      // Simply pop back to the previous screen
      context.pop();
    }
  }
} 
