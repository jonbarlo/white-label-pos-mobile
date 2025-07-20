// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_recipe_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartRecipeSuggestion _$SmartRecipeSuggestionFromJson(
        Map<String, dynamic> json) =>
    SmartRecipeSuggestion(
      id: (json['id'] as num).toInt(),
      recipe: Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      potentialSavings: (json['potentialSavings'] as num).toDouble(),
      urgencyLevel: $enumDecode(_$UrgencyLevelEnumMap, json['urgencyLevel']),
      matchingIngredients: (json['matchingIngredients'] as List<dynamic>)
          .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      expiringIngredients: (json['expiringIngredients'] as List<dynamic>)
          .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      underperformingIngredients:
          (json['underperformingIngredients'] as List<dynamic>)
              .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      reasoning: json['reasoning'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRecommended: json['isRecommended'] as bool? ?? false,
    );

Map<String, dynamic> _$SmartRecipeSuggestionToJson(
        SmartRecipeSuggestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipe': instance.recipe,
      'confidenceScore': instance.confidenceScore,
      'potentialSavings': instance.potentialSavings,
      'urgencyLevel': _$UrgencyLevelEnumMap[instance.urgencyLevel]!,
      'matchingIngredients': instance.matchingIngredients,
      'expiringIngredients': instance.expiringIngredients,
      'underperformingIngredients': instance.underperformingIngredients,
      'reasoning': instance.reasoning,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRecommended': instance.isRecommended,
    };

const _$UrgencyLevelEnumMap = {
  UrgencyLevel.high: 'high',
  UrgencyLevel.medium: 'medium',
  UrgencyLevel.low: 'low',
};

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      currentStock: (json['currentStock'] as num).toDouble(),
      minimumStock: (json['minimumStock'] as num).toDouble(),
      unitCost: (json['unitCost'] as num).toDouble(),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      manufacturingDate: json['manufacturingDate'] == null
          ? null
          : DateTime.parse(json['manufacturingDate'] as String),
      shelfLifeDays: (json['shelfLifeDays'] as num?)?.toInt(),
      lastSoldDate: json['lastSoldDate'] == null
          ? null
          : DateTime.parse(json['lastSoldDate'] as String),
      salesVelocity: (json['salesVelocity'] as num?)?.toDouble(),
      daysSinceLastSale: (json['daysSinceLastSale'] as num?)?.toInt(),
      isPerishable: json['isPerishable'] as bool,
      isUnderperforming: json['isUnderperforming'] as bool,
      isExpiringSoon: json['isExpiringSoon'] as bool,
      totalValue: (json['totalValue'] as num).toDouble(),
      alertMessage: json['alertMessage'] as String?,
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'currentStock': instance.currentStock,
      'minimumStock': instance.minimumStock,
      'unitCost': instance.unitCost,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'manufacturingDate': instance.manufacturingDate?.toIso8601String(),
      'shelfLifeDays': instance.shelfLifeDays,
      'lastSoldDate': instance.lastSoldDate?.toIso8601String(),
      'salesVelocity': instance.salesVelocity,
      'daysSinceLastSale': instance.daysSinceLastSale,
      'isPerishable': instance.isPerishable,
      'isUnderperforming': instance.isUnderperforming,
      'isExpiringSoon': instance.isExpiringSoon,
      'totalValue': instance.totalValue,
      'alertMessage': instance.alertMessage,
    };

InventorySummary _$InventorySummaryFromJson(Map<String, dynamic> json) =>
    InventorySummary(
      totalItems: (json['totalItems'] as num).toInt(),
      expiringItems: (json['expiringItems'] as num).toInt(),
      underperformingItems: (json['underperformingItems'] as num).toInt(),
      totalInventoryValue: (json['totalInventoryValue'] as num).toDouble(),
      potentialSavings: (json['potentialSavings'] as num).toDouble(),
      expiringItemsList: (json['expiringItemsList'] as List<dynamic>)
          .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      underperformingItemsList:
          (json['underperformingItemsList'] as List<dynamic>)
              .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      activeAlerts: (json['activeAlerts'] as List<dynamic>)
          .map((e) => InventoryAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      healthScore: (json['healthScore'] as num).toDouble(),
    );

Map<String, dynamic> _$InventorySummaryToJson(InventorySummary instance) =>
    <String, dynamic>{
      'totalItems': instance.totalItems,
      'expiringItems': instance.expiringItems,
      'underperformingItems': instance.underperformingItems,
      'totalInventoryValue': instance.totalInventoryValue,
      'potentialSavings': instance.potentialSavings,
      'expiringItemsList': instance.expiringItemsList,
      'underperformingItemsList': instance.underperformingItemsList,
      'activeAlerts': instance.activeAlerts,
      'healthScore': instance.healthScore,
    };

InventoryAlert _$InventoryAlertFromJson(Map<String, dynamic> json) =>
    InventoryAlert(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      message: json['message'] as String,
      urgencyLevel: $enumDecode(_$UrgencyLevelEnumMap, json['urgencyLevel']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      itemName: json['itemName'] as String?,
      itemId: (json['itemId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryAlertToJson(InventoryAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'urgencyLevel': _$UrgencyLevelEnumMap[instance.urgencyLevel]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
      'itemName': instance.itemName,
      'itemId': instance.itemId,
    };

SmartSuggestionResponse _$SmartSuggestionResponseFromJson(
        Map<String, dynamic> json) =>
    SmartSuggestionResponse(
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((e) => SmartRecipeSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      inventorySummary: InventorySummary.fromJson(
          json['inventorySummary'] as Map<String, dynamic>),
      totalSuggestions: (json['totalSuggestions'] as num).toInt(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => InventoryAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SmartSuggestionResponseToJson(
        SmartSuggestionResponse instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions,
      'inventorySummary': instance.inventorySummary,
      'totalSuggestions': instance.totalSuggestions,
      'alerts': instance.alerts,
    };
