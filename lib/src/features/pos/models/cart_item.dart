import 'package:json_annotation/json_annotation.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? barcode;
  final String? imageUrl;
  final String? category;
  final String? promotionId;
  final String? promotionName;
  final double? originalPrice;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.barcode,
    this.imageUrl,
    this.category,
    this.promotionId,
    this.promotionName,
    this.originalPrice,
  });

  double get total => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? barcode,
    String? imageUrl,
    String? category,
    String? promotionId,
    String? promotionName,
    double? originalPrice,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      promotionId: promotionId ?? this.promotionId,
      promotionName: promotionName ?? this.promotionName,
      originalPrice: originalPrice ?? this.originalPrice,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          quantity == other.quantity;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode ^ quantity.hashCode;

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, price: $price, quantity: $quantity)';
  }
} 