import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

enum OrderItemStatus { pending, preparing, ready, served }

@JsonSerializable()
class OrderItem {
  final int id;
  final int orderId;
  final int menuItemId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? notes;
  final OrderItemStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          orderId == other.orderId;

  @override
  int get hashCode => id.hashCode ^ orderId.hashCode;

  @override
  String toString() {
    return 'OrderItem(id: $id, menuItemId: $menuItemId, quantity: $quantity, totalPrice: $totalPrice)';
  }
} 