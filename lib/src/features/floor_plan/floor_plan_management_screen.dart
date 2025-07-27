import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'floor_plan_provider.dart';
import 'models/floor_plan.dart';
import 'floor_plan_viewer_screen.dart';
import 'floor_plan_edit_screen.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/result.dart';
import '../../shared/widgets/loading_indicator.dart';

class FloorPlanManagementScreen extends ConsumerStatefulWidget {
  const FloorPlanManagementScreen({super.key});

  @override
  ConsumerState<FloorPlanManagementScreen> createState() => _FloorPlanManagementScreenState();
}

class _FloorPlanManagementScreenState extends ConsumerState<FloorPlanManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFloorPlan = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Load floor plans progressively when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(progressiveFloorPlansProvider.notifier).startFreshLoad();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floorPlanState = ref.watch(progressiveFloorPlansProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Floor Plan Management',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.colorScheme.onSurface),
            onPressed: () => ref.read(progressiveFloorPlansProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: theme.colorScheme.onPrimary,
              unselectedLabelColor: theme.colorScheme.onSurface,
              labelStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Floor Plans'),
                Tab(text: 'Tables'),
                Tab(text: 'Settings'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(floorPlanState),
          _buildFloorPlansTab(floorPlanState),
          _buildTablesTab(floorPlanState),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AsyncValue<Result<List<FloorPlan>>> floorPlanState) {
    print('🔍 DEBUG: _buildOverviewTab called with state: $floorPlanState');
    
    return floorPlanState.when(
      data: (result) {
        print('🔍 DEBUG: _buildOverviewTab: data received: $result');
        if (result.isSuccess) {
          final floorPlans = result.data;
          print('🔍 DEBUG: _buildOverviewTab: Found ${floorPlans.length} floor plans');
          return _buildRestaurantOverview(floorPlans);
        } else {
          print('🔍 DEBUG: _buildOverviewTab: API error: ${result.errorMessage}');
          return _buildErrorState(result.errorMessage ?? 'Unknown error occurred');
        }
      },
      loading: () {
        print('🔍 DEBUG: _buildOverviewTab: Loading state');
        return const Center(child: LoadingIndicator());
      },
      error: (error, stack) {
        print('🔍 DEBUG: _buildOverviewTab: Error state: $error');
        return _buildErrorState(error.toString());
      },
    );
  }

  Widget _buildRestaurantOverview(List<FloorPlan> floorPlans) {
    final theme = Theme.of(context);
    
    // Calculate statistics
    int totalTables = 0;
    int availableTables = 0;
    int occupiedTables = 0;
    int reservedTables = 0;
    int cleaningTables = 0;
    double totalRevenue = 0.0;

    for (final floorPlan in floorPlans) {
      if (floorPlan.tables != null) {
        totalTables += floorPlan.tables!.length;
        for (final table in floorPlan.tables!) {
          switch (table.tableStatus.toLowerCase()) {
            case 'available':
              availableTables++;
              break;
            case 'occupied':
              occupiedTables++;
              break;
            case 'reserved':
              reservedTables++;
              break;
            case 'cleaning':
              cleaningTables++;
              break;
          }
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Metrics Section
          _buildSectionHeader(
            title: 'Table Status Overview',
            subtitle: 'Real-time restaurant floor plan metrics',
            icon: Icons.analytics,
            theme: theme,
          ),
          
          // Compact Statistics Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCompactStatCard('Total Tables', totalTables.toString(), Icons.table_restaurant, theme.colorScheme.primary, theme),
                const SizedBox(width: 8),
                _buildCompactStatCard('Available', availableTables.toString(), Icons.check_circle, Colors.green, theme),
                const SizedBox(width: 8),
                _buildCompactStatCard('Occupied', occupiedTables.toString(), Icons.people, Colors.red, theme),
                const SizedBox(width: 8),
                _buildCompactStatCard('Reserved', reservedTables.toString(), Icons.schedule, Colors.orange, theme),
                const SizedBox(width: 8),
                _buildCompactStatCard('Cleaning', cleaningTables.toString(), Icons.cleaning_services, Colors.purple, theme),
                const SizedBox(width: 8),
                _buildCompactStatCard('Revenue Today', '\$${totalRevenue.toStringAsFixed(2)}', Icons.attach_money, theme.colorScheme.secondary, theme),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Floor Plan Summary Section Header with Create Button
          Row(
            children: [
              Expanded(
                child: _buildSectionHeader(
                  title: 'Floor Plans',
                  subtitle: 'Manage your restaurant layouts and table arrangements',
                  icon: Icons.map,
                  theme: theme,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddFloorPlanDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create Floor Plan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Compact Floor Plan Cards with lazy loading
          floorPlans.isEmpty
              ? _buildEmptyFloorPlansState(theme)
              : Column(
                  children: floorPlans.map((floorPlan) => _buildCompactFloorPlanCard(floorPlan, theme)).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.08),
              color.withValues(alpha: 0.04),
            ],
          ),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, color: color, size: 14),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.trending_up,
                    color: color.withValues(alpha: 0.6),
                    size: 12,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactFloorPlanCard(FloorPlan floorPlan, ThemeData theme) {
    return _FloorPlanCardWithAnimation(
      key: ValueKey(floorPlan.id),
      floorPlan: floorPlan,
      theme: theme,
      onTap: () => _viewFloorPlan(floorPlan),
      onEdit: () => _editFloorPlan(floorPlan),
      onDelete: () => _deleteFloorPlan(floorPlan),
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
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildFloorPlansList(List<FloorPlan> floorPlans) {
    return Column(
      children: [
        // Action Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddFloorPlanDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Floor Plan'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => ref.read(progressiveFloorPlansProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        
        // Floor Plans List
        Expanded(
          child: floorPlans.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: floorPlans.length,
                  itemBuilder: (context, index) {
                    final floorPlan = floorPlans[index];
                    return _buildFloorPlanListItem(floorPlan);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFloorPlanListItem(FloorPlan floorPlan) {
    final tableCount = floorPlan.tables?.length ?? 0;
    final availableCount = floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'available').length ?? 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.map, color: Colors.white),
        ),
        title: Text(floorPlan.name),
        subtitle: Text('$tableCount tables • $availableCount available'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Table Status Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusChip('Available', availableCount, Colors.green),
                    _buildStatusChip('Occupied', 
                      floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'occupied').length ?? 0, 
                      Colors.red),
                    _buildStatusChip('Reserved', 
                      floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'reserved').length ?? 0, 
                      Colors.orange),
                    _buildStatusChip('Cleaning', 
                      floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'cleaning').length ?? 0, 
                      Colors.purple),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewFloorPlan(floorPlan),
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editFloorPlan(floorPlan),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _manageTables(floorPlan),
                        icon: const Icon(Icons.table_restaurant),
                        label: const Text('Tables'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTablesTab(AsyncValue<Result<List<FloorPlan>>> floorPlanState) {
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
          
          return _buildTablesListFromTablePositions(allTables);
        } else {
          return _buildErrorState(result.errorMessage ?? 'Unknown error occurred');
        }
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildTablesListFromTablePositions(List<TablePosition> tables) {
    return Column(
      children: [
        // Action Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddTableDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Table'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showBulkEditDialog(),
                icon: const Icon(Icons.edit),
                label: const Text('Bulk Edit'),
              ),
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
                table.tableStatus,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editTable(table),
              tooltip: 'Edit Table',
            ),
          ],
        ),
        onTap: () => _editTable(table),
      ),
    );
  }

  Widget _buildTableListItemFromMap(Map<String, dynamic> table) {
    Color statusColor;
    IconData statusIcon;
    
    final status = table['status']?.toString().toLowerCase() ?? 'available';
    switch (status) {
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
        title: Text('Table ${table['tableNumber'] ?? 'Unknown'}'),
        subtitle: Text('${table['capacity'] ?? 0} seats • ${table['section'] ?? 'Unknown'}'),
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
                table['status']?.toString().toUpperCase() ?? 'UNKNOWN',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editTableFromMap(table),
              tooltip: 'Edit Table',
            ),
          ],
        ),
        onTap: () => _editTableFromMap(table),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚙️ OPERATIONAL SETTINGS',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Settings Cards
          _buildSettingCard(
            'Reservation Settings',
            'Configure reservation time limits and policies',
            Icons.schedule,
            () => _showReservationSettings(),
          ),
          
          _buildSettingCard(
            'Table Rotation',
            'Set table rotation and assignment policies',
            Icons.rotate_right,
            () => _showTableRotationSettings(),
          ),
          
          _buildSettingCard(
            'Cleaning Schedule',
            'Configure table cleaning time requirements',
            Icons.cleaning_services,
            () => _showCleaningSettings(),
          ),
          
          _buildSettingCard(
            'Floor Plan Export',
            'Export floor plans for printing or sharing',
            Icons.download,
            () => _exportFloorPlans(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(String title, String description, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
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
            'Create your first table to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddTableDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Create Table'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        child: Card(
          elevation: 2,
          shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.error.withValues(alpha: 0.08),
                  theme.colorScheme.error.withValues(alpha: 0.04),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to Load Floor Plans',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your connection and try again',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(floorPlansWithTablesProvider),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Action Methods
  void _showAddFloorPlanDialog() {
    final nameController = TextEditingController();
    final widthController = TextEditingController(text: '1200');
    final heightController = TextEditingController(text: '800');
    final backgroundImageController = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Floor Plan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Floor Plan Name *',
                    hintText: 'e.g., Main Floor, Patio, Bar Area',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        decoration: const InputDecoration(
                          labelText: 'Width (pixels) *',
                          hintText: 'e.g., 1200',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          labelText: 'Height (pixels) *',
                          hintText: 'e.g., 800',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: backgroundImageController,
                  decoration: const InputDecoration(
                    labelText: 'Background Image URL (Optional)',
                    hintText: 'https://example.com/background.jpg',
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Active'),
                  subtitle: const Text('Floor plan is active and can be used'),
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value ?? true;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty &&
                    widthController.text.trim().isNotEmpty &&
                    heightController.text.trim().isNotEmpty) {
                  
                  final width = int.tryParse(widthController.text.trim());
                  final height = int.tryParse(heightController.text.trim());
                  
                  if (width == null || width <= 0 || height == null || height <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid width and height (positive numbers)'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop();
                  ref.read(floorPlanNotifierProvider.notifier).createFloorPlan({
                    'name': nameController.text.trim(),
                    'width': width,
                    'height': height,
                    if (backgroundImageController.text.trim().isNotEmpty)
                      'backgroundImage': backgroundImageController.text.trim(),
                    'isActive': isActive,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _viewFloorPlan(FloorPlan floorPlan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FloorPlanEditScreen(
          floorPlanId: floorPlan.id,
          isEditMode: false,
        ),
      ),
    );
  }

  void _editFloorPlan(FloorPlan floorPlan) {
    final nameController = TextEditingController(text: floorPlan.name);
    final widthController = TextEditingController(text: floorPlan.width.toString());
    final heightController = TextEditingController(text: floorPlan.height.toString());
    final backgroundImageController = TextEditingController(text: floorPlan.backgroundImage ?? '');
    bool isActive = floorPlan.isActive;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit Floor Plan: ${floorPlan.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Floor Plan Name *',
                    hintText: 'e.g., Main Floor, Patio, Bar Area',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        decoration: const InputDecoration(
                          labelText: 'Width (pixels) *',
                          hintText: 'e.g., 1200',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          labelText: 'Height (pixels) *',
                          hintText: 'e.g., 800',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: backgroundImageController,
                  decoration: const InputDecoration(
                    labelText: 'Background Image URL (Optional)',
                    hintText: 'https://example.com/background.jpg',
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Active'),
                  subtitle: const Text('Floor plan is active and can be used'),
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value ?? true;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty &&
                    widthController.text.trim().isNotEmpty &&
                    heightController.text.trim().isNotEmpty) {
                  
                  final width = int.tryParse(widthController.text.trim());
                  final height = int.tryParse(heightController.text.trim());
                  
                  if (width == null || width <= 0 || height == null || height <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid width and height (positive numbers)'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop();
                  ref.read(floorPlanNotifierProvider.notifier).updateFloorPlan(floorPlan.id, {
                    'name': nameController.text.trim(),
                    'width': width,
                    'height': height,
                    if (backgroundImageController.text.trim().isNotEmpty)
                      'backgroundImage': backgroundImageController.text.trim(),
                    'isActive': isActive,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteFloorPlan(FloorPlan floorPlan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Floor Plan'),
        content: Text('Are you sure you want to delete "${floorPlan.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(floorPlanNotifierProvider.notifier).deleteFloorPlan(floorPlan.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _manageTables(FloorPlan floorPlan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Tables: ${floorPlan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_location),
              title: const Text('Add Table to Floor Plan'),
              subtitle: const Text('Position a table on this floor plan'),
              onTap: () {
                Navigator.of(context).pop();
                _showAddTableToFloorPlanDialog(floorPlan);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_restaurant),
              title: const Text('View Table Positions'),
              subtitle: const Text('See all tables positioned on this floor plan'),
              onTap: () {
                Navigator.of(context).pop();
                _viewTablePositions(floorPlan);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_location),
              title: const Text('Edit Table Positions'),
              subtitle: const Text('Move or resize tables on this floor plan'),
              onTap: () {
                Navigator.of(context).pop();
                _editTablePositions(floorPlan);
              },
            ),
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

  void _showAddTableToFloorPlanDialog(FloorPlan floorPlan) {
    final xController = TextEditingController(text: '100');
    final yController = TextEditingController(text: '100');
    final widthController = TextEditingController(text: '80');
    final heightController = TextEditingController(text: '80');
    final rotationController = TextEditingController(text: '0');
    int? selectedTableId;

    // Get available tables that aren't already on this floor plan
    final allTablesState = ref.read(allTablesProvider);
    final allTables = allTablesState.when(
      data: (result) => result.isSuccess ? result.data : [],
      loading: () => [],
      error: (_, __) => [],
    );

    // Filter out tables that are already positioned on this floor plan
    final availableTables = allTables.where((table) {
      final tableId = table['id'] as int?;
      if (tableId == null) return false;
      
      // Check if this table is already positioned on this floor plan
      final existingPositions = floorPlan.tables ?? [];
      return !existingPositions.any((position) => position.tableId == tableId);
    }).toList();

    if (availableTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available tables to add to this floor plan'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Table to ${floorPlan.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedTableId,
                  decoration: const InputDecoration(
                    labelText: 'Select Table *',
                  ),
                  items: availableTables.map((table) {
                    final tableId = table['id'] as int?;
                    final tableNumber = table['tableNumber']?.toString() ?? 'Unknown';
                    final capacity = table['capacity']?.toString() ?? '0';
                    final section = table['section']?.toString() ?? 'Unknown';
                    
                    return DropdownMenuItem(
                      value: tableId,
                      child: Text('Table $tableNumber ($capacity seats, $section)'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTableId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Position (pixels)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: xController,
                        decoration: const InputDecoration(
                          labelText: 'X Coordinate',
                          hintText: '100',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: yController,
                        decoration: const InputDecoration(
                          labelText: 'Y Coordinate',
                          hintText: '100',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Size (pixels)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        decoration: const InputDecoration(
                          labelText: 'Width',
                          hintText: '80',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          labelText: 'Height',
                          hintText: '80',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rotationController,
                  decoration: const InputDecoration(
                    labelText: 'Rotation (degrees)',
                    hintText: '0',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTableId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a table'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final x = int.tryParse(xController.text.trim());
                final y = int.tryParse(yController.text.trim());
                final width = int.tryParse(widthController.text.trim());
                final height = int.tryParse(heightController.text.trim());
                final rotation = int.tryParse(rotationController.text.trim()) ?? 0;

                if (x == null || y == null || width == null || height == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid position and size values'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
                _addTableToFloorPlan(floorPlan.id, selectedTableId!, {
                  'tableId': selectedTableId,
                  'x': x,
                  'y': y,
                  'width': width,
                  'height': height,
                  'rotation': rotation,
                });
              },
              child: const Text('Add Table'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTableToFloorPlan(int floorPlanId, int tableId, Map<String, dynamic> positionData) async {
    final result = await ref.read(floorPlanNotifierProvider.notifier).createTablePosition(floorPlanId, positionData);
    
    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Table added to floor plan successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add table to floor plan: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewTablePositions(FloorPlan floorPlan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FloorPlanEditScreen(
          floorPlanId: floorPlan.id,
          isEditMode: false,
        ),
      ),
    );
  }

  void _editTablePositions(FloorPlan floorPlan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FloorPlanEditScreen(
          floorPlanId: floorPlan.id,
          isEditMode: true,
        ),
      ),
    );
  }

  void _showAddTableDialog() {
    final tableNumberController = TextEditingController();
    final capacityController = TextEditingController();
    final sectionController = TextEditingController();
    String selectedFloorPlan = '';
    String selectedStatus = 'available';

    // Get available floor plans
    final floorPlanState = ref.read(floorPlanNotifierProvider);
    final floorPlans = floorPlanState.when(
      data: (result) => result.isSuccess ? result.data : [],
      loading: () => [],
      error: (_, __) => [],
    );

    if (floorPlans.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please create a floor plan first before adding tables'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Set default floor plan
    selectedFloorPlan = floorPlans.first.id.toString();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Table'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tableNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Table Number',
                    hintText: 'e.g., 1, 2, A1, B2',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity (seats)',
                    hintText: 'e.g., 4, 6, 8',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: sectionController,
                  decoration: const InputDecoration(
                    labelText: 'Section',
                    hintText: 'e.g., Main Floor, Patio, Bar',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedFloorPlan.isNotEmpty ? selectedFloorPlan : null,
                  decoration: const InputDecoration(
                    labelText: 'Floor Plan',
                  ),
                  items: floorPlans.map((floorPlan) {
                    return DropdownMenuItem(
                      value: floorPlan.id.toString(),
                      child: Text(floorPlan.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFloorPlan = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Initial Status',
                  ),
                  items: [
                    DropdownMenuItem(value: 'available', child: Text('Available')),
                    DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                    DropdownMenuItem(value: 'reserved', child: Text('Reserved')),
                    DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value ?? 'available';
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (tableNumberController.text.trim().isNotEmpty &&
                    capacityController.text.trim().isNotEmpty &&
                    sectionController.text.trim().isNotEmpty &&
                    selectedFloorPlan.isNotEmpty) {
                  
                  final capacity = int.tryParse(capacityController.text.trim());
                  if (capacity == null || capacity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid capacity (positive number)'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop();
                  _createTable({
                    'tableNumber': tableNumberController.text.trim(),
                    'capacity': capacity,
                    'section': sectionController.text.trim(),
                    'status': selectedStatus,
                    'isActive': true,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Create Table'),
            ),
          ],
        ),
      ),
    );
  }

  void _createTable(Map<String, dynamic> tableData) async {
    // Remove floorPlanId from tableData as it's not needed for table creation
    final tableCreationData = Map<String, dynamic>.from(tableData);
    tableCreationData.remove('floorPlanId');
    
    final result = await ref.read(floorPlanNotifierProvider.notifier).createTable(tableCreationData);
    
    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Table ${tableData['tableNumber']} created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create table: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBulkEditDialog() {
    String selectedStatus = 'available';
    String selectedSection = '';
    bool updateStatus = false;
    bool updateSection = false;

    // Get available floor plans
    final floorPlanState = ref.read(floorPlanNotifierProvider);
    final floorPlans = floorPlanState.when(
      data: (result) => result.isSuccess ? result.data : [],
      loading: () => [],
      error: (_, __) => [],
    );

    if (floorPlans.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No floor plans available for bulk editing'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get all tables for selection from the API
    final allTablesState = ref.read(allTablesProvider);
    final allTables = allTablesState.when(
      data: (result) => result.isSuccess ? result.data : [],
      loading: () => [],
      error: (_, __) => [],
    );

    if (allTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tables available for bulk editing'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final selectedTables = <int>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Bulk Edit Tables'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select tables to edit:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: allTables.length,
                    itemBuilder: (context, index) {
                      final table = allTables[index];
                      final tableId = table['id'] as int?;
                      if (tableId == null) return const SizedBox.shrink();
                      
                      return CheckboxListTile(
                        title: Text('Table ${table['tableNumber'] ?? 'Unknown'}'),
                        subtitle: Text('${table['capacity'] ?? 0} seats • ${table['section'] ?? 'Unknown'}'),
                        value: selectedTables.contains(tableId),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedTables.add(tableId);
                            } else {
                              selectedTables.remove(tableId);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Select changes to apply:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Update Status'),
                  value: updateStatus,
                  onChanged: (value) {
                    setState(() {
                      updateStatus = value ?? false;
                    });
                  },
                ),
                if (updateStatus) ...[
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'New Status',
                    ),
                    items: [
                      DropdownMenuItem(value: 'available', child: Text('Available')),
                      DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                      DropdownMenuItem(value: 'reserved', child: Text('Reserved')),
                      DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value ?? 'available';
                      });
                    },
                  ),
                ],
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Update Section'),
                  value: updateSection,
                  onChanged: (value) {
                    setState(() {
                      updateSection = value ?? false;
                    });
                  },
                ),
                if (updateSection) ...[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'New Section',
                      hintText: 'e.g., Main Floor, Patio, Bar',
                    ),
                    onChanged: (value) {
                      selectedSection = value;
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTables.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one table'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (!updateStatus && !updateSection) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one change to apply'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (updateSection && selectedSection.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a section name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop();
                _bulkUpdateTables(
                  selectedTables.toList(),
                  updateStatus ? selectedStatus : null,
                  updateSection ? selectedSection.trim() : null,
                );
              },
              child: const Text('Apply Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _bulkUpdateTables(List<int> tableIds, String? newStatus, String? newSection) async {
    final result = await ref.read(floorPlanNotifierProvider.notifier).bulkUpdateTables(tableIds, newStatus, newSection);
    
    if (result.isSuccess) {
      final changes = <String>[];
      if (newStatus != null) changes.add('status: $newStatus');
      if (newSection != null) changes.add('section: $newSection');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully updated ${tableIds.length} tables: ${changes.join(', ')}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to bulk update tables: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editTable(TablePosition table) {
    final tableNumberController = TextEditingController(text: table.tableNumber);
    final capacityController = TextEditingController(text: table.tableCapacity.toString());
    final sectionController = TextEditingController(text: table.tableSection);
    String selectedStatus = table.tableStatus;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit Table ${table.tableNumber}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tableNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Table Number',
                    hintText: 'e.g., 1, 2, A1, B2',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity (seats)',
                    hintText: 'e.g., 4, 6, 8',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: sectionController,
                  decoration: const InputDecoration(
                    labelText: 'Section',
                    hintText: 'e.g., Main Floor, Patio, Bar',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: [
                    DropdownMenuItem(value: 'available', child: Text('Available')),
                    DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                    DropdownMenuItem(value: 'reserved', child: Text('Reserved')),
                    DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value ?? 'available';
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (tableNumberController.text.trim().isNotEmpty &&
                    capacityController.text.trim().isNotEmpty &&
                    sectionController.text.trim().isNotEmpty) {
                  
                  final capacity = int.tryParse(capacityController.text.trim());
                  if (capacity == null || capacity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid capacity (positive number)'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop();
                  _updateTable(table.id, {
                    'tableNumber': tableNumberController.text.trim(),
                    'capacity': capacity,
                    'section': sectionController.text.trim(),
                    'status': selectedStatus,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update Table'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTable(int tableId, Map<String, dynamic> tableData) async {
    final result = await ref.read(floorPlanNotifierProvider.notifier).updateTable(tableId, tableData);
    
    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Table ${tableData['tableNumber']} updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update table: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editTableFromMap(Map<String, dynamic> table) {
    final tableNumberController = TextEditingController(text: table['tableNumber']?.toString() ?? '');
    final capacityController = TextEditingController(text: (table['capacity'] ?? 0).toString());
    final sectionController = TextEditingController(text: table['section']?.toString() ?? '');
    String selectedStatus = table['status']?.toString() ?? 'available';
    final tableId = table['id'] as int?;

    if (tableId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot edit table: Invalid table ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Edit Table ${table['tableNumber']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tableNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Table Number',
                    hintText: 'e.g., 1, 2, A1, B2',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity (seats)',
                    hintText: 'e.g., 4, 6, 8',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: sectionController,
                  decoration: const InputDecoration(
                    labelText: 'Section',
                    hintText: 'e.g., Main Floor, Patio, Bar',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: [
                    DropdownMenuItem(value: 'available', child: Text('Available')),
                    DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                    DropdownMenuItem(value: 'reserved', child: Text('Reserved')),
                    DropdownMenuItem(value: 'cleaning', child: Text('Cleaning')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value ?? 'available';
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (tableNumberController.text.trim().isNotEmpty &&
                    capacityController.text.trim().isNotEmpty &&
                    sectionController.text.trim().isNotEmpty) {
                  
                  final capacity = int.tryParse(capacityController.text.trim());
                  if (capacity == null || capacity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid capacity (positive number)'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop();
                  _updateTable(tableId, {
                    'tableNumber': tableNumberController.text.trim(),
                    'capacity': capacity,
                    'section': sectionController.text.trim(),
                    'status': selectedStatus,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update Table'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReservationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reservation settings coming soon!')),
    );
  }

  void _showTableRotationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Table rotation settings coming soon!')),
    );
  }

  void _showCleaningSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleaning settings coming soon!')),
    );
  }

  void _exportFloorPlans() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon!')),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFloorPlansState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.map_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Floor Plans Yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first floor plan to start managing your restaurant layout',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showAddFloorPlanDialog(),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Floor Plan'),
          ),
        ],
      ),
    );
  }


} 

class _FloorPlanCardWithAnimation extends StatefulWidget {
  final FloorPlan floorPlan;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FloorPlanCardWithAnimation({
    super.key,
    required this.floorPlan,
    required this.theme,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_FloorPlanCardWithAnimation> createState() => _FloorPlanCardWithAnimationState();
}

class _FloorPlanCardWithAnimationState extends State<_FloorPlanCardWithAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showLoadingAnimation = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Show loading animation then fade in the card
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _showLoadingAnimation = false;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoadingAnimation) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Card(
          elevation: 1,
          shadowColor: widget.theme.colorScheme.shadow.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.theme.colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildActualFloorPlanCard(),
      ),
    );
  }

  Widget _buildActualFloorPlanCard() {
    final tableCount = widget.floorPlan.tables?.length ?? 0;
    final availableCount = widget.floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'available').length ?? 0;
    final occupiedCount = widget.floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'occupied').length ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 1,
        shadowColor: widget.theme.colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.map,
                    color: widget.theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.floorPlan.name,
                        style: widget.theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: widget.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.table_restaurant, size: 14, color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(
                            '$tableCount tables',
                            style: widget.theme.textTheme.bodySmall?.copyWith(
                              color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.check_circle, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            '$availableCount available',
                            style: widget.theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (occupiedCount > 0) ...[
                            const SizedBox(width: 12),
                            Icon(Icons.people, size: 14, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(
                              '$occupiedCount occupied',
                              style: widget.theme.textTheme.bodySmall?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      onPressed: widget.onEdit,
                      tooltip: 'Edit Floor Plan',
                      iconSize: 20,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: widget.onDelete,
                      tooltip: 'Delete Floor Plan',
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 