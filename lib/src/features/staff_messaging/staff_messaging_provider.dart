import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/env_config.dart';
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
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Fetching staff messages for user: ${user.name}');
  }
  
  final messages = await repo.getStaffMessages();
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Received ${messages.length} messages');
  }
  
  return messages;
});

// Get messages for current user
final userMessagesProvider = FutureProvider.autoDispose<List<StaffMessage>>((ref) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Fetching user messages for: ${user.name}');
  }
  
  final messages = await repo.getUserMessages();
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Received ${messages.length} user messages');
  }
  
  return messages;
});

// Get active messages for user role
final activeMessagesProvider = FutureProvider.autoDispose<List<StaffMessage>>((ref) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Fetching active messages for user: ${user.name}');
  }
  
  final messages = await repo.getActiveMessages();
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Received ${messages.length} active messages');
  }
  
  return messages;
});

// Get unread message count
final unreadMessageCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Fetching unread count for user: ${user.name}');
  }
  
  final count = await repo.getUnreadMessageCount();
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Unread count: $count');
  }
  
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
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Creating staff message: ${params.title}');
  }
  
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
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Message created successfully');
  }
  
  return message;
});

// Mark message as read provider
final markMessageAsReadProvider = FutureProvider.family<void, int>((ref, messageId) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Marking message $messageId as read');
  }
  
  await repo.markMessageAsRead(messageId);
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Message marked as read');
  }
});

// Acknowledge message provider
final acknowledgeMessageProvider = FutureProvider.family<void, int>((ref, messageId) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Acknowledging message $messageId');
  }
  
  await repo.acknowledgeMessage(messageId);
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Message acknowledged');
  }
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
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Updating message ${params.messageId}');
  }
  
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
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Message updated successfully');
  }
  
  return message;
});

// Delete staff message provider
final deleteStaffMessageProvider = FutureProvider.family<void, int>((ref, messageId) async {
  final repo = ref.watch(staffMessagingRepositoryProvider);
  final user = ref.watch(authNotifierProvider).user;
  if (user == null) throw Exception('Not authenticated');
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Deleting message $messageId');
  }
  
  await repo.deleteStaffMessage(messageId);
  
  if (EnvConfig.isDebugMode) {
    print('📢 PROVIDER: Message deleted successfully');
  }
}); 