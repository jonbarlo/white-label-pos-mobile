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
import '../../core/theme/app_theme.dart';

import '../../shared/widgets/app_image.dart';
import '../../core/services/navigation_service.dart';


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
  int _currentOrderNumber = 14; // Mock order number

  // Square-style categories with colors and icons
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'all',
      'name': 'All',
      'icon': Icons.all_inclusive,
      'color': Colors.grey,
      'itemCount': 0
    },
    {
      'id': 'burgers',
      'name': 'Burgers',
      'icon': Icons.lunch_dining,
      'color': Colors.orange,
      'itemCount': 9
    },
    {
      'id': 'sides',
      'name': 'Sides',
      'icon': Icons.fastfood,
      'color': Colors.orange.shade300,
      'itemCount': 4
    },
    {
      'id': 'salads',
      'name': 'Salads',
      'icon': Icons.eco,
      'color': Colors.red.shade700,
      'itemCount': 3
    },
    {
      'id': 'drinks',
      'name': 'Wine & Beer',
      'icon': Icons.local_bar,
      'color': Colors.red.shade800,
      'itemCount': 5
    },
    {
      'id': 'beverages',
      'name': 'Drinks',
      'icon': Icons.local_drink,
      'color': Colors.blue,
      'itemCount': 6
    },
    {
      'id': 'desserts',
      'name': 'Desserts',
      'icon': Icons.cake,
      'color': Colors.pink,
      'itemCount': 3
    },
  ];

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
    try {
      await ref.read(createSaleProvider(_selectedPaymentMethod, customerName: customerName, customerEmail: customerEmail).future);
      
      // Refresh sales summary/report
      ref.invalidate(salesSummaryProvider(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()));
      
      // Switch to Recent Sales tab if user can access reports
      final authState = ref.read(authNotifierProvider);
      final userRole = authState.user?.role;
      final canSeeReportsTab = userRole == UserRole.admin || userRole == UserRole.manager;
      if (mounted && canSeeReportsTab) {
        _tabController.animateTo(1);
      }
      
      setState(() {
        _selectedPaymentMethod = PaymentMethod.cash;
        _currentOrderNumber++; // Increment order number
      });
      
      // Close dialog safely
      if (mounted) {
        NavigationService.goBack(context);
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
      }
    } catch (e) {
      if (mounted) {
        NavigationService.goBack(context);
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
    try {
      await ref.read(createSplitSaleProvider(request).future);
      
      // Refresh sales summary/report
      ref.invalidate(salesSummaryProvider(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()));
      
      // Switch to Recent Sales tab if user can access reports
      final authState = ref.read(authNotifierProvider);
      final userRole = authState.user?.role;
      final canSeeReportsTab = userRole == UserRole.admin || userRole == UserRole.manager;
      if (mounted && canSeeReportsTab) {
        _tabController.animateTo(1);
      }
      
      setState(() {
        _currentOrderNumber++; // Increment order number
      });
      
      // Close dialog safely
      if (mounted) {
        NavigationService.goBack(context);
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
      }
    } catch (e) {
      if (mounted) {
        NavigationService.goBack(context);
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

    // Debug: Print auth state to help identify issues
    print('🔍 POS Screen Build - Auth State: ${authState.status}');
    print('🔍 POS Screen Build - User: ${authState.user?.id}');
    print('🔍 POS Screen Build - Business: ${authState.business?.id}');
    print('🔍 POS Screen Build - Menu Items Async: ${menuItemsAsync.toString()}');

    // Handle error states gracefully
    if (authState.status == AuthStatus.unauthenticated) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Authentication Error', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Please log in again'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Top Bar - Square style
          _buildTopBar(),
          
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Panel - Menu Items
                Expanded(
                  flex: 3,
                  child: _buildLeftPanel(
                    menuItemsAsync: menuItemsAsync,
                    searchResults: searchResults,
                    searchController: _searchController,
                    onSearchChanged: _onSearchChanged,
                    onAddToCart: _addToCart,
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _onCategorySelected,
                    isSearching: _isSearching,
                  ),
                ),
                
                // Right Panel - Order Summary
                Expanded(
                  flex: 1,
                  child: _buildRightPanel(
                    cart: cart,
                    cartTotal: cartTotal,
                    onRemoveFromCart: _removeFromCart,
                    onUpdateQuantity: _updateQuantity,
                    onCheckout: _showCheckoutDialog,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation - Square style
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side
          Row(
            children: [
              Text(
                'Lunch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  // Search functionality
                },
                icon: Icon(Icons.search, color: Colors.grey.shade600),
                tooltip: 'Search',
              ),
              IconButton(
                onPressed: () {
                  // History functionality
                },
                icon: Icon(Icons.history, color: Colors.grey.shade600),
                tooltip: 'History',
              ),
            ],
          ),
          
          const Spacer(),
          
          // Right side
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '#$_currentOrderNumber',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  // New order functionality
                  ref.read(cartNotifierProvider.notifier).clearCart();
                  setState(() {
                    _currentOrderNumber++;
                  });
                },
                icon: Icon(Icons.add, color: Colors.grey.shade600),
                tooltip: 'New Order',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel({
    required AsyncValue<List<MenuItem>> menuItemsAsync,
    required List<MenuItem> searchResults,
    required TextEditingController searchController,
    required Function(String) onSearchChanged,
    required Function(CartItem) onAddToCart,
    required List<Map<String, dynamic>> categories,
    required String selectedCategory,
    required Function(String) onCategorySelected,
    required bool isSearching,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
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
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          // Categories
          if (!isSearching) ...[
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _CategoryButton(
                      category: category,
                      isSelected: isSelected,
                      onTap: () => onCategorySelected(category['id']),
                    ),
                  );
                },
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: '% Discounts',
                      icon: Icons.discount,
                      color: Colors.green,
                      onTap: () {
                        // Discount functionality
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Scan',
                      icon: Icons.qr_code_scanner,
                      color: Colors.orange,
                      onTap: () {
                        // Scan functionality
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Menu items grid
          Expanded(
            child: menuItemsAsync.when(
              data: (menuItems) {
                final itemsToShow = isSearching ? searchResults : menuItems;
                
                if (isSearching && searchResults.isEmpty) {
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
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: itemsToShow.length,
                  itemBuilder: (context, index) {
                    final item = itemsToShow[index];
                    return _MenuItemCard(
                      item: item,
                      onAddToCart: onAddToCart,
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
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel({
    required List<CartItem> cart,
    required double cartTotal,
    required Function(String) onRemoveFromCart,
    required Function(String, int) onUpdateQuantity,
    required VoidCallback onCheckout,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Tabs
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: 'Check',
                    isSelected: true,
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: 'Actions',
                    isSelected: false,
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: 'Guest',
                    isSelected: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          
          // Order items
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items to get started',
                          style: TextStyle(
                            color: Colors.grey.shade500,
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
                      return _OrderItemTile(
                        item: item,
                        onRemove: onRemoveFromCart,
                        onUpdateQuantity: onUpdateQuantity,
                      );
                    },
                  ),
          ),
          
          // Totals and Pay button
          if (cart.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Totals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '\$${cartTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
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
                        'Tax:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '\$${(cartTotal * 0.095).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        '\$${(cartTotal * 1.095).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Pay button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('PAY'),
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

  Widget _buildBottomNavigation() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.person,
            label: 'LN',
            onTap: () {
              // Profile/logout functionality
            },
          ),
          _BottomNavItem(
            icon: Icons.menu,
            label: 'Menu',
            onTap: () {
              // Menu functionality
            },
          ),
          _BottomNavItem(
            icon: Icons.receipt_long,
            label: 'Orders',
            badge: '2',
            onTap: () {
              // Orders functionality
            },
          ),
          _BottomNavItem(
            icon: Icons.swap_horiz,
            label: 'Transactions',
            onTap: () {
              // Transactions functionality
            },
          ),
          _BottomNavItem(
            icon: Icons.local_offer,
            label: 'Items',
            onTap: () {
              // Items functionality
            },
          ),
          _BottomNavItem(
            icon: Icons.more_horiz,
            label: 'More',
            onTap: () {
              // More functionality
            },
          ),
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
                color: Colors.black.withValues(alpha: 0.1),
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
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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
        childAspectRatio: 0.85, // Better aspect ratio for image-focused cards
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
    print('Building popular items grid with ${popularItems.length} items');
    for (final item in popularItems.take(3)) {
      print('  Popular item: ${item.name} - image: ${item.image}');
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85, // Better aspect ratio for image-focused cards
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
              : Theme.of(context).colorScheme.surfaceContainerHighest,
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image with better styling
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AppImage(
                    imageUrl: item.image,
                    fit: BoxFit.cover,
                    placeholder: _buildImagePlaceholder(theme, item),
                    errorWidget: _buildImagePlaceholder(theme, item),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
            // Item details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item name
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Item description
                    if (item.description.isNotEmpty) ...[
                      Expanded(
                        child: Text(
                          item.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                            fontSize: 16,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => onAddToCart(CartItem(
                            id: item.id.toString(),
                            name: item.name,
                            price: item.price,
                            quantity: 1,
                            imageUrl: item.image,
                            category: item.categoryId.toString(),
                          )),
                          icon: const Icon(Icons.add_circle, size: 18),
                          label: const Text('Add', style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: const Size(80, 36),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme, MenuItem item) {
    // Create a subtle placeholder with category-based styling
    final colors = _getCategoryColors(item.categoryId);
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[0].withValues(alpha: 0.3),
            colors[1].withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(item.categoryId),
              size: 24,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 4),
            Text(
              item.name,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCategoryColors(int categoryId) {
    // Define subtle colors for different categories
    switch (categoryId) {
      case 1: // Appetizers
        return [Colors.orange.shade200, Colors.orange.shade300];
      case 2: // Main Course
        return [Colors.red.shade200, Colors.red.shade300];
      case 3: // Desserts
        return [Colors.pink.shade200, Colors.pink.shade300];
      case 4: // Drinks
        return [Colors.blue.shade200, Colors.blue.shade300];
      default:
        return [Colors.grey.shade200, Colors.grey.shade300];
    }
  }

  IconData _getCategoryIcon(int categoryId) {
    // Define icons for different categories
    switch (categoryId) {
      case 1: // Appetizers
        return Icons.restaurant_menu;
      case 2: // Main Course
        return Icons.dinner_dining;
      case 3: // Desserts
        return Icons.cake;
      case 4: // Drinks
        return Icons.local_drink;
      default:
        return Icons.restaurant;
    }
  }
}

class _CategoryButton extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = category['color'] as Color;
    final itemCount = category['itemCount'] as int;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'],
              size: 24,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(height: 4),
            Text(
              category['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
            ),
            if (itemCount > 0) ...[
              const SizedBox(height: 2),
              Text(
                '($itemCount)',
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white.withValues(alpha: 0.8) : color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue.shade600 : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final CartItem item;
  final Function(String) onRemove;
  final Function(String, int) onUpdateQuantity;

  const _OrderItemTile({
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Item image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade200,
                ),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: AppImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: Icon(Icons.restaurant, color: Colors.grey.shade400),
                          errorWidget: Icon(Icons.restaurant, color: Colors.grey.shade400),
                        ),
                      )
                    : Icon(Icons.restaurant, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 12),
              
              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${item.price.toStringAsFixed(2)} each',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
                      size: 16,
                      color: item.quantity > 1 
                          ? Colors.blue.shade600 
                          : Colors.red.shade600,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      minimumSize: const Size(28, 28),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: () => onUpdateQuantity(item.id, item.quantity + 1),
                    icon: Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      minimumSize: const Size(28, 28),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Item total
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.grey.shade600,
              ),
              if (badge != null)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
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
            color: Colors.black.withValues(alpha: 0.1),
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
                    child: ElevatedButton.icon(
                      onPressed: onCheckout,
                      icon: const Icon(Icons.shopping_cart_checkout, size: 20),
                      label: const Text('Checkout', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
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
            // Item image
            AppThumbnail(
              imageUrl: item.imageUrl,
              size: 50,
              borderRadius: 8,
              fallbackIcon: Icons.restaurant,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
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
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
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
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
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
  PaymentMethod _selectedMethod;
  String? _selectedCustomerId;
  String? _selectedCustomerName;
  String? _selectedCustomerEmail;
  bool _isLoading = false;
  bool _dialogClosed = false; // Add flag to prevent multiple closes

  _CheckoutDialogState() : _selectedMethod = PaymentMethod.cash;

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

  void _completeSale() async {
    if (_selectedCustomerName == null || _selectedCustomerName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a customer or enter customer information'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_dialogClosed) return; // Prevent multiple calls

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onCompleteSale(_selectedCustomerName!, _selectedCustomerEmail ?? '');
      
      // Close dialog only once
      if (mounted && !_dialogClosed) {
        _dialogClosed = true;
        NavigationService.goBack(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSplitPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => SplitPaymentDialog(
        totalAmount: widget.total,
        cartItems: widget.cart,
        userId: widget.userId,
      ),
    ).then((result) {
      if (result != null && result is SplitSaleRequest) {
        widget.onCompleteSplitSale(result);
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
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
