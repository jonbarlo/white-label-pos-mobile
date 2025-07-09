import 'package:json_annotation/json_annotation.dart';
import 'cart_item.dart';

part 'sale.g.dart';

enum PaymentMethod { cash, card, mobile }

@JsonSerializable()
class Sale {
  final String id;
  final List<CartItem> items;
  final double total;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final String? customerName;
  final String? customerEmail;
  final String? receiptNumber;

  const Sale({
    required this.id,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.customerName,
    this.customerEmail,
    this.receiptNumber,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Sale copyWith({
    String? id,
    List<CartItem>? items,
    double? total,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    String? customerName,
    String? customerEmail,
    String? receiptNumber,
  }) {
    return Sale(
      id: id ?? this.id,
      items: items ?? this.items,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      receiptNumber: receiptNumber ?? this.receiptNumber,
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
  Map<String, dynamic> toJson() => _$SaleToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sale &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          total == other.total &&
          paymentMethod == other.paymentMethod;

  @override
  int get hashCode => id.hashCode ^ total.hashCode ^ paymentMethod.hashCode;

  @override
  String toString() {
    return 'Sale(id: $id, total: $total, paymentMethod: $paymentMethod, itemCount: $itemCount)';
  }
} 