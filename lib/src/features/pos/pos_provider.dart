import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'pos_repository.dart';
import 'pos_repository_impl.dart';
import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/menu_item.dart';

part 'pos_provider.g.dart';

@riverpod
Future<PosRepository> posRepository(PosRepositoryRef ref) async {
  final dio = Dio();
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

  return sale;
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