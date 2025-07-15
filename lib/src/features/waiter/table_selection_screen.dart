import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'table_provider.dart';
import 'models/table.dart' as waiter_table;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import 'order_taking_screen.dart';
import 'waiter_order_provider.dart';

class TableSelectionScreen extends ConsumerStatefulWidget {
  const TableSelectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends ConsumerState<TableSelectionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  waiter_table.TableStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tablesProvider);
    final tableStatsAsync = ref.watch(tableStatsProvider);

    return Scaffold(
      body: Column(
        children: [
          // Tab bar for table status filters
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Theme.of(context).colorScheme.onPrimary,
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              tabs: [
                _buildTab('All', null, tableStatsAsync),
                _buildTab('Available', waiter_table.TableStatus.available, tableStatsAsync),
                _buildTab('Occupied', waiter_table.TableStatus.occupied, tableStatsAsync),
                _buildTab('Reserved', waiter_table.TableStatus.reserved, tableStatsAsync),
                _buildTab('Cleaning', waiter_table.TableStatus.cleaning, tableStatsAsync),
              ],
            ),
          ),
          
          // Search and filter bar
          _buildSearchBar(),
          
          // Table statistics
          _buildTableStats(tableStatsAsync),
          
          // Tables grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(tablesProvider);
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

  Widget _buildTab(String title, waiter_table.TableStatus? status, AsyncValue<Map<String, int>> statsAsync) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          const SizedBox(width: 4),
          statsAsync.when(
            data: (stats) {
              final count = status != null 
                  ? stats[status.name] ?? 0
                  : stats.values.fold(0, (sum, count) => sum + count);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
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
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildTableStats(AsyncValue<Map<String, int>> statsAsync) {
    return statsAsync.when(
      data: (stats) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _buildStatChip('Available', stats['available'] ?? 0, Colors.green),
            const SizedBox(width: 8),
            _buildStatChip('Occupied', stats['occupied'] ?? 0, Colors.orange),
            const SizedBox(width: 8),
            _buildStatChip('Reserved', stats['reserved'] ?? 0, Colors.blue),
            const SizedBox(width: 8),
            _buildStatChip('Cleaning', stats['cleaning'] ?? 0, Colors.grey),
          ],
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
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
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
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
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading tables',
              style: Theme.of(context).textTheme.headlineSmall,
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
                ref.invalidate(tablesProvider);
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
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: canTakeOrder ? () => _onTableSelected(table) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                statusColor.withOpacity(0.1),
                statusColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Table number and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Table ${table.name}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        table.status.shortName,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Capacity
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${table.capacity} seats',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                // Current order info
                if (table.currentOrderId != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.receipt,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Order ${table.currentOrderNumber ?? table.currentOrderId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (table.currentOrderTotal != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '\$${table.currentOrderTotal!.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ],
                
                // Customer name
                if (table.customerName != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          table.customerName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                
                const Spacer(),
                
                // Action buttons
                if (table.status == waiter_table.TableStatus.available) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showSeatCustomerDialog(table),
                          icon: const Icon(Icons.event_seat, size: 16),
                          label: const Text('Seat Customer', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: statusColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showReserveTableDialog(table),
                          icon: const Icon(Icons.event_available, size: 16),
                          label: const Text('Reserve', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (table.status == waiter_table.TableStatus.reserved) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showCheckInDialog(table),
                      icon: const Icon(Icons.login, size: 16),
                      label: const Text('Check-in', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ] else if (table.status == waiter_table.TableStatus.occupied) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Add Items button pressed for table:  [33m${table.name} [0m (id: ${table.id}, status: ${table.status}, currentOrderId: ${table.currentOrderId})');
                        _onTableSelected(table);
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('Add Items', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (table.status == waiter_table.TableStatus.occupied) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _clearTable(table),
                        icon: const Icon(Icons.cleaning_services, size: 16),
                        label: const Text('Clear Table', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ] else if (table.status == waiter_table.TableStatus.cleaning) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _clearTable(table),
                      icon: const Icon(Icons.cleaning_services, size: 16),
                      label: const Text('Clear Table', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showTableDetails(table),
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: const Text(
                        'Details',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: statusColor,
                        side: BorderSide(color: statusColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
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
        print('Dialog closed. Selected order: $selected');
        if (selected != null) {
          print('Navigating to OrderTakingScreen with order: $selected');
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OrderTakingScreen(table: table),
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
                Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold)),
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
            onPressed: () => Navigator.of(context).pop(),
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
        final _nameController = TextEditingController();
        final _notesController = TextEditingController();
        DateTime? _reservationTime;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Reserve Table ${table.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
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
                              _reservationTime = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                picked.hour,
                                picked.minute,
                              );
                            });
                          }
                        },
                        child: Text(_reservationTime != null
                            ? '${_reservationTime!.hour.toString().padLeft(2, '0')}:${_reservationTime!.minute.toString().padLeft(2, '0')}'
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
                  Navigator.of(context).pop();
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
        final _nameController = TextEditingController();
        final _partySizeController = TextEditingController();
        final _notesController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Seat Customer at Table ${table.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _partySizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Party Size'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
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
                  final name = _nameController.text.trim();
                  final partySize = int.tryParse(_partySizeController.text.trim());
                  final notes = _notesController.text.trim();
                  if (name.isEmpty || partySize == null || partySize < 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid name and party size.')),
                    );
                    return;
                  }
                  final container = ProviderScope.containerOf(context, listen: false);
                  try {
                    print('🪑 DIALOG: Calling seatCustomerProvider for table ${table.id}...');
                    await container.read(seatCustomerProvider((table.id, name, partySize, notes)).future);
                    print('🪑 DIALOG: seatCustomerProvider call succeeded.');
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pop();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Customer seated at table ${table.name}!')),
                      );
                    }
                  } catch (e) {
                    print('🪑 DIALOG: seatCustomerProvider call failed: $e');
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
      await container.read(clearTableProvider(table.id).future);

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
        final _nameController = TextEditingController(text: table.customerName ?? '');
        final _partySizeController = TextEditingController(text: table.partySize?.toString() ?? '');
        final _notesController = TextEditingController(text: table.notes ?? '');
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Check-in Reservation for Table ${table.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _partySizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Party Size'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
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
                  final name = _nameController.text.trim();
                  final partySize = int.tryParse(_partySizeController.text.trim());
                  final notes = _notesController.text.trim();
                  if (name.isEmpty || partySize == null || partySize < 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid name and party size.')),
                    );
                    return;
                  }
                  final container = ProviderScope.containerOf(context, listen: false);
                  try {
                    print('🪑 DIALOG: Calling seatCustomerProvider for table ${table.id}...');
                    await container.read(seatCustomerProvider((table.id, name, partySize, notes)).future);
                    print('🪑 DIALOG: seatCustomerProvider call succeeded.');
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pop();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reservation checked in for table ${table.name}!')),
                      );
                    }
                  } catch (e) {
                    print('🪑 DIALOG: seatCustomerProvider call failed: $e');
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
} 