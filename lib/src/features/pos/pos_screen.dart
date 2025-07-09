import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pos_provider.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load recent sales after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentSales();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadRecentSales() {
    ref.read(recentSalesNotifierProvider.notifier).loadRecentSales();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      ref.read(searchNotifierProvider.notifier).searchItems(query);
    } else {
      ref.read(searchNotifierProvider.notifier).clearSearch();
    }
  }

  void _addToCart(CartItem item) {
    ref.read(cartNotifierProvider.notifier).addItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeFromCart(String itemId) {
    ref.read(cartNotifierProvider.notifier).removeItem(itemId);
  }

  void _updateQuantity(String itemId, int quantity) {
    ref.read(cartNotifierProvider.notifier).updateItemQuantity(itemId, quantity);
  }

  void _showCheckoutDialog() {
    final cart = ref.read(cartNotifierProvider);
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _CheckoutDialog(
        cart: cart,
        total: ref.read(cartTotalProvider),
        selectedPaymentMethod: _selectedPaymentMethod,
        onPaymentMethodChanged: (method) {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
        onCompleteSale: _completeSale,
      ),
    );
  }

  Future<void> _completeSale() async {
    try {
      await ref.read(createSaleProvider(_selectedPaymentMethod).future);
      
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sale completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotifierProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final searchResults = ref.watch(searchNotifierProvider);
    final recentSales = ref.watch(recentSalesNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('POS'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sales'),
            Tab(text: 'Recent Sales'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SalesTab(
            cart: cart,
            cartTotal: cartTotal,
            searchResults: searchResults,
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onAddToCart: _addToCart,
            onRemoveFromCart: _removeFromCart,
            onUpdateQuantity: _updateQuantity,
            onCheckout: _showCheckoutDialog,
          ),
          _RecentSalesTab(sales: recentSales),
        ],
      ),
    );
  }
}

class _SalesTab extends StatelessWidget {
  final List<CartItem> cart;
  final double cartTotal;
  final List<CartItem> searchResults;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function(CartItem) onAddToCart;
  final Function(String) onRemoveFromCart;
  final Function(String, int) onUpdateQuantity;
  final VoidCallback onCheckout;

  const _SalesTab({
    required this.cart,
    required this.cartTotal,
    required this.searchResults,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onUpdateQuantity,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side - Search and Results
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              // Search results
              Expanded(
                child: searchResults.isEmpty
                    ? Center(
                        child: Text(
                          'Search for items to add to cart',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final item = searchResults[index];
                          return _SearchResultItem(
                            item: item,
                            onAddToCart: onAddToCart,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        // Right side - Cart
        Expanded(
          flex: 1,
          child: _CartSection(
            cart: cart,
            cartTotal: cartTotal,
            onRemoveFromCart: onRemoveFromCart,
            onUpdateQuantity: onUpdateQuantity,
            onCheckout: onCheckout,
          ),
        ),
      ],
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final CartItem item;
  final Function(CartItem) onAddToCart;

  const _SearchResultItem({
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(
          item.name,
          style: theme.textTheme.bodyLarge,
        ),
        subtitle: Text(
          '\$${item.price.toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart, color: theme.colorScheme.primary),
          onPressed: () => onAddToCart(item),
        ),
      ),
    );
  }
}

class _CartSection extends StatelessWidget {
  final List<CartItem> cart;
  final double cartTotal;
  final Function(String) onRemoveFromCart;
  final Function(String, int) onUpdateQuantity;
  final VoidCallback onCheckout;

  const _CartSection({
    required this.cart,
    required this.cartTotal,
    required this.onRemoveFromCart,
    required this.onUpdateQuantity,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        children: [
          // Cart header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    'Total: \$${cartTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Cart items
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items to get started',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _CartItemTile(
                        item: item,
                        onRemove: onRemoveFromCart,
                        onUpdateQuantity: onUpdateQuantity,
                      );
                    },
                  ),
          ),
          // Checkout button
          if (cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  child: Text(
                    'Checkout',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(String) onRemove;
  final Function(String, int) onUpdateQuantity;

  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('\$${item.price.toStringAsFixed(2)} each'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                if (item.quantity > 1) {
                  onUpdateQuantity(item.id, item.quantity - 1);
                } else {
                  onRemove(item.id);
                }
              },
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onUpdateQuantity(item.id, item.quantity + 1),
            ),
            Text(
              '\$${item.total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSalesTab extends StatelessWidget {
  final List<Sale> sales;

  const _RecentSalesTab({required this.sales});

  @override
  Widget build(BuildContext context) {
    if (sales.isEmpty) {
      return const Center(
        child: Text('No recent sales'),
      );
    }

    return ListView.builder(
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ListTile(
            title: Text('Sale #${sale.id}'),
            subtitle: Text(
              '${sale.itemCount} items • ${sale.paymentMethod.name}',
            ),
            trailing: Text(
              '\$${sale.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckoutDialog extends StatelessWidget {
  final List<CartItem> cart;
  final double total;
  final PaymentMethod selectedPaymentMethod;
  final Function(PaymentMethod) onPaymentMethodChanged;
  final VoidCallback onCompleteSale;

  const _CheckoutDialog({
    required this.cart,
    required this.total,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.onCompleteSale,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Complete Sale'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...PaymentMethod.values.map((method) => RadioListTile<PaymentMethod>(
                title: Text(method.name.toUpperCase()),
                value: method,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  if (value != null) {
                    onPaymentMethodChanged(value);
                  }
                },
              )),
          const SizedBox(height: 16),
          Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onCompleteSale,
          child: const Text('Complete Sale'),
        ),
      ],
    );
  }
} 