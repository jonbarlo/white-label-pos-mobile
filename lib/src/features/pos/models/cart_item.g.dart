// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      barcode: json['barcode'] as String?,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
      promotionId: json['promotionId'] as String?,
      promotionName: json['promotionName'] as String?,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'barcode': instance.barcode,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'promotionId': instance.promotionId,
      'promotionName': instance.promotionName,
      'originalPrice': instance.originalPrice,
    };
