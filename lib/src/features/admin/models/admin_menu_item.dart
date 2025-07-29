import 'package:json_annotation/json_annotation.dart';

part 'admin_menu_item.g.dart';

@JsonSerializable()
class AdminMenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final double cost;
  final int categoryId;
  final int businessId;
  @JsonKey(fromJson: _itemIdFromJson, toJson: _itemIdToJson)
  final dynamic itemId; // Can be int or null from API
  final String? sku; // Can be null - backend auto-generates
  final String? barcode; // Can be null - backend auto-generates
  final String? imageUrl; // Can be null
  final int preparationTime;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isSpicy;
  final String? spiceLevel; // Can be null
  final int? calories; // Can be null
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.cost,
    required this.categoryId,
    required this.businessId,
    required this.itemId,
    this.sku, // Optional - backend auto-generates
    this.barcode, // Optional - backend auto-generates
    this.imageUrl,
    required this.preparationTime,
    required this.isAvailable,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    required this.isSpicy,
    this.spiceLevel,
    this.calories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminMenuItem.fromJson(Map<String, dynamic> json) => _$AdminMenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$AdminMenuItemToJson(this);

  // Custom JSON conversion for itemId
  static dynamic _itemIdFromJson(dynamic json) => json;
  static dynamic _itemIdToJson(dynamic itemId) => itemId;

  AdminMenuItem copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    double? cost,
    int? categoryId,
    int? businessId,
    dynamic itemId,
    String? sku,
    String? barcode,
    String? imageUrl,
    int? preparationTime,
    bool? isAvailable,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isSpicy,
    String? spiceLevel,
    int? calories,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminMenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      categoryId: categoryId ?? this.categoryId,
      businessId: businessId ?? this.businessId,
      itemId: itemId ?? this.itemId,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      preparationTime: preparationTime ?? this.preparationTime,
      isAvailable: isAvailable ?? this.isAvailable,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isSpicy: isSpicy ?? this.isSpicy,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      calories: calories ?? this.calories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class AdminBusiness {
  final int id;
  final String name;
  final String slug;
  final String type;
  final bool isActive;

  const AdminBusiness({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.isActive,
  });

  factory AdminBusiness.fromJson(Map<String, dynamic> json) => _$AdminBusinessFromJson(json);
  Map<String, dynamic> toJson() => _$AdminBusinessToJson(this);
}

@JsonSerializable()
class AdminCategory {
  final int id;
  final String name;
  final String description;
  final int displayOrder;
  final bool isActive;

  const AdminCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.displayOrder,
    required this.isActive,
  });

  factory AdminCategory.fromJson(Map<String, dynamic> json) => _$AdminCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$AdminCategoryToJson(this);
} 