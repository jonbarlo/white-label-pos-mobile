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
import '../../shared/widgets/loading_indicator.dart';
import 'package:go_router/go_router.dart';

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
  String _selectedCategory = 'All';
  bool _isSearching = false;
  int _currentOrderNumber = DateTime.now().millisecondsSinceEpoch ~/ 1000 % 10000; // Dynamic order number based on timestamp
  String _selectedTab = 'Cart'; // Track selected tab for better UX
  
  // Table information for dynamic header
  String? _selectedTableNumber;
  String? _selectedTableWaitstaff;
  String _serviceType = 'POS Service'; // Default service type

  // Section management for bottom navigation
  String _currentSection = 'Menu'; // Menu, Orders, Transactions, Inventory

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
    print('🔍 DEBUG: _onSearchChanged called with query: "$query"');
    
    if (query.isNotEmpty) {
      print('🔍 DEBUG: Calling searchItems with query: "$query"');
      ref.read(searchNotifierProvider.notifier).searchItems(query);
    } else {
      print('🔍 DEBUG: Clearing search');
      ref.read(searchNotifierProvider.notifier).clearSearch();
    }
  }

  void _onCategorySelected(String categoryId) {
    print('🔍 DEBUG: _onCategorySelected called with categoryId: "$categoryId"');
    
    setState(() {
      _selectedCategory = categoryId;
      _isSearching = false;
    });
    
    print('🔍 DEBUG: _selectedCategory set to: "$_selectedCategory"');
    print('🔍 DEBUG: _isSearching set to: $_isSearching');
    
    // Clear search when selecting category
    _searchController.clear();
    ref.read(searchNotifierProvider.notifier).clearSearch();
    
    // Invalidate the items provider to refetch based on new category
    print('🔍 DEBUG: Invalidating itemsByCategoryProvider for category: "$_selectedCategory"');
    ref.invalidate(itemsByCategoryProvider(_selectedCategory));
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

  // Category information for colorful UI
  CategoryInfo _getCategoryInfo(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return CategoryInfo(
          color: const Color(0xFF6366F1), // Indigo
          icon: Icons.restaurant_menu,
        );
      case 'burgers':
        return CategoryInfo(
          color: const Color(0xFFEF4444), // Red
          icon: Icons.lunch_dining,
        );
      case 'sides':
        return CategoryInfo(
          color: const Color(0xFFEAB308), // Yellow/Orange
          icon: Icons.fastfood,
        );
      case 'wine & beer':
      case 'wine':
      case 'beer':
      case 'beverages':
      case 'drinks':
        return CategoryInfo(
          color: const Color(0xFF991B1B), // Dark red/wine
          icon: Icons.local_bar,
        );
      case 'salads':
        return CategoryInfo(
          color: const Color(0xFFDC2626), // Red
          icon: Icons.eco,
        );
      case 'desserts':
        return CategoryInfo(
          color: const Color(0xFFDB2777), // Pink
          icon: Icons.cake,
        );
      case 'pizza':
        return CategoryInfo(
          color: const Color(0xFFEF4444), // Red
          icon: Icons.local_pizza,
        );
      case 'pasta':
        return CategoryInfo(
          color: const Color(0xFFF59E0B), // Amber
          icon: Icons.ramen_dining,
        );
      case 'seafood':
        return CategoryInfo(
          color: const Color(0xFF059669), // Emerald
          icon: Icons.set_meal,
        );
      case 'soups':
        return CategoryInfo(
          color: const Color(0xFF7C3AED), // Violet
          icon: Icons.soup_kitchen,
        );
      default:
        return CategoryInfo(
          color: const Color(0xFF6B7280), // Gray
          icon: Icons.category,
        );
    }
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

  // Barcode scanning functionality
  void _onScanBarcode() {
    // TODO: Implement barcode scanning
    // For now, show a dialog asking for manual barcode entry
    showDialog(
      context: context,
      builder: (context) => _BarcodeInputDialog(
        onBarcodeScanned: _handleBarcodeScanned,
      ),
    );
  }

  void _handleBarcodeScanned(String barcode) async {
    try {
      final repository = await ref.read(posRepositoryProvider.future);
      final item = await repository.getItemByBarcode(barcode);
      
      if (item != null) {
        _addToCart(item);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item not found for this barcode'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning barcode: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Discounts functionality
  void _showDiscountsDialog() {
    showDialog(
      context: context,
      builder: (context) => _DiscountsDialog(
        onDiscountApplied: (discount) {
          // TODO: Implement discount application to cart
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Discount applied: ${discount.name}'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // Guest functionality
  void _showGuestDialog() {
    showDialog(
      context: context,
      builder: (context) => _GuestSelectionDialog(
        onGuestSelected: (guestCount) {
          setState(() {
            // Store guest count for order
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Guest count set to $guestCount'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final cashierName = authState.user?.name ?? 'Cashier';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Modern POS Header
          _buildPosHeader(theme, cashierName),
          
          // Main Content Area - now switches based on current section
          Expanded(
            child: _buildMainContent(theme),
          ),
          
          // Bottom Navigation
          _buildBottomNavigation(theme),
        ],
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    switch (_currentSection) {
      case 'Menu':
        return _buildMenuSection(theme);
      case 'Orders':
        return _buildOrdersSection(theme);
      case 'Transactions':
        return _buildTransactionsSection(theme);
      case 'Inventory':
        return _buildInventorySection(theme);
      default:
        return _buildMenuSection(theme);
    }
  }

  Widget _buildMenuSection(ThemeData theme) {
    final authState = ref.watch(authNotifierProvider);
    final userRole = authState.user?.role;
    final canSeeReportsTab = userRole == UserRole.admin || userRole == UserRole.manager;

    return canSeeReportsTab
        ? TabBarView(
            controller: _tabController,
            children: [
              _buildPosMainContent(theme),
              _buildReportsTab(theme),
            ],
          )
        : _buildPosMainContent(theme);
  }

  Widget _buildPosHeader(ThemeData theme, String cashierName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Business/Order Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedTableNumber != null 
                  ? 'Table $_selectedTableNumber' 
                  : 'Order #$_currentOrderNumber',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                _selectedTableNumber != null 
                  ? 'Waitstaff: ${_selectedTableWaitstaff ?? "Unassigned"}'
                  : _serviceType,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Search Bar
          Container(
            width: 300,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Action Buttons
          Row(
            children: [
              _buildHeaderActionButton(
                theme,
                Icons.percent,
                'Discounts',
                _showDiscountsDialog,
              ),
              const SizedBox(width: 8),
              _buildHeaderActionButton(
                theme,
                Icons.qr_code_scanner,
                'Scan',
                _onScanBarcode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton(
    ThemeData theme,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        foregroundColor: theme.colorScheme.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildPosMainContent(ThemeData theme) {
    return Row(
      children: [
        // Left Side - Menu Items
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Category Filter Tabs
              _buildCategoryTabs(theme),
              
              // Menu Items Grid
              Expanded(
                child: _buildMenuItemsGrid(theme),
              ),
            ],
          ),
        ),
        
        // Right Side - Cart and Checkout
        Container(
          width: 400,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: _buildCartSection(theme),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(ThemeData theme) {
    final categoriesAsync = ref.watch(posCategoriesProvider);
    
    return categoriesAsync.when(
      data: (categories) => Container(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category;
            
            // Get category color and icon
            final categoryInfo = _getCategoryInfo(category);
            
            return InkWell(
              onTap: () => _onCategorySelected(category),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? categoryInfo.color : categoryInfo.color.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                    ? Border.all(color: theme.colorScheme.primary, width: 2)
                    : null,
                  boxShadow: [
                    BoxShadow(
                      color: categoryInfo.color.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        categoryInfo.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            FutureBuilder<List<CartItem>>(
                              future: ref.read(itemsByCategoryProvider(category).future),
                              builder: (context, snapshot) {
                                final itemCount = snapshot.data?.length ?? 0;
                                return Text(
                                  '$itemCount items',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      loading: () => Container(
        height: 60,
        child: const Center(child: LoadingIndicator()),
      ),
      error: (error, stack) => Container(
        height: 60,
        child: Center(
          child: Text(
            'Error loading categories',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemsGrid(ThemeData theme) {
    if (_isSearching) {
      final searchResults = ref.watch(searchNotifierProvider);
      return _buildSearchResults(theme, searchResults);
    } else {
      final itemsAsync = ref.watch(itemsByCategoryProvider(_selectedCategory));
      return itemsAsync.when(
        data: (items) => _buildItemsGrid(theme, items),
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading items',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(itemsByCategoryProvider(_selectedCategory)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSearchResults(ThemeData theme, List<MenuItem> searchResults) {
    if (searchResults.isEmpty) {
      return const Center(child: LoadingIndicator());
    }
    
    // Convert MenuItem to CartItem for display
    final cartItems = searchResults.map((item) => CartItem(
      id: item.id.toString(),
      name: item.name,
      price: item.price,
      quantity: 1,
      imageUrl: item.image,
      category: 'Search Result',
    )).toList();
    
    return _buildItemsGrid(theme, cartItems);
  }

  Widget _buildItemsGrid(ThemeData theme, List<CartItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isSearching 
                ? 'Try adjusting your search terms'
                : 'No items available in this category',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
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
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMenuItemCard(theme, item);
      },
      // Add key to prevent unnecessary rebuilds
      key: const PageStorageKey('menu_items_grid'),
    );
  }

  Widget _buildMenuItemCard(ThemeData theme, CartItem item) {
    return Card(
      key: ValueKey('menu_item_${item.id}'), // Add stable key to prevent rebuilds
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _addToCart(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Image
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: item.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppImage(
                            imageUrl: item.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.restaurant,
                          size: 32,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Item Name
              Text(
                item.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Item Price
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartSection(ThemeData theme) {
    return Column(
      children: [
        // Tab Header
        _buildCartTabHeader(theme),
        
        // Cart Content
        Expanded(
                    child: _selectedTab == 'Cart'
              ? _buildCartTab(theme)
            : _selectedTab == 'Actions' 
              ? _buildCartActionsTab(theme)
              : _buildCartGuestTab(theme),
        ),
      ],
    );
  }

  Widget _buildCartTabHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
                        _buildTabButton(theme, 'Cart', _selectedTab == 'Cart'),
          _buildTabButton(theme, 'Actions', _selectedTab == 'Actions'),
          _buildTabButton(theme, 'Guest', _selectedTab == 'Guest'),
        ],
      ),
    );
  }

  Widget _buildTabButton(ThemeData theme, String label, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected 
                  ? theme.colorScheme.primary 
                  : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected 
                ? theme.colorScheme.primary 
                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartTab(ThemeData theme) {
    final cart = ref.watch(cartNotifierProvider);
    final total = ref.watch(cartTotalProvider);

    return Column(
      children: [
        // Cart Items
        Expanded(
          child: cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to get started',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                    return _buildCartItem(theme, item);
                  },
                ),
        ),
        
        // Cart Summary and Checkout
        if (cart.isNotEmpty) _buildCartSummary(theme, total),
      ],
    );
  }

  Widget _buildCartActionsTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildActionButton(
            theme,
            'Charge Table Order',
            Icons.table_restaurant,
            () => _showTableOrdersDialog(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            theme,
            'Hold Order',
            Icons.pause,
            () {
              // TODO: Implement hold order functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order held')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            theme,
            'Void Order',
            Icons.cancel,
            () {
              ref.read(cartNotifierProvider.notifier).clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order voided')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            theme,
            'Print Receipt',
            Icons.print,
            () {
              // TODO: Implement print functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receipt printed')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            theme,
            'Email Receipt',
            Icons.email,
            () {
              // TODO: Implement email functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receipt emailed')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartGuestTab(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildActionButton(
            theme,
            'Set Guest Count',
            Icons.people,
            _showGuestDialog,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            theme,
            'Customer Info',
            Icons.person,
            () {
              // TODO: Implement customer info functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Customer info dialog')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            theme,
            'Special Requests',
            Icons.note_add,
            () {
              // TODO: Implement special requests functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Special requests dialog')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainerHigh,
          foregroundColor: theme.colorScheme.onSurface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(ThemeData theme, CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)} each',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity Controls
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444), // Red
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: item.quantity! > 1
                        ? () => _updateQuantity(item.id, item.quantity! - 1)
                        : () => _removeFromCart(item.id),
                    borderRadius: BorderRadius.circular(8),
                    child: Icon(
                      item.quantity! > 1 ? Icons.remove : Icons.delete,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E), // Green
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _updateQuantity(item.id, item.quantity! + 1),
                    borderRadius: BorderRadius.circular(8),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(ThemeData theme, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showCheckoutDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Charge \$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    final authState = ref.watch(authNotifierProvider);
    final cashierName = authState.user?.name ?? 'Cashier';
    
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildBottomNavItem(
            theme,
            cashierName.split(' ').map((name) => name[0]).take(2).join(),
            cashierName,
            () {
              // Show cashier profile or settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Signed in as $cashierName')),
              );
            },
            isSelected: false,
          ),
          _buildBottomNavItem(
            theme,
            Icons.restaurant_menu,
            'Menu',
            () => setState(() => _currentSection = 'Menu'),
            isSelected: _currentSection == 'Menu',
          ),
          _buildBottomNavItem(
            theme,
            Icons.receipt_long,
            'Orders',
            () => setState(() => _currentSection = 'Orders'),
            isSelected: _currentSection == 'Orders',
          ),
          _buildBottomNavItem(
            theme,
            Icons.analytics,
            'Transactions',
            () => setState(() => _currentSection = 'Transactions'),
            isSelected: _currentSection == 'Transactions',
          ),
          _buildBottomNavItem(
            theme,
            Icons.inventory,
            'Inventory',
            () => setState(() => _currentSection = 'Inventory'),
            isSelected: _currentSection == 'Inventory',
          ),
          _buildBottomNavItem(
            theme,
            Icons.more_horiz,
            'More',
            () => context.go('/settings'),
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    ThemeData theme,
    dynamic icon,
    String label,
    VoidCallback onTap, {
    bool isSelected = false,
  }) {
    final color = isSelected 
        ? theme.colorScheme.primary 
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);
        
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon is IconData)
                Icon(
                  icon,
                  size: 24,
                  color: color,
                )
              else
                CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    icon.toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
        // Clear table information after completing sale
        _selectedTableNumber = null;
        _selectedTableWaitstaff = null;
        _serviceType = 'POS Service';
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

     Widget _buildReportsTab(ThemeData theme) {
     final sales = ref.watch(recentSalesNotifierProvider);

     if (sales.isEmpty) {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(
               Icons.receipt_long,
               size: 64,
               color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
             ),
             const SizedBox(height: 16),
             Text(
               'No recent sales',
               style: theme.textTheme.headlineSmall?.copyWith(
                 color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
               ),
             ),
             const SizedBox(height: 8),
             Text(
               'Sales will appear here after transactions',
               style: theme.textTheme.bodyMedium?.copyWith(
                 color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
               ),
             ),
           ],
         ),
       );
     }

     return _RecentSalesTab(sales: sales);
   }

   // Section builders for bottom navigation
  Widget _buildOrdersSection(ThemeData theme) {
    return Column(
      children: [
        // Section header
        _buildSectionHeader(theme, 'Current Orders', 'Manage restaurant orders'),
        
        // Orders list
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final ordersAsyncValue = ref.watch(restaurantOrdersProvider);
              
              return ordersAsyncValue.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return _buildEmptyStateSection(
                      theme,
                      Icons.receipt_long,
                      'No Active Orders',
                      'New orders will appear here',
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _buildOrderCard(theme, order);
                    },
                  );
                },
                loading: () => const Center(child: LoadingIndicator()),
                error: (error, stackTrace) => _buildErrorState(
                  theme,
                  'Failed to load orders',
                  error.toString(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(ThemeData theme) {
    return Column(
      children: [
        // Section header
        _buildSectionHeader(theme, 'Daily Transactions', 'View completed sales'),
        
        // Transactions list
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final transactionsAsyncValue = ref.watch(dailyTransactionsProvider);
              
              return transactionsAsyncValue.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return _buildEmptyStateSection(
                      theme,
                      Icons.analytics,
                      'No Transactions Today',
                      'Completed sales will appear here',
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionCard(theme, transaction);
                    },
                  );
                },
                loading: () => const Center(child: LoadingIndicator()),
                error: (error, stackTrace) => _buildErrorState(
                  theme,
                  'Failed to load transactions',
                  error.toString(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInventorySection(ThemeData theme) {
    return Column(
      children: [
        // Section header
        _buildSectionHeader(theme, 'Inventory Status', 'Monitor stock levels'),
        
        // Inventory list
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final inventoryAsyncValue = ref.watch(inventoryStatusProvider);
              
              return inventoryAsyncValue.when(
                data: (items) {
                  if (items.isEmpty) {
                    return _buildEmptyStateSection(
                      theme,
                      Icons.inventory,
                      'No Inventory Data',
                      'Menu items will appear here with stock info',
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildInventoryCard(theme, item);
                    },
                  );
                },
                loading: () => const Center(child: LoadingIndicator()),
                error: (error, stackTrace) => _buildErrorState(
                  theme,
                  'Failed to load inventory',
                  error.toString(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateSection(ThemeData theme, IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String title, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(ThemeData theme, Map<String, dynamic> order) {
    final tableNumber = order['tableNumber']?.toString() ?? 'Unknown';
    final guestCount = order['guestCount'] ?? 1;
    final waitstaff = order['waitstaff']?.toString() ?? 'Unknown';
    final total = (order['total'] ?? 0.0).toDouble();
    final status = order['status']?.toString() ?? 'pending';
    final items = order['items'] as List<dynamic>? ?? [];
    final createdAt = order['createdAt'] as DateTime? ?? DateTime.now();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showSettleOrderDialog(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.table_restaurant,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Table $tableNumber',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status, theme).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(status, theme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$guestCount guests',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.person,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    waitstaff,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${items.length} items • ${_formatOrderTime(createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(ThemeData theme, Map<String, dynamic> transaction) {
    final id = transaction['id']?.toString() ?? '';
    final total = (transaction['amount'] ?? transaction['total'] ?? 0.0).toDouble();
    final paymentMethod = transaction['paymentMethod']?.toString() ?? 'cash';
    final customerName = transaction['customerName']?.toString() ?? 'Guest';
    final timestamp = transaction['timestamp']?.toString() ?? '';
    final createdAt = DateTime.tryParse(timestamp) ?? DateTime.now();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'SALE-$id',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getPaymentMethodIcon(paymentMethod),
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  paymentMethod.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.person,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  customerName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatOrderTime(createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(ThemeData theme, Map<String, dynamic> item) {
    final name = item['name']?.toString() ?? 'Unknown Item';
    final stockQuantity = item['stockQuantity'] ?? 0;
    final minStock = item['minStock'] ?? 10;
    final price = (item['price'] ?? 0.0).toDouble();
    final category = item['category']?.toString() ?? 'General';
    final imageUrl = item['imageUrl']?.toString();
    
    final isLowStock = stockQuantity <= minStock;
    final isOutOfStock = stockQuantity <= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Item image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? AppImage(
                      imageUrl: imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.restaurant,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isOutOfStock)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'OUT OF STOCK',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else if (isLowStock)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'LOW STOCK',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$stockQuantity in stock',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'ready':
      case 'ready_to_pay':
        return Colors.green;
      case 'preparing':
        return Colors.orange;
      case 'pending':
        return theme.colorScheme.primary;
      case 'completed':
        return Colors.grey;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'mobile':
        return Icons.phone_android;
      case 'check':
        return Icons.receipt;
      default:
        return Icons.payment;
    }
  }

  String _formatOrderTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showSettleOrderDialog(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => _SettleOrderDialog(
        order: order,
        onSettleOrder: (orderItems) {
          // Load order items into cart
          final cartNotifier = ref.read(cartNotifierProvider.notifier);
          cartNotifier.clearCart();
          
          for (final item in orderItems) {
            final cartItem = CartItem(
              id: item['itemId'].toString(),
              name: item['itemName'],
              price: item['unitPrice'].toDouble(),
              quantity: item['quantity'],
              category: '1',
            );
            cartNotifier.addItem(cartItem);
          }
          
          // Update table information for header
          setState(() {
            _selectedTableNumber = order['tableNumber']?.toString();
            _selectedTableWaitstaff = order['waitstaff']?.toString();
            _serviceType = 'Table Service';
            _currentSection = 'Menu'; // Switch back to menu section for checkout
          });
          
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order loaded into cart - Table ${order['tableNumber']}'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // Waitstaff to POS charging flow
   void _showTableOrdersDialog() {
     showDialog(
       context: context,
       builder: (context) => _TableOrdersDialog(
         onOrderSelected: _chargeTableOrder,
       ),
     );
   }

   void _chargeTableOrder(TableOrder order) async {
     try {
       // Update table information in header
       setState(() {
         _selectedTableNumber = order.tableNumber;
         _selectedTableWaitstaff = order.waitstaff;
         _serviceType = 'Table Service';
       });
       
       // Clear current cart first
       ref.read(cartNotifierProvider.notifier).clearCart();
       
       // Add order items to cart
       for (final item in order.items) {
         final cartItem = CartItem(
           id: item.itemId.toString(),
           name: item.itemName,
           price: item.unitPrice,
           quantity: item.quantity,
           category: 'Table Order',
         );
         ref.read(cartNotifierProvider.notifier).addItem(cartItem);
       }
       
       // Show checkout dialog immediately
       _showCheckoutDialog();
       
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('Table ${order.tableNumber} order loaded for charging'),
           backgroundColor: Colors.green,
         ),
       );
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('Error loading table order: $e'),
           backgroundColor: Colors.red,
         ),
       );
     }
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
      key: const PageStorageKey('search_results_grid'),
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
      key: const PageStorageKey('popular_items_grid'),
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
      key: ValueKey('menu_item_card_${item.id}'), // Add stable key to prevent rebuilds
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

// Add missing dialog classes and helper widgets at the end of the file

// Barcode Input Dialog
class _BarcodeInputDialog extends StatefulWidget {
  final Function(String) onBarcodeScanned;

  const _BarcodeInputDialog({
    required this.onBarcodeScanned,
  });

  @override
  State<_BarcodeInputDialog> createState() => _BarcodeInputDialogState();
}

class _BarcodeInputDialogState extends State<_BarcodeInputDialog> {
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: const Text('Scan Barcode'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter barcode manually or use camera scanner:'),
          const SizedBox(height: 16),
          TextField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: 'Barcode',
              hintText: 'Enter barcode number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final barcode = _barcodeController.text.trim();
            if (barcode.isNotEmpty) {
              widget.onBarcodeScanned(barcode);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Scan'),
        ),
      ],
    );
  }
}

// Discounts Dialog
class _DiscountsDialog extends StatelessWidget {
  final Function(Discount) onDiscountApplied;

  const _DiscountsDialog({
    required this.onDiscountApplied,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Mock discounts for now
    final discounts = [
      Discount(id: '1', name: '10% Off', percentage: 10, isActive: true),
      Discount(id: '2', name: '15% Senior Discount', percentage: 15, isActive: true),
      Discount(id: '3', name: '20% Employee Discount', percentage: 20, isActive: true),
      Discount(id: '4', name: '5% Student Discount', percentage: 5, isActive: true),
    ];
    
    return AlertDialog(
      title: const Text('Available Discounts'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: discounts.length,
          itemBuilder: (context, index) {
            final discount = discounts[index];
            return ListTile(
              leading: Icon(
                Icons.local_offer,
                color: theme.colorScheme.primary,
              ),
              title: Text(discount.name),
              subtitle: Text('${discount.percentage}% off'),
              onTap: () {
                onDiscountApplied(discount);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

// Guest Selection Dialog
class _GuestSelectionDialog extends StatefulWidget {
  final Function(int) onGuestSelected;

  const _GuestSelectionDialog({
    required this.onGuestSelected,
  });

  @override
  State<_GuestSelectionDialog> createState() => _GuestSelectionDialogState();
}

class _GuestSelectionDialogState extends State<_GuestSelectionDialog> {
  int _guestCount = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: const Text('Set Guest Count'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How many guests will be dining?'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _guestCount > 1 ? () => setState(() => _guestCount--) : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$_guestCount',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _guestCount < 20 ? () => setState(() => _guestCount++) : null,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onGuestSelected(_guestCount);
            Navigator.of(context).pop();
          },
          child: const Text('Set'),
        ),
      ],
    );
  }
}



// Simple Discount model
class Discount {
  final String id;
  final String name;
  final double percentage;
  final bool isActive;

  const Discount({
    required this.id,
    required this.name,
    required this.percentage,
    required this.isActive,
  });
}

// Table Orders Dialog for waitstaff charging flow
class _TableOrdersDialog extends ConsumerWidget {
  final Function(TableOrder) onOrderSelected;

  const _TableOrdersDialog({
    required this.onOrderSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tableOrdersAsync = ref.watch(tableOrdersReadyToChargeProvider);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Table Orders Ready to Charge',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Orders List
            Expanded(
              child: tableOrdersAsync.when(
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading table orders...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading orders',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(tableOrdersReadyToChargeProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (orderData) {
                  // Convert API data to TableOrder objects
                  final tableOrders = orderData.map((data) {
                    final items = (data['items'] as List<dynamic>).map((item) {
                      return TableOrderItem(
                        itemId: item['itemId'] ?? 0,
                        itemName: item['itemName'] ?? 'Unknown Item',
                        quantity: item['quantity'] ?? 1,
                        unitPrice: (item['unitPrice'] ?? 0.0).toDouble(),
                      );
                    }).toList();

                    return TableOrder(
                      id: data['id'] ?? 0,
                      tableNumber: data['tableNumber'] ?? 'Unknown',
                      guestCount: data['guestCount'] ?? 1,
                      waitstaff: data['waitstaff'] ?? 'Unknown Server',
                      total: (data['total'] ?? 0.0).toDouble(),
                      status: data['status'] ?? 'ready_to_pay',
                      items: items,
                      createdAt: data['createdAt'] ?? DateTime.now(),
                    );
                  }).toList();

                  if (tableOrders.isEmpty) {
                    return _buildEmptyState(theme);
                  }

                  return _buildOrdersList(tableOrders, theme);
                },
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Select an order to load items into POS for charging',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders ready to charge',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders from waitstaff will appear here when ready',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<TableOrder> tableOrders, ThemeData theme) {
    return ListView.builder(
      itemCount: tableOrders.length,
      itemBuilder: (context, index) {
        final order = tableOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              onOrderSelected(order);
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Table ${order.tableNumber}',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.people,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${order.guestCount} guests',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Waitstaff and Time
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Served by ${order.waitstaff}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatOrderTime(order.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Items Summary
                  Text(
                    'Items (${order.items.length}):',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: order.items.take(3).map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${item.quantity}x ${item.itemName}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      );
                    }).toList()
                      ..addAll(order.items.length > 3
                          ? [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '+${order.items.length - 3} more',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ]
                          : []),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatOrderTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }


}

// Table Order Models
class TableOrder {
  final int id;
  final String tableNumber;
  final int guestCount;
  final String waitstaff;
  final double total;
  final String status;
  final List<TableOrderItem> items;
  final DateTime createdAt;

  const TableOrder({
    required this.id,
    required this.tableNumber,
    required this.guestCount,
    required this.waitstaff,
    required this.total,
    required this.status,
    required this.items,
    required this.createdAt,
  });
}

class TableOrderItem {
  final int itemId;
  final String itemName;
  final int quantity;
  final double unitPrice;

  const TableOrderItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });
}

// Category information class for colorful UI
class CategoryInfo {
  final Color color;
  final IconData icon;

  const CategoryInfo({
    required this.color,
    required this.icon,
  });
}

// Settlement dialog for table orders
class _SettleOrderDialog extends StatelessWidget {
  final Map<String, dynamic> order;
  final Function(List<dynamic>) onSettleOrder;

  const _SettleOrderDialog({
    required this.order,
    required this.onSettleOrder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableNumber = order['tableNumber']?.toString() ?? 'Unknown';
    final waitstaff = order['waitstaff']?.toString() ?? 'Unknown';
    final total = (order['total'] ?? 0.0).toDouble();
    final items = order['items'] as List<dynamic>? ?? [];
    final orderTime = order['orderTime']?.toString() ?? '';

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.table_restaurant,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text('Settle Order - $tableNumber'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Waitstaff: $waitstaff',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Order Time: ${_formatOrderTime(orderTime)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Order Items
            Text(
              'Order Items (${items.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            if (items.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final itemName = item['name'] ?? item['itemName'] ?? 'Unknown Item';
                    final quantity = item['quantity'] ?? 1;
                    final price = (item['price'] ?? item['unitPrice'] ?? 0.0).toDouble();
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          quantity.toString(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      title: Text(
                        itemName,
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Text(
                        '\$${(price * quantity).toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No items in this order',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: items.isNotEmpty
              ? () => onSettleOrder(items)
              : null,
          child: const Text('Load to Cart & Settle'),
        ),
      ],
    );
  }

  String _formatOrderTime(String orderTime) {
    try {
      final dateTime = DateTime.parse(orderTime);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ${difference.inMinutes % 60}m ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return orderTime;
    }
  }
}
