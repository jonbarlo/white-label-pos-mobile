import 'package:dio/dio.dart';
import 'models/table.dart' as waiter_table;

class TableRepository {
  final Dio dio;
  TableRepository(this.dio);

  Future<List<waiter_table.Table>> getTables({int? businessId}) async {
    final queryParams = <String, dynamic>{};
    if (businessId != null) queryParams['businessId'] = businessId;

    final response = await dio.get('/tables', queryParameters: queryParams);

    // Handle the new response format with success/data structure
    final responseData = response.data;
    List<dynamic> data;
    
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      data = responseData['data'] as List<dynamic>;
    } else if (responseData is List<dynamic>) {
      data = responseData;
    } else {
      throw Exception('Unexpected response format');
    }
    
    final tables = data.map((json) => waiter_table.Table.fromJson(json)).toList();

    return tables;
  }

  Future<waiter_table.Table> getTable(int tableId) async {
    final response = await dio.get('/tables/$tableId');
    final responseData = response.data;
    
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return waiter_table.Table.fromJson(responseData['data']);
    } else {
      return waiter_table.Table.fromJson(responseData);
    }
  }

  Future<waiter_table.Table> updateTableStatus(int tableId, waiter_table.TableStatus status) async {
    final response = await dio.put(
      '/tables/$tableId/status',
      data: {'status': status.name},
    );

    final responseData = response.data;
    
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return waiter_table.Table.fromJson(responseData['data']);
    } else {
      return waiter_table.Table.fromJson(responseData);
    }
  }

  Future<waiter_table.Table> assignTable(int tableId, int waiterId) async {
    final response = await dio.put(
      '/tables/$tableId/assign',
      data: {'waiterId': waiterId},
    );

    final responseData = response.data;
    
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return waiter_table.Table.fromJson(responseData['data']);
    } else {
      return waiter_table.Table.fromJson(responseData);
    }
  }

  Future<void> clearTable(int tableId) async {
    await dio.put(
      '/tables/$tableId/status',
      data: {'status': 'available'},
    );
  }

  Future<List<waiter_table.Table>> getTablesByStatus(waiter_table.TableStatus status, {int? businessId}) async {
    final queryParams = <String, dynamic>{
      'status': status.name,
    };
    if (businessId != null) queryParams['businessId'] = businessId;

    final response = await dio.get(
      '/tables',
      queryParameters: queryParams,
    );

    // Handle the new response format with success/data structure
    final responseData = response.data;
    List<dynamic> data;
    
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      data = responseData['data'] as List<dynamic>;
    } else if (responseData is List<dynamic>) {
      data = responseData;
    } else {
      throw Exception('Unexpected response format');
    }
    
    final tables = data.map((json) => waiter_table.Table.fromJson(json)).toList();

    return tables;
  }

  Future<List<waiter_table.Table>> getMyAssignedTables(int waiterId, {int? businessId}) async {
    final queryParams = <String, dynamic>{
      'assignedWaiterId': waiterId,
    };
    if (businessId != null) queryParams['businessId'] = businessId;

    final response = await dio.get(
      '/tables',
      queryParameters: queryParams,
    );

    // Handle the new response format with success/data structure
    final responseData = response.data;
    List<dynamic> data;
    
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      data = responseData['data'] as List<dynamic>;
    } else if (responseData is List<dynamic>) {
      data = responseData;
    } else {
      throw Exception('Unexpected response format');
    }
    
    final tables = data.map((json) => waiter_table.Table.fromJson(json)).toList();

    return tables;
  }

  Future<void> seatCustomer(int tableId, String customerName, int partySize, String notes) async {
    try {
      final response = await dio.post(
        '/tables/$tableId/seat',
        data: {
          'customerName': customerName,
          'partySize': partySize,
          'notes': notes,
          'status': 'occupied',
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to seat customer: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to seat customer: $msg');
    }
  }
} 