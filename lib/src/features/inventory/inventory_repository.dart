import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'models/category.dart';

abstract class InventoryRepository {
  /// Get all inventory items
  Future<Result<List<InventoryItem>>> getInventoryItems();

  /// Get a specific inventory item by ID
  Future<Result<InventoryItem>> getInventoryItem(String id);

  /// Create a new inventory item
  Future<Result<InventoryItem>> createInventoryItem(InventoryItem item);

  /// Update an existing inventory item
  Future<Result<InventoryItem>> updateInventoryItem(InventoryItem item);

  /// Delete an inventory item
  Future<Result<bool>> deleteInventoryItem(String id);

  /// Update stock level for an item
  Future<Result<InventoryItem>> updateStockLevel(String id, int newQuantity);

  /// Get items with low stock (below minimum stock level)
  Future<Result<List<InventoryItem>>> getLowStockItems();

  /// Get all available categories
  Future<Result<List<Category>>> getCategories({required int businessId});

  /// Search inventory items by name, SKU, or barcode
  Future<Result<List<InventoryItem>>> searchItems(String query);

  /// Get items by category
  Future<Result<List<InventoryItem>>> getItemsByCategory(String category);
} 