import 'package:json_annotation/json_annotation.dart';
import 'cart_item.dart';

part 'sale.g.dart';

enum PaymentMethod { cash, card, mobile, check }

@JsonSerializable()
class Sale {
  final String id;
  final List<CartItem>? items;
  @JsonKey(name: 'totalAmount')
  final double total;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final String? customerName;
  final String? customerEmail;
  final String? receiptNumber;
  final String? status;
  final double? taxAmount;
  final double? discountAmount;

  const Sale({
    required this.id,
    this.items,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.customerName,
    this.customerEmail,
    this.receiptNumber,
    this.status,
    this.taxAmount,
    this.discountAmount,
  });

  int get itemCount => items?.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0)) ?? 0;

  Sale copyWith({
    String? id,
    List<CartItem>? items,
    double? total,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    String? customerName,
    String? customerEmail,
    String? receiptNumber,
    String? status,
    double? taxAmount,
    double? discountAmount,
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
      status: status ?? this.status,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
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
    return 'Sale(id: $id, total: $total, paymentMethod: $paymentMethod, itemCount: $itemCount, status: $status)';
  }
} 