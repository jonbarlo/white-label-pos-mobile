import 'package:json_annotation/json_annotation.dart';

part 'promotion.g.dart';

enum PromotionType { percentage, fixed, buyOneGetOne, freeItem }
enum PromotionStatus { active, inactive, scheduled, expired }

@JsonSerializable()
class Promotion {
  final int id;
  final int businessId;
  final String name;
  final String description;
  final PromotionType type;
  final PromotionStatus status;
  final double discountValue; // percentage or fixed amount
  final DateTime startDate;
  final DateTime endDate;
  final List<int> applicableItemIds; // menu item IDs
  final List<String> applicableCategories; // category names
  final double? minimumOrderAmount;
  final int? maximumUses;
  final int currentUses;
  final String? imageUrl;
  final String? termsAndConditions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Promotion({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.applicableItemIds,
    required this.applicableCategories,
    this.minimumOrderAmount,
    this.maximumUses,
    required this.currentUses,
    this.imageUrl,
    this.termsAndConditions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionToJson(this);

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && 
           status == PromotionStatus.active && 
           now.isAfter(startDate) && 
           now.isBefore(endDate) &&
           (maximumUses == null || currentUses < maximumUses!);
  }

  String get discountDisplay {
    switch (type) {
      case PromotionType.percentage:
        return '${discountValue.toInt()}% OFF';
      case PromotionType.fixed:
        return '\$${discountValue.toStringAsFixed(2)} OFF';
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
    PromotionStatus? status,
    double? discountValue,
    DateTime? startDate,
    DateTime? endDate,
    List<int>? applicableItemIds,
    List<String>? applicableCategories,
    double? minimumOrderAmount,
    int? maximumUses,
    int? currentUses,
    String? imageUrl,
    String? termsAndConditions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      discountValue: discountValue ?? this.discountValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      applicableItemIds: applicableItemIds ?? this.applicableItemIds,
      applicableCategories: applicableCategories ?? this.applicableCategories,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      maximumUses: maximumUses ?? this.maximumUses,
      currentUses: currentUses ?? this.currentUses,
      imageUrl: imageUrl ?? this.imageUrl,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      isActive: isActive ?? this.isActive,
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