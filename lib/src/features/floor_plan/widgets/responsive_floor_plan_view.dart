import 'package:flutter/material.dart';
import '../models/floor_plan.dart';

class ResponsiveFloorPlanView extends StatelessWidget {
  final FloorPlan floorPlan;
  final Function(TablePosition)? onTableTapped;
  final Set<int> loadingTableIds;

  const ResponsiveFloorPlanView({
    super.key,
    required this.floorPlan,
    this.onTableTapped,
    this.loadingTableIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        
        // Calculate responsive scaling
        final scale = _calculateScale(maxWidth, maxHeight);
        
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
                
                // Tables with responsive positioning
                if (floorPlan.tables != null)
                  ...floorPlan.tables!.map((table) => _buildResponsiveTableWidget(
                    table, 
                    scale, 
                    maxWidth, 
                    maxHeight
                  )),
              ],
            ),
          ),
        );
      },
    );
  }

  double _calculateScale(double maxWidth, double maxHeight) {
    // Base scale on screen size
    if (maxWidth < 600) {
      return 0.8; // Mobile
    } else if (maxWidth < 1200) {
      return 1.0; // Tablet
    } else {
      return 1.2; // Desktop
    }
  }

  Widget _buildResponsiveTableWidget(
    TablePosition table, 
    double scale, 
    double maxWidth, 
    double maxHeight
  ) {
    Color statusColor;
    IconData statusIcon;
    final bool isLoading = loadingTableIds.contains(table.tableId);
    
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
    
    // Calculate responsive position and size
    final responsiveX = (table.x * scale).clamp(0.0, maxWidth - (table.width * scale));
    final responsiveY = (table.y * scale).clamp(0.0, maxHeight - (table.height * scale));
    final responsiveWidth = (table.width * scale).clamp(40.0, maxWidth * 0.3);
    final responsiveHeight = (table.height * scale).clamp(40.0, maxHeight * 0.3);
    
    return Positioned(
      left: responsiveX,
      top: responsiveY,
      child: Transform.rotate(
        angle: table.rotation * 3.14159 / 180,
        child: GestureDetector(
          onTap: () {
            if (!isLoading) {
              onTableTapped?.call(table);
            }
          },
          child: Container(
            width: responsiveWidth,
            height: responsiveHeight,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              border: Border.all(
                color: isLoading ? Colors.blue : statusColor, 
                width: isLoading ? 3 : 2
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main table content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      statusIcon, 
                      color: statusColor, 
                      size: responsiveWidth * 0.15,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      table.tableNumber,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: responsiveWidth * 0.12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${table.tableCapacity}',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: responsiveWidth * 0.1,
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
} 