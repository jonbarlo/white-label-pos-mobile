import 'package:freezed_annotation/freezed_annotation.dart';

part 'table.freezed.dart';
part 'table.g.dart';

enum TableStatus {
  @JsonValue('available')
  available,
  @JsonValue('occupied')
  occupied,
  @JsonValue('reserved')
  reserved,
  @JsonValue('cleaning')
  cleaning,
  @JsonValue('out_of_service')
  outOfService,
}

@freezed
class Customer with _$Customer {
  const factory Customer({
    required int id,
    required String name,
    String? phone,
    String? email,
    String? notes,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        notes: json['notes'] as String?,
      );
}

@freezed
class Table with _$Table {
  const factory Table({
    required int id,
    required int businessId,
    required String name, // Changed from tableNumber to name as per API
    required TableStatus status,
    required int capacity,
    String? location, // Changed from section to location as per API
    int? currentOrderId,
    int? serverId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Customer data (nested as per API)
    Customer? customer,
    // Legacy fields for backward compatibility
    String? currentOrderNumber,
    double? currentOrderTotal,
    int? currentOrderItemCount,
    String? customerName,
    String? notes,
    DateTime? lastActivity,
    DateTime? reservationTime,
    String? assignedWaiter,
    int? assignedWaiterId,
    Map<String, dynamic>? metadata,
    int? partySize,
  }) = _Table;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: (json['id'] as num).toInt(),
        businessId: (json['businessId'] as num).toInt(),
        name: json['name'] as String? ?? json['tableNumber'] as String? ?? '',
        status: $enumDecode(_$TableStatusEnumMap, json['status']),
        capacity: (json['capacity'] as num).toInt(),
        location: json['location'] as String? ?? json['section'] as String?,
        currentOrderId: json['currentOrderId'] as int?,
        serverId: json['serverId'] as int?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
        // Customer data (nested as per API)
        customer: json['customer'] != null ? Customer.fromJson(json['customer'] as Map<String, dynamic>) : null,
        // Legacy fields for backward compatibility
        currentOrderNumber: json['currentOrderNumber'] as String?,
        currentOrderTotal: (json['currentOrderTotal'] as num?)?.toDouble(),
        currentOrderItemCount: json['currentOrderItemCount'] as int?,
        customerName: json['customerName'] as String?,
        notes: json['notes'] as String?,
        lastActivity: json['lastActivity'] == null ? null : DateTime.parse(json['lastActivity'] as String),
        reservationTime: json['reservationTime'] == null ? null : DateTime.parse(json['reservationTime'] as String),
        assignedWaiter: json['assignedWaiter'] as String?,
        assignedWaiterId: json['assignedWaiterId'] as int?,
        metadata: json['metadata'] as Map<String, dynamic>?,
        partySize: json['partySize'] as int?,
      );
}

extension TableStatusExtension on TableStatus {
  String get displayName {
    switch (this) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.reserved:
        return 'Reserved';
      case TableStatus.cleaning:
        return 'Cleaning';
      case TableStatus.outOfService:
        return 'Out of Service';
    }
  }

  String get shortName {
    switch (this) {
      case TableStatus.available:
        return 'Free';
      case TableStatus.occupied:
        return 'Busy';
      case TableStatus.reserved:
        return 'Reserved';
      case TableStatus.cleaning:
        return 'Cleaning';
      case TableStatus.outOfService:
        return 'Closed';
    }
  }

  bool get canTakeOrder => this == TableStatus.available || this == TableStatus.occupied;
  bool get isActive => this != TableStatus.outOfService;
} 