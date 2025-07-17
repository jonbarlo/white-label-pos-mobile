import 'package:json_annotation/json_annotation.dart';

part 'floor_plan.g.dart';

@JsonSerializable()
class FloorPlan {
  final int id;
  final int businessId;
  final String name;
  final int width;
  final int height;
  final String? backgroundImage;
  final bool isActive;
  final int? tableCount;
  final List<TablePosition>? tables;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FloorPlan({
    required this.id,
    required this.businessId,
    required this.name,
    required this.width,
    required this.height,
    this.backgroundImage,
    required this.isActive,
    this.tableCount,
    this.tables,
    this.createdAt,
    this.updatedAt,
  });

  // Custom fromJson to handle type mismatches and missing fields
  factory FloorPlan.fromJson(Map<String, dynamic> json) {
    // Handle tablePositions field from API response
    List<TablePosition>? tables;
    if (json['tablePositions'] is List) {
      // API returns tablePositions with nested table data
      tables = (json['tablePositions'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) {
        final positionData = e as Map<String, dynamic>;
        final tableData = positionData['table'] as Map<String, dynamic>?;
        
        if (tableData != null) {
          // Combine position data with table data
          return TablePosition.fromJson({
            ...positionData,
            'tableId': tableData['id'],
            'tableNumber': tableData['tableNumber'],
            'tableCapacity': tableData['capacity'],
            'tableStatus': tableData['status'],
            'tableSection': tableData['section'],
          });
        } else {
          // Fallback to direct position data
          return TablePosition.fromJson(positionData);
        }
      }).toList();
    } else if (json['tables'] is List) {
      // Direct tables field (fallback)
      tables = (json['tables'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => TablePosition.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return FloorPlan(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      backgroundImage: json['backgroundImage'] as String?,
      isActive: json['isActive'] as bool,
      tableCount: tables?.length,
      tables: tables,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() => _$FloorPlanToJson(this);
}

@JsonSerializable()
class TablePosition {
  final int id;
  final int tableId;
  final String tableNumber;
  final int tableCapacity;
  final String tableStatus;
  final String tableSection;
  final int x;
  final int y;
  final int rotation;
  final int width;
  final int height;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TablePosition({
    required this.id,
    required this.tableId,
    required this.tableNumber,
    required this.tableCapacity,
    required this.tableStatus,
    required this.tableSection,
    required this.x,
    required this.y,
    required this.rotation,
    required this.width,
    required this.height,
    this.createdAt,
    this.updatedAt,
  });

  // Custom fromJson to handle type mismatches and missing fields
  factory TablePosition.fromJson(Map<String, dynamic> json) {
    // Debug logging for table status
    print('🔍 DEBUG: TablePosition.fromJson: Processing table ${json['tableNumber']}');
    print('🔍 DEBUG: TablePosition.fromJson: Raw tableStatus from JSON: ${json['tableStatus']}');
    final tableStatus = json['tableStatus'] as String;
    print('🔍 DEBUG: TablePosition.fromJson: Final tableStatus: $tableStatus');
    
    return TablePosition(
      id: (json['id'] as num).toInt(),
      tableId: (json['tableId'] as num).toInt(),
      tableNumber: json['tableNumber'] as String,
      tableCapacity: (json['tableCapacity'] as num).toInt(),
      tableStatus: tableStatus,
      tableSection: json['tableSection'] as String,
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      rotation: (json['rotation'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() => _$TablePositionToJson(this);

  String get statusColor {
    switch (tableStatus.toLowerCase()) {
      case 'available':
        return '#4CAF50'; // Green
      case 'occupied':
        return '#F44336'; // Red
      case 'reserved':
        return '#FF9800'; // Orange
      case 'cleaning':
        return '#2196F3'; // Blue
      case 'out_of_service':
        return '#9E9E9E'; // Grey
      default:
        return '#4CAF50'; // Default to green
    }
  }

  TablePosition copyWith({
    int? id,
    int? tableId,
    String? tableNumber,
    int? tableCapacity,
    String? tableStatus,
    String? tableSection,
    int? x,
    int? y,
    int? rotation,
    int? width,
    int? height,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TablePosition(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      tableNumber: tableNumber ?? this.tableNumber,
      tableCapacity: tableCapacity ?? this.tableCapacity,
      tableStatus: tableStatus ?? this.tableStatus,
      tableSection: tableSection ?? this.tableSection,
      x: x ?? this.x,
      y: y ?? this.y,
      rotation: rotation ?? this.rotation,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 