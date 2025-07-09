import 'package:json_annotation/json_annotation.dart';

part 'menu_item.g.dart';

@JsonSerializable()
class MenuItem {
  final int id;
  final int businessId;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final double cost;
  final String? image;
  final List<String>? allergens;
  final Map<String, dynamic>? nutritionalInfo;
  final int preparationTime;
  final bool isAvailable;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuItem({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.cost,
    this.image,
    this.allergens,
    this.nutritionalInfo,
    required this.preparationTime,
    required this.isAvailable,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          businessId == other.businessId;

  @override
  int get hashCode => id.hashCode ^ businessId.hashCode;

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, price: $price, isAvailable: $isAvailable)';
  }
} 