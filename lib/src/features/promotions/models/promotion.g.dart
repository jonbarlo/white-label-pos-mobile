// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promotion _$PromotionFromJson(Map<String, dynamic> json) => Promotion(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$PromotionTypeEnumMap, json['type']),
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      conditions: json['conditions'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool,
      imageUrl: json['imageUrl'] as String?,
      totalQuantity: (json['totalQuantity'] as num?)?.toInt(),
      usedQuantity: (json['usedQuantity'] as num).toInt(),
      maxUsesPerCustomer: (json['maxUsesPerCustomer'] as num?)?.toInt(),
      recipeId: (json['recipeId'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'description': instance.description,
      'type': _$PromotionTypeEnumMap[instance.type]!,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'conditions': instance.conditions,
      'isActive': instance.isActive,
      'imageUrl': instance.imageUrl,
      'totalQuantity': instance.totalQuantity,
      'usedQuantity': instance.usedQuantity,
      'maxUsesPerCustomer': instance.maxUsesPerCustomer,
      'recipeId': instance.recipeId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PromotionTypeEnumMap = {
  PromotionType.discount: 'discount',
  PromotionType.chef_special: 'chef_special',
  PromotionType.buyOneGetOne: 'buyOneGetOne',
  PromotionType.freeItem: 'freeItem',
};

PromotionStats _$PromotionStatsFromJson(Map<String, dynamic> json) =>
    PromotionStats(
      totalPromotions: (json['totalPromotions'] as num).toInt(),
      activePromotions: (json['activePromotions'] as num).toInt(),
      scheduledPromotions: (json['scheduledPromotions'] as num).toInt(),
      expiredPromotions: (json['expiredPromotions'] as num).toInt(),
      promotionsByType: (json['promotionsByType'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$PromotionTypeEnumMap, k), (e as num).toInt()),
      ),
      totalDiscountValue: (json['totalDiscountValue'] as num).toDouble(),
      totalUses: (json['totalUses'] as num).toInt(),
      mostPopularPromotions: (json['mostPopularPromotions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PromotionStatsToJson(PromotionStats instance) =>
    <String, dynamic>{
      'totalPromotions': instance.totalPromotions,
      'activePromotions': instance.activePromotions,
      'scheduledPromotions': instance.scheduledPromotions,
      'expiredPromotions': instance.expiredPromotions,
      'promotionsByType': instance.promotionsByType
          .map((k, e) => MapEntry(_$PromotionTypeEnumMap[k]!, e)),
      'totalDiscountValue': instance.totalDiscountValue,
      'totalUses': instance.totalUses,
      'mostPopularPromotions': instance.mostPopularPromotions,
    };
