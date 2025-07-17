import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'models/floor_plan.dart';

abstract class FloorPlanRepository {
  Future<Result<List<FloorPlan>>> getFloorPlans();
  Future<Result<FloorPlan>> getFloorPlan(int id);
  Future<Result<FloorPlan>> createFloorPlan(Map<String, dynamic> data);
  Future<Result<FloorPlan>> updateFloorPlan(int id, Map<String, dynamic> data);
  Future<Result<void>> deleteFloorPlan(int id);
  Future<Result<FloorPlan>> getFloorPlanWithTables(int id);
  Future<Result<List<TablePosition>>> getAvailableTables(int floorPlanId);
  Future<Result<TablePosition>> updateTablePosition(int floorPlanId, int tableId, Map<String, dynamic> data);
  Future<Result<void>> removeTableFromFloorPlan(int floorPlanId, int tableId);
  
  // Table position management methods
  Future<Result<List<TablePosition>>> getTablePositions(int floorPlanId);
  Future<Result<TablePosition>> createTablePosition(int floorPlanId, Map<String, dynamic> data);
  Future<Result<TablePosition>> updateTablePositionById(int floorPlanId, int positionId, Map<String, dynamic> data);
  Future<Result<void>> deleteTablePosition(int floorPlanId, int positionId);
  
  // Table management methods
  Future<Result<Map<String, dynamic>>> createTable(Map<String, dynamic> tableData);
  Future<Result<Map<String, dynamic>>> updateTable(int tableId, Map<String, dynamic> tableData);
  Future<Result<void>> deleteTable(int tableId);
  Future<Result<Map<String, dynamic>>> updateTableStatus(int tableId, String status);
  Future<Result<List<Map<String, dynamic>>>> getAllTables({String? status, String? section, int? capacity});
} 