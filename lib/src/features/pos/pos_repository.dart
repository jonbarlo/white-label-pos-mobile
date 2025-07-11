import 'models/cart_item.dart';
import 'models/sale.dart';
import 'models/split_payment.dart';

abstract class PosRepository {
  /// Search for items by name, SKU, or description
  Future<List<CartItem>> searchItems(String query);

  /// Get item by barcode
  Future<CartItem?> getItemByBarcode(String barcode);

  /// Create a new sale transaction
  Future<Sale> createSale({
    required List<CartItem> items,
    required PaymentMethod paymentMethod,
    String? customerName,
    String? customerEmail,
  });

  /// Get recent sales for the current business
  Future<List<Sale>> getRecentSales({int limit = 50});

  /// Get sales summary for a specific date range
  Future<Map<String, dynamic>> getSalesSummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get top selling items
  Future<List<CartItem>> getTopSellingItems({int limit = 10});

  /// Update item stock levels after sale
  Future<void> updateStockLevels(List<CartItem> items);

  // Split payment methods
  /// Create a sale with split payments
  Future<SplitSaleResponse> createSplitSale(SplitSaleRequest request);

  /// Add payment to existing sale
  Future<SplitSale> addPaymentToSale(int saleId, AddPaymentRequest request);

  /// Refund a split payment
  Future<SplitSale> refundSplitPayment(int saleId, RefundRequest request);

  /// Get split billing statistics
  Future<SplitBillingStats> getSplitBillingStats();
} 