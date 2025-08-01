import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'promotion.g.dart';

enum PromotionType { discount, chef_special, buyOneGetOne, freeItem }
enum PromotionStatus { active, inactive, scheduled, expired }

class PromotionTypeConverter implements JsonConverter<PromotionType, String> {
  const PromotionTypeConverter();

  @override
  PromotionType fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'discount':
        return PromotionType.discount;
      case 'chef_special':
        return PromotionType.chef_special;
      case 'buyonegetone':
      case 'bogo':
        return PromotionType.buyOneGetOne;
      case 'freeitem':
        return PromotionType.freeItem;
      default:
        return PromotionType.discount; // Default fallback
    }
  }

  @override
  String toJson(PromotionType object) {
    switch (object) {
      case PromotionType.discount:
        return 'discount';
      case PromotionType.chef_special:
        return 'chef_special';
      case PromotionType.buyOneGetOne:
        return 'buyOneGetOne';
      case PromotionType.freeItem:
        return 'freeItem';
    }
  }
}

class ConditionsConverter implements JsonConverter<Map<String, dynamic>?, dynamic> {
  const ConditionsConverter();

  @override
  Map<String, dynamic>? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Map<String, dynamic>) return json;
    if (json is String) {
      try {
        return Map<String, dynamic>.from(jsonDecode(json));
      } catch (e) {
        print('🔍 DEBUG: Error parsing conditions JSON: $e');
        return null;
      }
    }
    return null;
  }

  @override
  dynamic toJson(Map<String, dynamic>? object) {
    return object;
  }
}

@JsonSerializable()
class Promotion {
  final int id;
  final int businessId;
  final String name;
  final String description;
  @PromotionTypeConverter()
  final PromotionType type;
  final String discountType; // percentage, fixed, etc.
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;
  @ConditionsConverter()
  final Map<String, dynamic>? conditions;
  final bool isActive;
  final String? imageUrl;
  final int? totalQuantity;
  final int usedQuantity;
  final int? maxUsesPerCustomer;
  final int? recipeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Promotion({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.type,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    this.conditions,
    required this.isActive,
    this.imageUrl,
    this.totalQuantity,
    required this.usedQuantity,
    this.maxUsesPerCustomer,
    this.recipeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionToJson(this);

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(startDate) && 
           now.isBefore(endDate) &&
           (maxUsesPerCustomer == null || usedQuantity < maxUsesPerCustomer!);
  }

  String get discountDisplay {
    switch (type) {
      case PromotionType.discount:
        return '${discountValue.toInt()}% OFF';
      case PromotionType.chef_special:
        return 'Chef\'s Special';
      case PromotionType.buyOneGetOne:
        return 'Buy 1 Get 1 FREE';
      case PromotionType.freeItem:
        return 'FREE ITEM';
    }
  }

  Promotion copyWith({
    int? id,
    int? businessId,
    String? name,
    String? description,
    PromotionType? type,
    String? discountType,
    double? discountValue,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? conditions,
    bool? isActive,
    String? imageUrl,
    int? totalQuantity,
    int? usedQuantity,
    int? maxUsesPerCustomer,
    int? recipeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      conditions: conditions ?? this.conditions,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      maxUsesPerCustomer: maxUsesPerCustomer ?? this.maxUsesPerCustomer,
      recipeId: recipeId ?? this.recipeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class PromotionStats {
  final int totalPromotions;
  final int activePromotions;
  final int scheduledPromotions;
  final int expiredPromotions;
  final Map<PromotionType, int> promotionsByType;
  final double totalDiscountValue;
  final int totalUses;
  final List<String> mostPopularPromotions;

  const PromotionStats({
    required this.totalPromotions,
    required this.activePromotions,
    required this.scheduledPromotions,
    required this.expiredPromotions,
    required this.promotionsByType,
    required this.totalDiscountValue,
    required this.totalUses,
    required this.mostPopularPromotions,
  });

  factory PromotionStats.fromJson(Map<String, dynamic> json) => _$PromotionStatsFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionStatsToJson(this);
} 