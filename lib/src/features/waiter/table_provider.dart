import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/env_config.dart';
import '../auth/auth_provider.dart';
import 'table_repository.dart';
import 'models/table.dart' as waiter_table;

final tableRepositoryProvider = Provider<TableRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return TableRepository(dio);
});

// Get all tables
final tablesProvider = FutureProvider.autoDispose<List<waiter_table.Table>>((ref) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Fetching tables for user: ${user.name}');
  }
  
  final tables = await repo.getTables(businessId: user.businessId);
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Received ${tables.length} tables');
  }
  
  return tables;
});

// Get tables by status
final tablesByStatusProvider = FutureProvider.family<List<waiter_table.Table>, waiter_table.TableStatus>((ref, status) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Fetching tables with status $status for user: ${user.name}');
  }
  
  final tables = await repo.getTablesByStatus(status, businessId: user.businessId);
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Found ${tables.length} tables with status $status');
  }
  
  return tables;
});

// Get waiter's assigned tables
final myAssignedTablesProvider = FutureProvider.autoDispose<List<waiter_table.Table>>((ref) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Fetching assigned tables for waiter: ${user.name}');
  }
  
  final tables = await repo.getMyAssignedTables(user.id, businessId: user.businessId);
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Found ${tables.length} assigned tables');
  }
  
  return tables;
});

// Get specific table
final tableProvider = FutureProvider.family<waiter_table.Table, int>((ref, tableId) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Fetching table $tableId for user: ${user.name}');
  }
  
  final table = await repo.getTable(tableId);
  
  if (EnvConfig.isDebugMode) {
            print('🪑 PROVIDER: Received table ${table.name}');
  }
  
  return table;
});

// Update table status
final updateTableStatusProvider = FutureProvider.family<waiter_table.Table, ({int tableId, waiter_table.TableStatus status})>((ref, params) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Updating table ${params.tableId} status to ${params.status}');
  }
  
  final table = await repo.updateTableStatus(params.tableId, params.status);
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Table status updated successfully');
  }
  
  // Invalidate tables provider to refresh the list
  ref.invalidate(tablesProvider);
  
  return table;
});

// Assign table to waiter
final assignTableProvider = FutureProvider.family<waiter_table.Table, ({int tableId, int waiterId})>((ref, params) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Assigning table ${params.tableId} to waiter ${params.waiterId}');
  }
  
  final table = await repo.assignTable(params.tableId, params.waiterId);
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Table assigned successfully');
  }
  
  // Invalidate tables provider to refresh the list
  ref.invalidate(tablesProvider);
  ref.invalidate(myAssignedTablesProvider);
  
  return table;
});

// Clear table
final clearTableProvider = FutureProvider.family<void, int>((ref, tableId) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Clearing table $tableId');
  }
  
  await repo.clearTable(tableId);
  
  if (EnvConfig.isDebugMode) {
    print('🪑 PROVIDER: Table cleared successfully');
  }
  
  // Invalidate tables provider to refresh the list
  ref.invalidate(tablesProvider);
  ref.invalidate(myAssignedTablesProvider);
});

// Computed providers for filtered views
final availableTablesProvider = Provider<AsyncValue<List<waiter_table.Table>>>((ref) {
  return ref.watch(tablesByStatusProvider(waiter_table.TableStatus.available));
});

final occupiedTablesProvider = Provider<AsyncValue<List<waiter_table.Table>>>((ref) {
  return ref.watch(tablesByStatusProvider(waiter_table.TableStatus.occupied));
});

final reservedTablesProvider = Provider<AsyncValue<List<waiter_table.Table>>>((ref) {
  return ref.watch(tablesByStatusProvider(waiter_table.TableStatus.reserved));
});

final cleaningTablesProvider = Provider<AsyncValue<List<waiter_table.Table>>>((ref) {
  return ref.watch(tablesByStatusProvider(waiter_table.TableStatus.cleaning));
});

// Table statistics
final tableStatsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final tablesAsync = ref.watch(tablesProvider);
  
  return tablesAsync.when(
    data: (tables) {
      final stats = <String, int>{};
      for (final status in waiter_table.TableStatus.values) {
        stats[status.name] = tables.where((table) => table.status == status).length;
      }
      // Ensure all statuses are present with a count (even if 0)
      for (final status in waiter_table.TableStatus.values) {
        stats.putIfAbsent(status.name, () => 0);
      }
      return AsyncValue.data(stats);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
}); 