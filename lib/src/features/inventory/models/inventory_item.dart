import 'package:json_annotation/json_annotation.dart';

part 'inventory_item.g.dart';

@JsonSerializable()
class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final double price;
  final double cost;
  final int stockQuantity;
  final String category;
  final String? barcode;
  final String? imageUrl;
  final String? description;
  final int minStockLevel;
  final int maxStockLevel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.cost,
    required this.stockQuantity,
    required this.category,
    this.barcode,
    this.imageUrl,
    this.description,
    required this.minStockLevel,
    required this.maxStockLevel,
    this.createdAt,
    this.updatedAt,
  });

  double get profit => price - cost;
  double get profitMargin => cost > 0 ? (profit / cost) * 100 : 0;
  bool get isLowStock => stockQuantity <= minStockLevel;
  bool get isOutOfStock => stockQuantity <= 0;
  bool get isOverStocked => stockQuantity > maxStockLevel;

  InventoryItem copyWith({
    String? id,
    String? name,
    String? sku,
    double? price,
    double? cost,
    int? stockQuantity,
    String? category,
    String? barcode,
    String? imageUrl,
    String? description,
    int? minStockLevel,
    int? maxStockLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      category: category ?? this.category,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      maxStockLevel: maxStockLevel ?? this.maxStockLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        sku: json['sku']?.toString() ?? '',
        price: _parseDouble(json['price']),
        cost: _parseDouble(json['cost']),
        stockQuantity: _parseInt(json['stockQuantity']),
        category: json['category']?.toString() ?? '',
        barcode: json['barcode']?.toString(),
        imageUrl: json['imageUrl']?.toString(),
        description: json['description']?.toString(),
        minStockLevel: _parseInt(json['minStockLevel']),
        maxStockLevel: _parseInt(json['maxStockLevel']),
        createdAt: json['createdAt'] == null ? null : DateTime.tryParse(json['createdAt'].toString()),
        updatedAt: json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt'].toString()),
      );

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          sku == other.sku;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ sku.hashCode;

  @override
  String toString() {
    return 'InventoryItem(id: $id, name: $name, sku: $sku, stockQuantity: $stockQuantity)';
  }
} 