import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';

abstract class SmartRecipeRepository {
  Future<List<SmartRecipeSuggestion>> getSmartRecipeSuggestions({
    bool? includeExpiringItems,
    bool? includeUnderperformingItems,
    int? limit,
    String? status, // 'pending', 'cooked', 'expired', 'dismissed'
    bool? includeCooked, // Include cooked suggestions with pending ones
    int? maxDaysToExpiry,
    double? minSalesVelocity,
    int? maxDaysSinceLastSale,
  });
  
  Future<InventorySummary> getInventorySummary();
  
  Future<List<InventoryItem>> getExpiringItems({int days});
  
  Future<List<InventoryItem>> getUnderperformingItems();
  
  Future<List<InventoryAlert>> getInventoryAlerts();
  
  Future<void> updateTrackingData();
  
  Future<Map<String, dynamic>> cookRecipe(
    int recipeId, 
    int quantity, {
    String? promotionType,
    String? promotionName,
    String? promotionDescription,
    String? discountType,
    double? discountValue,
    int? promotionExpiresInHours,
  });
  
  Future<List<Map<String, dynamic>>> getCookingHistory();
  
  Future<Map<String, dynamic>> getCookingAnalytics();
  
  Future<Map<String, dynamic>> createPromotion({
    required String name,
    required String type,
    required String discountType,
    required double discountValue,
    required DateTime expiresAt,
    List<int>? itemIds,
    String? description,
  });
  
  Future<Map<String, dynamic>> getWastePreventionSuggestions({
    int? maxDaysToExpiry,
    int? limit,
  });
} 