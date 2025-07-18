import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/bottom_navigation.dart';
import 'models/table.dart' as waiter_table;
import '../floor_plan/floor_plan_provider.dart' as fp;
import '../floor_plan/models/floor_plan.dart';

class TablesScreen extends ConsumerWidget {
  const TablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floorPlanState = ref.watch(fp.progressiveFloorPlansProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables Management'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(fp.progressiveFloorPlansProvider.notifier).refresh();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: floorPlanState.when(
        data: (result) {
          if (!result.isSuccess) {
            return _buildErrorState(result.errorMessage ?? 'Failed to load tables');
          }
          final floorPlans = result.data;
          return Column(
            children: [
              // Quick Stats
              _buildQuickStats(context, floorPlans),
              
              // Tables List
              Expanded(
                child: _buildTablesList(context, floorPlans),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildQuickStats(BuildContext context, List<FloorPlan> floorPlans) {
    // Calculate stats from actual data
    int available = 0;
    int occupied = 0;
    int reserved = 0;
    int cleaning = 0;
    
    for (final floorPlan in floorPlans) {
      if (floorPlan.tables != null) {
        for (final table in floorPlan.tables!) {
          switch (table.tableStatus.toLowerCase()) {
            case 'available':
              available++;
              break;
            case 'occupied':
              occupied++;
              break;
            case 'reserved':
              reserved++;
              break;
            case 'cleaning':
              cleaning++;
              break;
          }
        }
      }
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Available', available.toString(), Colors.green),
          ),
          Expanded(
            child: _buildStatItem('Occupied', occupied.toString(), Colors.red),
          ),
          Expanded(
            child: _buildStatItem('Reserved', reserved.toString(), Colors.orange),
          ),
          Expanded(
            child: _buildStatItem('Cleaning', cleaning.toString(), Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTablesList(BuildContext context, List<FloorPlan> floorPlans) {
    // Collect all tables from all floor plans
    final allTables = <TablePosition>[];
    for (final floorPlan in floorPlans) {
      if (floorPlan.tables != null) {
        allTables.addAll(floorPlan.tables!);
      }
    }

    if (allTables.isEmpty) {
      return const Center(
        child: Text('No tables found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: allTables.length,
      itemBuilder: (context, index) {
        final table = allTables[index];
        return _buildTableCard(context, table);
      },
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

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error loading tables',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Refresh data
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, TablePosition table) {
    final statusColor = _getStatusColor(table.tableStatus);
    final statusIcon = _getStatusIcon(table.tableStatus);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTableActions(context, table),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              // Status Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              
              const SizedBox(width: 16),
              
              // Table Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Table ${table.tableNumber}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${table.tableCapacity} seats • ${table.tableSection}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status Badge
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
              
              // Action Icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTableActions(BuildContext context, TablePosition table) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildTableActionsSheet(context, table),
    );
  }

  Widget _buildTableActionsSheet(BuildContext context, TablePosition table) {
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
          
          const SizedBox(height: 24),
          
          // Action Buttons
          _buildActionButton(
            'Seat Customers',
            Icons.person_add,
            Colors.blue,
            () => _seatCustomers(context, table),
            isEnabled: table.tableStatus.toLowerCase() == 'available',
          ),
          _buildActionButton(
            'Make Reservation',
            Icons.schedule,
            Colors.orange,
            () => _makeReservation(context, table),
            isEnabled: table.tableStatus.toLowerCase() == 'available',
          ),
          _buildActionButton(
            'Clear Table',
            Icons.cleaning_services,
            Colors.purple,
            () => _clearTable(context, table),
            isEnabled: table.tableStatus.toLowerCase() == 'occupied' || table.tableStatus.toLowerCase() == 'reserved',
          ),
          _buildActionButton(
            'View Details',
            Icons.info,
            Colors.grey,
            () => _viewDetails(context, table),
            isEnabled: true,
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

  void _seatCustomers(BuildContext context, TablePosition table) {
    Navigator.of(context).pop();
    // TODO: Implement seating dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Seating customers at Table ${table.tableNumber}')),
    );
  }

  void _makeReservation(BuildContext context, TablePosition table) {
    Navigator.of(context).pop();
    // TODO: Implement reservation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Making reservation for Table ${table.tableNumber}')),
    );
  }

  void _clearTable(BuildContext context, TablePosition table) {
    Navigator.of(context).pop();
    // TODO: Implement clear table
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clearing Table ${table.tableNumber}')),
    );
  }

  void _viewDetails(BuildContext context, TablePosition table) {
    Navigator.of(context).pop();
    // TODO: Navigate to table details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for Table ${table.tableNumber}')),
    );
  }
} 