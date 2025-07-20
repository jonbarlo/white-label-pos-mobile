import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';

abstract class SmartRecipeRepository {
  Future<List<SmartRecipeSuggestion>> getSmartRecipeSuggestions({
    bool includeExpiringItems,
    bool includeUnderperformingItems,
    int limit,
  });
  
  Future<InventorySummary> getInventorySummary();
  
  Future<List<InventoryItem>> getExpiringItems({int days});
  
  Future<List<InventoryItem>> getUnderperformingItems();
  
  Future<List<InventoryAlert>> getInventoryAlerts();
  
  Future<void> updateTrackingData();
} 