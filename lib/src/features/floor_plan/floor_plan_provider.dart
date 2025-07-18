import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'floor_plan_repository.dart';
import 'floor_plan_repository_impl.dart';
import 'models/floor_plan.dart';
import 'dart:async'; // Added for Timer


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

// Reservations provider
final reservationsProvider = FutureProvider<Result<List<Map<String, dynamic>>>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  final authState = ref.watch(authNotifierProvider);
  
  if (authState.status != AuthStatus.authenticated) {
    return Result.failure('Not authenticated');
  }
  
  try {
    final response = await dio.get('/reservations');
    final reservations = response.data as List;
    return Result.success(reservations.cast<Map<String, dynamic>>());
  } catch (e) {
    print('🔍 DEBUG: Error fetching reservations: $e');
    return Result.failure('Failed to fetch reservations: $e');
  }
});

// Floor plans with tables and reservations provider
final floorPlansWithTablesAndReservationsProvider = FutureProvider<Result<List<FloorPlan>>>((ref) async {
  print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Starting to load floor plans with tables and reservations');
  final repository = ref.watch(floorPlanRepositoryProvider);
  
  // Get floor plans with tables
  final floorPlansResult = await repository.getFloorPlans();
  
  if (!floorPlansResult.isSuccess) {
    print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Failed to get floor plans: ${floorPlansResult.errorMessage}');
    return floorPlansResult;
  }
  
  final floorPlans = floorPlansResult.data;
  print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Got ${floorPlans.length} floorPlans');
  
  // Get reservations
  final reservationsResult = await ref.read(reservationsProvider.future);
  final reservations = reservationsResult.isSuccess ? reservationsResult.data : <Map<String, dynamic>>[];
  print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Got ${reservations.length} reservations');
  
  // Create a map of tableId to reservation for quick lookup
  final reservationMap = <int, Map<String, dynamic>>{};
  for (final reservation in reservations) {
    final tableId = reservation['tableId'] as int?;
    if (tableId != null) {
      reservationMap[tableId] = reservation;
    }
  }
  
  final floorPlansWithTables = <FloorPlan>[];
  
  for (final floorPlan in floorPlans) {
    try {
      print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Loading tables for floor plan ${floorPlan.id} (${floorPlan.name})');
      final tablesResult = await repository.getFloorPlanWithTables(floorPlan.id);
      if (tablesResult.isSuccess) {
        final floorPlanWithTables = tablesResult.data;
        print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Floor plan ${floorPlan.id} has ${floorPlanWithTables.tables?.length ?? 0} tables');
        
        // Add reservation data to reserved tables
        if (floorPlanWithTables.tables != null) {
          final updatedTables = <TablePosition>[];
          for (final table in floorPlanWithTables.tables!) {
            print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Table ${table.tableNumber} (ID: ${table.tableId}) status: ${table.tableStatus}');
            
            if (table.tableStatus.toLowerCase() == 'reserved' && reservationMap.containsKey(table.tableId)) {
              final reservationData = reservationMap[table.tableId]!;
              print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Found reservation for table ${table.tableNumber}: ${reservationData['customerName']}');
              
              // Create reservation object
              final reservation = Reservation(
                customerName: reservationData['customerName'] ?? 'Unknown',
                customerPhone: reservationData['customerPhone'],
                partySize: reservationData['partySize'] ?? 1,
                reservationDate: reservationData['reservationDate'] ?? DateTime.now().toIso8601String().split('T')[0],
                reservationTime: reservationData['reservationTime'] ?? '19:00',
                notes: reservationData['notes'],
              );
              
              // Create updated table with reservation
              final updatedTable = table.copyWith(reservation: reservation);
              updatedTables.add(updatedTable);
            } else {
              updatedTables.add(table);
            }
          }
          
          // Create updated floor plan with tables that have reservation data
          final updatedFloorPlan = FloorPlan(
            id: floorPlanWithTables.id,
            businessId: floorPlanWithTables.businessId,
            name: floorPlanWithTables.name,
            width: floorPlanWithTables.width,
            height: floorPlanWithTables.height,
            backgroundImage: floorPlanWithTables.backgroundImage,
            isActive: floorPlanWithTables.isActive,
            tableCount: updatedTables.length,
            tables: updatedTables,
            createdAt: floorPlanWithTables.createdAt,
            updatedAt: floorPlanWithTables.updatedAt,
          );
          floorPlansWithTables.add(updatedFloorPlan);
        } else {
          floorPlansWithTables.add(floorPlanWithTables);
        }
      } else {
        print('🔍 DEBUG: floorPlansWithTablesAndReservationsProvider: Failed to get tables for floor plan ${floorPlan.id}: ${tablesResult.errorMessage}');
        floorPlansWithTables.add(floorPlan);
      }
    } catch (e) {
      print('🔍 DEBUG: Error loading tables for floor plan ${floorPlan.id}: $e');
      floorPlansWithTables.add(floorPlan);
    }
  }
  
  print('🔍 DEBUG: Created ${floorPlansWithTables.length} floor plans with tables and reservations');
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

// Tables provider using /api/tables as single source of truth
final tablesProvider = FutureProvider<Result<List<Map<String, dynamic>>>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  final authState = ref.watch(authNotifierProvider);
  
  if (authState.status != AuthStatus.authenticated) {
    return Result.failure('Not authenticated');
  }
  
  try {
    print('🔍 DEBUG: Fetching tables from /api/tables');
    final repository = FloorPlanRepositoryImpl(dio);
    final result = await repository.getAllTables();
    print('🔍 DEBUG: Tables API response: ${result.isSuccess ? 'Success' : 'Failed'}');
    if (result.isSuccess) {
      print('🔍 DEBUG: Found ${result.data!.length} tables');
      // Log reservation data for debugging
      for (final table in result.data!) {
        if (table['status'] == 'reserved' && table['reservation'] != null) {
          final reservation = table['reservation'] as Map<String, dynamic>;
          print('🔍 DEBUG: Table ${table['tableNumber']} has reservation:');
          print('   - Customer: ${reservation['customerName']}');
          print('   - Email: ${reservation['customerEmail']}');
          print('   - Phone: ${reservation['customerPhone']}');
          print('   - Party Size: ${reservation['partySize']}');
          print('   - Date: ${reservation['reservationDate']}');
          print('   - Time: ${reservation['reservationTime']}');
          print('   - Status: ${reservation['status']}');
          if (reservation['customer'] != null) {
            final customer = reservation['customer'] as Map<String, dynamic>;
            print('   - Customer Preferences: ${customer['preferences']}');
          }
          print('   - Notes: ${reservation['notes']}');
        }
      }
    }
    return result;
  } catch (e) {
    print('🔍 DEBUG: Error fetching tables: $e');
    return Result.failure('Failed to fetch tables: $e');
  }
});

// Real-time tables provider with auto-refresh every 30 seconds
final realtimeTablesProvider = StreamProvider<Result<List<Map<String, dynamic>>>>((ref) async* {
  final authState = ref.watch(authNotifierProvider);
  
  if (authState.status != AuthStatus.authenticated) {
    yield Result.failure('Not authenticated');
    return;
  }
  
  // Initial load
  final initialResult = await ref.read(tablesProvider.future);
  yield initialResult;
  
  // Set up periodic refresh every 30 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    final authState = ref.read(authNotifierProvider);
    if (authState.status != AuthStatus.authenticated) {
      yield Result.failure('Not authenticated');
      return;
    }
    
    try {
      print('🔍 DEBUG: Auto-refreshing tables data');
      final dio = ref.read(dioClientProvider);
      final repository = FloorPlanRepositoryImpl(dio);
      final result = await repository.getAllTables();
      yield result;
    } catch (e) {
      print('🔍 DEBUG: Error in auto-refresh: $e');
      // Don't yield error, keep previous data
    }
  }
});

// Tables by status provider
final tablesByStatusProvider = Provider<AsyncValue<Map<String, List<Map<String, dynamic>>>>>((ref) {
  final tablesAsync = ref.watch(realtimeTablesProvider);
  
  return tablesAsync.when(
    data: (result) {
      if (result.isFailure) {
        return AsyncValue.error(result.errorMessage!, StackTrace.current);
      }
      
      final tables = result.data!;
      final grouped = <String, List<Map<String, dynamic>>>{};
      
      for (final table in tables) {
        final status = table['status']?.toString().toLowerCase() ?? 'unknown';
        grouped.putIfAbsent(status, () => []).add(table);
      }
      
      return AsyncValue.data(grouped);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Floor plan notifier for CRUD operations
class FloorPlanNotifier extends StateNotifier<AsyncValue<Result<List<FloorPlan>>>> {
  final FloorPlanRepository _repository;

  FloorPlanNotifier(this._repository) : super(AsyncValue.data(Result.success([]))) {
    print('🔍 DEBUG: FloorPlanNotifier constructor called');
    // Don't load floor plans automatically - wait for authentication
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

// Floor plan notifier that only loads when authenticated
final authenticatedFloorPlanNotifierProvider = StateNotifierProvider<FloorPlanNotifier, AsyncValue<Result<List<FloorPlan>>>>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final repository = ref.watch(floorPlanRepositoryProvider);
  final notifier = FloorPlanNotifier(repository);
  
  // Only load floor plans if user is authenticated
  if (authState.status == AuthStatus.authenticated) {
    print('🔍 DEBUG: authenticatedFloorPlanNotifierProvider: User authenticated, loading floor plans');
    notifier._loadFloorPlans();
  } else {
    print('🔍 DEBUG: authenticatedFloorPlanNotifierProvider: User not authenticated (${authState.status}), skipping floor plan load');
  }
  
  return notifier;
});

// Progressive loading provider for floor plans with tables
class ProgressiveFloorPlanNotifier extends StateNotifier<AsyncValue<Result<List<FloorPlan>>>> {
  final FloorPlanRepository _repository;
  Timer? _refreshTimer;

  ProgressiveFloorPlanNotifier(this._repository) : super(AsyncValue.data(Result.success([]))) {
    print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Created');
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state.value?.isSuccess == true) {
        print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Auto-refreshing floor plans');
        loadFloorPlansProgressive();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> loadFloorPlansProgressive() async {
    print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Starting progressive load');
    state = const AsyncValue.loading();
    
    try {
      // First, get the list of floor plans
      final floorPlansResult = await _repository.getFloorPlans();
      
      if (!floorPlansResult.isSuccess) {
        print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Failed to get floor plans: ${floorPlansResult.errorMessage}');
        state = AsyncValue.data(floorPlansResult);
        return;
      }
      
      final floorPlans = floorPlansResult.data;
      print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Found ${floorPlans.length} floor plans to load');
      
      final floorPlansWithTables = <FloorPlan>[];
      
      // Load each floor plan with tables progressively
      for (int i = 0; i < floorPlans.length; i++) {
        final floorPlan = floorPlans[i];
        print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Loading floor plan ${i + 1}/${floorPlans.length}: ${floorPlan.name}');
        
        try {
          // Load tables for this floor plan
          final tablesResult = await _repository.getFloorPlanWithTables(floorPlan.id);
          
          if (tablesResult.isSuccess) {
            final floorPlanWithTables = tablesResult.data;
            print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Floor plan ${floorPlan.name} has ${floorPlanWithTables.tables?.length ?? 0} tables');
            
            // Debug: Print table statuses
            if (floorPlanWithTables.tables != null) {
              for (final table in floorPlanWithTables.tables!) {
                print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Table ${table.tableNumber} (ID: ${table.tableId}) status: ${table.tableStatus}');
              }
            }
            
            floorPlansWithTables.add(floorPlanWithTables);
          } else {
            print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Failed to get tables for ${floorPlan.name}: ${tablesResult.errorMessage}');
            floorPlansWithTables.add(floorPlan);
          }
        } catch (e) {
          print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Error loading tables for ${floorPlan.name}: $e');
          floorPlansWithTables.add(floorPlan);
        }
        
        // Update state with current progress (partial results)
        final currentResult = Result.success(floorPlansWithTables);
        state = AsyncValue.data(currentResult);
        
        // Add a small delay to make the progressive loading visible
        if (i < floorPlans.length - 1) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
      
      print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Completed loading ${floorPlansWithTables.length} floor plans');
      final finalResult = Result.success(floorPlansWithTables);
      state = AsyncValue.data(finalResult);
      
    } catch (e, stack) {
      print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Error in progressive load: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    print('🔍 DEBUG: ProgressiveFloorPlanNotifier: Manual refresh requested');
    await loadFloorPlansProgressive();
  }
}

final progressiveFloorPlansProvider = StateNotifierProvider<ProgressiveFloorPlanNotifier, AsyncValue<Result<List<FloorPlan>>>>((ref) {
  print('🔍 DEBUG: progressiveFloorPlansProvider: Creating ProgressiveFloorPlanNotifier');
  final repository = ref.watch(floorPlanRepositoryProvider);
  return ProgressiveFloorPlanNotifier(repository);
});