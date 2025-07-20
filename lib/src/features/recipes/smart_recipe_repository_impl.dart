import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_repository.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/recipe.dart';

class SmartRecipeRepositoryImpl implements SmartRecipeRepository {
  final Dio _dio;

  SmartRecipeRepositoryImpl(this._dio);

  @override
  Future<List<SmartRecipeSuggestion>> getSmartRecipeSuggestions({
    bool includeExpiringItems = true,
    bool includeUnderperformingItems = true,
    int limit = 10,
  }) async {
    try {
      // Use the new smart suggestions endpoint
      final response = await _dio.get('/smart/smart-suggestions', queryParameters: {
        'includeExpiringItems': includeExpiringItems,
        'includeUnderperformingItems': includeUnderperformingItems,
        'limit': limit,
      });
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;

      final suggestions = data['suggestions'] as List<dynamic>? ?? [];
      
      return suggestions.map((suggestion) {
        final suggestionMap = suggestion as Map<String, dynamic>;
        
        // Parse suggested items
        final suggestedItems = suggestionMap['suggestedItems'] as List<dynamic>? ?? [];
        final inventoryItems = suggestedItems.map((item) {
          final itemMap = item as Map<String, dynamic>;
          return InventoryItem(
            id: itemMap['itemId']?.toInt() ?? 0,
            name: itemMap['itemName']?.toString() ?? 'Unknown Item',
            currentStock: itemMap['currentStock']?.toDouble() ?? 0.0,
            minimumStock: 0.0, // Not provided in API
            unitCost: 0.0, // Not provided in API
            expirationDate: null, // Parse from daysToExpiry if available
            manufacturingDate: null,
            shelfLifeDays: null,
            lastSoldDate: null,
            salesVelocity: null,
            daysSinceLastSale: null,
            isPerishable: false,
            isUnderperforming: false, // Will be determined by reason
            isExpiringSoon: itemMap['reason']?.toString().contains('Expires') ?? false,
            totalValue: 0.0,
            alertMessage: itemMap['reason']?.toString(),
          );
        }).toList();

        // Create recipe from suggestion data
        final recipe = Recipe(
          id: suggestionMap['recipeId']?.toInt() ?? 0,
          businessId: 1,
          name: suggestionMap['recipeName']?.toString() ?? 'Unknown Recipe',
          description: 'AI-suggested recipe based on inventory analysis',
          difficulty: _mapDifficulty(suggestionMap['recipeDifficulty']?.toString() ?? 'medium'),
          steps: [
            RecipeStep(
              stepNumber: 1,
              instruction: 'Use suggested ingredients to create ${suggestionMap['recipeName']}',
              timeMinutes: suggestionMap['prepTime']?.toInt() ?? 15,
            ),
          ],
          ingredients: inventoryItems.map((item) => RecipeIngredient(
            name: item.name,
            quantity: item.currentStock,
            unit: 'piece',
          )).toList(),
          prepTimeMinutes: suggestionMap['prepTime']?.toInt() ?? 15,
          cookTimeMinutes: suggestionMap['cookTime']?.toInt() ?? 30,
          totalTimeMinutes: (suggestionMap['prepTime']?.toInt() ?? 15) + (suggestionMap['cookTime']?.toInt() ?? 30),
          servings: 4,
          imageUrl: suggestionMap['imageUrl']?.toString(),
          tags: ['AI Suggested', 'Smart Recipe'],
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        return SmartRecipeSuggestion(
          id: suggestionMap['recipeId']?.toInt() ?? 0,
          recipe: recipe,
          confidenceScore: suggestionMap['confidence']?.toDouble() ?? 0.0,
          potentialSavings: suggestionMap['totalPotentialSavings']?.toDouble() ?? 0.0,
          urgencyLevel: _mapUrgencyLevel(suggestionMap['urgency']?.toString() ?? 'low'),
          matchingIngredients: inventoryItems,
          expiringIngredients: inventoryItems.where((item) => item.isExpiringSoon).toList(),
          underperformingIngredients: inventoryItems.where((item) => 
            item.alertMessage?.contains('underperforming') ?? false).toList(),
          reasoning: _generateReasoningFromItems(inventoryItems),
          createdAt: DateTime.now(),
          isRecommended: true,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get smart recipe suggestions: $e');
    }
  }

  @override
  Future<InventorySummary> getInventorySummary() async {
    try {
      final response = await _dio.get('/smart/inventory-summary');
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;

      return InventorySummary(
        totalItems: data['totalItems']?.toInt() ?? 0,
        expiringItems: data['expiringSoon']?.toInt() ?? 0,
        underperformingItems: data['underperforming']?.toInt() ?? 0,
        totalInventoryValue: 0.0, // Not provided in API
        potentialSavings: 0.0, // Not provided in API
        expiringItemsList: [], // Will be populated by separate call
        underperformingItemsList: [], // Will be populated by separate call
        activeAlerts: [], // Will be populated by separate call
        healthScore: _calculateHealthScore(data),
      );
    } catch (e) {
      throw Exception('Failed to get inventory summary: $e');
    }
  }

  @override
  Future<List<InventoryItem>> getExpiringItems({int days = 7}) async {
    try {
      final response = await _dio.get('/smart/expiring-items', queryParameters: {
        'days': days,
      });
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;

      final items = data['items'] as List<dynamic>? ?? [];
      
      return items.map((item) {
        final itemMap = item as Map<String, dynamic>;
        return InventoryItem(
          id: itemMap['itemId']?.toInt() ?? 0,
          name: itemMap['itemName']?.toString() ?? 'Unknown Item',
          currentStock: itemMap['currentStock']?.toDouble() ?? 0.0,
          minimumStock: 0.0,
          unitCost: 0.0,
          expirationDate: DateTime.now().add(Duration(days: itemMap['daysToExpiry']?.toInt() ?? 0)),
          manufacturingDate: null,
          shelfLifeDays: null,
          lastSoldDate: null,
          salesVelocity: null,
          daysSinceLastSale: null,
          isPerishable: true,
          isUnderperforming: false,
          isExpiringSoon: true,
          totalValue: itemMap['potentialLoss']?.toDouble() ?? 0.0,
          alertMessage: 'Expires in ${itemMap['daysToExpiry']?.toInt() ?? 0} days',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get expiring items: $e');
    }
  }

  @override
  Future<List<InventoryItem>> getUnderperformingItems() async {
    try {
      final response = await _dio.get('/smart/underperforming-items');
      
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;

      final items = data['items'] as List<dynamic>? ?? [];
      
      return items.map((item) {
        final itemMap = item as Map<String, dynamic>;
        return InventoryItem(
          id: itemMap['itemId']?.toInt() ?? 0,
          name: itemMap['itemName']?.toString() ?? 'Unknown Item',
          currentStock: itemMap['currentStock']?.toDouble() ?? 0.0,
          minimumStock: 0.0,
          unitCost: 0.0,
          expirationDate: null,
          manufacturingDate: null,
          shelfLifeDays: null,
          lastSoldDate: null,
          salesVelocity: itemMap['salesVelocity']?.toDouble() ?? 0.0,
          daysSinceLastSale: itemMap['daysSinceLastSale']?.toInt() ?? 0,
          isPerishable: false,
          isUnderperforming: true,
          isExpiringSoon: false,
          totalValue: itemMap['potentialLoss']?.toDouble() ?? 0.0,
          alertMessage: 'Low sales velocity: ${itemMap['salesVelocity']?.toStringAsFixed(1) ?? '0.0'}',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get underperforming items: $e');
    }
  }

  @override
  Future<List<InventoryAlert>> getInventoryAlerts() async {
    try {
      // Get alerts from multiple sources
      final expiringItems = await getExpiringItems(days: 7);
      final underperformingItems = await getUnderperformingItems();
      
      final alerts = <InventoryAlert>[];
      
      // Create alerts for expiring items
      for (final item in expiringItems) {
        alerts.add(InventoryAlert(
          id: item.id,
          title: 'Expiring Soon',
          message: '${item.name} expires in ${item.daysUntilExpiration} days',
          urgencyLevel: item.urgencyLevel,
          createdAt: DateTime.now(),
          isRead: false,
          itemName: item.name,
          itemId: item.id,
        ));
      }
      
      // Create alerts for underperforming items
      for (final item in underperformingItems) {
        alerts.add(InventoryAlert(
          id: item.id,
          title: 'Underperforming Item',
          message: '${item.name} has low sales velocity',
          urgencyLevel: item.urgencyLevel,
          createdAt: DateTime.now(),
          isRead: false,
          itemName: item.name,
          itemId: item.id,
        ));
      }
      
      return alerts;
    } catch (e) {
      throw Exception('Failed to get inventory alerts: $e');
    }
  }

  @override
  Future<void> updateTrackingData() async {
    try {
      await _dio.post('/smart/update-tracking');
    } catch (e) {
      throw Exception('Failed to update tracking data: $e');
    }
  }

  RecipeDifficulty _mapDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return RecipeDifficulty.easy;
      case 'medium':
        return RecipeDifficulty.medium;
      case 'hard':
        return RecipeDifficulty.hard;
      default:
        return RecipeDifficulty.medium;
    }
  }

  UrgencyLevel _mapUrgencyLevel(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return UrgencyLevel.high;
      case 'medium':
        return UrgencyLevel.medium;
      case 'low':
        return UrgencyLevel.low;
      default:
        return UrgencyLevel.low;
    }
  }

  double _calculateHealthScore(Map<String, dynamic> data) {
    final totalItems = data['totalItems']?.toInt() ?? 0;
    final expiringItems = data['expiringSoon']?.toInt() ?? 0;
    final underperformingItems = data['underperforming']?.toInt() ?? 0;
    
    if (totalItems == 0) return 100.0;
    
    final expiringPercentage = (expiringItems / totalItems) * 100;
    final underperformingPercentage = (underperformingItems / totalItems) * 100;
    
    // Health score decreases with more problematic items
    return 100.0 - (expiringPercentage + underperformingPercentage);
  }

  String _generateReasoningFromItems(List<InventoryItem> items) {
    final expiringItems = items.where((item) => item.isExpiringSoon).toList();
    final underperformingItems = items.where((item) => item.isUnderperforming).toList();
    
    if (expiringItems.isNotEmpty && underperformingItems.isNotEmpty) {
      return 'Recipe uses ${expiringItems.length} expiring items and ${underperformingItems.length} underperforming items to reduce waste.';
    } else if (expiringItems.isNotEmpty) {
      return 'Recipe uses ${expiringItems.length} expiring items to prevent waste.';
    } else if (underperformingItems.isNotEmpty) {
      return 'Recipe uses ${underperformingItems.length} underperforming items to improve turnover.';
    } else {
      return 'Recipe suggestion based on inventory optimization.';
    }
  }
} 