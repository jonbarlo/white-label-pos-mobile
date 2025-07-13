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
class Table with _$Table {
  const factory Table({
    required int id,
    required int businessId,
    required String tableNumber,
    required TableStatus status,
    required int capacity,
    String? currentOrderId,
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
  }) = _Table;

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);
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