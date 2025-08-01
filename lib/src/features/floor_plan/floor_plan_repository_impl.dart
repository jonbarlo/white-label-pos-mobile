import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'floor_plan_repository.dart';
import 'models/floor_plan.dart';

class FloorPlanRepositoryImpl implements FloorPlanRepository {
  final Dio _dio;

  FloorPlanRepositoryImpl(this._dio);

  @override
  Future<Result<List<FloorPlan>>> getFloorPlans() async {
    try {
      print('🔍 DEBUG: FloorPlanRepositoryImpl.getFloorPlans() called');
      final response = await _dio.get('/floor-plans');
      print('🔍 DEBUG: API Response status: ${response.statusCode}');
      print('🔍 DEBUG: API Response data: ${response.data}');
      
      // Handle both response structures: direct array or {success: true, data: [...]}
      List<dynamic> data;
      if (response.data is List) {
        // Direct array response
        data = response.data as List<dynamic>;
        print('🔍 DEBUG: Direct array response, length: ${data.length}');
      } else if (response.data is Map<String, dynamic> && response.data['data'] != null) {
        // Wrapped response
        data = response.data['data'] as List<dynamic>;
        print('🔍 DEBUG: Wrapped response, data length: ${data.length}');
      } else {
        print('🔍 DEBUG: Unexpected response structure: ${response.data.runtimeType}');
        return Result.failure('Unexpected response structure');
      }
      
      print('🔍 DEBUG: Extracted data list length: ${data.length}');
      
      if (data.isNotEmpty) {
        print('🔍 DEBUG: First item in data: ${data.first}');
        print('🔍 DEBUG: First item type: ${data.first.runtimeType}');
        if (data.first is Map<String, dynamic>) {
          final firstItem = data.first as Map<String, dynamic>;
          print('🔍 DEBUG: First item fields:');
          firstItem.forEach((key, value) {
            print('   $key: $value (${value.runtimeType})');
          });
        }
      }
      
      final floorPlans = data.map((json) {
        print('🔍 DEBUG: Processing floor plan JSON: $json');
        return FloorPlan.fromJson(json);
      }).toList();
      
      print('🔍 DEBUG: Successfully parsed ${floorPlans.length} floor plans');
      return Result.success(floorPlans);
    } on DioException catch (e) {
      print('🔍 DEBUG: DioException in getFloorPlans: ${e.message}');
      return Result.failure(e.message ?? 'Failed to fetch floor plans');
    } catch (e) {
      print('🔍 DEBUG: Unexpected error in getFloorPlans: $e');
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<FloorPlan>> getFloorPlan(int id) async {
    try {
      final response = await _dio.get('/floor-plans/$id');
      final floorPlan = FloorPlan.fromJson(response.data['data'] ?? response.data);
      return Result.success(floorPlan);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch floor plan');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<FloorPlan>> createFloorPlan(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/floor-plans', data: data);
      final floorPlan = FloorPlan.fromJson(response.data['data'] ?? response.data);
      return Result.success(floorPlan);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to create floor plan');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<FloorPlan>> updateFloorPlan(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/floor-plans/$id', data: data);
      final floorPlan = FloorPlan.fromJson(response.data['data'] ?? response.data);
      return Result.success(floorPlan);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to update floor plan');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<void>> deleteFloorPlan(int id) async {
    try {
      await _dio.delete('/floor-plans/$id');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to delete floor plan');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<FloorPlan>> getFloorPlanWithTables(int id) async {
    try {
      final response = await _dio.get('/floor-plans/$id/tables');
      final floorPlan = FloorPlan.fromJson(response.data['data'] ?? response.data);
      return Result.success(floorPlan);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch floor plan with tables');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<List<TablePosition>>> getAvailableTables(int floorPlanId) async {
    try {
      final response = await _dio.get('/floor-plans/$floorPlanId/available-tables');
      final List<dynamic> data = response.data['data'] ?? [];
      final tablePositions = data.map((json) => TablePosition.fromJson(json)).toList();
      return Result.success(tablePositions);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch available tables');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<TablePosition>> updateTablePosition(int floorPlanId, int tableId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/floor-plans/$floorPlanId/tables/$tableId/position', data: data);
      final tablePosition = TablePosition.fromJson(response.data['data'] ?? response.data);
      return Result.success(tablePosition);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to update table position');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<void>> removeTableFromFloorPlan(int floorPlanId, int tableId) async {
    try {
      await _dio.delete('/floor-plans/$floorPlanId/tables/$tableId');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to remove table from floor plan');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  // Table position management methods
  @override
  Future<Result<List<TablePosition>>> getTablePositions(int floorPlanId) async {
    try {
      final response = await _dio.get('/floor-plans/$floorPlanId/table-positions');
      final List<dynamic> data = response.data['data'] ?? [];
      final tablePositions = data.map((json) => TablePosition.fromJson(json)).toList();
      return Result.success(tablePositions);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch table positions');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<TablePosition>> createTablePosition(int floorPlanId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/floor-plans/$floorPlanId/table-positions', data: data);
      
      // Add debug logging
      print('🔍 DEBUG: createTablePosition response: ${response.data}');
      
      // Check if response indicates an error
      if (response.data is Map<String, dynamic> && response.data['success'] == false) {
        final errorMessage = response.data['error']?['message'] ?? 'API returned error';
        return Result.failure(errorMessage);
      }
      
      final responseData = response.data['data'] ?? response.data;
      
      // Validate response data before parsing
      if (responseData == null) {
        return Result.failure('Invalid response: no data received');
      }
      
      if (responseData is! Map<String, dynamic>) {
        return Result.failure('Invalid response format: expected Map, got ${responseData.runtimeType}');
      }
      
      final tablePosition = TablePosition.fromJson(responseData);
      return Result.success(tablePosition);
    } on DioException catch (e) {
      print('🔍 DEBUG: DioException in createTablePosition: ${e.message}');
      return Result.failure(e.message ?? 'Failed to create table position');
    } catch (e) {
      print('🔍 DEBUG: Unexpected error in createTablePosition: $e');
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<TablePosition>> updateTablePositionById(int floorPlanId, int positionId, Map<String, dynamic> data) async {
    try {
      // Use the correct endpoint: /tables/{tableId}/position instead of /table-positions/{positionId}
      final response = await _dio.put('/floor-plans/$floorPlanId/tables/$positionId/position', data: data);
      
      // Add debug logging
      print('🔍 DEBUG: updateTablePositionById response: ${response.data}');
      
      // Check if response indicates an error
      if (response.data is Map<String, dynamic> && response.data['success'] == false) {
        final errorMessage = response.data['error']?['message'] ?? 'API returned error';
        return Result.failure(errorMessage);
      }
      
      final responseData = response.data['data'] ?? response.data;
      
      // Validate response data before parsing
      if (responseData == null) {
        return Result.failure('Invalid response: no data received');
      }
      
      if (responseData is! Map<String, dynamic>) {
        return Result.failure('Invalid response format: expected Map, got ${responseData.runtimeType}');
      }
      
      final tablePosition = TablePosition.fromJson(responseData);
      return Result.success(tablePosition);
    } on DioException catch (e) {
      print('🔍 DEBUG: DioException in updateTablePositionById: ${e.message}');
      return Result.failure(e.message ?? 'Failed to update table position');
    } catch (e) {
      print('🔍 DEBUG: Unexpected error in updateTablePositionById: $e');
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<void>> deleteTablePosition(int floorPlanId, int positionId) async {
    try {
      await _dio.delete('/floor-plans/$floorPlanId/table-positions/$positionId');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to delete table position');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  // Table management methods
  @override
  Future<Result<Map<String, dynamic>>> createTable(Map<String, dynamic> tableData) async {
    try {
      final response = await _dio.post('/tables', data: tableData);
      final table = response.data['data'] ?? response.data;
      return Result.success(Map<String, dynamic>.from(table));
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to create table');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> updateTable(int tableId, Map<String, dynamic> tableData) async {
    try {
      final response = await _dio.put('/tables/$tableId', data: tableData);
      final table = response.data['data'] ?? response.data;
      return Result.success(Map<String, dynamic>.from(table));
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to update table');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<void>> deleteTable(int tableId) async {
    try {
      await _dio.delete('/tables/$tableId');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to delete table');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> updateTableStatus(int tableId, String status) async {
    try {
      final response = await _dio.patch('/tables/$tableId/status', data: {'status': status});
      final table = response.data['data'] ?? response.data;
      return Result.success(Map<String, dynamic>.from(table));
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to update table status');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllTables({String? status, String? section, int? capacity}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (section != null) queryParams['section'] = section;
      if (capacity != null) queryParams['capacity'] = capacity;

      final response = await _dio.get('/tables', queryParameters: queryParams);
      final List<dynamic> data = response.data['data'] ?? [];
      final tables = data.map((json) => Map<String, dynamic>.from(json)).toList();
      return Result.success(tables);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch tables');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }
} 