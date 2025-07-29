// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminMenuItem _$AdminMenuItemFromJson(Map<String, dynamic> json) =>
    AdminMenuItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      itemId: AdminMenuItem._itemIdFromJson(json['itemId']),
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      imageUrl: json['imageUrl'] as String?,
      preparationTime: (json['preparationTime'] as num).toInt(),
      isAvailable: json['isAvailable'] as bool,
      isVegetarian: json['isVegetarian'] as bool,
      isVegan: json['isVegan'] as bool,
      isGlutenFree: json['isGlutenFree'] as bool,
      isSpicy: json['isSpicy'] as bool,
      spiceLevel: json['spiceLevel'] as String?,
      calories: (json['calories'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AdminMenuItemToJson(AdminMenuItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'cost': instance.cost,
      'categoryId': instance.categoryId,
      'businessId': instance.businessId,
      'itemId': AdminMenuItem._itemIdToJson(instance.itemId),
      'sku': instance.sku,
      'barcode': instance.barcode,
      'imageUrl': instance.imageUrl,
      'preparationTime': instance.preparationTime,
      'isAvailable': instance.isAvailable,
      'isVegetarian': instance.isVegetarian,
      'isVegan': instance.isVegan,
      'isGlutenFree': instance.isGlutenFree,
      'isSpicy': instance.isSpicy,
      'spiceLevel': instance.spiceLevel,
      'calories': instance.calories,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

AdminBusiness _$AdminBusinessFromJson(Map<String, dynamic> json) =>
    AdminBusiness(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      type: json['type'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$AdminBusinessToJson(AdminBusiness instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'type': instance.type,
      'isActive': instance.isActive,
    };

AdminCategory _$AdminCategoryFromJson(Map<String, dynamic> json) =>
    AdminCategory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$AdminCategoryToJson(AdminCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'displayOrder': instance.displayOrder,
      'isActive': instance.isActive,
    };
