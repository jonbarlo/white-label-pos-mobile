import 'models/promotion.dart';

abstract class PromotionRepository {
  Future<List<Promotion>> getPromotions({int? businessId});
  Future<Promotion> getPromotion(int promotionId);
  Future<Promotion> createPromotion(Promotion promotion);
  Future<Promotion> updatePromotion(int promotionId, Promotion promotion);
  Future<void> deletePromotion(int promotionId);
  Future<List<Promotion>> getActivePromotions({int? businessId});
  Future<PromotionStats> getPromotionStats({int? businessId});
} 