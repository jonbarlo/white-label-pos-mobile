import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'pos_repository.dart';
import 'pos_repository_impl.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/menu_item.dart';
import 'models/split_payment.dart';
import 'models/analytics.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import '../waiter/table_provider.dart';
import '../waiter/waiter_order_provider.dart';
import '../waiter/models/table.dart' as waiter_table;

part 'pos_provider.g.dart';

@riverpod
Future<PosRepository> posRepository(PosRepositoryRef ref) async {
  final dio = ref.watch(dioClientProvider);
  return PosRepositoryImpl(dio, ref);
}

// Cart management
@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItem> build() {
    return [];
  }

  void addItem(CartItem item) {
    print('🔍 DEBUG: CartNotifier.addItem called with: ${item.name} x${item.quantity}');
    print('🔍 DEBUG: Current cart state before adding: ${state.length} items');
    
    final existingIndex = state.indexWhere((cartItem) => cartItem.id == item.id);
    
    if (existingIndex != -1) {
      // Item already exists, increase quantity
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
      print('🔍 DEBUG: Updated existing item quantity. New cart state: ${state.length} items');
    } else {
      // Add new item
      state = [...state, item];
      print('🔍 DEBUG: Added new item. New cart state: ${state.length} items');
    }
    
    print('🔍 DEBUG: Final cart state: ${state.map((item) => '${item.name} x${item.quantity}').join(', ')}');
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  void updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    state = state.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }
}

@riverpod
double cartTotal(CartTotalRef ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart.fold(0.0, (total, item) => total + item.total);
}

// Search functionality
@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  List<MenuItem> build() {
    return [];
  }

  Future<void> searchItems(String query) async {
    print('🔍 DEBUG: SearchNotifier.searchItems called with query: "$query"');
    
    if (query.trim().isEmpty) {
      print('🔍 DEBUG: Query is empty, clearing search results');
      state = [];
      return;
    }

    try {
      print('🔍 DEBUG: Getting repository and searching...');
      final repository = await ref.read(posRepositoryProvider.future);
      final results = await repository.searchItems(query);
      
      print('🔍 DEBUG: Search results count: ${results.length}');
      
      // Convert CartItem results to MenuItem for display
      final menuItems = results.map((item) => MenuItem(
        id: int.parse(item.id),
        businessId: 1, // This should come from auth state
        categoryId: int.tryParse(item.category ?? '1') ?? 1,
        name: item.name,
        description: '',
        price: item.price,
        cost: 0.0,
        image: item.imageUrl,
        allergens: null,
        nutritionalInfo: null,
        preparationTime: 0,
        isAvailable: true,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )).toList();
      
      print('🔍 DEBUG: Converted to ${menuItems.length} MenuItems');
      state = menuItems;
    } catch (e) {
      print('🔍 DEBUG: Error in searchItems: $e');
      // Handle error silently for now, could add error state later
      state = [];
    }
  }

  void clearSearch() {
    print('🔍 DEBUG: SearchNotifier.clearSearch called');
    state = [];
  }
}

// Recent sales
@riverpod
class RecentSalesNotifier extends _$RecentSalesNotifier {
  @override
  List<Sale> build() {
    return [];
  }

  Future<void> loadRecentSales({int limit = 10}) async {
    try {
      final repository = await ref.read(posRepositoryProvider.future);
      
      // First get the basic sales list
      final sales = await repository.getRecentSales(limit: limit);
      
      // Then fetch each sale with its items
      final salesWithItems = <Sale>[];
      for (final sale in sales) {
        try {
          final saleWithItems = await repository.getSaleWithItems(sale.id);
          if (saleWithItems != null) {
            salesWithItems.add(saleWithItems);
          } else {
            // Fallback to the original sale if fetching with items fails
            salesWithItems.add(sale);
          }
        } catch (e) {
          print('Error fetching sale ${sale.id} with items: $e');
          // Fallback to the original sale
          salesWithItems.add(sale);
        }
      }
      
      state = salesWithItems;
    } catch (e) {
      print('Error loading recent sales: $e');
      // Handle error silently for now
      state = [];
    }
  }

  void addSale(Sale sale) {
    state = [sale, ...state];
  }
}

// Create sale
@riverpod
Future<Sale> createSale(
  CreateSaleRef ref,
  PaymentMethod paymentMethod, {
  String? customerName,
  String? customerEmail,
}) async {
  final cart = ref.read(cartNotifierProvider);
  
  if (cart.isEmpty) {
    throw Exception('Cannot create sale with empty cart');
  }

  final repository = await ref.read(posRepositoryProvider.future);
  
  try {
  final sale = await repository.createSale(
    items: cart,
    paymentMethod: paymentMethod,
    customerName: customerName,
    customerEmail: customerEmail,
  );
    
    // Clear cart after successful sale
  ref.read(cartNotifierProvider.notifier).clearCart();
  
  // Add to recent sales
  ref.read(recentSalesNotifierProvider.notifier).addSale(sale);

  // Invalidate all related providers to refresh data after order submission
  ref.invalidate(tablesProvider);
  ref.invalidate(recentSalesNotifierProvider);
  ref.invalidate(salesSummaryProvider(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()));
  
  // Force refresh of all table data by invalidating the provider family
  // This will cause all table-related data to be refetched
  ref.invalidate(tablesByStatusProvider(waiter_table.TableStatus.occupied));
  ref.invalidate(myAssignedTablesProvider);
  
  // Add a small delay to ensure the backend has processed the order
  // before refreshing table data
  await Future.delayed(const Duration(milliseconds: 500));

  return sale;
  } catch (e) {
    rethrow;
  }
}

// Create sale with custom cart items
@riverpod
Future<Sale> createSaleWithItems(
  CreateSaleWithItemsRef ref,
  List<CartItem> items,
  PaymentMethod paymentMethod, {
  String? customerName,
  String? customerEmail,
  int? existingOrderId,
}) async {
  if (items.isEmpty) {
    throw Exception('Cannot create sale with empty cart');
  }

  final repository = await ref.read(posRepositoryProvider.future);
  
  try {
    final sale = await repository.createSale(
      items: items,
      paymentMethod: paymentMethod,
      customerName: customerName,
      customerEmail: customerEmail,
      existingOrderId: existingOrderId,
    );
    
    // Clear cart after successful sale
    ref.read(cartNotifierProvider.notifier).clearCart();
    
    // Add to recent sales
    ref.read(recentSalesNotifierProvider.notifier).addSale(sale);

    // Invalidate all related providers to refresh data after order submission
    ref.invalidate(tablesProvider);
    ref.invalidate(recentSalesNotifierProvider);
    ref.invalidate(salesSummaryProvider(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()));
    
    // Force refresh of all table data by invalidating the provider family
    // This will cause all table-related data to be refetched
    ref.invalidate(tablesByStatusProvider(waiter_table.TableStatus.occupied));
    ref.invalidate(myAssignedTablesProvider);
    
    // Add a small delay to ensure the backend has processed the order
    // before refreshing table data
    await Future.delayed(const Duration(milliseconds: 500));

    return sale;
  } catch (e) {
    rethrow;
  }
}

// Barcode scanning
@riverpod
Future<CartItem?> scanBarcode(ScanBarcodeRef ref, String barcode) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    return await repository.getItemByBarcode(barcode);
  } catch (e) {
    return null;
  }
}

// Sales summary
@riverpod
Future<Map<String, dynamic>> salesSummary(
  SalesSummaryRef ref,
  DateTime startDate,
  DateTime endDate,
) async {
  final repository = await ref.read(posRepositoryProvider.future);
  return await repository.getSalesSummary(
    startDate: startDate,
    endDate: endDate,
  );
}

// Top selling items
@riverpod
Future<List<CartItem>> topSellingItems(TopSellingItemsRef ref, {int limit = 10}) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    return await repository.getTopSellingItems(limit: limit);
  } catch (e) {
    return [];
  }
}

// Split payment functionality
@riverpod
Future<SplitSaleResponse> createSplitSale(
  CreateSplitSaleRef ref,
  SplitSaleRequest request,
) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    
    final response = await repository.createSplitSale(request);

    // Clear cart after successful sale
    ref.read(cartNotifierProvider.notifier).clearCart();
    
    // Add to recent sales (convert to regular sale for display)
    final sale = Sale(
      id: response.sale.id.toString(),
      customerName: response.sale.customerName ?? 'Split Payment',
      total: response.sale.totalAmount,
      status: response.sale.status,
      createdAt: response.sale.createdAt,
      paymentMethod: PaymentMethod.card, // Default for split payments
    );
    ref.read(recentSalesNotifierProvider.notifier).addSale(sale);

    return response;
  } catch (e) {
    rethrow;
  }
}

@riverpod
Future<SplitSale> addPaymentToSale(
  AddPaymentToSaleRef ref,
  int saleId,
  AddPaymentRequest request,
) async {
  final repository = await ref.read(posRepositoryProvider.future);
  return await repository.addPaymentToSale(saleId, request);
}

@riverpod
Future<SplitSale> refundSplitPayment(
  RefundSplitPaymentRef ref,
  int saleId,
  RefundRequest request,
) async {
  final repository = await ref.read(posRepositoryProvider.future);
  return await repository.refundSplitPayment(saleId, request);
}

@riverpod
Future<SplitBillingStats> getSplitBillingStats(GetSplitBillingStatsRef ref) async {
  final repository = await ref.read(posRepositoryProvider.future);
  return await repository.getSplitBillingStats();
} 

// Menu items provider to fetch real inventory
@riverpod
Future<List<MenuItem>> menuItems(MenuItemsRef ref) async {
  
  try {
    // Check auth state first
    final authState = ref.read(authNotifierProvider);
    if (authState.status != AuthStatus.authenticated) {
      print('🔍 menuItems provider: User not authenticated');
      return [];
    }
    
    if (authState.business?.id == null) {
      print('🔍 menuItems provider: No business ID found');
      return [];
    }
    
    final repository = await ref.read(posRepositoryProvider.future);
    
    // Fetch all available menu items using searchItems which uses _safeMenuItemFromJson
    final cartItems = await repository.searchItems(''); // Empty query to get all items
    
    // Convert CartItem results to MenuItem for display
    // The CartItem objects already have proper image URLs from _safeMenuItemFromJson
    final menuItems = cartItems.map((item) => MenuItem(
      id: int.parse(item.id),
      businessId: authState.business?.id ?? 1,
      categoryId: int.tryParse(item.category ?? '1') ?? 1,
      name: item.name,
      description: '', // CartItem doesn't have description, use empty string
      price: item.price,
      cost: 0.0,
      image: item.imageUrl, // This should now have the sample image URL
      allergens: null,
      nutritionalInfo: null,
      preparationTime: 0,
      isAvailable: true,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    )).toList();
    
    print('🔍 POS menuItems provider: Created ${menuItems.length} menu items');
    for (final item in menuItems.take(3)) {
      print('  - ${item.name}: image = ${item.image}');
    }
    
    return menuItems;
  } catch (e) {
    print('🔍 Error in menuItems provider: $e');
    // Return empty list on error - NO FALLBACK ITEMS
    return [];
  }
}

// Analytics Providers
@riverpod
Future<ItemAnalytics> itemAnalytics(
  ItemAnalyticsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
}) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    return await repository.getItemAnalytics(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  } catch (e) {
    print('Error fetching item analytics: $e');
    rethrow;
  }
}

@riverpod
Future<RevenueAnalytics> revenueAnalytics(
  RevenueAnalyticsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
  String? period,
}) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    return await repository.getRevenueAnalytics(
      startDate: startDate,
      endDate: endDate,
      period: period,
    );
  } catch (e) {
    print('Error fetching revenue analytics: $e');
    rethrow;
  }
}

@riverpod
Future<StaffAnalytics> staffAnalytics(
  StaffAnalyticsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
}) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    return await repository.getStaffAnalytics(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  } catch (e) {
    print('Error fetching staff analytics: $e');
    rethrow;
  }
}

@riverpod
Future<CustomerAnalytics> customerAnalytics(
  CustomerAnalyticsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
}) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    return await repository.getCustomerAnalytics(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  } catch (e) {
    print('Error fetching customer analytics: $e');
    rethrow;
  }
}

@riverpod
Future<InventoryAnalytics> inventoryAnalytics(
  InventoryAnalyticsRef ref, {
  int? limit,
}) async {
  try {
    final repository = await ref.read(posRepositoryProvider.future);
    return await repository.getInventoryAnalytics(limit: limit);
  } catch (e) {
    print('Error fetching inventory analytics: $e');
    rethrow;
  }
} 

// Add new providers for POS categories and filtering
@riverpod
Future<List<String>> posCategories(PosCategoriesRef ref) async {
  final repository = await ref.watch(posRepositoryProvider.future);
  return await repository.getCategories();
}

@riverpod
Future<List<CartItem>> itemsByCategory(ItemsByCategoryRef ref, String category) async {
  final repository = await ref.watch(posRepositoryProvider.future);
  
  // Always fetch all items first (this will be cached by Riverpod)
  final allItems = await repository.getAllItems();
  
  // If "All" category, return all items
  if (category == 'All') {
    return allItems;
  }
  
  // Create a mapping from category names to category IDs
  // Based on the API response, we know:
  // Pizza -> 13, Pasta -> 14, Desserts -> 15, Beverages -> 16
  final categoryNameToId = {
    'Pizza': '13',
    'Pasta': '14', 
    'Desserts': '15',
    'Beverages': '16',
  };
  
  // Get the category ID for the requested category name
  final categoryId = categoryNameToId[category];
  
  if (categoryId == null) {
    print('🔍 DEBUG: No mapping found for category "$category"');
    return [];
  }
  
  // Filter items locally based on category ID
  final filteredItems = allItems.where((item) {
    final itemCategory = item.category ?? '';
    final matches = itemCategory == categoryId;
            // Debug logging removed to reduce console noise
    return matches;
  }).toList();
  
      // Debug logging removed to reduce console noise
  
  return filteredItems;
}

@riverpod
Future<List<CartItem>> allMenuItems(AllMenuItemsRef ref) async {
  final repository = await ref.watch(posRepositoryProvider.future);
  return await repository.getAllItems();
}

// Table orders provider for POS charging flow
@riverpod
Future<List<Map<String, dynamic>>> tableOrdersReadyToCharge(TableOrdersReadyToChargeRef ref) async {
  final repository = await ref.watch(posRepositoryProvider.future);
  return await repository.getTableOrdersReadyToCharge();
}

// Restaurant orders provider for Orders section
@riverpod
Future<List<Map<String, dynamic>>> restaurantOrders(RestaurantOrdersRef ref) async {
  final repository = await ref.watch(posRepositoryProvider.future);
  return await repository.getRestaurantOrders();
}

// Daily transactions provider for Transactions section
@riverpod
Future<List<Map<String, dynamic>>> dailyTransactions(DailyTransactionsRef ref) async {
  final repository = await ref.watch(posRepositoryProvider.future);
  return await repository.getDailyTransactions();
}

// Inventory status provider for Inventory section  
@riverpod
Future<List<Map<String, dynamic>>> inventoryStatus(InventoryStatusRef ref) async {
  final repository = await ref.watch(posRepositoryProvider.future);
  return await repository.getInventoryStatus();
} 