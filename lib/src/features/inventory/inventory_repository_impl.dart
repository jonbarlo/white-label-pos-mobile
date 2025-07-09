import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/shared/models/api_response.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/core/errors/app_exception.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final Dio _dio;

  InventoryRepositoryImpl(this._dio);

  @override
  Future<Result<List<InventoryItem>>> getInventoryItems() async {
    try {
      final response = await _dio.get('/inventory/items');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('No data received from server');
      }
      
      final items = apiResponse.data!
          .map((json) => InventoryItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
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
      final response = await _dio.get('/inventory/items/$id');
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
        '/inventory/items',
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
        '/inventory/items/${item.id}',
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
      await _dio.delete('/inventory/items/$id');
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
        '/inventory/items/$id/stock',
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
      final response = await _dio.get('/inventory/items/search', queryParameters: {
        'q': query,
      });
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('No search results found');
      }
      
      final items = apiResponse.data!
          .map((json) => InventoryItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    try {
      final response = await _dio.get('/inventory/categories');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('No categories found');
      }
      
      final categories = apiResponse.data!.cast<String>();
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
      final response = await _dio.get('/inventory/items/category/$category');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('No items found in category');
      }
      
      final items = apiResponse.data!
          .map((json) => InventoryItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
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
      final response = await _dio.get('/inventory/items/low-stock');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => json as List<dynamic>,
      );
      
      if (apiResponse.data == null) {
        return Result.failure('No low stock items found');
      }
      
      final items = apiResponse.data!
          .map((json) => InventoryItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return Result.success(items);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }
} 