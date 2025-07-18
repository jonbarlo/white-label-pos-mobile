import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'table_provider.dart' as waiter;
import 'models/table.dart' as waiter_table;
import 'order_taking_screen.dart';
import '../../features/floor_plan/floor_plan_viewer_screen.dart';
import '../../features/floor_plan/models/floor_plan.dart';
import '../../features/floor_plan/floor_plan_provider.dart' as fp;
import '../../features/auth/auth_provider.dart';
import '../../core/navigation/app_router.dart';

import 'waiter_order_provider.dart';
import '../../core/services/navigation_service.dart';
import '../../core/theme/theme_provider.dart';

class TableSelectionScreen extends ConsumerStatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  ConsumerState<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends ConsumerState<TableSelectionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this); // Added floor plan view tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(waiter.tablesProvider);
    final tableStatsAsync = ref.watch(waiter.tableStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(waiter.tablesProvider);
            },
            tooltip: 'Refresh Tables',
          ),
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeModeProvider);
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () async {
                  print('Theme toggle pressed. Current theme: $themeMode');
                  await ref.read(themeModeProvider.notifier).toggleTheme();
                  print('Theme toggled. New theme: ${ref.read(themeModeProvider)}');
                  if (mounted) {
                    setState(() {}); // Force rebuild
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () async {
              // Get floor plans from API
              final floorPlanState = ref.read(fp.floorPlanNotifierProvider);
              
              final floorPlans = floorPlanState.when(
                data: (result) => result.isSuccess ? result.data : [],
                loading: () => [],
                error: (_, __) => [],
              );

              if (floorPlans.isEmpty) {
                // Show error if no floor plans available
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No floor plans available. Please create a floor plan first.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                return;
              }

              // Use the first active floor plan, or the first one if none are active
              final selectedFloorPlan = floorPlans.firstWhere(
                (fp) => fp.isActive,
                orElse: () => floorPlans.first,
              );

              // Navigate to floor plan viewer with actual floor plan ID
              if (mounted) {
                context.push(AppRouter.floorPlanViewerRoute, extra: {
                  'floorPlanId': selectedFloorPlan.id,
                  'isEditMode': false,
                });
              }
            },
            tooltip: 'Floor Plan View',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Profile
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          
          // Status tabs
          _buildStatusTabs(tableStatsAsync),
          
          // Tables grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(waiter.tablesProvider);
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTablesGrid(tablesAsync, null),
                  _buildTablesGrid(tablesAsync, waiter_table.TableStatus.available),
                  _buildTablesGrid(tablesAsync, waiter_table.TableStatus.occupied),
                  _buildTablesGrid(tablesAsync, waiter_table.TableStatus.reserved),
                  _buildTablesGrid(tablesAsync, waiter_table.TableStatus.cleaning),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search tables...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStatusTabs(AsyncValue<Map<String, int>> statsAsync) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        tabs: [
          _buildTab('All', null, statsAsync),
          _buildTab('Available', waiter_table.TableStatus.available, statsAsync),
          _buildTab('Occupied', waiter_table.TableStatus.occupied, statsAsync),
          _buildTab('Reserved', waiter_table.TableStatus.reserved, statsAsync),
          _buildTab('Cleaning', waiter_table.TableStatus.cleaning, statsAsync),
        ],
      ),
    );
  }

  Widget _buildTab(String title, waiter_table.TableStatus? status, AsyncValue<Map<String, int>> statsAsync) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          const SizedBox(width: 6),
          statsAsync.when(
            data: (stats) {
              final count = status != null 
                  ? stats[status.name] ?? 0
                  : stats.values.fold(0, (sum, count) => sum + count);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesGrid(AsyncValue<List<waiter_table.Table>> tablesAsync, waiter_table.TableStatus? filterStatus) {
    return tablesAsync.when(
      data: (tables) {
        // Filter tables by status and search query
        final filteredTables = tables.where((table) {
          final matchesStatus = filterStatus == null || table.status == filterStatus;
          final matchesSearch = _searchQuery.isEmpty ||
              table.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (table.customerName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
          return matchesStatus && matchesSearch;
        }).toList();

        if (filteredTables.isEmpty) {
          return _buildEmptyState(filterStatus);
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: filteredTables.length,
          itemBuilder: (context, index) {
            return _buildTableCard(filteredTables[index]);
          },
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading tables...'),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading tables',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(waiter.tablesProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(waiter_table.TableStatus? filterStatus) {
    String message;
    IconData icon;

    if (_searchQuery.isNotEmpty) {
      message = 'No tables found matching "$_searchQuery"';
      icon = Icons.search_off;
    } else {
      switch (filterStatus) {
        case waiter_table.TableStatus.available:
          message = 'No available tables';
          icon = Icons.table_restaurant_outlined;
          break;
        case waiter_table.TableStatus.occupied:
          message = 'No occupied tables';
          icon = Icons.people_outline;
          break;
        case waiter_table.TableStatus.reserved:
          message = 'No reserved tables';
          icon = Icons.event_available_outlined;
          break;
        case waiter_table.TableStatus.cleaning:
          message = 'No tables being cleaned';
          icon = Icons.cleaning_services_outlined;
          break;
        default:
          message = 'No tables found';
          icon = Icons.table_restaurant_outlined;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later or try a different filter',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard(waiter_table.Table table) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(table.status);
    final canTakeOrder = table.status.canTakeOrder;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: canTakeOrder ? () => _onTableSelected(table) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Table name
              Text(
                'Table ${table.name}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Status with dot
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    table.status.shortName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              // Party size
              Row(
                children: [
                  Icon(Icons.people, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 2),
                  Text(
                    '${table.capacity} seats',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              // Order info if exists
              if (table.currentOrderId != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.receipt, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 2),
                    Text(
                      'Order ${table.currentOrderNumber ?? table.currentOrderId}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                if (table.currentOrderTotal != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '\$${table.currentOrderTotal!.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
              
              const Spacer(),
              
              // Action buttons
              _buildActionButtons(table, statusColor),
            ],
          ),
        ),
      ),
    );
  }



  Color _getStatusColor(waiter_table.TableStatus status) {
    switch (status) {
      case waiter_table.TableStatus.available:
        return Colors.green;
      case waiter_table.TableStatus.occupied:
        return Colors.orange;
      case waiter_table.TableStatus.reserved:
        return Colors.blue;
      case waiter_table.TableStatus.cleaning:
        return Colors.grey;
      case waiter_table.TableStatus.outOfService:
        return Colors.red;
    }
  }

  void _onTableSelected(waiter_table.Table table) async {
    print('🔍 DEBUG: _onTableSelected called for table ${table.name} (ID: ${table.id})');
    print('🔍 DEBUG: Table status: ${table.status}');
    print('🔍 DEBUG: Table customerName: "${table.customerName}"');
    print('🔍 DEBUG: Table notes: "${table.notes}"');
    print('🔍 DEBUG: Table partySize: ${table.partySize}');
    print('🔍 DEBUG: Table currentOrderId: ${table.currentOrderId}');
    
    if (table.status == waiter_table.TableStatus.occupied && table.currentOrderId != null) {
      // Fetch all orders for this table
      final container = ProviderScope.containerOf(context, listen: false);
      final orders = await container.read(tableOrdersProvider(table.id).future);
      // Filter for open orders (not completed/cancelled)
      final openOrders = orders.where((order) =>
        order['status'] != 'completed' && order['status'] != 'cancelled').toList();
      if (openOrders.isEmpty) {
        // Fallback: just use the current order
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderTakingScreen(table: table),
          ),
        );
        return;
      }
      if (openOrders.length == 1) {
        // Only one open order, use it
        final order = openOrders.first;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderTakingScreen(
              table: table,
              prefillOrder: order,
            ),
          ),
        );
      } else {
        // Multiple open orders, prompt user to select
        final selected = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Select Open Order'),
            children: openOrders.map((order) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, order),
              child: Text('Order #${order['orderNumber'] ?? order['id']}'),
            )).toList(),
          ),
        );
        if (selected != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OrderTakingScreen(
                table: table,
                prefillOrder: selected,
              ),
            ),
          );
        }
      }
    } else {
      // Default: start new order
      // Pass customer data from table metadata if available
      Map<String, dynamic>? prefillOrder;
      print('🔍 DEBUG: Table has no current order, checking for customer data...');
      print('🔍 DEBUG: table.customerName: "${table.customerName}"');
      print('🔍 DEBUG: table.customerName != null: ${table.customerName != null}');
      print('🔍 DEBUG: table.customerName!.isNotEmpty: ${table.customerName != null ? table.customerName!.isNotEmpty : "N/A"}');
      
      if (table.customerName != null && table.customerName!.isNotEmpty) {
        prefillOrder = {
          'customerName': table.customerName,
          'partySize': table.partySize ?? 0,
          'notes': table.notes ?? '',
          'items': [],
        };
        print('🔍 DEBUG: Created prefillOrder with customer data - customerName: "${table.customerName}", notes: "${table.notes}", partySize: ${table.partySize}');
      } else {
        print('🔍 DEBUG: No customer data available, prefillOrder will be null');
      }
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OrderTakingScreen(
            table: table,
            prefillOrder: prefillOrder,
          ),
        ),
      );
    }
  }

  void _showTableDetails(waiter_table.Table table) async {
    // Fetch order details if there is a current order
    Map<String, dynamic>? orderDetails;
    if (table.currentOrderId != null) {
      final container = ProviderScope.containerOf(context, listen: false);
      orderDetails = await container.read(orderByIdProvider(table.currentOrderId!).future);
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table ${table.name} Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: ${table.status.displayName}'),
              Text('Capacity: ${table.capacity} seats'),
              if (table.customerName != null) Text('Customer: ${table.customerName}'),
              if (table.assignedWaiter != null) Text('Assigned to: ${table.assignedWaiter}'),
              if (table.notes != null) Text('Notes: ${table.notes}'),
              if (table.lastActivity != null) Text('Last Activity: ${_formatDateTime(table.lastActivity!)}'),
              if (table.reservationTime != null) Text('Reservation: ${_formatDateTime(table.reservationTime!)}'),
              if (orderDetails != null) ...[
                const Divider(height: 24),
                const Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...((orderDetails['items'] as List?)?.map((item) => Text(
                  '${item['quantity']}x ${item['name']}',
                  style: const TextStyle(fontSize: 15),
                )) ?? [const Text('No items')]),
                if (orderDetails['total'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Total:  \$${orderDetails['total'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => NavigationService.goBack(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReserveTableDialog(waiter_table.Table table) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final notesController = TextEditingController();
        DateTime? reservationTime;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Reserve Table ${table.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Time:'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              reservationTime = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                picked.hour,
                                picked.minute,
                              );
                            });
                          }
                        },
                        child: Text(reservationTime != null
                            ? '${reservationTime!.hour.toString().padLeft(2, '0')}:${reservationTime!.minute.toString().padLeft(2, '0')}'
                            : 'Select Time'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Call backend to reserve table
                  // For now, just close dialog
                  NavigationService.goBack(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Table reserved (placeholder)!')),
                  );
                },
                child: const Text('Reserve'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSeatCustomerDialog(waiter_table.Table table) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final partySizeController = TextEditingController();
        final notesController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Seat Customer at Table ${table.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: partySizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Party Size'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final partySize = int.tryParse(partySizeController.text.trim());
                  final notes = notesController.text.trim();
                  if (name.isEmpty || partySize == null || partySize < 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid name and party size.')),
                    );
                    return;
                  }
                  final container = ProviderScope.containerOf(context, listen: false);
                  try {
                    await container.read(waiter.seatCustomerProvider((table.id, name, partySize, notes)).future);
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        NavigationService.goBack(context);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Customer seated at table ${table.name}!')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to seat customer: $e')),
                    );
                  }
                },
                child: const Text('Seat'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _clearTable(waiter_table.Table table) async {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Text('Clearing table ${table.name}...'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Call the clear table provider
      await container.read(waiter.clearTableProvider(table.id).future);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Table ${table.name} cleared successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear table: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCheckInDialog(waiter_table.Table table) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: table.customerName ?? '');
        final partySizeController = TextEditingController(text: table.partySize?.toString() ?? '');
        final notesController = TextEditingController(text: table.notes ?? '');
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Check-in Reservation for Table ${table.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: partySizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Party Size'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final partySize = int.tryParse(partySizeController.text.trim());
                  final notes = notesController.text.trim();
                  if (name.isEmpty || partySize == null || partySize < 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid name and party size.')),
                    );
                    return;
                  }
                  final container = ProviderScope.containerOf(context, listen: false);
                  try {
                    await container.read(waiter.seatCustomerProvider((table.id, name, partySize, notes)).future);
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        NavigationService.goBack(context);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reservation checked in for table ${table.name}!')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to check-in: $e')),
                    );
                  }
                },
                child: const Text('Check-in'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  VoidCallback? _getActionCallback(waiter_table.Table table) {
    switch (table.status) {
      case waiter_table.TableStatus.available:
        return () => _showSeatCustomerDialog(table);
      case waiter_table.TableStatus.reserved:
        return () => _showCheckInDialog(table);
      case waiter_table.TableStatus.occupied:
        return () => _onTableSelected(table);
      case waiter_table.TableStatus.cleaning:
        return () => _clearTable(table);
      default:
        return () => _showTableDetails(table);
    }
  }

  String _getActionText(waiter_table.Table table) {
    switch (table.status) {
      case waiter_table.TableStatus.available:
        return 'Seat';
      case waiter_table.TableStatus.reserved:
        return 'Check-in';
      case waiter_table.TableStatus.occupied:
        return 'View';
      case waiter_table.TableStatus.cleaning:
        return 'Ready';
      default:
        return 'Details';
    }
  }

  Widget _buildActionButtons(waiter_table.Table table, Color statusColor) {
    switch (table.status) {
      case waiter_table.TableStatus.available:
        return SizedBox(
          width: double.infinity,
          height: 24,
          child: ElevatedButton(
            onPressed: () => _showSeatCustomerDialog(table),
            style: ElevatedButton.styleFrom(
              backgroundColor: statusColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Text('Seat', style: TextStyle(fontSize: 10)),
          ),
        );
        
      case waiter_table.TableStatus.occupied:
        // Check if table has orders to determine button text and color
        final hasOrders = table.currentOrderId != null;
        return SizedBox(
          width: double.infinity,
          height: 24,
          child: ElevatedButton(
            onPressed: () => _onTableSelected(table),
            style: ElevatedButton.styleFrom(
              backgroundColor: hasOrders ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              hasOrders ? 'Add Items' : 'Start',
              style: const TextStyle(fontSize: 10),
            ),
          ),
        );
        
      case waiter_table.TableStatus.reserved:
        return SizedBox(
          width: double.infinity,
          height: 24,
          child: ElevatedButton(
            onPressed: () => _showCheckInDialog(table),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Text('Check-in', style: TextStyle(fontSize: 10)),
          ),
        );
        
      case waiter_table.TableStatus.cleaning:
        return SizedBox(
          width: double.infinity,
          height: 24,
          child: OutlinedButton(
            onPressed: () => _clearTable(table),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Text('Ready', style: TextStyle(fontSize: 10)),
          ),
        );
        
      default:
        return SizedBox(
          width: double.infinity,
          height: 24,
          child: OutlinedButton(
            onPressed: () => _showTableDetails(table),
            style: OutlinedButton.styleFrom(
              foregroundColor: statusColor,
              side: BorderSide(color: statusColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Text('Details', style: TextStyle(fontSize: 10)),
          ),
        );
    }
  }

  waiter_table.TableStatus _convertStatus(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return waiter_table.TableStatus.available;
      case 'occupied':
        return waiter_table.TableStatus.occupied;
      case 'reserved':
        return waiter_table.TableStatus.reserved;
      case 'cleaning':
        return waiter_table.TableStatus.cleaning;
      case 'out_of_service':
        return waiter_table.TableStatus.outOfService;
      default:
        return waiter_table.TableStatus.available;
    }
  }
} 
