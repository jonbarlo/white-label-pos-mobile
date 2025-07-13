import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import 'messaging_repository.dart';

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return MessagingRepository(dio);
});

// Messages providers
final messagesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getMessages();
});

final unreadMessagesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getMessages(isRead: false);
});

final kitchenMessagesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getMessages(type: 'kitchen');
});

final managementMessagesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getMessages(type: 'management');
});

final customerMessagesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getMessages(type: 'customer');
});

// Message actions
final sendMessageProvider = FutureProvider.family<Map<String, dynamic>, ({
  String content,
  String type,
  String? recipientId,
  String? tableId,
})>((ref, params) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.sendMessage(
    content: params.content,
    type: params.type,
    recipientId: params.recipientId,
    tableId: params.tableId,
  );
});

final markMessageAsReadProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, messageId) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.markMessageAsRead(messageId);
});

final deleteMessageProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, messageId) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.deleteMessage(messageId);
});

// Promotions providers
final promotionsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getPromotions();
});

final activePromotionsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getPromotions(isActive: true);
});

final promotionsByCategoryProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, category) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getPromotions(isActive: true, category: category);
});

// Promotion actions
final createPromotionProvider = FutureProvider.family<Map<String, dynamic>, ({
  String title,
  String description,
  String discount,
  String category,
  DateTime validUntil,
})>((ref, params) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.createPromotion(
    title: params.title,
    description: params.description,
    discount: params.discount,
    category: params.category,
    validUntil: params.validUntil,
  );
});

final updatePromotionProvider = FutureProvider.family<Map<String, dynamic>, ({
  String promotionId,
  String? title,
  String? description,
  String? discount,
  String? category,
  DateTime? validUntil,
  bool? isActive,
})>((ref, params) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.updatePromotion(
    promotionId: params.promotionId,
    title: params.title,
    description: params.description,
    discount: params.discount,
    category: params.category,
    validUntil: params.validUntil,
    isActive: params.isActive,
  );
});

final deletePromotionProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, promotionId) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.deletePromotion(promotionId);
});

// Utility providers
final callKitchenProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.callKitchen();
});

final callManagerProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.callManager();
});

final emergencyCallProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.emergencyCall();
});

final dailyReportProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getDailyReport();
});

final inventoryStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(messagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  return await repo.getInventoryStatus();
});

// Computed providers
final unreadMessageCountProvider = Provider<int>((ref) {
  final unreadMessagesAsync = ref.watch(unreadMessagesProvider);
  return unreadMessagesAsync.when(
    data: (messages) => messages.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final activePromotionCountProvider = Provider<int>((ref) {
  final activePromotionsAsync = ref.watch(activePromotionsProvider);
  return activePromotionsAsync.when(
    data: (promotions) => promotions.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}); 