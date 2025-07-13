import 'package:dio/dio.dart';
import 'models/table.dart' as waiter_table;
import '../../core/config/env_config.dart';

class TableRepository {
  final Dio dio;
  TableRepository(this.dio);

  Future<List<waiter_table.Table>> getTables({int? businessId}) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Fetching tables');
      if (businessId != null) print('🪑 TABLE: Business ID: $businessId');
    }

    final queryParams = <String, dynamic>{};
    if (businessId != null) queryParams['businessId'] = businessId;

    final response = await dio.get('/tables', queryParameters: queryParams);

    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Response status: ${response.statusCode}');
      print('🪑 TABLE: Response data: ${response.data}');
    }

    final data = response.data['data'] as List<dynamic>;
    final tables = data.map((json) => waiter_table.Table.fromJson(json)).toList();

    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Parsed ${tables.length} tables');
      for (int i = 0; i < tables.length; i++) {
        final table = tables[i];
        print('🪑 TABLE: Table $i: ${table.tableNumber}, status: ${table.status}, capacity: ${table.capacity}');
      }
    }

    return tables;
  }

  Future<waiter_table.Table> getTable(int tableId) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Fetching table $tableId');
    }

    final response = await dio.get('/tables/$tableId');
    return waiter_table.Table.fromJson(response.data['data']);
  }

  Future<waiter_table.Table> updateTableStatus(int tableId, waiter_table.TableStatus status) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Updating table $tableId status to $status');
    }

    final response = await dio.put(
      '/tables/$tableId/status',
      data: {'status': status.name},
    );

    return waiter_table.Table.fromJson(response.data['data']);
  }

  Future<waiter_table.Table> assignTable(int tableId, int waiterId) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Assigning table $tableId to waiter $waiterId');
    }

    final response = await dio.put(
      '/tables/$tableId/assign',
      data: {'waiterId': waiterId},
    );

    return waiter_table.Table.fromJson(response.data['data']);
  }

  Future<void> clearTable(int tableId) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Clearing table $tableId');
    }

    await dio.post('/tables/$tableId/clear');
  }

  Future<List<waiter_table.Table>> getTablesByStatus(waiter_table.TableStatus status, {int? businessId}) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Fetching tables with status $status');
      if (businessId != null) print('🪑 TABLE: Business ID: $businessId');
    }

    final queryParams = <String, dynamic>{
      'status': status.name,
    };
    if (businessId != null) queryParams['businessId'] = businessId;

    final response = await dio.get(
      '/tables',
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List<dynamic>;
    final tables = data.map((json) => waiter_table.Table.fromJson(json)).toList();

    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Found ${tables.length} tables with status $status');
    }

    return tables;
  }

  Future<List<waiter_table.Table>> getMyAssignedTables(int waiterId, {int? businessId}) async {
    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Fetching tables assigned to waiter $waiterId');
      if (businessId != null) print('🪑 TABLE: Business ID: $businessId');
    }

    final queryParams = <String, dynamic>{
      'assignedWaiterId': waiterId,
    };
    if (businessId != null) queryParams['businessId'] = businessId;

    final response = await dio.get(
      '/tables',
      queryParameters: queryParams,
    );

    final data = response.data['data'] as List<dynamic>;
    final tables = data.map((json) => waiter_table.Table.fromJson(json)).toList();

    if (EnvConfig.isDebugMode) {
      print('🪑 TABLE: Found ${tables.length} tables assigned to waiter $waiterId');
    }

    return tables;
  }
} 