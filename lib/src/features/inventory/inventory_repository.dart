import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';

abstract class InventoryRepository {
  /// Get all inventory items
  Future<List<InventoryItem>> getInventoryItems();

  /// Get a specific inventory item by ID
  Future<InventoryItem> getInventoryItem(String id);

  /// Create a new inventory item
  Future<InventoryItem> createInventoryItem(InventoryItem item);

  /// Update an existing inventory item
  Future<InventoryItem> updateInventoryItem(InventoryItem item);

  /// Delete an inventory item
  Future<bool> deleteInventoryItem(String id);

  /// Update stock level for an item
  Future<InventoryItem> updateStockLevel(String id, int newQuantity);

  /// Get items with low stock (below minimum stock level)
  Future<List<InventoryItem>> getLowStockItems();

  /// Get all available categories
  Future<List<String>> getCategories();

  /// Search inventory items by name, SKU, or barcode
  Future<List<InventoryItem>> searchItems(String query);

  /// Get items by category
  Future<List<InventoryItem>> getItemsByCategory(String category);
} 