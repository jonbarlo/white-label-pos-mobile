import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'floor_plan_provider.dart';
import 'models/floor_plan.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/result.dart';
import '../waiter/table_provider.dart';
import '../waiter/models/table.dart' as waiter_table;
import 'package:flutter/foundation.dart';

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
      // Force clear all provider caches
      ref.invalidate(floorPlansWithTablesProvider);
      ref.invalidate(tableProvider);
      ref.invalidate(tablesProvider);
      ref.invalidate(floorPlanNotifierProvider);
      ref.invalidate(seatCustomerProvider);
      ref.invalidate(tablesByStatusProvider);
      ref.invalidate(myAssignedTablesProvider);
      
      // Force clear all floor plan related providers
      ref.invalidate(floorPlansProvider);
      ref.invalidate(floorPlanProvider);
      ref.invalidate(floorPlanWithTablesProvider);
      ref.invalidate(tablePositionsProvider);
      ref.invalidate(allTablesProvider);
      
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

  @override
  Widget build(BuildContext context) {
    final floorPlanState = ref.watch(floorPlansWithTablesProvider);
    
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
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Force rebuild with fresh data
          _buildFloorPlansTab(floorPlanState),
          _buildAllTablesTab(floorPlanState),
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
            _showTableActions(table);
          },
          child: Container(
            width: table.width.toDouble(),
            height: table.height.toDouble(),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              border: Border.all(color: statusColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
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
                  if (table.reservation!.customerPhone != null && table.reservation!.customerPhone!.isNotEmpty)
                    _buildReservationDetailRow(Icons.phone, 'Phone', table.reservation!.customerPhone!),
                  _buildReservationDetailRow(Icons.people, 'Party Size', '${table.reservation!.partySize} guests'),
                  _buildReservationDetailRow(Icons.calendar_today, 'Date', table.reservation!.formattedDate),
                  _buildReservationDetailRow(Icons.access_time, 'Time', table.reservation!.formattedTime),
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
            isEnabled: table.tableStatus.toLowerCase() == 'reserved',
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
    _showSeatCustomersDialog(table);
  }

  void _addItemsToOrder(TablePosition table) {
    Navigator.of(context).pop();
    _showAddItemsDialog(table);
  }

  void _makeReservation(TablePosition table) {
    Navigator.of(context).pop();
    _showReservationDialog(table);
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

  // Dialog Methods
  void _showSeatCustomersDialog(TablePosition table) {
    final customerNameController = TextEditingController();
    final partySizeController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seat Customers - Table ${table.tableNumber}'),
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
                // Actually seat the customer using the provider
                await ref.read(seatCustomerProvider((table.tableId, customerName, partySize, notes)).future);
                // Invalidate floorPlansWithTablesProvider to force UI update
                ref.invalidate(floorPlansWithTablesProvider);
                // Navigate to order taking screen
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Customers seated at Table ${table.tableNumber}'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error seating customers: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Seat Customers'),
          ),
        ],
      ),
    );
  }

  void _showAddItemsDialog(TablePosition table) {
    // Navigate directly to order taking screen for occupied tables
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
          'partySize': 0, // Will be filled from existing order
          'notes': '',
          'items': [],
        },
      },
    );
  }

  void _showReservationDialog(TablePosition table) {
    final customerNameController = TextEditingController();
    final customerPhoneController = TextEditingController();
    final partySizeController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Make Reservation - Table ${table.tableNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                hintText: 'Full name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Contact number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: partySizeController,
              decoration: const InputDecoration(
                labelText: 'Party Size',
                hintText: 'Number of guests',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        dateController.text = '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            dateController.text.isEmpty ? 'Select Date' : dateController.text,
                            style: TextStyle(
                              color: dateController.text.isEmpty ? Colors.grey.shade500 : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        timeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 20, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            timeController.text.isEmpty ? 'Select Time' : timeController.text,
                            style: TextStyle(
                              color: timeController.text.isEmpty ? Colors.grey.shade500 : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
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
            onPressed: () async {
              print('🔍 DEBUG: Make reservation button tapped for table ${table.tableNumber}');
              
              // Validate inputs
              final customerName = customerNameController.text.trim();
              final partySize = int.tryParse(partySizeController.text.trim());
              final date = dateController.text.trim();
              final time = timeController.text.trim();
              
              if (customerName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a customer name'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              if (partySize == null || partySize < 1) {
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
                        Text('Making reservation for table ${table.tableNumber}...'),
                      ],
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Update table status to reserved
                await container.read(updateTableStatusProvider((
                  tableId: table.tableId,
                  status: waiter_table.TableStatus.reserved,
                )).future);
                
                print('🔍 DEBUG: Reservation successful for table ${table.tableNumber}');

                // Show success message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reservation made successfully for Table ${table.tableNumber}!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                
                // Refresh the floor plan data to update table statuses
                print('🔍 DEBUG: Invalidating floorPlansWithTablesProvider to refresh table statuses');
                ref.invalidate(floorPlansWithTablesProvider);
                print('🔍 DEBUG: Provider invalidated, UI should refresh automatically');
                
              } catch (e) {
                print('🔍 DEBUG: Reservation failed for table ${table.tableNumber}: $e');
                
                // Show error message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to make reservation: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Make Reservation'),
          ),
        ],
      ),
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
                await container.read(clearTableProvider(table.tableId).future);
                
                print('🔍 DEBUG: Clear table successful for table ${table.tableNumber}');

                // Show success message
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Table ${table.tableNumber} cleared successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                
                // Refresh the floor plan data to update table statuses
                print('🔍 DEBUG: Invalidating floorPlansWithTablesProvider to refresh table statuses');
                ref.invalidate(floorPlansWithTablesProvider);
                print('🔍 DEBUG: Provider invalidated, UI should refresh automatically');
                
              } catch (e) {
                print('🔍 DEBUG: Clear table failed for table ${table.tableNumber}: $e');
                
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
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Clear Table'),
          ),
        ],
      ),
    );
  }

  void _showCheckInReservationDialog(TablePosition table) {
    final customerNameController = TextEditingController();
    final partySizeController = TextEditingController();
    final notesController = TextEditingController();

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
                await container.read(seatCustomerProvider((table.tableId, customerName, partySize, notes)).future);
                
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
                
                // Refresh the floor plan data to update table statuses
                print('🔍 DEBUG: Invalidating floorPlansWithTablesProvider to refresh table statuses');
                ref.invalidate(floorPlansWithTablesProvider);
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

  void _showOrderDetailsDialog(TablePosition table) {
    // Navigate to order taking screen to view existing order
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
          'partySize': 0, // Will be filled from existing order
          'notes': '',
          'items': [],
        },
      },
    );
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