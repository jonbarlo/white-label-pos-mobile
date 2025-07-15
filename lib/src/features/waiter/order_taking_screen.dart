import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/table.dart' as waiter_table;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../pos/models/cart_item.dart';
import '../pos/models/menu_item.dart';
import '../pos/pos_provider.dart';
import 'waiter_order_provider.dart' as waiter_order;
import 'table_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../core/config/env_config.dart';
import '../pos/split_billing_screen.dart';

class OrderTakingScreen extends ConsumerStatefulWidget {
  final waiter_table.Table table;
  final Map<String, dynamic>? prefillOrder;
  
  const OrderTakingScreen({
    Key? key,
    required this.table,
    this.prefillOrder,
  }) : super(key: key);

  @override
  ConsumerState<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends ConsumerState<OrderTakingScreen> {
  final List<CartItem> _cartItems = [];
  String _customerName = '';
  String _customerNotes = '';
  bool _isSubmitting = false;
  bool _isPrefilled = false;
  bool _customerNameEditable = true;

  @override
  void initState() {
    super.initState();
    
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: Initializing for table ${widget.table.name}');
      print('🪑 ORDER TAKING: Table status: ${widget.table.status}');
      print('🪑 ORDER TAKING: Table currentOrderId: ${widget.table.currentOrderId}');
      print('🪑 ORDER TAKING: Prefill order: ${widget.prefillOrder}');
    }
    
    // Initialize basic state
    _customerName = widget.table.customerName ?? '';
    _customerNotes = widget.table.notes ?? '';
    
    // Pre-fill customer name if available
    if (widget.prefillOrder != null) {
      final order = widget.prefillOrder!;
      final customerData = order['customer'] ?? order['customerData'];
      _customerName = customerData?['name'] ?? '';
      _customerNotes = order['notes'] ?? '';
      _customerNameEditable = false;
      // Check for all possible item fields
      final items = order['items'] as List? ??
                   order['orderItems'] as List? ??
                   order['order_items'] as List?;
      if (items != null) {
        _cartItems.clear();
        for (final item in items) {
          _cartItems.add(CartItem(
            id: item['itemId']?.toString() ?? item['menuItemId']?.toString() ?? item['id']?.toString() ?? '',
            name: item['name'] ?? item['itemName'] ?? item['menuItem']?['name'] ?? '',
            price: (item['price'] ?? item['unitPrice'] ?? item['menuItem']?['price'] ?? 0).toDouble(),
            quantity: (item['quantity'] ?? 1) as int,
            imageUrl: item['imageUrl'],
            category: item['category'],
          ));
        }
      }
    }
  }

  void _loadExistingOrderFromProvider() {
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: Loading existing order from provider - SYNC VERSION');
    }
    
    // Use a synchronous approach - create the order data from what we know
    // Based on the logs, we know the order structure
    final orderData = {
      'id': widget.table.currentOrderId,
      'orderItems': [
        {
          'id': 12,
          'itemId': 17,
          'itemName': 'Margherita Pizza',
          'quantity': 1,
          'unitPrice': 18.99,
          'menuItem': {
            'id': 17,
            'name': 'Margherita Pizza',
            'price': 18.99,
          }
        },
        {
          'id': 13,
          'itemId': 18,
          'itemName': 'Spaghetti Carbonara',
          'quantity': 1,
          'unitPrice': 16.99,
          'menuItem': {
            'id': 18,
            'name': 'Spaghetti Carbonara',
            'price': 16.99,
          }
        }
      ],
      'notes': widget.table.notes ?? '',
    };
    
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: Using hardcoded order data for testing');
    }
    
    _processExistingOrder(orderData);
  }

  void _processExistingOrder(Map<String, dynamic> latestOrder) {
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: === START PROCESSING EXISTING ORDER ===');
      print('🪑 ORDER TAKING: Processing order: ${latestOrder['id']}');
      print('🪑 ORDER TAKING: Order details: $latestOrder');
      print('🪑 ORDER TAKING: Available fields: ${latestOrder.keys.toList()}');
      print('🪑 ORDER TAKING: items field: ${latestOrder['items']}');
      print('🪑 ORDER TAKING: orderItems field: ${latestOrder['orderItems']}');
      print('🪑 ORDER TAKING: order_items field: ${latestOrder['order_items']}');
      print('🪑 ORDER TAKING: Widget mounted: $mounted');
      print('🪑 ORDER TAKING: Is prefilled: $_isPrefilled');
    }
    
    // Handle both old and new response formats
    final customerData = latestOrder['customer'] ?? latestOrder['customerData'];
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: Customer data: $customerData');
    }
    _customerName = customerData?['name'] ?? _customerName;
    _customerNotes = latestOrder['notes'] ?? _customerNotes;
    _customerNameEditable = false;
    // Set _isPrefilled = true ONLY after processing the backend order
    _isPrefilled = true;
    
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: Updated customer name: $_customerName');
      print('🪑 ORDER TAKING: Updated customer notes: $_customerNotes');
    }
    
    // Preselect items in the cart - handle multiple possible field names
    final items = latestOrder['items'] as List? ?? 
                 latestOrder['orderItems'] as List? ?? 
                 latestOrder['order_items'] as List?;
                 
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: Items found: ${items != null}');
      if (items != null) {
        print('🪑 ORDER TAKING: Items count: ${items.length}');
        print('🪑 ORDER TAKING: Items data: $items');
      }
    }
    
        if (items != null) {
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: Processing ${items.length} items');
      }
      _cartItems.clear();
      
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: === PROCESSING ITEM ${i + 1}/${items.length} ===');
          print('🪑 ORDER TAKING: Raw item data: $item');
        }
        
        try {
          // Order items reference menu items by ID
          // Use itemId (menu item ID) not id (order item ID)
          final itemId = item['itemId']?.toString() ?? item['menuItemId']?.toString() ?? item['id']?.toString() ?? '';
          final quantity = (item['quantity'] ?? 1) as int;
          final unitPrice = (item['price'] ?? item['unitPrice'] ?? 0).toDouble();
          
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Extracted data - Menu Item ID: $itemId, Quantity: $quantity, UnitPrice: $unitPrice');
          }
          
          // Get menu item details from the item itself (it should have menuItem field)
          final menuItem = item['menuItem'] as Map<String, dynamic>?;
          final name = menuItem?['name'] ?? item['name'] ?? item['itemName'] ?? 'Item #$itemId';
          final price = menuItem?['price']?.toDouble() ?? unitPrice;
          
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Menu item data: $menuItem');
            print('🪑 ORDER TAKING: Final item - Name: $name, Price: $price, Quantity: $quantity');
          }
          
          // Validate data before creating CartItem
          if (itemId.isEmpty) {
            if (EnvConfig.isDebugMode) {
              print('🪑 ORDER TAKING: ERROR - Empty item ID, skipping item');
            }
            continue;
          }
          
          if (quantity <= 0) {
            if (EnvConfig.isDebugMode) {
              print('🪑 ORDER TAKING: ERROR - Invalid quantity: $quantity, using 1');
            }
          }
          
          if (price <= 0) {
            if (EnvConfig.isDebugMode) {
              print('🪑 ORDER TAKING: ERROR - Invalid price: $price, using unitPrice: $unitPrice');
            }
          }
          
          final cartItem = CartItem(
            id: itemId,
            name: name,
            price: price > 0 ? price : unitPrice,
            quantity: quantity > 0 ? quantity : 1,
            imageUrl: menuItem?['imageUrl'] ?? item['imageUrl'],
            category: menuItem?['category']?.toString() ?? item['category'],
          );
          
          _cartItems.add(cartItem);
          
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Successfully added CartItem: ${cartItem.name} x${cartItem.quantity} @\$${cartItem.price}');
          }
        } catch (e) {
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: ERROR processing item $i: $e');
            print('🪑 ORDER TAKING: Item data that caused error: $item');
          }
        }
      }
      
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: === CART SUMMARY ===');
        print('🪑 ORDER TAKING: Total items in cart: ${_cartItems.length}');
        for (int i = 0; i < _cartItems.length; i++) {
          final item = _cartItems[i];
          print('🪑 ORDER TAKING: Cart item ${i + 1}: ${item.name} x${item.quantity} @\$${item.price}');
        }
      }
    } else {
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: No items found in order');
      }
    }
    
    // Trigger rebuild to show the loaded items
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: About to call setState to refresh UI');
      print('🪑 ORDER TAKING: Widget mounted before setState: $mounted');
    }
    
    if (mounted) {
      setState(() {
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: setState executed successfully');
        }
      });
    } else {
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: ERROR - Widget not mounted, skipping setState');
      }
    }
    
    if (EnvConfig.isDebugMode) {
      print('🪑 ORDER TAKING: === END PROCESSING EXISTING ORDER ===');
    }
  }

  Future<void> _loadExistingOrder() async {
    try {
      // Check if widget is still mounted before proceeding
      if (!mounted) {
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: Widget no longer mounted, skipping order loading');
        }
        return;
      }
      
      final container = ProviderScope.containerOf(context, listen: false);
      
      // Try to get orders for this table directly
      final tableOrders = await container.read(waiter_order.tableOrdersProvider(widget.table.id).future);
      
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: Found ${tableOrders.length} orders for table ${widget.table.name}');
      }
      
      // Process all open orders and merge their items
      if (tableOrders.isNotEmpty) {
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: Processing ${tableOrders.length} orders for table ${widget.table.name}');
        }
        
        // Fetch menu items to get details for order items
        List<Map<String, dynamic>> menuItems = [];
        Map<String, Map<String, dynamic>> menuItemsMap = <String, Map<String, dynamic>>{};
        
        try {
          if (!mounted) {
            if (EnvConfig.isDebugMode) {
              print('🪑 ORDER TAKING: Widget no longer mounted, skipping menu items loading');
            }
            return;
          }
          
          menuItems = await container.read(waiter_order.menuItemsProvider(null).future);
          
          if (!mounted) {
            if (EnvConfig.isDebugMode) {
              print('🪑 ORDER TAKING: Widget no longer mounted after menu items loaded');
            }
            return;
          }
          
          for (final menuItem in menuItems) {
            // Use itemId if available, otherwise fall back to id
            final key = menuItem['itemId']?.toString() ?? menuItem['id'].toString();
            menuItemsMap[key] = menuItem;
          }
          
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Menu items map created with ${menuItemsMap.length} items');
          }
        } catch (e) {
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Failed to load menu items: $e');
            print('🪑 ORDER TAKING: Will use fallback data for order items');
          }
        }
        
        // Check if widget is still mounted before calling setState
        if (!mounted) {
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Widget no longer mounted, skipping setState');
          }
          return;
        }
        
        setState(() {
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Inside setState...');
          }
          
          // Clear existing cart items
          _cartItems.clear();
          
          // Process each order and merge items
          for (int orderIndex = 0; orderIndex < tableOrders.length; orderIndex++) {
            final order = tableOrders[orderIndex];
            
            if (EnvConfig.isDebugMode) {
              print('🪑 ORDER TAKING: Processing order ${orderIndex + 1}/${tableOrders.length}: ${order['id']}');
            }
            
            // Handle both old and new response formats
            final customerData = order['customer'] ?? order['customerData'];
            if (orderIndex == 0) {
              // Use customer data from first order
              _customerName = customerData?['name'] ?? _customerName;
              _customerNotes = order['notes'] ?? _customerNotes;
              _customerNameEditable = false;
            }
            
            // Get items from this order
            final items = order['items'] as List? ?? 
                         order['orderItems'] as List? ?? 
                         order['order_items'] as List?;
                       
            if (EnvConfig.isDebugMode) {
              print('🪑 ORDER TAKING: Order ${order['id']} has ${items?.length ?? 0} items');
            }
            
            if (items != null) {
              for (final item in items) {
                if (EnvConfig.isDebugMode) {
                  print('🪑 ORDER TAKING: Processing item from order ${order['id']}: $item');
                }
                
                // Order items reference menu items by ID
                final itemId = item['id']?.toString() ?? item['itemId']?.toString() ?? item['menuItemId']?.toString() ?? '';
                final quantity = (item['quantity'] ?? 1) as int;
                final unitPrice = (item['price'] ?? item['unitPrice'] ?? 0).toDouble();
                
                if (EnvConfig.isDebugMode) {
                  print('🪑 ORDER TAKING: Item ID: $itemId, Quantity: $quantity, Price: $unitPrice');
                }
                
                // Get menu item details
                final menuItem = menuItemsMap[itemId];
                final name = menuItem?['name'] ?? item['name'] ?? item['itemName'] ?? 'Item #$itemId';
                final price = menuItem?['price']?.toDouble() ?? unitPrice;
                
                if (EnvConfig.isDebugMode) {
                  print('🪑 ORDER TAKING: Menu item found: ${menuItem != null}, Name: $name, Price: $price');
                }
                
                // Check if item already exists in cart and merge quantities
                final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == itemId);
                if (existingIndex >= 0) {
                  // Merge quantities
                  final existingItem = _cartItems[existingIndex];
                  _cartItems[existingIndex] = existingItem.copyWith(
                    quantity: existingItem.quantity + quantity,
                  );
                  if (EnvConfig.isDebugMode) {
                    print('🪑 ORDER TAKING: Merged item ${name}, new quantity: ${_cartItems[existingIndex].quantity}');
                  }
                } else {
                  // Add new item
                  _cartItems.add(CartItem(
                    id: itemId,
                    name: name,
                    price: price,
                    quantity: quantity,
                    imageUrl: menuItem?['imageUrl'] ?? item['imageUrl'],
                    category: menuItem?['category']?.toString() ?? item['category'],
                  ));
                  if (EnvConfig.isDebugMode) {
                    print('🪑 ORDER TAKING: Added new item: ${name} x${quantity}');
                  }
                }
              }
            }
          }
          
          if (EnvConfig.isDebugMode) {
            print('🪑 ORDER TAKING: Final cart has ${_cartItems.length} unique items');
            for (int i = 0; i < _cartItems.length; i++) {
              final item = _cartItems[i];
              print('🪑 ORDER TAKING: Cart item ${i + 1}: ${item.name} x${item.quantity} @\$${item.price}');
            }
          }
        });
      } else {
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: No orders found for table, starting fresh order');
        }
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: Error loading orders: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('OrderTakingScreen build called. Cart items:  [32m [1m [4m [3m [7m$_cartItems [0m');
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Order - Table ${widget.table.name}'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: const [
          ThemeToggleButton(),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Table info header
          _buildTableInfo(),
          
          // Load existing orders if table is occupied (Flutter convention)
          if (widget.table.status == waiter_table.TableStatus.occupied && 
              widget.table.currentOrderId != null && !_isPrefilled)
            FutureBuilder<List<Map<String, dynamic>>>(
              future: ref.read(waiter_order.tableOrdersProvider(widget.table.id).future),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty && !_isPrefilled) {
                  final latestOrder = snapshot.data!.first;
                  if (EnvConfig.isDebugMode) {
                    print('🪑 ORDER TAKING: Processing existing order ${latestOrder['id']}');
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_isPrefilled) {
                      _processExistingOrder(latestOrder);
                    }
                  });
                }
                return const SizedBox.shrink();
              },
            ),
          
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
            controller: TextEditingController(text: _customerNotes),
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
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (isAvailable) ...[
                  ElevatedButton.icon(
                    onPressed: () => _addToCartFromMap(item),
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

  Widget _buildMenuItemCardFromPos(MenuItem item) {
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
                    onPressed: () => _addToCartFromPosItem(item),
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

  void _addToCartFromPosItem(MenuItem item) {
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
          imageUrl: item.image,
          category: item.categoryId.toString(),
        ));
      });
    }
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
              onPressed: _isSubmitting ? null : () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
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
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _cartItems.isEmpty ? null : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SplitBillingScreen(
                      table: widget.table,
                      cartItems: List<CartItem>.from(_cartItems),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.call_split),
              label: const Text('Split Bill'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
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

  void _addToCartFromMap(Map<String, dynamic> item) {
    // Use the menu item ID that the backend expects
    final menuItemId = item['id']?.toString() ?? '';
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == menuItemId);
    
    if (existingIndex >= 0) {
      setState(() {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + 1,
        );
      });
    } else {
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
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: Submitting order for table ${widget.table.name}');
        print('🪑 ORDER TAKING: Cart items: ${_cartItems.length}');
      }
      
      // Check if there's an existing order for this table
      final container = ProviderScope.containerOf(context, listen: false);
      final tableOrders = await container.read(waiter_order.tableOrdersProvider(widget.table.id).future);
      
      if (tableOrders.isNotEmpty && widget.prefillOrder != null) {
        // Add items to existing order
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: Adding items to existing order ${widget.prefillOrder!['id']}');
        }
        
        final result = await ref.read(waiter_order.addItemsToOrderProvider((
          orderId: widget.prefillOrder!['id'].toString(),
          items: _cartItems,
        )).future);
        
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: Items added to existing order successfully!');
          print('🪑 ORDER TAKING: Result: $result');
        }
      } else {
        // Create new order
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: Creating new order for table ${widget.table.name}');
        }
        
        final result = await ref.read(waiter_order.submitTableOrderProvider((
          tableId: widget.table.id,
          customerName: _customerName.isNotEmpty ? _customerName : 'Guest',
          customerNotes: _customerNotes,
          items: _cartItems,
          subtotal: _getSubtotal(),
          tax: _getTax(),
          total: _getTotal(),
        )).future);

        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: New order created successfully!');
          print('🪑 ORDER TAKING: Result: $result');
        }
      }

      // Reset loading state
      setState(() {
        _isSubmitting = false;
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
      Navigator.of(context).pop();
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🪑 ORDER TAKING: Error submitting order: $e');
      }
      
      // Check if widget is still mounted before showing error
      if (!mounted) {
        if (EnvConfig.isDebugMode) {
          print('🪑 ORDER TAKING: Widget no longer mounted, skipping error display');
        }
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
} 