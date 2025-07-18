import 'package:flutter/material.dart';
import '../models/floor_plan.dart';

class FloorPlanStatsCard extends StatelessWidget {
  final List<FloorPlan> floorPlans;

  const FloorPlanStatsCard({
    super.key,
    required this.floorPlans,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allTables = <TablePosition>[];
    for (final floorPlan in floorPlans) {
      if (floorPlan.tables != null) {
        allTables.addAll(floorPlan.tables!);
      }
    }

    final availableCount = allTables.where((t) => t.tableStatus.toLowerCase() == 'available').length;
    final occupiedCount = allTables.where((t) => t.tableStatus.toLowerCase() == 'occupied').length;
    final reservedCount = allTables.where((t) => t.tableStatus.toLowerCase() == 'reserved').length;
    final cleaningCount = allTables.where((t) => t.tableStatus.toLowerCase() == 'cleaning').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Quick Stats',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatChip('Available', availableCount, theme.colorScheme.secondary)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatChip('Occupied', occupiedCount, theme.colorScheme.error)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatChip('Reserved', reservedCount, theme.colorScheme.tertiary)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatChip('Cleaning', cleaningCount, theme.colorScheme.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 