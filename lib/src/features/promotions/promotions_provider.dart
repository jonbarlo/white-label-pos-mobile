import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'promotion_repository.dart';
import 'promotion_repository_impl.dart';
import 'models/promotion.dart';

part 'promotions_provider.g.dart';

@riverpod
Future<List<Promotion>> promotions(PromotionsRef ref) async {
  final repository = ref.watch(promotionRepositoryProvider);
  return await repository.getPromotions();
}

@riverpod
Future<List<Promotion>> activePromotions(ActivePromotionsRef ref) async {
  final repository = ref.watch(promotionRepositoryProvider);
  return await repository.getActivePromotions();
}

@riverpod
Future<List<Promotion>> promotionsByType(PromotionsByTypeRef ref, String type) async {
  final repository = ref.watch(promotionRepositoryProvider);
  return await repository.getPromotionsByType(type);
}

@riverpod
class PromotionsNotifier extends _$PromotionsNotifier {
  @override
  Future<List<Promotion>> build() async {
    final repository = ref.watch(promotionRepositoryProvider);
    return await repository.getPromotions();
  }

  Future<void> refreshPromotions() async {
    ref.invalidateSelf();
  }

  Future<void> createPromotion(Promotion promotion) async {
    final repository = ref.watch(promotionRepositoryProvider);
    await repository.createPromotion(promotion);
    // Refresh the list after creating a new promotion
    ref.invalidateSelf();
  }

  Future<void> updatePromotion(Promotion promotion) async {
    final repository = ref.watch(promotionRepositoryProvider);
    await repository.updatePromotion(promotion);
    // Refresh the list after updating a promotion
    ref.invalidateSelf();
  }

  Future<void> deletePromotion(int id) async {
    final repository = ref.watch(promotionRepositoryProvider);
    await repository.deletePromotion(id);
    // Refresh the list after deleting a promotion
    ref.invalidateSelf();
  }
} 