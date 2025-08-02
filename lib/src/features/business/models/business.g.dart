// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Business _$BusinessFromJson(Map<String, dynamic> json) => Business(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      type: $enumDecodeNullable(_$BusinessTypeEnumMap, json['type']),
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      taxRate: (json['taxRate'] as num).toDouble(),
      currencyId: (json['currencyId'] as num).toInt(),
      timezone: json['timezone'] as String,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'type': _$BusinessTypeEnumMap[instance.type],
      'description': instance.description,
      'logo': instance.logo,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'taxRate': instance.taxRate,
      'currencyId': instance.currencyId,
      'timezone': instance.timezone,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$BusinessTypeEnumMap = {
  BusinessType.restaurant: 'restaurant',
  BusinessType.retail: 'retail',
  BusinessType.service: 'service',
};
