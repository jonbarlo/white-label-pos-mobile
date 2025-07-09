import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'mock_data.dart';

/// Mock implementation of InventoryRepository for development
class MockInventoryRepository implements InventoryRepository {
  @override
  Future<Result<List<InventoryItem>>> getInventoryItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(MockData.mockInventoryItems);
  }

  @override
  Future<Result<InventoryItem>> getInventoryItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final item = MockData.mockInventoryItems.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Item not found'),
    );
    return Result.success(item);
  }

  @override
  Future<Result<InventoryItem>> createInventoryItem(InventoryItem item) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // In a real implementation, this would save to the backend
    return Result.success(item);
  }

  @override
  Future<Result<InventoryItem>> updateInventoryItem(InventoryItem item) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // In a real implementation, this would update the backend
    return Result.success(item);
  }

  @override
  Future<Result<bool>> deleteInventoryItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real implementation, this would delete from the backend
    return Result.success(true);
  }

  @override
  Future<Result<InventoryItem>> updateStockLevel(String id, int newQuantity) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final item = MockData.mockInventoryItems.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Item not found'),
    );
    final updatedItem = item.copyWith(stockQuantity: newQuantity);
    return Result.success(updatedItem);
  }

  @override
  Future<Result<List<InventoryItem>>> getLowStockItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowStockItems = MockData.mockInventoryItems.where((item) => item.isLowStock).toList();
    return Result.success(lowStockItems);
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Result.success(MockData.mockCategories);
  }

  @override
  Future<Result<List<InventoryItem>>> searchItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowercaseQuery = query.toLowerCase();
    final results = MockData.mockInventoryItems.where((item) =>
      item.name.toLowerCase().contains(lowercaseQuery) ||
      item.sku.toLowerCase().contains(lowercaseQuery) ||
      (item.barcode?.toLowerCase().contains(lowercaseQuery) ?? false)
    ).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<InventoryItem>>> getItemsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final items = MockData.mockInventoryItems.where((item) => item.category == category).toList();
    return Result.success(items);
  }
} 