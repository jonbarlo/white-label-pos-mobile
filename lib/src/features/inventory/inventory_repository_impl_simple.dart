import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/category.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';

class InventoryRepositoryImplSimple implements InventoryRepository {
  final Dio _dio;

  InventoryRepositoryImplSimple(this._dio);

  @override
  Future<Result<List<InventoryItem>>> getInventoryItems() async {
    try {
      final response = await _dio.get('/inventory/items');
      
      // Add debug logging
      print('🔍 DEBUG: getInventoryItems response: ${response.data}');
      
      final List<dynamic> data = response.data['data'] ?? response.data;
      
      if (data.isNotEmpty) {
        print('🔍 DEBUG: First inventory item: ${data.first}');
      }
      
      final items = data.map((json) => InventoryItem.fromJson(json)).toList();
      return Result.success(items);
    } catch (e) {
      print('🔍 DEBUG: Error in getInventoryItems: $e');
      return Result.failure('Failed to load inventory items: ${e.toString()}');
    }
  }

  @override
  Future<Result<InventoryItem>> getInventoryItem(String id) async {
    try {
      final response = await _dio.get('/inventory/items/$id');
      final item = InventoryItem.fromJson(response.data);
      return Result.success(item);
    } catch (e) {
      return Result.failure('Failed to load inventory item: ${e.toString()}');
    }
  }

  @override
  Future<Result<InventoryItem>> createInventoryItem(InventoryItem item) async {
    try {
      final response = await _dio.post('/inventory/items', data: item.toJson());
      final createdItem = InventoryItem.fromJson(response.data);
      return Result.success(createdItem);
    } catch (e) {
      return Result.failure('Failed to create inventory item: ${e.toString()}');
    }
  }

  @override
  Future<Result<InventoryItem>> updateInventoryItem(InventoryItem item) async {
    try {
      final response = await _dio.put('/inventory/items/${item.id}', data: item.toJson());
      final updatedItem = InventoryItem.fromJson(response.data);
      return Result.success(updatedItem);
    } catch (e) {
      return Result.failure('Failed to update inventory item: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> deleteInventoryItem(String id) async {
    try {
      await _dio.delete('/inventory/items/$id');
      return Result.success(true);
    } catch (e) {
      return Result.failure('Failed to delete inventory item: ${e.toString()}');
    }
  }

  @override
  Future<Result<InventoryItem>> updateStockLevel(String id, int newQuantity) async {
    try {
      final response = await _dio.patch('/inventory/items/$id/stock', data: {
        'stockQuantity': newQuantity,
      });
      final updatedItem = InventoryItem.fromJson(response.data);
      return Result.success(updatedItem);
    } catch (e) {
      return Result.failure('Failed to update stock level: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<InventoryItem>>> getLowStockItems() async {
    try {
      final response = await _dio.get('/inventory/items/low-stock');
      
      // Add debug logging
      print('🔍 DEBUG: getLowStockItems response: ${response.data}');
      
      final List<dynamic> data = response.data['data'] ?? response.data;
      
      if (data.isNotEmpty) {
        print('🔍 DEBUG: First low stock item: ${data.first}');
      }
      
      final items = data.map((json) => InventoryItem.fromJson(json)).toList();
      return Result.success(items);
    } catch (e) {
      print('🔍 DEBUG: Error in getLowStockItems: $e');
      return Result.failure('Failed to load low stock items: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Category>>> getCategories({required int businessId}) async {
    try {
      final response = await _dio.get('/inventory/categories', queryParameters: {
        'businessId': businessId,
      });
      final List<dynamic> data = response.data['data'] ?? response.data;
      final categories = data.map((json) => Category.fromJson(json)).toList();
      return Result.success(categories);
    } catch (e) {
      return Result.failure('Failed to load categories: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<InventoryItem>>> searchItems(String query) async {
    try {
      final response = await _dio.get('/inventory/items/search', queryParameters: {
        'q': query,
      });
      final List<dynamic> data = response.data['data'] ?? response.data;
      final items = data.map((json) => InventoryItem.fromJson(json)).toList();
      return Result.success(items);
    } catch (e) {
      return Result.failure('Failed to search items: ${e.toString()}');
    }
  }

  @override
  Future<Result<List<InventoryItem>>> getItemsByCategory(String category) async {
    try {
      final response = await _dio.get('/inventory/items', queryParameters: {
        'category': category,
      });
      final List<dynamic> data = response.data['data'] ?? response.data;
      final items = data.map((json) => InventoryItem.fromJson(json)).toList();
      return Result.success(items);
    } catch (e) {
      return Result.failure('Failed to load items by category: ${e.toString()}');
    }
  }
} 