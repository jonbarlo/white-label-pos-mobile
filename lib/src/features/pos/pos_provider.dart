import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'pos_repository.dart';
import 'pos_repository_impl.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/menu_item.dart';
import 'models/split_payment.dart';
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
    } else {
      // Add new item
      state = [...state, item];
    }
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
    if (query.trim().isEmpty) {
      state = [];
      return;
    }

    try {
      final repository = await ref.read(posRepositoryProvider.future);
      final results = await repository.searchItems(query);
      // Convert CartItem results to MenuItem for display
      state = results.map((item) => MenuItem(
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
    } catch (e) {
      // Handle error silently for now, could add error state later
      state = [];
    }
  }

  void clearSearch() {
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
      final sales = await repository.getRecentSales(limit: limit);
      state = sales;
    } catch (e) {
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
    final repository = await ref.read(posRepositoryProvider.future);
    
    // Fetch all available menu items using searchItems which uses _safeMenuItemFromJson
    final cartItems = await repository.searchItems(''); // Empty query to get all items
    
    // Convert CartItem results to MenuItem for display
    // The CartItem objects already have proper image URLs from _safeMenuItemFromJson
    final menuItems = cartItems.map((item) => MenuItem(
      id: int.parse(item.id),
      businessId: ref.read(authNotifierProvider).business?.id ?? 1,
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
    
    print('POS menuItems provider: Created ${menuItems.length} menu items');
    for (final item in menuItems.take(3)) {
      print('  - ${item.name}: image = ${item.image}');
    }
    
    return menuItems;
  } catch (e) {
    print('Error in menuItems provider: $e');
    // Return empty list on error - NO FALLBACK ITEMS
    return [];
  }
} 