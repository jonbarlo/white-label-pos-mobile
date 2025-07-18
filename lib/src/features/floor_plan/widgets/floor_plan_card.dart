import 'package:flutter/material.dart';
import '../models/floor_plan.dart';

class FloorPlanCard extends StatelessWidget {
  final FloorPlan floorPlan;
  final bool isSelected;
  final VoidCallback onTap;

  const FloorPlanCard({
    super.key,
    required this.floorPlan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableCount = floorPlan.tables?.length ?? 0;
    final availableCount = floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'available').length ?? 0;
    final occupiedCount = floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'occupied').length ?? 0;
    final reservedCount = floorPlan.tables?.where((t) => t.tableStatus.toLowerCase() == 'reserved').length ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.map,
                    color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      floorPlan.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '$tableCount tables',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8) : null,
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: [
                    if (availableCount > 0) _buildStatusDot(theme.colorScheme.secondary, availableCount),
                    if (occupiedCount > 0) _buildStatusDot(theme.colorScheme.error, occupiedCount),
                    if (reservedCount > 0) _buildStatusDot(theme.colorScheme.tertiary, reservedCount),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDot(Color color, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 