import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/shared/models/api_response.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/core/errors/app_exception.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'models/category.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final Dio _dio;

  InventoryRepositoryImpl(this._dio);

  /// Helper method to parse API response and map fields
  List<InventoryItem> _parseItemsResponse(dynamic responseData) {
    List<dynamic> data;
    
    // Handle both response formats:
    // 1. Direct array: [...]
    // 2. Wrapped response: {"success": true, "data": [...]}
    if (responseData is List<dynamic>) {
      // Direct array format
      data = responseData;
    } else if (responseData is Map<String, dynamic>) {
      // Wrapped response format
      final responseMap = responseData;
      final responseDataList = responseMap['data'] as List<dynamic>?;
      if (responseDataList == null) {
        throw Exception('No items data received from server');
      }
      data = responseDataList;
    } else {
      throw Exception('Unexpected response format from server');
    }
    
    return data.map((json) {
      final itemJson = json as Map<String, dynamic>;
      // Map API field names to model field names
      return InventoryItem.fromJson({
        ...itemJson,
        'stockQuantity': itemJson['stock'] ?? 0, // Map 'stock' to 'stockQuantity'
        'cost': itemJson['cost'] ?? 0.0, // Ensure cost field exists
        'minStockLevel': itemJson['minStockLevel'] ?? 0, // Ensure minStockLevel exists
        'maxStockLevel': itemJson['maxStockLevel'] ?? 100, // Ensure maxStockLevel exists
      });
    }).toList();
  }

  @override
  Future<Result<List<InventoryItem>>> getInventoryItems() async {
    try {
      final response = await _dio.get('/items');
      
      final items = _parseItemsResponse(response.data);
      
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<InventoryItem>> getInventoryItem(String id) async {
    try {
      final response = await _dio.get('/items/$id');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('Item not found');
      }
      
      final item = InventoryItem.fromJson(apiResponse.data!);
      return Result.success(item);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<InventoryItem>> createInventoryItem(InventoryItem item) async {
    try {
      final response = await _dio.post(
        '/items',
        data: item.toJson(),
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('Failed to create item');
      }
      
      final createdItem = InventoryItem.fromJson(apiResponse.data!);
      return Result.success(createdItem);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<InventoryItem>> updateInventoryItem(InventoryItem item) async {
    try {
      final response = await _dio.put(
        '/items/${item.id}',
        data: item.toJson(),
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('Failed to update item');
      }
      
      final updatedItem = InventoryItem.fromJson(apiResponse.data!);
      return Result.success(updatedItem);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<bool>> deleteInventoryItem(String id) async {
    try {
      await _dio.delete('/items/$id');
      return Result.success(true);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<InventoryItem>> updateStockLevel(String id, int newQuantity) async {
    try {
      final response = await _dio.patch(
        '/items/$id/stock',
        data: {'quantity': newQuantity},
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('Failed to update stock');
      }
      
      final updatedItem = InventoryItem.fromJson(apiResponse.data!);
      return Result.success(updatedItem);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<List<InventoryItem>>> searchItems(String query) async {
    try {
      final response = await _dio.get('/items/search', queryParameters: {
        'q': query,
      });
      
      final items = _parseItemsResponse(response.data);
      
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<List<Category>>> getCategories({required int businessId}) async {
    try {
      final response = await _dio.get('/menu/categories', queryParameters: {'businessId': businessId});
      
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => (json as List<dynamic>).map((e) => Category.fromJson(e as Map<String, dynamic>)).toList(),
      );
      
      if (apiResponse.data == null) {
        return Result.failure('No categories found');
      }
      
      final categories = apiResponse.data! as List<Category>;
      return Result.success(categories);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<List<InventoryItem>>> getItemsByCategory(String category) async {
    try {
      final response = await _dio.get('/items/category/$category');
      
      final items = _parseItemsResponse(response.data);
      
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<List<InventoryItem>>> getLowStockItems() async {
    try {
      final response = await _dio.get('/items/low-stock');
      
      final items = _parseItemsResponse(response.data);
      
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }
} 