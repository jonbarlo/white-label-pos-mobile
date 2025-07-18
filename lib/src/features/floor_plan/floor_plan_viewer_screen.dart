import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:another_flushbar/flushbar.dart';
import 'floor_plan_provider.dart' as fp;
import 'models/floor_plan.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/result.dart';
import '../waiter/table_provider.dart' as waiter;
import '../waiter/models/table.dart' as waiter_table;
import 'package:flutter/foundation.dart';
import 'dialogs/reservation_dialog.dart';
import 'dialogs/seating_dialog.dart';



class FloorPlanViewerScreen extends ConsumerStatefulWidget {
  const FloorPlanViewerScreen({super.key});

  @override
  ConsumerState<FloorPlanViewerScreen> createState() => _FloorPlanViewerScreenState();
}

class _FloorPlanViewerScreenState extends ConsumerState<FloorPlanViewerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedFloorPlanId;
  bool _isRefreshing = false;
  
  // Track which tables are currently being synchronized
  final Set<int> _loadingTableIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load floor plans when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFloorPlans();
    });
  }

  Future<void> _refreshFloorPlans() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });

    try {
      // Clear all table loading states
      setState(() {
        _loadingTableIds.clear();
      });
      
      // Force clear all provider caches
      ref.invalidate(fp.floorPlansWithTablesProvider);
      ref.invalidate(waiter.tableProvider);
      ref.invalidate(waiter.tablesProvider);
      ref.invalidate(fp.floorPlanNotifierProvider);
      ref.invalidate(waiter.seatCustomerProvider);
      ref.invalidate(waiter.tablesByStatusProvider);
      ref.invalidate(waiter.myAssignedTablesProvider);
      
      // Force clear all floor plan related providers
      ref.invalidate(fp.floorPlansProvider);
      ref.invalidate(fp.floorPlanProvider);
      ref.invalidate(fp.floorPlanWithTablesProvider);
      ref.invalidate(fp.tablePositionsProvider);
      ref.invalidate(fp.allTablesProvider);
      
      // Wait longer for the API to process changes
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Force a complete widget rebuild
      if (mounted) {
        setState(() {});
      }
    } finally {
        setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper methods to manage table loading states
  void _setTableLoading(int tableId, bool isLoading) {
      setState(() {
      if (isLoading) {
        _loadingTableIds.add(tableId);
      } else {
        _loadingTableIds.remove(tableId);
      }
    });
  }

  bool _isTableLoading(int tableId) {
    return _loadingTableIds.contains(tableId);
  }

  @override
  Widget build(BuildContext context) {
    final floorPlanState = ref.watch(fp.floorPlansWithTablesProvider);
    
      return Scaffold(
        appBar: AppBar(
          title: const Text('Floor Plan Viewer'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '🗺️ Floor Plans'),
            Tab(text: '📋 All Tables'),
          ],
        ),
        actions: [
            IconButton(
            icon: _isRefreshing 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshFloorPlans,
            tooltip: _isRefreshing ? 'Refreshing...' : 'Refresh',
          ),
          if (_isRefreshing)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const Text(
                'Refreshing...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // Force rebuild with fresh data
              _buildFloorPlansTab(floorPlanState),
              _buildAllTablesTab(floorPlanState),
            ],
          ),
          // Loading overlay when refreshing
          if (_isRefreshing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Refreshing floor plan data...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloorPlansTab(AsyncValue<Result<List<FloorPlan>>> floorPlanState) {
    return floorPlanState.when(
      data: (result) {
        if (result.isSuccess) {
          return _buildFloorPlansList(result.data);
        } else {
          return _buildErrorState(result.errorMessage ?? 'Unknown error occurred');
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildFloorPlansList(List<FloorPlan> floorPlans) {
    return Column(
        children: [
        // Floor Plan Selector
          Container(
            padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<String>(
            value: _selectedFloorPlanId,
            decoration: const InputDecoration(
              labelText: 'Select Floor Plan',
              border: OutlineInputBorder(),
            ),
            items: floorPlans.map((floorPlan) {
              final tableCount = floorPlan.tables?.length ?? 0;
              return DropdownMenuItem(
                value: floorPlan.id.toString(),
                child: Text('${floorPlan.name} ($tableCount tables)'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFloorPlanId = value;
              });
            },
          ),
        ),
        
        // Floor Plan Viewer
        Expanded(
          child: _selectedFloorPlanId != null
              ? _buildFloorPlanView(
                  floorPlans.firstWhere((fp) => fp.id.toString() == _selectedFloorPlanId)
                )
              : _buildNoFloorPlanSelected(),
        ),
      ],
    );
  }

  Widget _buildFloorPlanView(FloorPlan floorPlan) {
    return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
            // Background Image
            if (floorPlan.backgroundImage != null)
                      Positioned.fill(
                        child: Image.network(
                  floorPlan.backgroundImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                      color: Colors.grey.shade200,
                              child: const Center(
                        child: Icon(Icons.image, size: 64, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                color: Colors.grey.shade200,
                        child: const Center(
                  child: Icon(Icons.map, size: 64, color: Colors.grey),
                ),
              ),
            
            // Tables
            if (floorPlan.tables != null)
              ...floorPlan.tables!.map((table) => _buildTableWidget(table)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableWidget(TablePosition table) {
    Color statusColor;
    IconData statusIcon;
    final bool isLoading = _isTableLoading(table.tableId);
    
    switch (table.tableStatus.toLowerCase()) {
      case 'available':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'occupied':
        statusColor = Colors.red;
        statusIcon = Icons.people;
        break;
      case 'reserved':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'cleaning':
        statusColor = Colors.purple;
        statusIcon = Icons.cleaning_services;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }
    
    return Positioned(
      left: table.x.toDouble(),
      top: table.y.toDouble(),
      child: Transform.rotate(
        angle: table.rotation * 3.14159 / 180,
      child: GestureDetector(
          onTap: () {
            if (!isLoading) {
              _showTableActions(table);
            }
          },
          child: Container(
          width: table.width.toDouble(),
          height: table.height.toDouble(),
          decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
            border: Border.all(
                color: isLoading ? Colors.blue : statusColor, 
                width: isLoading ? 3 : 2
            ),
            borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Main table content
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                  Text(
                    table.tableNumber,
                      style: TextStyle(
                        color: statusColor,
                      fontWeight: FontWeight.bold,
                        fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${table.tableCapacity}',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ],
                ),
                
                // Loading overlay
                if (isLoading)
                    Container(
                      decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllTablesTab(AsyncValue<Result<List<FloorPlan>>> floorPlanState) {
    return floorPlanState.when(
      data: (result) {
        if (result.isSuccess) {
          // Extract all tables from all floor plans
          final allTables = <TablePosition>[];
          for (final floorPlan in result.data) {
            if (floorPlan.tables != null) {
              allTables.addAll(floorPlan.tables!);
            }
          }
          
          if (allTables.isEmpty) {
            return _buildEmptyState();
          }
          
          return _buildAllTablesList(allTables);
        } else {
          return _buildErrorState(result.errorMessage ?? 'Unknown error occurred');
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildAllTablesList(List<TablePosition> tables) {
    return Column(
      children: [
        // Statistics Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildStatusChip('Available', 
                tables.where((t) => t.tableStatus.toLowerCase() == 'available').length, 
                Colors.green),
              const SizedBox(width: 8),
              _buildStatusChip('Occupied', 
                tables.where((t) => t.tableStatus.toLowerCase() == 'occupied').length, 
                Colors.red),
              const SizedBox(width: 8),
              _buildStatusChip('Reserved', 
                tables.where((t) => t.tableStatus.toLowerCase() == 'reserved').length, 
                Colors.orange),
              const SizedBox(width: 8),
              _buildStatusChip('Cleaning', 
                tables.where((t) => t.tableStatus.toLowerCase() == 'cleaning').length, 
                Colors.purple),
            ],
          ),
        ),
        
        // Tables List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              return _buildTableListItem(table);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
                        style: TextStyle(
              color: color,
                          fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
                      ),
                    ),
                ],
              ),
    );
  }

  Widget _buildTableListItem(TablePosition table) {
    Color statusColor;
    IconData statusIcon;
    
    switch (table.tableStatus.toLowerCase()) {
      case 'available':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'occupied':
        statusColor = Colors.red;
        statusIcon = Icons.people;
        break;
      case 'reserved':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'cleaning':
        statusColor = Colors.purple;
        statusIcon = Icons.cleaning_services;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text('Table ${table.tableNumber}'),
        subtitle: Text('${table.tableCapacity} seats • ${table.tableSection}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                table.tableStatus.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showTableActions(table);
              },
              tooltip: 'Table Actions',
            ),
          ],
        ),
        onTap: () {
          _showTableActions(table);
        },
      ),
    );
  }

  void _showTableActions(TablePosition table) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildTableActionsSheet(table),
    );
  }

  Widget _buildTableActionsSheet(TablePosition table) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _getStatusColor(table.tableStatus).withOpacity(0.1),
                child: Icon(_getStatusIcon(table.tableStatus), 
                  color: _getStatusColor(table.tableStatus)),
              ),
              const SizedBox(width: 12),
              Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                      'Table ${table.tableNumber}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${table.tableCapacity} seats • ${table.tableSection}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(table.tableStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(table.tableStatus)),
                ),
                child: Text(
                  table.tableStatus.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(table.tableStatus),
                    fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
              ),
            ],
          ),
          
          // Reservation Information (if table is reserved and has reservation data)
          if (table.tableStatus.toLowerCase() == 'reserved' && table.reservation != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Reservation Details',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Real reservation details from API
                  _buildReservationDetailRow(Icons.person, 'Customer', table.reservation!.customerName),
                  if (table.reservation!.customerEmail != null && table.reservation!.customerEmail!.isNotEmpty)
                    _buildReservationDetailRow(Icons.email, 'Email', table.reservation!.customerEmail!),
                  if (table.reservation!.customerPhone != null && table.reservation!.customerPhone!.isNotEmpty)
                    _buildReservationDetailRow(Icons.phone, 'Phone', table.reservation!.customerPhone!),
                  _buildReservationDetailRow(Icons.people, 'Party Size', '${table.reservation!.partySize} guests'),
                  _buildReservationDetailRow(Icons.calendar_today, 'Date', table.reservation!.formattedDate),
                  _buildReservationDetailRow(Icons.access_time, 'Time', table.reservation!.formattedTime),
                  if (table.reservation!.status != null && table.reservation!.status!.isNotEmpty) ...[
                    _buildReservationDetailRow(Icons.info, 'Status', table.reservation!.status!.toUpperCase()),
                  ],
                  if (table.reservation!.customer?.preferences != null && table.reservation!.customer!.preferences!.isNotEmpty) ...[
                    _buildReservationDetailRow(Icons.favorite, 'Preferences', table.reservation!.customer!.preferences!),
                  ],
                  if (table.reservation!.notes != null && table.reservation!.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildReservationDetailRow(Icons.note, 'Notes', table.reservation!.notes!),
                  ],
                ],
              ),
            ),
          ] else if (table.tableStatus.toLowerCase() == 'reserved') ...[
            // Show placeholder when table is reserved but no reservation data available
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Reservation Details',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
        Container(
                    padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
                      color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange.shade200),
          ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade600, size: 14),
        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Table is reserved but no reservation details available. This may be a legacy reservation or the reservation data has expired.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Action Buttons
          _buildActionButton(
            'Seat Customers',
            Icons.person_add,
            Colors.blue,
            () => _seatCustomers(table),
            isEnabled: table.tableStatus.toLowerCase() == 'available',
          ),
          _buildActionButton(
            'Add Items to Order',
            Icons.add_shopping_cart,
            Colors.green,
            () => _addItemsToOrder(table),
            isEnabled: table.tableStatus.toLowerCase() == 'occupied',
          ),
          _buildActionButton(
            'Make Reservation',
            Icons.schedule,
            Colors.orange,
            () => _makeReservation(table),
            isEnabled: table.tableStatus.toLowerCase() == 'available',
          ),
          _buildActionButton(
            'Check-in Reservation',
            Icons.login,
            Colors.teal,
            () => _checkInReservation(table),
            isEnabled: table.tableStatus.toLowerCase() == 'reserved' && table.reservation != null,
          ),
          if (table.tableStatus.toLowerCase() == 'reserved' && table.reservation == null)
            _buildActionButton(
              'Clear Invalid Reservation',
              Icons.clear,
              Colors.red,
              () => _clearInvalidReservation(table),
              isEnabled: true,
            ),
          _buildActionButton(
            'Clear Table',
            Icons.cleaning_services,
            Colors.purple,
            () => _clearTable(table),
            isEnabled: table.tableStatus.toLowerCase() == 'occupied' || table.tableStatus.toLowerCase() == 'reserved',
          ),
          _buildActionButton(
            'View Order Details',
            Icons.receipt_long,
            Colors.indigo,
            () => _viewOrderDetails(table),
            isEnabled: table.tableStatus.toLowerCase() == 'occupied',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed, {bool isEnabled = true}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(icon, color: isEnabled ? Colors.white : Colors.grey),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? color : Colors.grey.shade300,
          foregroundColor: isEnabled ? Colors.white : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'occupied':
        return Colors.red;
      case 'reserved':
        return Colors.orange;
      case 'cleaning':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Icons.check_circle;
      case 'occupied':
        return Icons.people;
      case 'reserved':
        return Icons.schedule;
      case 'cleaning':
        return Icons.cleaning_services;
      default:
        return Icons.help;
    }
  }

  Widget _buildReservationDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange.shade600, size: 16),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action Methods
  void _seatCustomers(TablePosition table) {
    Navigator.of(context).pop();
    showSeatingDialog(context, table);
  }

  void _addItemsToOrder(TablePosition table) {
    Navigator.of(context).pop();
    _showAddItemsDialog(table);
  }

  void _makeReservation(TablePosition table) {
    print('🔍 DEBUG: _makeReservation called for table ${table.tableNumber}');
    Navigator.of(context).pop();
    showReservationDialog(context, table);
  }

  void _clearTable(TablePosition table) {
    Navigator.of(context).pop();
    _showClearTableDialog(table);
  }

  void _checkInReservation(TablePosition table) {
    Navigator.of(context).pop();
    _showCheckInReservationDialog(table);
  }

  void _viewOrderDetails(TablePosition table) {
    Navigator.of(context).pop();
    _showOrderDetailsDialog(table);
  }

  

  void _showAddItemsDialog(TablePosition table) async {
    print('🔍 DEBUG: _showAddItemsDialog called for table ${table.tableNumber} (ID: ${table.tableId})');
    
    // Try to get customer data from the table's current state
    String customerName = '';
    String notes = '';
    int partySize = 0;
    
    // Try to get from reservation data if available
    if (table.reservation != null) {
      customerName = table.reservation!.customerName ?? '';
      notes = table.reservation!.notes ?? '';
      partySize = table.reservation!.partySize ?? 0;
      print('🔍 DEBUG: Got customer data from reservation - customerName: "$customerName", notes: "$notes", partySize: $partySize');
    } else {
        // Try to get from API as fallback
        try {
          // First try to get from tablesWithOrders
          final tablesWithOrders = await ref.read(waiter.tablesWithOrdersProvider.future);
          final tableWithOrders = tablesWithOrders.firstWhere(
            (t) => t.id == table.tableId,
          );
          
          print('🔍 DEBUG: Found table with orders: ${tableWithOrders.name}');
          
          // Try to get customer data from nested customer field (new API structure)
          if (tableWithOrders.customer != null) {
            customerName = tableWithOrders.customer!.name;
            notes = tableWithOrders.customer!.notes ?? '';
            // Party size might be in the table metadata or order
            partySize = tableWithOrders.partySize ?? 1;
            print('🔍 DEBUG: Got customer data from nested customer field - customerName: "$customerName", notes: "$notes", partySize: $partySize');
          } else {
            // Fallback to legacy fields for backward compatibility
            customerName = tableWithOrders.customerName ?? '';
            notes = tableWithOrders.notes ?? '';
            partySize = tableWithOrders.partySize ?? 0;
            print('🔍 DEBUG: Got customer data from legacy fields - customerName: "$customerName", notes: "$notes", partySize: $partySize');
          }
          
          // If still no customer data, try to get from individual table endpoint
          if (customerName.isEmpty && table.tableStatus == 'occupied') {
            print('🔍 DEBUG: No customer data from tablesWithOrders, trying individual table endpoint');
            try {
              final tableRepository = ref.read(waiter.tableRepositoryProvider);
              final individualTable = await tableRepository.getTable(table.tableId);
              
              // Try to get customer data from nested customer field (new API structure)
              if (individualTable.customer != null) {
                customerName = individualTable.customer!.name;
                notes = individualTable.customer!.notes ?? '';
                partySize = individualTable.partySize ?? 1;
                print('🔍 DEBUG: Got customer data from individual table nested customer field - customerName: "$customerName", notes: "$notes", partySize: $partySize');
              } else {
                // Fallback to legacy fields
                customerName = individualTable.customerName ?? '';
                notes = individualTable.notes ?? '';
                partySize = individualTable.partySize ?? 0;
                print('🔍 DEBUG: Got customer data from individual table legacy fields - customerName: "$customerName", notes: "$notes", partySize: $partySize');
              }
            } catch (e) {
              print('🔍 DEBUG: Error getting individual table data: $e');
            }
          }
        } catch (e) {
          print('🔍 DEBUG: Error getting table data from API: $e');
          // Keep empty values if API fails
        }
      }
    
    // Since the backend API doesn't store customer data in the table model,
    // we need to implement a workaround. For now, we'll use default values
    // for occupied tables that don't have customer data
    if (table.tableStatus == 'occupied' && customerName.isEmpty) {
      print('🔍 DEBUG: Table is occupied but no customer data found, using default values');
      // Use default values since the backend doesn't store customer data
      customerName = 'Guest';
      notes = '';
      partySize = 1; // Default party size for occupied tables
    }
    
    // Navigate to order taking screen with customer data
    context.push(
      '/waiter/order/${table.tableId}',
      extra: {
        'table': {
          'id': table.tableId,
          'tableNumber': table.tableNumber,
          'capacity': table.tableCapacity,
          'section': table.tableSection,
          'status': table.tableStatus,
        },
        'prefillOrder': {
          'customerName': customerName,
          'partySize': partySize,
          'notes': notes,
          'items': [],
        },
      },
    );
  }



  void _showClearTableDialog(TablePosition table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Table ${table.tableNumber}'),
        content: const Text('Are you sure you want to clear this table? This will mark it as available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              print('🔍 DEBUG: Clear table button tapped for table ${table.tableNumber}');
              Navigator.of(context).pop();
              
              try {
                final container = ProviderScope.containerOf(context, listen: false);
                
                // Set table loading state
                _setTableLoading(table.tableId, true);
                
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
                        Text('Clearing table ${table.tableNumber}...'),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Call the clear table provider
                await container.read(waiter.clearTableProvider(table.tableId).future);
                
                print('🔍 DEBUG: Clear table successful for table ${table.tableNumber}');

                // Show success message
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Flushbar(
                        message: 'Table ${table.tableNumber} cleared successfully!',
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.green,
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                      ).show(context);
                    }
                  });
                }
                
                // Refresh the floor plan data to update table statuses
                print('🔍 DEBUG: Invalidating fp.floorPlansWithTablesProvider to refresh table statuses');
                ref.invalidate(fp.floorPlansWithTablesProvider);
                print('🔍 DEBUG: Provider invalidated, UI should refresh automatically');
                
                // Clear table loading state
                _setTableLoading(table.tableId, false);
                
              } catch (e) {
                print('🔍 DEBUG: Clear table failed for table ${table.tableNumber}: $e');
                
                // Show error message
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Flushbar(
                        message: 'Failed to clear table: ${e.toString()}',
                        duration: const Duration(seconds: 4),
                        backgroundColor: Colors.red,
                        icon: const Icon(Icons.error, color: Colors.white),
                      ).show(context);
                    }
                  });
                }
                // Clear table loading state on error
                _setTableLoading(table.tableId, false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Clear Table'),
          ),
        ],
      ),
    );
  }

  void _showCheckInReservationDialog(TablePosition table) {
    // Pre-populate with reservation data if available
    final customerNameController = TextEditingController(
      text: table.reservation?.customerName ?? '',
    );
    final partySizeController = TextEditingController(
      text: table.reservation?.partySize.toString() ?? '',
    );
    final notesController = TextEditingController(
      text: table.reservation?.notes ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Check-in Reservation - Table ${table.tableNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                hintText: 'Customer name or party name',
              ),
              ),
              const SizedBox(height: 16),
              TextField(
              controller: partySizeController,
                decoration: const InputDecoration(
                labelText: 'Party Size',
                hintText: 'Number of customers',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            TextField(
              controller: notesController,
                decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Special requests, etc.',
              ),
              maxLines: 3,
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
              print('🔍 DEBUG: Check-in reservation button tapped for table ${table.tableNumber}');
              
              final customerName = customerNameController.text.trim();
              final partySize = int.tryParse(partySizeController.text.trim()) ?? 0;
              final notes = notesController.text.trim();
              
              if (customerName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    content: Text('Please enter a customer name'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              if (partySize <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid party size'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
              
              try {
                final container = ProviderScope.containerOf(context, listen: false);
                
                // Set table loading state
                _setTableLoading(table.tableId, true);
                
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
                        Text('Checking in reservation for table ${table.tableNumber}...'),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Seat the customer (this will change status from reserved to occupied)
                await container.read(waiter.seatCustomerProvider((table.tableId, customerName, partySize, notes)).future);
                
                print('🔍 DEBUG: Check-in reservation successful for table ${table.tableNumber}');

                // Show success message
                if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reservation checked in successfully for Table ${table.tableNumber}!'),
          backgroundColor: Colors.green,
        ),
      );
                }
                
                // Clear table loading state on success
                _setTableLoading(table.tableId, false);
                
                // Refresh the floor plan data to update table statuses
                print('🔍 DEBUG: Invalidating fp.floorPlansWithTablesProvider to refresh table statuses');
                ref.invalidate(fp.floorPlansWithTablesProvider);
                print('🔍 DEBUG: Provider invalidated, UI should refresh automatically');
                
                // Navigate to order taking screen with captured data
                context.push(
                  '/waiter/order/${table.tableId}',
                  extra: {
                    'table': {
                      'id': table.tableId,
                      'tableNumber': table.tableNumber,
                      'capacity': table.tableCapacity,
                      'section': table.tableSection,
                      'status': 'occupied',
                    },
                    'prefillOrder': {
                      'customerName': customerName,
                      'partySize': partySize,
                      'notes': notes,
                      'items': [],
                    },
                  },
                );
                
              } catch (e) {
                // Clear table loading state on error
                _setTableLoading(table.tableId, false);
                
              } catch (e) {
                print('🔍 DEBUG: Check-in reservation failed for table ${table.tableNumber}: $e');
                
                // Show error message
                if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
                      content: Text('Failed to check-in reservation: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
              }
            },
            child: const Text('Check-in'),
          ),
        ],
      ),
    );
  }

  void _clearInvalidReservation(TablePosition table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Invalid Reservation'),
        content: Text('This table is marked as reserved but has no reservation details. Would you like to clear the reservation status and make it available?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                // Set table loading state
                _setTableLoading(table.tableId, true);
                
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
                        Text('Clearing invalid reservation for table ${table.tableNumber}...'),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // Update table status to available
                await ref.read(waiter.updateTableStatusProvider((
                  tableId: table.tableId,
                  status: waiter_table.TableStatus.available,
                )).future);
                
                // Clear table loading state on success
                _setTableLoading(table.tableId, false);
                
                // Refresh the floor plan data
                ref.invalidate(fp.floorPlansWithTablesAndReservationsProvider);
                ref.invalidate(fp.reservationsProvider);
                
                // Show success message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid reservation cleared for Table ${table.tableNumber}!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                // Clear table loading state on error
                _setTableLoading(table.tableId, false);
                
                // Show error message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to clear reservation: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear Reservation'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetailsDialog(TablePosition table) async {
    // Get the latest table data with orders to get customer info
    try {
                  final tablesWithOrders = await ref.read(waiter.tablesWithOrdersProvider.future);
      final tableWithOrders = tablesWithOrders.firstWhere(
        (t) => t.id == table.tableId,
      );
      
      // Navigate to order taking screen with customer data from the API
      context.push(
        '/waiter/order/${table.tableId}',
        extra: {
          'table': {
            'id': table.tableId,
            'tableNumber': table.tableNumber,
            'capacity': table.tableCapacity,
            'section': table.tableSection,
            'status': table.tableStatus,
          },
          'prefillOrder': {
            'customerName': tableWithOrders.customerName ?? '',
            'partySize': tableWithOrders.partySize ?? 0,
            'notes': tableWithOrders.notes ?? '',
            'items': [],
          },
        },
      );
    } catch (e) {
      // Fallback to reservation data if API call fails
      context.push(
        '/waiter/order/${table.tableId}',
        extra: {
          'table': {
            'id': table.tableId,
            'tableNumber': table.tableNumber,
            'capacity': table.tableCapacity,
            'section': table.tableSection,
            'status': table.tableStatus,
          },
          'prefillOrder': {
            'customerName': table.reservation?.customerName ?? '',
            'partySize': table.reservation?.partySize ?? 0,
            'notes': table.reservation?.notes ?? '',
            'items': [],
          },
        },
      );
    }
  }

  Widget _buildNoFloorPlanSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Select a Floor Plan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a floor plan from the dropdown above to view tables',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_restaurant,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tables found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tables will appear here once they are added to floor plans',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading floor plans',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _refreshFloorPlans(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
} 
