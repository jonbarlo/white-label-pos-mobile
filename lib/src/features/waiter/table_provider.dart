import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import '../floor_plan/floor_plan_provider.dart';
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
  
  final tables = await repo.getTables(businessId: user.businessId);
  
  return tables;
});

// Get tables by status
final tablesByStatusProvider = FutureProvider.family<List<waiter_table.Table>, waiter_table.TableStatus>((ref, status) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final tables = await repo.getTablesByStatus(status, businessId: user.businessId);
  
  return tables;
});

// Get waiter's assigned tables
final myAssignedTablesProvider = FutureProvider.autoDispose<List<waiter_table.Table>>((ref) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final tables = await repo.getMyAssignedTables(user.id, businessId: user.businessId);
  
  return tables;
});

// Get specific table
final tableProvider = FutureProvider.family<waiter_table.Table, int>((ref, tableId) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final table = await repo.getTable(tableId);
  
  return table;
});

// Update table status
final updateTableStatusProvider = FutureProvider.family<waiter_table.Table, ({int tableId, waiter_table.TableStatus status})>((ref, params) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final table = await repo.updateTableStatus(params.tableId, params.status);
  
  // Invalidate tables provider to refresh the list
  ref.invalidate(tablesProvider);
  
  return table;
});

// Assign table to waiter
final assignTableProvider = FutureProvider.family<waiter_table.Table, ({int tableId, int waiterId})>((ref, params) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final table = await repo.assignTable(params.tableId, params.waiterId);
  
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
  
  await repo.clearTable(tableId);
  
  // Invalidate tables provider to refresh the list
  ref.invalidate(tablesProvider);
  ref.invalidate(myAssignedTablesProvider);
});

// Create reservation
final createReservationProvider = FutureProvider.family<void, (int tableId, String customerName, String customerPhone, int partySize, String reservationDate, String reservationTime, String notes)>((ref, params) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');

  final (tableId, customerName, customerPhone, partySize, reservationDate, reservationTime, notes) = params;
  
  print('🔍 DEBUG: Creating reservation for table $tableId');
  print('🔍 DEBUG: customerName: $customerName, partySize: $partySize, date: $reservationDate, time: $reservationTime');
  
  await repo.createReservation(tableId, customerName, customerPhone, partySize, reservationDate, reservationTime, notes);

  // Invalidate all related providers to force refresh
  ref.invalidate(tablesProvider);
  ref.invalidate(floorPlansWithTablesProvider);
  ref.invalidate(floorPlanNotifierProvider);
  
  // Force refresh of all table-related data
  ref.invalidate(tableProvider);
  ref.invalidate(tablesByStatusProvider);
  ref.invalidate(myAssignedTablesProvider);
  
  // Add a small delay to ensure the API has processed the change
  await Future.delayed(const Duration(milliseconds: 500));
});

// Seat customer at table
final seatCustomerProvider = FutureProvider.family<void, (int tableId, String customerName, int partySize, String notes, String? customerPhone, String? customerEmail)>((ref, params) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');

  final (tableId, customerName, partySize, notes, customerPhone, customerEmail) = params;
  
  print('🔍 DEBUG: User ID from auth state: ${user.id}');
  print('🔍 DEBUG: User name: ${user.name}');
  print('🔍 DEBUG: User role: ${user.role}');
  
  await repo.seatCustomer(tableId, customerName, partySize, notes, serverId: user.id, customerPhone: customerPhone, customerEmail: customerEmail);

  // Invalidate all related providers to force refresh
  ref.invalidate(tablesProvider);
  ref.invalidate(floorPlansWithTablesProvider);
  ref.invalidate(floorPlanNotifierProvider);
  
  // Force refresh of all table-related data
  ref.invalidate(tableProvider);
  ref.invalidate(tablesByStatusProvider);
  ref.invalidate(myAssignedTablesProvider);
  
  // Add a small delay to ensure the API has processed the change
  await Future.delayed(const Duration(milliseconds: 500));
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

// Get tables with orders
final tablesWithOrdersProvider = FutureProvider.autoDispose<List<waiter_table.Table>>((ref) async {
  final repo = ref.watch(tableRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final tables = await repo.getTablesWithOrders(businessId: user.businessId);
  
  return tables;
}); 