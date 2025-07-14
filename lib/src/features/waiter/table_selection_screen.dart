import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'table_provider.dart';
import 'models/table.dart' as waiter_table;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import 'order_taking_screen.dart';

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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _onTableSelected(table),
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('Start Order', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ] else if (table.status == waiter_table.TableStatus.occupied && table.currentOrderId != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _onTableSelected(table),
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

  void _onTableSelected(waiter_table.Table table) {
    // Navigate to order taking screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderTakingScreen(table: table),
      ),
    );
  }

  void _showTableDetails(waiter_table.Table table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table ${table.name} Details'),
        content: Column(
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
          ],
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 