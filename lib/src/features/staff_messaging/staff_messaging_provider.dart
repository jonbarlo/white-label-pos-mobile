import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import 'staff_messaging_repository.dart';
import 'models/staff_message.dart';

final staffMessagingRepositoryProvider = Provider<StaffMessagingRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return StaffMessagingRepository(dio);
});

// Get all staff messages for business
final staffMessagesProvider = FutureProvider.autoDispose<List<StaffMessage>>((ref) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final messages = await repo.getStaffMessages();
  
  return messages;
});

// Get messages for current user
final userMessagesProvider = FutureProvider.autoDispose<List<StaffMessage>>((ref) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final messages = await repo.getUserMessages();
  
  return messages;
});

// Get active messages for user role
final activeMessagesProvider = FutureProvider.autoDispose<List<StaffMessage>>((ref) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final messages = await repo.getActiveMessages();
  
  return messages;
});

// Get unread message count
final unreadMessageCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final count = await repo.getUnreadMessageCount();
  
  return count;
});

// Create staff message provider
final createStaffMessageProvider = FutureProvider.family<StaffMessage, ({
  String title,
  String content,
  String messageType,
  String priority,
  List<String> targetRoles,
  List<int>? targetUserIds,
  String? expiresAt,
  Map<String, dynamic>? metadata,
})>((ref, params) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final message = await repo.createStaffMessage(
    title: params.title,
    content: params.content,
    messageType: params.messageType,
    priority: params.priority,
    targetRoles: params.targetRoles,
    targetUserIds: params.targetUserIds,
    expiresAt: params.expiresAt,
    metadata: params.metadata,
  );
  
  return message;
});

// Mark message as read provider
final markMessageAsReadProvider = FutureProvider.family<void, int>((ref, messageId) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  await repo.markMessageAsRead(messageId);
});

// Acknowledge message provider
final acknowledgeMessageProvider = FutureProvider.family<void, int>((ref, messageId) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  await repo.acknowledgeMessage(messageId);
});

// Update staff message provider
final updateStaffMessageProvider = FutureProvider.family<StaffMessage, ({
  int messageId,
  String? title,
  String? content,
  String? messageType,
  String? priority,
  String? status,
  List<String>? targetRoles,
  List<int>? targetUserIds,
  String? expiresAt,
  Map<String, dynamic>? metadata,
})>((ref, params) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  final message = await repo.updateStaffMessage(
    params.messageId,
    title: params.title,
    content: params.content,
    messageType: params.messageType,
    priority: params.priority,
    status: params.status,
    targetRoles: params.targetRoles,
    targetUserIds: params.targetUserIds,
    expiresAt: params.expiresAt,
    metadata: params.metadata,
  );
  
  return message;
});

// Delete staff message provider
final deleteStaffMessageProvider = FutureProvider.family<void, int>((ref, messageId) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  await repo.deleteStaffMessage(messageId);
}); 