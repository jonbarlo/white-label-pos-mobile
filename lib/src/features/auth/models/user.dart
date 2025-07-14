import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  admin,
  owner,
  manager,
  cashier,
  waiter,
  waitstaff,
  kitchen_staff,
  viewer,
}

// Custom converter for case-insensitive role parsing
class UserRoleConverter implements JsonConverter<UserRole, String> {
  const UserRoleConverter();

  @override
  UserRole fromJson(String json) {
    final lowerJson = json.toLowerCase();
    switch (lowerJson) {
      case 'admin':
        return UserRole.admin;
      case 'owner':
        return UserRole.owner;
      case 'manager':
        return UserRole.manager;
      case 'cashier':
        return UserRole.cashier;
      case 'waiter':
        return UserRole.waiter;
      case 'waitstaff':
      case 'wait_staff': // Handle both formats from API
        return UserRole.waitstaff;
      case 'kitchen_staff':
        return UserRole.kitchen_staff;
      case 'viewer':
        return UserRole.viewer;
      default:
        throw ArgumentError('Unknown user role: $json');
    }
  }

  @override
  String toJson(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.owner:
        return 'owner';
      case UserRole.manager:
        return 'manager';
      case UserRole.cashier:
        return 'cashier';
      case UserRole.waiter:
        return 'waiter';
      case UserRole.waitstaff:
        return 'waitstaff';
      case UserRole.kitchen_staff:
        return 'kitchen_staff';
      case UserRole.viewer:
        return 'viewer';
    }
  }
}

@freezed
class User with _$User {
  const factory User({
    required int id,
    required int businessId,
    required String name,
    required String email,
    @UserRoleConverter() required UserRole role,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? assignment,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.owner:
        return 'Owner';
      case UserRole.manager:
        return 'Manager';
      case UserRole.cashier:
        return 'Cashier';
      case UserRole.waiter:
        return 'Waiter';
      case UserRole.waitstaff:
        return 'Waitstaff';
      case UserRole.kitchen_staff:
        return 'Kitchen Staff';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  bool get canAccessBusinessManagement => this == UserRole.admin;
  bool get canAccessPOS => this != UserRole.admin && this != UserRole.viewer;
  bool get canAccessKitchen => this == UserRole.viewer;
  bool get canAccessWaiterDashboard => this == UserRole.waiter || this == UserRole.waitstaff;
  bool get canAccessReports => this == UserRole.admin || this == UserRole.manager;
  bool get canManageUsers => this == UserRole.admin;
  bool get canViewOnly => this == UserRole.viewer;
} 