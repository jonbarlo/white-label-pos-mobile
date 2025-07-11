import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/cart_item.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/sale.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/menu_item.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/split_payment.dart';
import 'package:white_label_pos_mobile/src/features/pos/pos_provider.dart';
import 'package:white_label_pos_mobile/src/features/pos/customer_selection_dialog.dart';
import 'package:white_label_pos_mobile/src/features/pos/split_payment_dialog.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/core/config/env_config.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/theme_toggle_button.dart';

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
  String _selectedCategory = 'all';
  bool _isSearching = false;

  // Mock categories for better UX
  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'name': 'All', 'icon': Icons.all_inclusive},
    {'id': 'appetizers', 'name': 'Appetizers', 'icon': Icons.restaurant_menu},
    {'id': 'main', 'name': 'Main Course', 'icon': Icons.dinner_dining},
    {'id': 'desserts', 'name': 'Desserts', 'icon': Icons.cake},
    {'id': 'drinks', 'name': 'Drinks', 'icon': Icons.local_drink},
  ];

  // No hardcoded items - only real data from backend

  @override
  void initState() {
    super.initState();
    // Check if user can access reports to determine tab count
    final authState = ref.read(authNotifierProvider);
    final userRole = authState.user?.role;
    final canSeeReportsTab = userRole == UserRole.admin || userRole == UserRole.manager;
    _tabController = TabController(length: canSeeReportsTab ? 2 : 1, vsync: this);
    
    // Load recent sales after the widget is built (only if user can access reports)
    if (canSeeReportsTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadRecentSales();
      });
    }
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
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    
    if (query.isNotEmpty) {
      ref.read(searchNotifierProvider.notifier).searchItems(query);
    } else {
      ref.read(searchNotifierProvider.notifier).clearSearch();
    }
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _isSearching = false;
    });
    ref.read(searchNotifierProvider.notifier).clearSearch();
  }

  void _addToCart(CartItem item) {
    ref.read(cartNotifierProvider.notifier).addItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('${item.name} added to cart'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
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
        const SnackBar(
          content: Text('Cart is empty'),
          backgroundColor: Colors.orange,
        ),
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
        onCompleteSplitSale: _completeSplitSale,
        userId: ref.read(authNotifierProvider).user?.id ?? 1,
      ),
    );
  }

  Future<void> _completeSale(String customerName, String customerEmail) async {
    print('🛒 MAIN: _completeSale called');
    print('🛒 MAIN: Customer name: $customerName');
    print('🛒 MAIN: Customer email: $customerEmail');
    print('🛒 MAIN: Payment method: ${_selectedPaymentMethod.name}');
    
    try {
      print('🛒 MAIN: Calling createSaleProvider...');
      await ref.read(createSaleProvider(_selectedPaymentMethod, customerName: customerName, customerEmail: customerEmail).future);
      print('🛒 MAIN: Sale completed successfully!');
      
      // Refresh sales summary/report
      print('🛒 MAIN: Refreshing sales summary...');
      ref.refresh(salesSummaryProvider(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()));
      
      // Switch to Recent Sales tab if user can access reports
      final authState = ref.read(authNotifierProvider);
      final userRole = authState.user?.role;
      final canSeeReportsTab = userRole == UserRole.admin || userRole == UserRole.manager;
      if (mounted && canSeeReportsTab) {
        print('🛒 MAIN: Switching to Recent Sales tab...');
        _tabController.animateTo(1);
      }
      
      setState(() {
        _selectedPaymentMethod = PaymentMethod.cash;
      });
      
      Navigator.of(context).pop(); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Sale completed successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('🛒 MAIN: EXCEPTION in _completeSale: $e');
      print('🛒 MAIN: Exception type: ${e.runtimeType}');
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _completeSplitSale(SplitSaleRequest request) async {
    print('💳 MAIN: _completeSplitSale called');
    print('💳 MAIN: User ID: ${request.userId}');
    print('💳 MAIN: Total amount: ${request.totalAmount}');
    print('💳 MAIN: Payments count: ${request.payments.length}');
    print('💳 MAIN: Customer name: ${request.customerName}');
    print('💳 MAIN: Customer email: ${request.customerEmail}');
    
    try {
      print('💳 MAIN: Calling createSplitSaleProvider...');
      await ref.read(createSplitSaleProvider(request).future);
      print('💳 MAIN: Split sale completed successfully!');
      
      // Refresh sales summary/report
      print('💳 MAIN: Refreshing sales summary...');
      ref.refresh(salesSummaryProvider(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()));
      
      // Switch to Recent Sales tab if user can access reports
      final authState = ref.read(authNotifierProvider);
      final userRole = authState.user?.role;
      final canSeeReportsTab = userRole == UserRole.admin || userRole == UserRole.manager;
      if (mounted && canSeeReportsTab) {
        print('💳 MAIN: Switching to Recent Sales tab...');
        _tabController.animateTo(1);
      }
      
      Navigator.of(context).pop(); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Split payment completed successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('💳 MAIN: EXCEPTION in _completeSplitSale: $e');
      print('💳 MAIN: Exception type: ${e.runtimeType}');
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
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
    final menuItemsAsync = ref.watch(menuItemsProvider);
    final authState = ref.watch(authNotifierProvider);
    final userRole = authState.user?.role;
    final canSeeReportsTab = userRole == UserRole.admin || userRole == UserRole.manager;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
        actions: const [
          ThemeToggleButton(),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(
              icon: Icon(Icons.point_of_sale),
              text: 'Sales',
            ),
            if (canSeeReportsTab)
              const Tab(
                icon: Icon(Icons.history),
                text: 'Recent Sales',
              ),
          ],
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          menuItemsAsync.when(
            data: (menuItems) {
              print('🍽️ UI: Received ${menuItems.length} menu items from provider');
              for (int i = 0; i < menuItems.length; i++) {
                final item = menuItems[i];
                print('🍽️ UI: Item $i: ${item.id} - ${item.name} - \$${item.price}');
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive: if width < 700, stack vertically
                  final isWide = constraints.maxWidth >= 700;
                  return isWide
                      ? Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _SalesTab(
                                cart: cart,
                                cartTotal: cartTotal,
                                searchResults: searchResults,
                                searchController: _searchController,
                                onSearchChanged: _onSearchChanged,
                                onAddToCart: _addToCart,
                                onRemoveFromCart: _removeFromCart,
                                onUpdateQuantity: _updateQuantity,
                                onCheckout: _showCheckoutDialog,
                                categories: _categories,
                                selectedCategory: _selectedCategory,
                                onCategorySelected: _onCategorySelected,
                                                            popularItems: menuItems,
                            isSearching: _isSearching,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _CartSection(
                            cart: cart,
                            cartTotal: cartTotal,
                            onRemoveFromCart: _removeFromCart,
                            onUpdateQuantity: _updateQuantity,
                            onCheckout: _showCheckoutDialog,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _SalesTab(
                            cart: cart,
                            cartTotal: cartTotal,
                            searchResults: searchResults,
                            searchController: _searchController,
                            onSearchChanged: _onSearchChanged,
                            onAddToCart: _addToCart,
                            onRemoveFromCart: _removeFromCart,
                            onUpdateQuantity: _updateQuantity,
                            onCheckout: _showCheckoutDialog,
                            categories: _categories,
                            selectedCategory: _selectedCategory,
                            onCategorySelected: _onCategorySelected,
                            popularItems: menuItems,
                                isSearching: _isSearching,
                              ),
                            ),
                            Divider(height: 1),
                            SizedBox(
                              height: 320,
                              child: _CartSection(
                                cart: cart,
                                cartTotal: cartTotal,
                                onRemoveFromCart: _removeFromCart,
                                onUpdateQuantity: _updateQuantity,
                                onCheckout: _showCheckoutDialog,
                              ),
                            ),
                          ],
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
                  Text('Loading menu items...'),
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
                    'Error loading menu items',
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
                      ref.invalidate(menuItemsProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          if (canSeeReportsTab) _RecentSalesTab(sales: recentSales),
        ],
      ),
    );
  }
}

class _SalesTab extends StatelessWidget {
  final List<CartItem> cart;
  final double cartTotal;
  final List<MenuItem> searchResults;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function(CartItem) onAddToCart;
  final Function(String) onRemoveFromCart;
  final Function(String, int) onUpdateQuantity;
  final VoidCallback onCheckout;
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final List<MenuItem> popularItems;
  final bool isSearching;

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
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.popularItems,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return _MenuSection(
      searchController: searchController,
      onSearchChanged: onSearchChanged,
      categories: categories,
      selectedCategory: selectedCategory,
      onCategorySelected: onCategorySelected,
      isSearching: isSearching,
      searchResults: searchResults,
      popularItems: popularItems,
      onAddToCart: onAddToCart,
    );
  }
}

class _MenuSection extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool isSearching;
  final List<MenuItem> searchResults;
  final List<MenuItem> popularItems;
  final Function(CartItem) onAddToCart;

  const _MenuSection({
    required this.searchController,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.isSearching,
    required this.searchResults,
    required this.popularItems,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search menu items...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        // Categories
        if (!isSearching) ...[
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _CategoryChip(
                    category: category,
                    isSelected: isSelected,
                    onTap: () => onCategorySelected(category['id']),
                  ),
                );
              },
            ),
          ),
        ],
        // Items Grid
        Expanded(
          child: isSearching
              ? _buildSearchResults()
              : _buildPopularItems(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Try a different search term',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final item = searchResults[index];
        return _MenuItemCard(
          item: item,
          onAddToCart: onAddToCart,
        );
      },
    );
  }

  Widget _buildPopularItems() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: popularItems.length,
      itemBuilder: (context, index) {
        final item = popularItems[index];
        return _MenuItemCard(
          item: item,
          onAddToCart: onAddToCart,
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category['icon'],
              size: 16,
              color: isSelected 
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              category['name'],
              style: TextStyle(
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final Function(CartItem) onAddToCart;

  const _MenuItemCard({
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onAddToCart(CartItem(
          id: item.id.toString(),
          name: item.name,
          price: item.price,
          quantity: 1,
          imageUrl: item.image,
          category: item.categoryId.toString(),
        )),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item image placeholder (fixed height)
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 32,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              // Item name
              Text(
                item.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Item description
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              // Price and add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onAddToCart(CartItem(
                      id: item.id.toString(),
                      name: item.name,
                      price: item.price,
                      quantity: 1,
                      imageUrl: item.image,
                      category: item.categoryId.toString(),
                    )),
                    icon: Icon(
                      Icons.add_circle,
                      color: theme.colorScheme.primary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(color: theme.dividerColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cart header
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${cart.length} items',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
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
                          size: 80,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items to get started',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
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
          
          // Cart total and checkout
          if (cart.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Column(
                children: [
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${cartTotal.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Checkout button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onCheckout,
                      style: AppTheme.neutralButtonStyle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment),
                          const SizedBox(width: 8),
                          Text(
                            'Checkout',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Item image placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.restaurant,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)} each',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity controls
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (item.quantity > 1) {
                      onUpdateQuantity(item.id, item.quantity - 1);
                    } else {
                      onRemove(item.id);
                    }
                  },
                  icon: Icon(
                    item.quantity > 1 ? Icons.remove : Icons.delete,
                    size: 20,
                    color: item.quantity > 1 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.error,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    minimumSize: const Size(32, 32),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${item.quantity}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => onUpdateQuantity(item.id, item.quantity + 1),
                  icon: Icon(
                    Icons.add,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    minimumSize: const Size(32, 32),
                  ),
                ),
              ],
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
    final theme = Theme.of(context);
    
    if (sales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No recent sales',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sales will appear here after checkout',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.receipt,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              sale.receiptNumber ?? 'Sale #${sale.id}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sale.customerName != null) ...[
                  Text(
                    'Customer: ${sale.customerName}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                Text(
                  '${sale.items?.length ?? 0} items • ${sale.paymentMethod.name}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  sale.createdAt.toString().substring(0, 16),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            trailing: Text(
              '\$${sale.total.toStringAsFixed(2)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckoutDialog extends StatefulWidget {
  final List<CartItem> cart;
  final double total;
  final PaymentMethod selectedPaymentMethod;
  final Function(PaymentMethod) onPaymentMethodChanged;
  final Function(String customerName, String customerEmail) onCompleteSale;
  final Function(SplitSaleRequest) onCompleteSplitSale;
  final int userId;

  const _CheckoutDialog({
    required this.cart,
    required this.total,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.onCompleteSale,
    required this.onCompleteSplitSale,
    required this.userId,
  });

  @override
  State<_CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<_CheckoutDialog> {
  late PaymentMethod _selectedMethod;
  String? _selectedCustomerName;
  String? _selectedCustomerEmail;
  int? _selectedCustomerId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedPaymentMethod;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMethodChanged(PaymentMethod method) {
    setState(() {
      _selectedMethod = method;
    });
    widget.onPaymentMethodChanged(method);
  }

  Future<void> _selectCustomer() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomerSelectionDialog(
        initialCustomerName: _selectedCustomerName,
        initialCustomerEmail: _selectedCustomerEmail,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedCustomerId = result['customerId'];
        _selectedCustomerName = result['customerName'];
        _selectedCustomerEmail = result['customerEmail'];
      });
    }
  }

  void _completeSale() {
    print('🛒 UI: _completeSale called');
    print('🛒 UI: Selected customer name: $_selectedCustomerName');
    print('🛒 UI: Selected customer email: $_selectedCustomerEmail');
    print('🛒 UI: Selected payment method: ${_selectedMethod?.name}');
    print('🛒 UI: Cart items count: ${widget.cart.length}');
    for (int i = 0; i < widget.cart.length; i++) {
      final item = widget.cart[i];
      print('🛒 UI: Cart item $i: ${item.quantity}x ${item.name} - \$${item.total}');
    }
    
    if (_selectedCustomerName == null || _selectedCustomerName!.isEmpty) {
      print('🛒 UI: ERROR - No customer selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a customer or enter customer information'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('🛒 UI: Setting loading state to true');
    setState(() {
      _isLoading = true;
    });

    print('🛒 UI: Calling widget.onCompleteSale...');
    widget.onCompleteSale(_selectedCustomerName!, _selectedCustomerEmail ?? '');
  }

  void _showSplitPaymentDialog() {
    if (EnvConfig.isDebugMode) {
      print('💳 SPLIT PAYMENT: Opening split payment dialog');
      print('💳 SPLIT PAYMENT: User ID: ${widget.userId}');
      print('💳 SPLIT PAYMENT: Total amount: ${widget.total}');
      print('💳 SPLIT PAYMENT: Cart items: ${widget.cart.length}');
    }
    
    showDialog(
      context: context,
      builder: (context) => SplitPaymentDialog(
        totalAmount: widget.total,
        cartItems: widget.cart,
        userId: widget.userId,
      ),
    ).then((result) {
      if (result != null && result is SplitSaleRequest) {
        if (EnvConfig.isDebugMode) {
          print('💳 SPLIT PAYMENT: Split payment request received');
        }
        widget.onCompleteSplitSale(result);
      } else {
        if (EnvConfig.isDebugMode) {
          print('💳 SPLIT PAYMENT: No valid result received: $result');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.payment, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Complete Sale'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary
            Text(
              'Order Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Items list
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final item = widget.cart[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.name}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          '\$${item.total.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${widget.total.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Customer Information
            Text(
              'Customer Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Customer Selection Button
            OutlinedButton.icon(
              onPressed: _selectCustomer,
              icon: Icon(_selectedCustomerName != null ? Icons.person : Icons.person_add, 
                        color: _selectedCustomerName != null ? Colors.green : Colors.orange),
              label: Text(_selectedCustomerName != null 
                ? 'Customer: $_selectedCustomerName' 
                : 'Select Customer (Required)'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: BorderSide(
                  color: _selectedCustomerName != null ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
            ),
            if (_selectedCustomerName != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $_selectedCustomerName',
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (_selectedCustomerEmail != null && _selectedCustomerEmail!.isNotEmpty)
                      Text(
                        'Email: $_selectedCustomerEmail',
                        style: theme.textTheme.bodyMedium,
                      ),
                    if (_selectedCustomerId != null)
                      Text(
                        'Customer ID: $_selectedCustomerId',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            // Payment method
            Text(
              'Payment Method',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: PaymentMethod.values.map((method) {
                final isSelected = _selectedMethod == method;
                return ChoiceChip(
                  label: Text(method.name.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _onMethodChanged(method);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _showSplitPaymentDialog,
          icon: const Icon(Icons.account_balance_wallet),
          label: const Text('Split Payment'),
          style: AppTheme.neutralButtonStyle,
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _completeSale,
          style: AppTheme.neutralButtonStyle,
          child: _isLoading 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text('Complete Sale'),
        ),
      ],
    );
  }
} 