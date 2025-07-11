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

  @override
  Future<Result<List<InventoryItem>>> getInventoryItems() async {
    try {
      final response = await _dio.get('/items');
      final data = response.data as List<dynamic>?;
      if (data == null) {
        return Result.failure('No data received from server');
      }
      final items = data
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
      final data = response.data as List<dynamic>?;
      if (data == null) {
        return Result.failure('No search results found');
      }
      final items = data
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
  Future<Result<List<Category>>> getCategories({required int businessId}) async {
    try {
      print('🔍 REPOSITORY DEBUG: Making GET request to /menu/categories with businessId: $businessId');
      print('🔍 REPOSITORY DEBUG: Query parameters: {"businessId": $businessId}');
      
      final response = await _dio.get('/menu/categories', queryParameters: {'businessId': businessId});
      
      print('🔍 REPOSITORY DEBUG: Response status:  [32m${response.statusCode} [0m');
      print('🔍 REPOSITORY DEBUG: Response data: ${response.data}');
      
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (json) => (json as List<dynamic>).map((e) => Category.fromJson(e as Map<String, dynamic>)).toList(),
      );
      
      if (apiResponse.data == null) {
        print('❌ REPOSITORY DEBUG: No categories found in response');
        return Result.failure('No categories found');
      }
      
      final categories = apiResponse.data! as List<Category>;
      print('🔍 REPOSITORY DEBUG: Parsed categories: $categories');
      return Result.success(categories);
    } on DioException catch (e) {
      print('❌ REPOSITORY DEBUG: DioException caught: ${e.message}');
      print('❌ REPOSITORY DEBUG: DioException type: ${e.type}');
      print('❌ REPOSITORY DEBUG: DioException response: ${e.response?.data}');
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      print('❌ REPOSITORY DEBUG: General exception caught: $e');
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<List<InventoryItem>>> getItemsByCategory(String category) async {
    try {
      final response = await _dio.get('/items/category/$category');
      final data = response.data as List<dynamic>?;
      if (data == null) {
        return Result.failure('No items found in category');
      }
      final items = data
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
      final response = await _dio.get('/items/low-stock');
      final data = response.data as List<dynamic>?;
      if (data == null) {
        return Result.failure('No low stock items found');
      }
      final items = data
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