import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:another_flushbar/flushbar.dart';
import 'floor_plan_provider.dart' as fp;
import 'progressive_loading_provider.dart';
import 'models/floor_plan.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/result.dart';
import '../waiter/table_provider.dart' as waiter;
import '../waiter/models/table.dart' as waiter_table;
import 'package:flutter/foundation.dart';
import 'dialogs/reservation_dialog.dart';
import 'dialogs/seating_dialog.dart';
import 'widgets/floor_plan_viewer.dart';
import '../../shared/widgets/bottom_navigation.dart';

class FloorPlanViewerScreen extends ConsumerStatefulWidget {
  const FloorPlanViewerScreen({super.key});

  @override
  ConsumerState<FloorPlanViewerScreen> createState() => _FloorPlanViewerScreenState();
}

class _FloorPlanViewerScreenState extends ConsumerState<FloorPlanViewerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  FloorPlan? _selectedFloorPlan;
  bool _isRefreshing = false;
  
  // Track which tables are currently being synchronized
  final Set<int> _loadingTableIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Start auto-refresh when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fp.progressiveFloorPlansProvider.notifier).loadFloorPlansProgressive();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      
      // Force refresh the progressive provider
      await ref.read(fp.progressiveFloorPlansProvider.notifier).refresh();
      
      // Wait for the API to process changes
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

  void _onFloorPlanSelected(FloorPlan floorPlan) {
    setState(() {
      _selectedFloorPlan = floorPlan;
    });
  }

  void _onTableTapped(TablePosition table) {
    // Handle table tap - show table actions
    _showTableActions(table);
  }

  void _showTableActions(TablePosition table) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildTableActionsSheet(table),
    );
  }

  Widget _buildTableActionsSheet(TablePosition table) {
    final theme = Theme.of(context);
    final isOccupied = table.tableStatus.toLowerCase() == 'occupied';
    
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
                backgroundColor: _getStatusColor(table.tableStatus, theme).withOpacity(0.1),
                child: Icon(_getStatusIcon(table.tableStatus), 
                  color: _getStatusColor(table.tableStatus, theme)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Table ${table.tableNumber}',
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      '${table.tableCapacity} seats • ${table.tableSection}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(table.tableStatus, theme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(table.tableStatus, theme)),
                ),
                child: Text(
                  table.tableStatus.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(table.tableStatus, theme),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          if (!isOccupied) ...[
            _buildActionButton(
              'Seat Customers',
              Icons.person_add,
              theme.colorScheme.primary,
              () => _seatCustomers(table),
              isEnabled: table.tableStatus.toLowerCase() == 'available',
            ),
            _buildActionButton(
              'Make Reservation',
              Icons.schedule,
              theme.colorScheme.tertiary,
              () => _makeReservation(table),
              isEnabled: table.tableStatus.toLowerCase() == 'available',
            ),
          ],
          
          if (isOccupied) ...[
            _buildActionButton(
              'Add Items',
              Icons.add_shopping_cart,
              theme.colorScheme.secondary,
              () => _addItems(table),
              isEnabled: true,
            ),
            _buildActionButton(
              'View Order',
              Icons.receipt_long,
              theme.colorScheme.primary,
              () => _viewOrder(table),
              isEnabled: true,
            ),
          ],
          
          _buildActionButton(
            'Clear Table',
            Icons.cleaning_services,
            theme.colorScheme.primary,
            () => _clearTable(table),
            isEnabled: table.tableStatus.toLowerCase() == 'occupied' || table.tableStatus.toLowerCase() == 'reserved',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed, {bool isEnabled = true}) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: Icon(icon, color: isEnabled ? Colors.white : theme.colorScheme.onSurfaceVariant),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? color : theme.colorScheme.surfaceVariant,
          foregroundColor: isEnabled ? Colors.white : theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'available':
        return theme.colorScheme.secondary;
      case 'occupied':
        return theme.colorScheme.error;
      case 'reserved':
        return theme.colorScheme.tertiary;
      case 'cleaning':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.onSurfaceVariant;
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

  // Action Methods
  void _seatCustomers(TablePosition table) {
    Navigator.of(context).pop();
    showSeatingDialog(context, table);
  }

  void _makeReservation(TablePosition table) {
    Navigator.of(context).pop();
    showReservationDialog(context, table);
  }

  void _addItems(TablePosition table) {
    Navigator.of(context).pop();
    _navigateToPosWithTable(table);
  }

  void _viewOrder(TablePosition table) {
    Navigator.of(context).pop();
    _navigateToPosWithTable(table);
  }

  void _navigateToPosWithTable(TablePosition table) async {
    try {
      print('🔍 DEBUG: Fetching complete table data for table ${table.tableId}');
      
      // Fetch the complete table information with customer data
      final completeTable = await ref.read(waiter.tableProvider(table.tableId).future);
      
      print('🔍 DEBUG: Complete table data fetched:');
      print('🔍 DEBUG: - Table ID: ${completeTable.id}');
      print('🔍 DEBUG: - Table Name: ${completeTable.name}');
      print('🔍 DEBUG: - Table Status: ${completeTable.status}');
      print('🔍 DEBUG: - Customer: ${completeTable.customer}');
      print('🔍 DEBUG: - Customer Name (legacy): ${completeTable.customerName}');
      print('🔍 DEBUG: - Notes (legacy): ${completeTable.notes}');
      
      // Navigate to Order Taking screen with complete table context
      if (mounted) {
        print('🔍 DEBUG: Navigating to Order Taking Screen with complete table data');
        context.push('/waiter/order/${table.tableId}', extra: {
          'table': completeTable,
        });
      }
    } catch (e) {
      print('🔍 DEBUG: Error fetching complete table data: $e');
      // Fallback to basic table info if fetching fails
      if (mounted) {
        print('🔍 DEBUG: Using fallback table data');
        context.push('/waiter/order/${table.tableId}', extra: {
          'table': {
            'id': table.tableId,
            'name': table.tableNumber,
            'section': table.tableSection,
            'capacity': table.tableCapacity,
            'status': table.tableStatus,
          },
        });
      }
    }
  }

  void _clearTable(TablePosition table) {
    Navigator.of(context).pop();
    _showClearTableDialog(table);
  }

  void _showClearTableDialog(TablePosition table) {
    final theme = Theme.of(context);
    
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
              Navigator.of(context).pop();
              
              try {
                _setTableLoading(table.tableId, true);
                
                // Call the clear table provider
                await ref.read(waiter.clearTableProvider(table.tableId).future);
                
                // Show success message
                if (mounted) {
                  Flushbar(
                    message: 'Table ${table.tableNumber} cleared successfully!',
                    duration: const Duration(seconds: 3),
                    backgroundColor: theme.colorScheme.secondary,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                  ).show(context);
                }
                
                // Refresh the floor plan data
                await ref.read(fp.progressiveFloorPlansProvider.notifier).refresh();
                
              } catch (e) {
                if (mounted) {
                  Flushbar(
                    message: 'Failed to clear table: ${e.toString()}',
                    duration: const Duration(seconds: 4),
                    backgroundColor: theme.colorScheme.error,
                    icon: const Icon(Icons.error, color: Colors.white),
                  ).show(context);
                }
              } finally {
                _setTableLoading(table.tableId, false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
            child: const Text('Clear Table'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floorPlanState = ref.watch(fp.progressiveFloorPlansProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floor Plan Viewer'),
        // Remove hardcoded colors - let theme handle it
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.onSurface,
          labelColor: theme.colorScheme.onSurface,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
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
              child: Text(
                'Refreshing...',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
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
              // Floor Plans Tab
              _buildFloorPlansTab(floorPlanState),
              // All Tables Tab
              _buildAllTablesTab(floorPlanState),
            ],
          ),
          // Loading overlay when refreshing
          if (_isRefreshing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Refreshing floor plan data...',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
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
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildFloorPlansTab(AsyncValue<Result<List<FloorPlan>>> floorPlanState) {
    return floorPlanState.when(
      data: (result) {
        if (!result.isSuccess) {
          return _buildErrorState(result.errorMessage ?? 'Failed to load floor plans');
        }
        final floorPlans = result.data;
        if (floorPlans.isEmpty) {
          return _buildEmptyState();
        }
        
        // Get progress information from the provider
        final provider = ref.read(progressiveFloorPlanNotifierProvider.notifier);
        final isFullyLoaded = provider.isFullyLoaded;
        final totalCount = provider.totalFloorPlans;
        final loadedCount = provider.loadedFloorPlans;
        
        // Only show loading if we're not fully loaded AND we have a total count
        final shouldShowLoading = !isFullyLoaded && totalCount > 0;
        
        return FloorPlanViewer(
          floorPlans: floorPlans,
          selectedFloorPlan: _selectedFloorPlan,
          onFloorPlanSelected: _onFloorPlanSelected,
          onTableTapped: _onTableTapped,
          loadingTableIds: _loadingTableIds,
          isFloorPlansTab: true,
          isLoading: shouldShowLoading,
          loadedCount: shouldShowLoading ? loadedCount : null,
          totalCount: shouldShowLoading ? totalCount : null,
        );
      },
      loading: () {
        // Get progress information from the provider
        final provider = ref.read(progressiveFloorPlanNotifierProvider.notifier);
        
        return FloorPlanViewer(
          floorPlans: const [],
          selectedFloorPlan: null,
          onFloorPlanSelected: null,
          onTableTapped: null,
          loadingTableIds: const {},
          isFloorPlansTab: true,
          isLoading: true,
          loadedCount: provider.loadedFloorPlans,
          totalCount: provider.totalFloorPlans,
        );
      },
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildAllTablesTab(AsyncValue<Result<List<FloorPlan>>> floorPlanState) {
    return floorPlanState.when(
      data: (result) {
        if (!result.isSuccess) {
          return _buildErrorState(result.errorMessage ?? 'Failed to load floor plans');
        }
        final floorPlans = result.data;
        if (floorPlans.isEmpty) {
          return _buildEmptyState();
        }
        
        // Get progress information from the provider
        final provider = ref.read(progressiveFloorPlanNotifierProvider.notifier);
        final isFullyLoaded = provider.isFullyLoaded;
        final totalCount = provider.totalFloorPlans;
        final loadedCount = provider.loadedFloorPlans;
        
        // Only show loading if we're not fully loaded AND we have a total count
        final shouldShowLoading = !isFullyLoaded && totalCount > 0;
        
        return FloorPlanViewer(
          floorPlans: floorPlans,
          selectedFloorPlan: _selectedFloorPlan,
          onFloorPlanSelected: _onFloorPlanSelected,
          onTableTapped: _onTableTapped,
          loadingTableIds: _loadingTableIds,
          isFloorPlansTab: false,
          isLoading: shouldShowLoading,
          loadedCount: shouldShowLoading ? loadedCount : null,
          totalCount: shouldShowLoading ? totalCount : null,
        );
      },
      loading: () {
        // Get progress information from the provider
        final provider = ref.read(progressiveFloorPlanNotifierProvider.notifier);
        
        return FloorPlanViewer(
          floorPlans: const [],
          selectedFloorPlan: null,
          onFloorPlanSelected: null,
          onTableTapped: null,
          loadingTableIds: const {},
          isFloorPlansTab: false,
          isLoading: true,
          loadedCount: provider.loadedFloorPlans,
          totalCount: provider.totalFloorPlans,
        );
      },
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_restaurant,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No floor plans found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Floor plans will appear here once they are created',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Error loading floor plans',
            style: theme.textTheme.headlineSmall,
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
