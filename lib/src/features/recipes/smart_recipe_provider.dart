import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_repository.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_repository_impl.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';

part 'smart_recipe_provider.g.dart';

@riverpod
SmartRecipeRepository smartRecipeRepository(SmartRecipeRepositoryRef ref) {
  final dio = ref.watch(dioClientProvider);
  return SmartRecipeRepositoryImpl(dio);
}

@riverpod
Future<List<SmartRecipeSuggestion>> smartRecipeSuggestions(SmartRecipeSuggestionsRef ref) async {
  final repository = ref.watch(smartRecipeRepositoryProvider);
  return await repository.getSmartRecipeSuggestions(
    includeExpiringItems: true,
    includeUnderperformingItems: true,
    limit: 10,
  );
}

@riverpod
Future<InventorySummary> inventorySummary(InventorySummaryRef ref) async {
  final repository = ref.watch(smartRecipeRepositoryProvider);
  return await repository.getInventorySummary();
}

@riverpod
Future<List<InventoryItem>> expiringItems(ExpiringItemsRef ref, int days) async {
  final repository = ref.watch(smartRecipeRepositoryProvider);
  return await repository.getExpiringItems(days: days);
}

@riverpod
Future<List<InventoryItem>> underperformingItems(UnderperformingItemsRef ref) async {
  final repository = ref.watch(smartRecipeRepositoryProvider);
  return await repository.getUnderperformingItems();
}

@riverpod
Future<List<InventoryAlert>> inventoryAlerts(InventoryAlertsRef ref) async {
  final repository = ref.watch(smartRecipeRepositoryProvider);
  return await repository.getInventoryAlerts();
}

@riverpod
Future<List<SmartRecipeSuggestion>> urgentSuggestions(UrgentSuggestionsRef ref) async {
  final suggestions = await ref.watch(smartRecipeSuggestionsProvider.future);
  return suggestions.where((suggestion) => suggestion.urgencyLevel == UrgencyLevel.high).toList();
}

@riverpod
Future<List<SmartRecipeSuggestion>> mediumSuggestions(MediumSuggestionsRef ref) async {
  final suggestions = await ref.watch(smartRecipeSuggestionsProvider.future);
  return suggestions.where((suggestion) => suggestion.urgencyLevel == UrgencyLevel.medium).toList();
}

@riverpod
Future<List<SmartRecipeSuggestion>> lowSuggestions(LowSuggestionsRef ref) async {
  final suggestions = await ref.watch(smartRecipeSuggestionsProvider.future);
  return suggestions.where((suggestion) => suggestion.urgencyLevel == UrgencyLevel.low).toList();
}

@riverpod
Future<List<InventoryAlert>> urgentAlerts(UrgentAlertsRef ref) async {
  final alerts = await ref.watch(inventoryAlertsProvider.future);
  return alerts.where((alert) => alert.urgencyLevel == UrgencyLevel.high).toList();
}

@riverpod
Future<List<InventoryAlert>> mediumAlerts(MediumAlertsRef ref) async {
  final alerts = await ref.watch(inventoryAlertsProvider.future);
  return alerts.where((alert) => alert.urgencyLevel == UrgencyLevel.medium).toList();
}

@riverpod
Future<List<InventoryAlert>> lowAlerts(LowAlertsRef ref) async {
  final alerts = await ref.watch(inventoryAlertsProvider.future);
  return alerts.where((alert) => alert.urgencyLevel == UrgencyLevel.low).toList();
}

@riverpod
Future<void> updateTrackingData(UpdateTrackingDataRef ref) async {
  final repository = ref.watch(smartRecipeRepositoryProvider);
  await repository.updateTrackingData();
}

@riverpod
Future<List<InventoryItem>> highUrgencyExpiringItems(HighUrgencyExpiringItemsRef ref) async {
  final items = await ref.watch(expiringItemsProvider(7).future);
  return items.where((item) => item.daysUntilExpiration <= 3).toList();
}

@riverpod
Future<List<InventoryItem>> mediumUrgencyExpiringItems(MediumUrgencyExpiringItemsRef ref) async {
  final items = await ref.watch(expiringItemsProvider(7).future);
  return items.where((item) => item.daysUntilExpiration > 3 && item.daysUntilExpiration <= 7).toList();
} 