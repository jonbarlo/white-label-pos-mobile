import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';
import 'floor_plan_repository.dart';
import 'floor_plan_repository_impl.dart';
import 'models/floor_plan.dart';

// Repository provider
final floorPlanRepositoryProvider = Provider<FloorPlanRepository>((ref) {
  print('🔍 DEBUG: floorPlanRepositoryProvider: Creating FloorPlanRepositoryImpl');
  final dio = ref.watch(dioClientProvider);
  print('🔍 DEBUG: floorPlanRepositoryProvider: Dio client = $dio');
  return FloorPlanRepositoryImpl(dio);
});

// Floor plans list provider
final floorPlansProvider = FutureProvider<Result<List<FloorPlan>>>((ref) async {
  final repository = ref.watch(floorPlanRepositoryProvider);
  return await repository.getFloorPlans();
});

// Floor plans with tables provider
final floorPlansWithTablesProvider = FutureProvider<Result<List<FloorPlan>>>((ref) async {
  print('🔍 DEBUG: floorPlansWithTablesProvider: Starting to load floor plans with tables');
  final repository = ref.watch(floorPlanRepositoryProvider);
  
  // Add timestamp to force fresh data
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  print('🔍 DEBUG: floorPlansWithTablesProvider: Timestamp: $timestamp');
  
  final floorPlansResult = await repository.getFloorPlans();
  
  if (!floorPlansResult.isSuccess) {
    print('🔍 DEBUG: floorPlansWithTablesProvider: Failed to get floor plans: ${floorPlansResult.errorMessage}');
    return floorPlansResult;
  }
  
  final floorPlans = floorPlansResult.data;
  print('🔍 DEBUG: floorPlansWithTablesProvider: Got ${floorPlans.length} floorPlans');
  final floorPlansWithTables = <FloorPlan>[];
  
  for (final floorPlan in floorPlans) {
    try {
      print('🔍 DEBUG: floorPlansWithTablesProvider: Loading tables for floor plan ${floorPlan.id} (${floorPlan.name})');
      // Use the correct endpoint: /floor-plans/{id}/tables
      final tablesResult = await repository.getFloorPlanWithTables(floorPlan.id);
      if (tablesResult.isSuccess) {
        // The floor plan already includes tables from the API
        final floorPlanWithTables = tablesResult.data;
        print('🔍 DEBUG: floorPlansWithTablesProvider: Floor plan ${floorPlan.id} has ${floorPlanWithTables.tables?.length ?? 0} tables');
        
        // Debug: Print table statuses
        if (floorPlanWithTables.tables != null) {
          for (final table in floorPlanWithTables.tables!) {
            print('🔍 DEBUG: floorPlansWithTablesProvider: Table ${table.tableNumber} (ID: ${table.tableId}) status: ${table.tableStatus}');
          }
        }
        floorPlansWithTables.add(floorPlanWithTables);
      } else {
        print('🔍 DEBUG: floorPlansWithTablesProvider: Failed to get tables for floor plan ${floorPlan.id}: ${tablesResult.errorMessage}');
        // If we cant get tables, add the floor plan without tables
        floorPlansWithTables.add(floorPlan);
      }
    } catch (e) {
      print('🔍 DEBUG: Error loading tables for floor plan ${floorPlan.id}: $e');
      // Add the floor plan without tables if there's an error
      floorPlansWithTables.add(floorPlan);
    }
  }
  
  print('🔍 DEBUG: Created ${floorPlansWithTables.length} floor plans with tables');
  return Result.success(floorPlansWithTables);
});

// Single floor plan provider
final floorPlanProvider = FutureProvider.family<Result<FloorPlan>, int>((ref, id) async {
  final repository = ref.watch(floorPlanRepositoryProvider);
  return await repository.getFloorPlan(id);
});

// Floor plan with tables provider
final floorPlanWithTablesProvider = FutureProvider.family<Result<FloorPlan>, int>((ref, id) async {
  final repository = ref.watch(floorPlanRepositoryProvider);
  return await repository.getFloorPlanWithTables(id);
});

// Available tables provider
final availableTablesProvider = FutureProvider.family<Result<List<TablePosition>>, int>((ref, floorPlanId) async {
  final repository = ref.watch(floorPlanRepositoryProvider);
  return await repository.getAvailableTables(floorPlanId);
});

// Table positions provider for a specific floor plan
final tablePositionsProvider = FutureProvider.family<Result<List<TablePosition>>, int>((ref, floorPlanId) async {
  final repository = ref.watch(floorPlanRepositoryProvider);
  return await repository.getTablePositions(floorPlanId);
});

// All tables provider
final allTablesProvider = FutureProvider<Result<List<Map<String, dynamic>>>>((ref) async {
  final repository = ref.watch(floorPlanRepositoryProvider);
  return await repository.getAllTables();
});

// Floor plan notifier for CRUD operations
class FloorPlanNotifier extends StateNotifier<AsyncValue<Result<List<FloorPlan>>>> {
  final FloorPlanRepository _repository;

  FloorPlanNotifier(this._repository) : super(const AsyncValue.loading()) {
    print('🔍 DEBUG: FloorPlanNotifier constructor called');
    _loadFloorPlans();
  }

  Future<void> _loadFloorPlans() async {
    print('🔍 DEBUG: FloorPlanNotifier._loadFloorPlans() called');
    state = const AsyncValue.loading();
    try {
      print('🔍 DEBUG: FloorPlanNotifier: Calling repository.getFloorPlans()');
      final result = await _repository.getFloorPlans();
      print('🔍 DEBUG: FloorPlanNotifier: Repository result: $result');
      state = AsyncValue.data(result);
      print('🔍 DEBUG: FloorPlanNotifier: State updated with result');
    } catch (e, stack) {
      print('🔍 DEBUG: FloorPlanNotifier: Error occurred: $e');
      print('🔍 DEBUG: FloorPlanNotifier: Stack trace: $stack');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    print('🔍 DEBUG: FloorPlanNotifier.refresh() called');
    await _loadFloorPlans();
  }

  Future<void> createFloorPlan(Map<String, dynamic> data) async {
    try {
      final result = await _repository.createFloorPlan(data);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateFloorPlan(int id, Map<String, dynamic> data) async {
    try {
      final result = await _repository.updateFloorPlan(id, data);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteFloorPlan(int id) async {
    try {
      final result = await _repository.deleteFloorPlan(id);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Table management methods
  Future<Result<Map<String, dynamic>>> createTable(Map<String, dynamic> tableData) async {
    try {
      final result = await _repository.createTable(tableData);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list to show new table
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to create table: $e');
    }
  }

  Future<Result<Map<String, dynamic>>> updateTable(int tableId, Map<String, dynamic> tableData) async {
    try {
      final result = await _repository.updateTable(tableId, tableData);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list to show updated table
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to update table: $e');
    }
  }

  Future<Result<void>> deleteTable(int tableId) async {
    try {
      final result = await _repository.deleteTable(tableId);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list to show removed table
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to delete table: $e');
    }
  }

  Future<Result<Map<String, dynamic>>> updateTableStatus(int tableId, String status) async {
    try {
      final result = await _repository.updateTableStatus(tableId, status);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list to show updated status
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to update table status: $e');
    }
  }

  Future<Result<void>> bulkUpdateTables(List<int> tableIds, String? newStatus, String? newSection) async {
    try {
      bool hasUpdates = false;
      
      for (final tableId in tableIds) {
        final updateData = <String, dynamic>{};
        if (newStatus != null) updateData['status'] = newStatus;
        if (newSection != null) updateData['section'] = newSection;
        
        if (updateData.isNotEmpty) {
          final result = await _repository.updateTable(tableId, updateData);
          if (result.isSuccess) {
            hasUpdates = true;
          }
        }
      }
      
      if (hasUpdates) {
        await _loadFloorPlans(); // Refresh the list to show updated tables
      }
      
      return Result.success(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to bulk update tables: $e');
    }
  }

  // Table position management methods
  Future<Result<List<TablePosition>>> getTablePositions(int floorPlanId) async {
    try {
      return await _repository.getTablePositions(floorPlanId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to get table positions: $e');
    }
  }

  Future<Result<TablePosition>> createTablePosition(int floorPlanId, Map<String, dynamic> data) async {
    try {
      final result = await _repository.createTablePosition(floorPlanId, data);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list to show new table position
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to create table position: $e');
    }
  }

  Future<Result<TablePosition>> updateTablePosition(int floorPlanId, int positionId, Map<String, dynamic> data) async {
    try {
      final result = await _repository.updateTablePositionById(floorPlanId, positionId, data);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list to show updated table position
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to update table position: $e');
    }
  }

  Future<Result<void>> deleteTablePosition(int floorPlanId, int positionId) async {
    try {
      final result = await _repository.deleteTablePosition(floorPlanId, positionId);
      if (result.isSuccess) {
        await _loadFloorPlans(); // Refresh the list to show removed table position
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return Result.failure('Failed to delete table position: $e');
    }
  }
}

final floorPlanNotifierProvider = StateNotifierProvider<FloorPlanNotifier, AsyncValue<Result<List<FloorPlan>>>>((ref) {
  print('🔍 DEBUG: floorPlanNotifierProvider: Creating FloorPlanNotifier');
  final repository = ref.watch(floorPlanRepositoryProvider);
  print('🔍 DEBUG: floorPlanNotifierProvider: Repository = $repository');
  final notifier = FloorPlanNotifier(repository);
  print('🔍 DEBUG: floorPlanNotifierProvider: FloorPlanNotifier created = $notifier');
  return notifier;
}); 