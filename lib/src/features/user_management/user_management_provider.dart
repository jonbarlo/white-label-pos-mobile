import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:white_label_pos_mobile/src/features/user_management/user_management_repository.dart';
import 'package:white_label_pos_mobile/src/features/user_management/models/user.dart';

part 'user_management_provider.g.dart';

@riverpod
UserManagementRepository userManagementRepository(UserManagementRepositoryRef ref) {
  // This will be overridden in tests and dependency injection
  throw UnimplementedError('userManagementRepository must be overridden');
}

@riverpod
Future<List<User>> users(UsersRef ref) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.getUsers();
}

@riverpod
Future<User> user(UserRef ref, String userId) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.getUser(userId);
}

@riverpod
Future<List<String>> userRoles(UserRolesRef ref) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.getUserRoles();
}

@riverpod
Future<List<String>> userPermissions(
  UserPermissionsRef ref,
  String userId,
) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.getUserPermissions(userId);
}

@riverpod
Future<List<User>> searchUsers(
  SearchUsersRef ref,
  String query,
) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.searchUsers(query);
}

@riverpod
Future<List<User>> usersByRole(
  UsersByRoleRef ref,
  String role,
) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.getUsersByRole(role);
}

@riverpod
Future<int> activeUsersCount(ActiveUsersCountRef ref) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.getActiveUsersCount();
}

@riverpod
Future<List<User>> usersByDateRange(
  UsersByDateRangeRef ref, {
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final repository = ref.watch(userManagementRepositoryProvider);
  return await repository.getUsersByDateRange(startDate, endDate);
}

@riverpod
class UserManagementNotifier extends _$UserManagementNotifier {
  @override
  Future<void> build() async {
    // Initialize with default state
  }

  Future<User> createUser(User user) async {
    final repository = ref.read(userManagementRepositoryProvider);
    final createdUser = await repository.createUser(user);
    
    // Invalidate related providers
    ref.invalidate(usersProvider);
    ref.invalidate(activeUsersCountProvider);
    
    return createdUser;
  }

  Future<User> updateUser(User user) async {
    final repository = ref.read(userManagementRepositoryProvider);
    final updatedUser = await repository.updateUser(user);
    
    // Invalidate related providers
    ref.invalidate(usersProvider);
    ref.invalidate(userProvider(user.id));
    ref.invalidate(activeUsersCountProvider);
    
    return updatedUser;
  }

  Future<bool> deleteUser(String userId) async {
    final repository = ref.read(userManagementRepositoryProvider);
    final success = await repository.deleteUser(userId);
    
    if (success) {
      // Invalidate related providers
      ref.invalidate(usersProvider);
      ref.invalidate(userProvider(userId));
      ref.invalidate(activeUsersCountProvider);
    }
    
    return success;
  }

  Future<User> updateUserRole(String userId, String newRole) async {
    final repository = ref.read(userManagementRepositoryProvider);
    final updatedUser = await repository.updateUserRole(userId, newRole);
    
    // Invalidate related providers
    ref.invalidate(usersProvider);
    ref.invalidate(userProvider(userId));
    ref.invalidate(usersByRoleProvider(newRole));
    
    return updatedUser;
  }

  Future<User> toggleUserStatus(String userId) async {
    final repository = ref.read(userManagementRepositoryProvider);
    final updatedUser = await repository.toggleUserStatus(userId);
    
    // Invalidate related providers
    ref.invalidate(usersProvider);
    ref.invalidate(userProvider(userId));
    ref.invalidate(activeUsersCountProvider);
    
    return updatedUser;
  }

  void refreshUsers() {
    ref.invalidate(usersProvider);
    ref.invalidate(activeUsersCountProvider);
  }

  void refreshUser(String userId) {
    ref.invalidate(userProvider(userId));
    ref.invalidate(userPermissionsProvider(userId));
  }
} 