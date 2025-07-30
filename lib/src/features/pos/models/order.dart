import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

enum OrderType { dine_in, takeaway, delivery }
enum OrderStatus { pending, confirmed, preparing, ready, served, completed, cancelled }

@JsonSerializable()
class Order {
  final int id;
  final int businessId;
  final int? customerId;
  final int? tableId;
  final String orderNumber;
  @JsonKey(name: 'orderType')
  final OrderType type;
  final OrderStatus status;
  final double subtotal;
  @JsonKey(name: 'taxAmount')
  final double tax;
  @JsonKey(name: 'discountAmount')
  final double discount;
  @JsonKey(name: 'totalAmount')
  final double total;
  final String? notes;
  final DateTime? estimatedReadyTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.businessId,
    this.customerId,
    this.tableId,
    required this.orderNumber,
    required this.type,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    this.notes,
    this.estimatedReadyTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          businessId == other.businessId;

  @override
  int get hashCode => id.hashCode ^ businessId.hashCode;

  @override
  String toString() {
    return 'Order(id: $id, orderNumber: $orderNumber, status: $status, total: $total)';
  }
} 