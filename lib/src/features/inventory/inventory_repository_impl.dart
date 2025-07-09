import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  static const String _cacheKey = 'inventory_items_cache';
  static const String _categoriesCacheKey = 'inventory_categories_cache';

  InventoryRepositoryImpl(this._dio, this._prefs);

  @override
  Future<List<InventoryItem>> getInventoryItems() async {
    try {
      final response = await _dio.get('/inventory/items');
      final List<dynamic> data = response.data['data'] ?? response.data;
      final items = data.map((json) => InventoryItem.fromJson(json)).toList();
      
      // Cache the items
      await _cacheItems(items);
      
      return items;
    } on DioException catch (e) {
      // Try to return cached data if available
      final cachedItems = await _getCachedItems();
      if (cachedItems.isNotEmpty) {
        return cachedItems;
      }
      throw Exception('Failed to load inventory items: ${e.message}');
    }
  }

  @override
  Future<InventoryItem> getInventoryItem(String id) async {
    try {
      final response = await _dio.get('/inventory/items/$id');
      return InventoryItem.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load inventory item: ${e.message}');
    }
  }

  @override
  Future<InventoryItem> createInventoryItem(InventoryItem item) async {
    try {
      final response = await _dio.post('/inventory/items', data: item.toJson());
      final createdItem = InventoryItem.fromJson(response.data);
      
      // Update cache
      final cachedItems = await _getCachedItems();
      cachedItems.add(createdItem);
      await _cacheItems(cachedItems);
      
      return createdItem;
    } on DioException catch (e) {
      throw Exception('Failed to create inventory item: ${e.message}');
    }
  }

  @override
  Future<InventoryItem> updateInventoryItem(InventoryItem item) async {
    try {
      final response = await _dio.put('/inventory/items/${item.id}', data: item.toJson());
      final updatedItem = InventoryItem.fromJson(response.data);
      
      // Update cache
      final cachedItems = await _getCachedItems();
      final index = cachedItems.indexWhere((cached) => cached.id == item.id);
      if (index != -1) {
        cachedItems[index] = updatedItem;
        await _cacheItems(cachedItems);
      }
      
      return updatedItem;
    } on DioException catch (e) {
      throw Exception('Failed to update inventory item: ${e.message}');
    }
  }

  @override
  Future<bool> deleteInventoryItem(String id) async {
    try {
      await _dio.delete('/inventory/items/$id');
      
      // Remove from cache
      final cachedItems = await _getCachedItems();
      cachedItems.removeWhere((item) => item.id == id);
      await _cacheItems(cachedItems);
      
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      throw Exception('Failed to delete inventory item: ${e.message}');
    }
  }

  @override
  Future<InventoryItem> updateStockLevel(String id, int newQuantity) async {
    try {
      final response = await _dio.patch('/inventory/items/$id/stock', data: {
        'stockQuantity': newQuantity,
      });
      final updatedItem = InventoryItem.fromJson(response.data);
      
      // Update cache
      final cachedItems = await _getCachedItems();
      final index = cachedItems.indexWhere((cached) => cached.id == id);
      if (index != -1) {
        cachedItems[index] = updatedItem;
        await _cacheItems(cachedItems);
      }
      
      return updatedItem;
    } on DioException catch (e) {
      throw Exception('Failed to update stock level: ${e.message}');
    }
  }

  @override
  Future<List<InventoryItem>> getLowStockItems() async {
    try {
      final response = await _dio.get('/inventory/items/low-stock');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => InventoryItem.fromJson(json)).toList();
    } on DioException catch (e) {
      // Fallback to filtering cached items
      final cachedItems = await _getCachedItems();
      return cachedItems.where((item) => item.isLowStock).toList();
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/inventory/categories');
      final List<dynamic> data = response.data['data'] ?? response.data;
      final categories = data.cast<String>();
      
      // Cache categories
      await _cacheCategories(categories);
      
      return categories;
    } on DioException catch (e) {
      // Try to return cached categories
      final cachedCategories = await _getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        return cachedCategories;
      }
      throw Exception('Failed to load categories: ${e.message}');
    }
  }

  @override
  Future<List<InventoryItem>> searchItems(String query) async {
    try {
      final response = await _dio.get('/inventory/items/search', queryParameters: {
        'q': query,
      });
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => InventoryItem.fromJson(json)).toList();
    } on DioException catch (e) {
      // Fallback to filtering cached items
      final cachedItems = await _getCachedItems();
      final lowercaseQuery = query.toLowerCase();
      return cachedItems.where((item) =>
        item.name.toLowerCase().contains(lowercaseQuery) ||
        item.sku.toLowerCase().contains(lowercaseQuery) ||
        (item.barcode?.toLowerCase().contains(lowercaseQuery) ?? false)
      ).toList();
    }
  }

  @override
  Future<List<InventoryItem>> getItemsByCategory(String category) async {
    try {
      final response = await _dio.get('/inventory/items', queryParameters: {
        'category': category,
      });
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => InventoryItem.fromJson(json)).toList();
    } on DioException catch (e) {
      // Fallback to filtering cached items
      final cachedItems = await _getCachedItems();
      return cachedItems.where((item) => item.category == category).toList();
    }
  }

  // Cache management methods
  Future<void> _cacheItems(List<InventoryItem> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _prefs.setString(_cacheKey, jsonList.toString());
  }

  Future<List<InventoryItem>> _getCachedItems() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString == null) return [];
    
    try {
      // This is a simplified cache implementation
      // In a real app, you'd use proper JSON serialization
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> _cacheCategories(List<String> categories) async {
    await _prefs.setStringList(_categoriesCacheKey, categories);
  }

  Future<List<String>> _getCachedCategories() async {
    return _prefs.getStringList(_categoriesCacheKey) ?? [];
  }
} 