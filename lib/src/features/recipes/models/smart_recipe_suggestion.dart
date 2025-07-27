import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'recipe.dart';

part 'smart_recipe_suggestion.g.dart';

enum UrgencyLevel { high, medium, low }
enum SuggestionStatus { pending, cooked, expired, dismissed }

extension UrgencyLevelExtension on UrgencyLevel {
  Color get urgencyColor {
    switch (this) {
      case UrgencyLevel.high:
        return Colors.red;
      case UrgencyLevel.medium:
        return Colors.orange;
      case UrgencyLevel.low:
        return Colors.green;
    }
  }

  String get urgencyText {
    switch (this) {
      case UrgencyLevel.high:
        return 'HIGH URGENCY';
      case UrgencyLevel.medium:
        return 'MEDIUM URGENCY';
      case UrgencyLevel.low:
        return 'LOW URGENCY';
    }
  }
}

@JsonSerializable()
class SmartRecipeSuggestion {
  final int id;
  final Recipe recipe;
  final double confidenceScore;
  final double potentialSavings;
  final UrgencyLevel urgencyLevel;
  final List<InventoryItem> matchingIngredients;
  final List<InventoryItem> expiringIngredients;
  final List<InventoryItem> underperformingIngredients;
  final String reasoning;
  final DateTime createdAt;
  final bool isRecommended;
  final SuggestionStatus status;

  const SmartRecipeSuggestion({
    required this.id,
    required this.recipe,
    required this.confidenceScore,
    required this.potentialSavings,
    required this.urgencyLevel,
    required this.matchingIngredients,
    required this.expiringIngredients,
    required this.underperformingIngredients,
    required this.reasoning,
    required this.createdAt,
    this.isRecommended = false,
    this.status = SuggestionStatus.pending,
  });

  factory SmartRecipeSuggestion.fromJson(Map<String, dynamic> json) => 
      _$SmartRecipeSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$SmartRecipeSuggestionToJson(this);

  // Computed properties for UI
  Color get urgencyColor => urgencyLevel.urgencyColor;
  String get urgencyText => urgencyLevel.urgencyText;

  bool get isUrgent => urgencyLevel == UrgencyLevel.high;
  bool get hasExpiringIngredients => expiringIngredients.isNotEmpty;
  bool get hasUnderperformingIngredients => underperformingIngredients.isNotEmpty;
  bool get canBeCooked => status == SuggestionStatus.pending;
  bool get isCooked => status == SuggestionStatus.cooked;
  bool get isExpired => status == SuggestionStatus.expired;
  bool get isDismissed => status == SuggestionStatus.dismissed;
}

@JsonSerializable()
class InventoryItem {
  final int id;
  final String name;
  final double currentStock;
  final double minimumStock;
  final double unitCost;
  final DateTime? expirationDate;
  final DateTime? manufacturingDate;
  final int? shelfLifeDays;
  final DateTime? lastSoldDate;
  final double? salesVelocity;
  final int? daysSinceLastSale;
  final bool isPerishable;
  final bool isUnderperforming;
  final bool isExpiringSoon;
  final double totalValue;
  final String? alertMessage;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minimumStock,
    required this.unitCost,
    this.expirationDate,
    this.manufacturingDate,
    this.shelfLifeDays,
    this.lastSoldDate,
    this.salesVelocity,
    this.daysSinceLastSale,
    required this.isPerishable,
    required this.isUnderperforming,
    required this.isExpiringSoon,
    required this.totalValue,
    this.alertMessage,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => 
      _$InventoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);

  bool get isExpiring => isExpiringSoon;
  bool get needsAttention => isExpiringSoon || isUnderperforming;
  int get daysUntilExpiration {
    if (expirationDate == null) return -1;
    return expirationDate!.difference(DateTime.now()).inDays;
  }

  UrgencyLevel get urgencyLevel {
    if (isExpiringSoon && daysUntilExpiration <= 2) return UrgencyLevel.high;
    if (isExpiringSoon && daysUntilExpiration <= 7) return UrgencyLevel.medium;
    if (isUnderperforming && (daysSinceLastSale ?? 0) > 30) return UrgencyLevel.high;
    if (isUnderperforming && (daysSinceLastSale ?? 0) > 14) return UrgencyLevel.medium;
    return UrgencyLevel.low;
  }

  String get statusText {
    if (isExpiringSoon && daysUntilExpiration <= 2) {
      return 'Expires in ${daysUntilExpiration} days!';
    } else if (isExpiringSoon) {
      return 'Expires in ${daysUntilExpiration} days';
    } else if (isUnderperforming) {
      return 'Underperforming (${daysSinceLastSale ?? 0} days since last sale)';
    }
    return 'Normal';
  }
}

@JsonSerializable()
class InventorySummary {
  final int totalItems;
  final int expiringItems;
  final int underperformingItems;
  final double totalInventoryValue;
  final double potentialSavings;
  final List<InventoryItem> expiringItemsList;
  final List<InventoryItem> underperformingItemsList;
  final List<InventoryAlert> activeAlerts;
  final double healthScore;

  const InventorySummary({
    required this.totalItems,
    required this.expiringItems,
    required this.underperformingItems,
    required this.totalInventoryValue,
    required this.potentialSavings,
    required this.expiringItemsList,
    required this.underperformingItemsList,
    required this.activeAlerts,
    required this.healthScore,
  });

  factory InventorySummary.fromJson(Map<String, dynamic> json) => 
      _$InventorySummaryFromJson(json);
  Map<String, dynamic> toJson() => _$InventorySummaryToJson(this);

  bool get hasUrgentAlerts => activeAlerts.any((alert) => alert.urgencyLevel == UrgencyLevel.high);
  bool get hasMediumAlerts => activeAlerts.any((alert) => alert.urgencyLevel == UrgencyLevel.medium);
  
  String get healthStatus {
    if (healthScore >= 80) return 'Excellent';
    if (healthScore >= 60) return 'Good';
    if (healthScore >= 40) return 'Fair';
    return 'Poor';
  }

  Color get healthColor {
    if (healthScore >= 80) return Colors.green;
    if (healthScore >= 60) return Colors.orange;
    if (healthScore >= 40) return Colors.red;
    return Colors.red;
  }
}

@JsonSerializable()
class InventoryAlert {
  final int id;
  final String title;
  final String message;
  final UrgencyLevel urgencyLevel;
  final DateTime createdAt;
  final bool isRead;
  final String? itemName;
  final int? itemId;

  const InventoryAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.urgencyLevel,
    required this.createdAt,
    required this.isRead,
    this.itemName,
    this.itemId,
  });

  factory InventoryAlert.fromJson(Map<String, dynamic> json) => 
      _$InventoryAlertFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryAlertToJson(this);

  Color get urgencyColor => urgencyLevel.urgencyColor;
  String get urgencyText => urgencyLevel.urgencyText;
}

@JsonSerializable()
class SmartSuggestionResponse {
  final List<SmartRecipeSuggestion> suggestions;
  final InventorySummary inventorySummary;
  final int totalSuggestions;
  final List<InventoryAlert> alerts;

  const SmartSuggestionResponse({
    required this.suggestions,
    required this.inventorySummary,
    required this.totalSuggestions,
    required this.alerts,
  });

  factory SmartSuggestionResponse.fromJson(Map<String, dynamic> json) => 
      _$SmartSuggestionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SmartSuggestionResponseToJson(this);

  List<SmartRecipeSuggestion> get urgentSuggestions => 
      suggestions.where((s) => s.urgencyLevel == UrgencyLevel.high).toList();
  
  List<SmartRecipeSuggestion> get mediumSuggestions => 
      suggestions.where((s) => s.urgencyLevel == UrgencyLevel.medium).toList();
  
  List<SmartRecipeSuggestion> get lowSuggestions => 
      suggestions.where((s) => s.urgencyLevel == UrgencyLevel.low).toList();
} 