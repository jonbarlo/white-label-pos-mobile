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

  Future<void> createReservation(int tableId, String customerName, String customerPhone, int partySize, String reservationDate, String reservationTime, String notes) async {
    try {
      print('🔍 DEBUG: Creating reservation for table $tableId');
      print('🔍 DEBUG: customerName: $customerName, partySize: $partySize, date: $reservationDate, time: $reservationTime');
      
      final response = await dio.post(
        '/tables/$tableId/reservations',
        data: {
          'customerName': customerName,
          'customerPhone': customerPhone,
          'partySize': partySize,
          'reservationDate': reservationDate,
          'reservationTime': reservationTime,
          'specialRequests': notes,
        },
      );
      
      print('🔍 DEBUG: Reservation response: ${response.data}');
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create reservation: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('🔍 DEBUG: DioException in createReservation: ${e.message}');
      print('🔍 DEBUG: Response data: ${e.response?.data}');
      final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw Exception('Failed to create reservation: $msg');
    } catch (e) {
      print('🔍 DEBUG: General exception in createReservation: $e');
      throw Exception('Failed to create reservation: $e');
    }
  }

  Future<void> seatCustomer(int tableId, String customerName, int partySize, String notes, {int? serverId, String? customerPhone, String? customerEmail}) async {
    try {
      print('🔍 DEBUG: Seating customer at table $tableId');
      print('🔍 DEBUG: customerName: $customerName, partySize: $partySize, notes: $notes');
      print('🔍 DEBUG: customerPhone: $customerPhone, customerEmail: $customerEmail');
      print('🔍 DEBUG: Using serverId: $serverId');
      
      final requestData = {
        'partySize': partySize,
        'serverId': serverId,
        'notes': notes,
        'customerName': customerName,
        'customerPhone': customerPhone ?? '',
        'customerEmail': customerEmail ?? '',
      };
      
      final response = await dio.post(
        '/tables/$tableId/seat',
        data: requestData,
      );
      
      print('🔍 DEBUG: Seating response: ${response.data}');
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to seat customer: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('🔍 DEBUG: DioException in seatCustomer: ${e.message}');
      print('🔍 DEBUG: Response data: ${e.response?.data}');
      final msg = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw Exception('Failed to seat customer: $msg');
    } catch (e) {
      print('🔍 DEBUG: General exception in seatCustomer: $e');
      throw Exception('Failed to seat customer: $e');
    }
  }

  Future<List<waiter_table.Table>> getTablesWithOrders({int? businessId}) async {
    final queryParams = <String, dynamic>{};
    if (businessId != null) queryParams['businessId'] = businessId;

    final response = await dio.get('/tables/tables-with-orders', queryParameters: queryParams);

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
} 