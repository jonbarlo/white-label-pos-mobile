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
  final OrderType type;
  final OrderStatus status;
  final double subtotal;
  final double tax;
  final double discount;
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

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: (json['id'] as num).toInt(),
    businessId: (json['businessId'] as num).toInt(),
    customerId: (json['customerId'] as num?)?.toInt(),
    tableId: (json['tableId'] as num?)?.toInt(),
    orderNumber: json['orderNumber'] as String,
    type: $enumDecode(_$OrderTypeEnumMap, json['orderType']),
    status: $enumDecode(_$OrderStatusEnumMap, json['status']),
    subtotal: (json['subtotal'] as num).toDouble(),
    tax: (json['tax'] as num).toDouble(),
    discount: (json['discount'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
    notes: json['notes'] as String?,
    estimatedReadyTime: json['estimatedReadyTime'] == null
        ? null
        : DateTime.parse(json['estimatedReadyTime'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
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