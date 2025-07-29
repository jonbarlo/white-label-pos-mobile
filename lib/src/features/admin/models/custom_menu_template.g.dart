// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_menu_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomMenuTemplate _$CustomMenuTemplateFromJson(Map<String, dynamic> json) =>
    CustomMenuTemplate(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      htmlContent: json['htmlContent'] as String,
      cssContent: json['cssContent'] as String,
      isActive: json['isActive'] as bool,
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomMenuTemplateToJson(CustomMenuTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'description': instance.description,
      'htmlContent': instance.htmlContent,
      'cssContent': instance.cssContent,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
