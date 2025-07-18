import 'package:flutter/material.dart';
import '../models/floor_plan.dart';
import 'floor_plan_stats_card.dart';
import 'floor_plan_card.dart';
import 'table_card.dart';
import 'responsive_floor_plan_view.dart';

class FloorPlanViewer extends StatelessWidget {
  final List<FloorPlan> floorPlans;
  final FloorPlan? selectedFloorPlan;
  final Function(FloorPlan)? onFloorPlanSelected;
  final Function(TablePosition)? onTableTapped;
  final Set<int> loadingTableIds;
  final bool isFloorPlansTab;
  final bool isLoading;
  final int? loadedCount;
  final int? totalCount;

  const FloorPlanViewer({
    super.key,
    required this.floorPlans,
    this.selectedFloorPlan,
    this.onFloorPlanSelected,
    this.onTableTapped,
    this.loadingTableIds = const {},
    this.isFloorPlansTab = true,
    this.isLoading = false,
    this.loadedCount,
    this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    if (isFloorPlansTab) {
      return _buildFloorPlansTab(context);
    } else {
      return _buildAllTablesTab(context);
    }
  }

  Widget _buildFloorPlansTab(BuildContext context) {
    return Column(
      children: [
        // Stats Card
        FloorPlanStatsCard(floorPlans: floorPlans),
        
        // Floor Plan Cards
        _buildFloorPlanSection(context),
        
        // Selected Floor Plan View
        if (selectedFloorPlan != null) ...[
          const SizedBox(height: 16),
          _buildSelectedFloorPlanView(context, selectedFloorPlan!),
        ] else ...[
          const SizedBox(height: 16),
          _buildNoFloorPlanSelected(context),
        ],
      ],
    );
  }

  Widget _buildAllTablesTab(BuildContext context) {
    final allTables = <TablePosition>[];
    for (final floorPlan in floorPlans) {
      if (floorPlan.tables != null) {
        allTables.addAll(floorPlan.tables!);
      }
    }

    return Column(
      children: [
        // Stats Card
        FloorPlanStatsCard(floorPlans: floorPlans),
        
        // All Tables Section
        Expanded(child: _buildAllTablesSection(context, allTables)),
      ],
    );
  }

  Widget _buildFloorPlanSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.map, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Floor Plans',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              // Loading animation and progress text
              if (isLoading && totalCount != null && loadedCount != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$loadedCount out of $totalCount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140, // Increased height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: floorPlans.length,
            itemBuilder: (context, index) {
              final floorPlan = floorPlans[index];
              return SizedBox(
                width: 200,
                child: FloorPlanCard(
                  floorPlan: floorPlan,
                  isSelected: selectedFloorPlan?.id == floorPlan.id,
                  onTap: () => onFloorPlanSelected?.call(floorPlan),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedFloorPlanView(BuildContext context, FloorPlan floorPlan) {
    return Expanded(
      child: ResponsiveFloorPlanView(
        floorPlan: floorPlan,
        onTableTapped: onTableTapped,
        loadingTableIds: loadingTableIds,
      ),
    );
  }

  Widget _buildTableWidget(TablePosition table, BuildContext context) {
    final theme = Theme.of(context);
    Color statusColor;
    IconData statusIcon;
    final bool isLoading = loadingTableIds.contains(table.tableId);
    
    switch (table.tableStatus.toLowerCase()) {
      case 'available':
        statusColor = theme.colorScheme.secondary;
        statusIcon = Icons.check_circle;
        break;
      case 'occupied':
        statusColor = theme.colorScheme.error;
        statusIcon = Icons.people;
        break;
      case 'reserved':
        statusColor = theme.colorScheme.tertiary;
        statusIcon = Icons.schedule;
        break;
      case 'cleaning':
        statusColor = theme.colorScheme.primary;
        statusIcon = Icons.cleaning_services;
        break;
      default:
        statusColor = theme.colorScheme.onSurfaceVariant;
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
              onTableTapped?.call(table);
            }
          },
          child: Container(
            width: table.width.toDouble(),
            height: table.height.toDouble(),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              border: Border.all(
                color: isLoading ? theme.colorScheme.primary : statusColor, 
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
                      color: theme.colorScheme.primary.withOpacity(0.3),
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

  Widget _buildAllTablesSection(BuildContext context, List<TablePosition> allTables) {
    final theme = Theme.of(context);
    
    if (allTables.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.table_restaurant, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'All Tables (${allTables.length} total)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allTables.length,
            itemBuilder: (context, index) {
              final table = allTables[index];
              return TableCard(
                table: table,
                isLoading: loadingTableIds.contains(table.tableId),
                onTap: () => onTableTapped?.call(table),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoFloorPlanSelected(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Select a Floor Plan',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a floor plan from the cards above to view tables',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            'No tables found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tables will appear here once they are added to floor plans',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 