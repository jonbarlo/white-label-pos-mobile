// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      category: json['category'] as String,
      barcode: json['barcode'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      minStockLevel: (json['minStockLevel'] as num).toInt(),
      maxStockLevel: (json['maxStockLevel'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'price': instance.price,
      'cost': instance.cost,
      'stockQuantity': instance.stockQuantity,
      'category': instance.category,
      'barcode': instance.barcode,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'minStockLevel': instance.minStockLevel,
      'maxStockLevel': instance.maxStockLevel,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
