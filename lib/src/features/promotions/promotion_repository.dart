import 'models/promotion.dart';

abstract class PromotionRepository {
  /// Get all promotions for the current business
  Future<List<Promotion>> getPromotions();
  
  /// Get a specific promotion by ID
  Future<Promotion?> getPromotion(int id);
  
  /// Create a new promotion
  Future<Promotion> createPromotion(Promotion promotion);
  
  /// Update an existing promotion
  Future<Promotion> updatePromotion(Promotion promotion);
  
  /// Delete a promotion
  Future<void> deletePromotion(int id);
  
  /// Get active promotions
  Future<List<Promotion>> getActivePromotions();
  
  /// Get promotions by type
  Future<List<Promotion>> getPromotionsByType(String type);
} 