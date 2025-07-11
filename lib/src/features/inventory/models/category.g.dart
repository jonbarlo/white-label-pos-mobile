// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      displayOrder: (json['displayOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
      imageUrl: json['imageUrl'] as String?,
      colorCode: json['colorCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'description': instance.description,
      'displayOrder': instance.displayOrder,
      'isActive': instance.isActive,
      'imageUrl': instance.imageUrl,
      'colorCode': instance.colorCode,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
