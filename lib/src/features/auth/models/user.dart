import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('manager')
  manager,
  @JsonValue('cashier')
  cashier,
  @JsonValue('viewer')
  viewer,
}

@freezed
class User with _$User {
  const factory User({
    required int id,
    required int businessId,
    required String name,
    required String email,
    required UserRole role,
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
      case UserRole.manager:
        return 'Manager';
      case UserRole.cashier:
        return 'Cashier';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  bool get canAccessBusinessManagement => this == UserRole.admin;
  bool get canAccessPOS => this != UserRole.admin && this != UserRole.viewer;
  bool get canAccessKitchen => this == UserRole.viewer;
  bool get canAccessReports => this == UserRole.admin || this == UserRole.manager;
  bool get canManageUsers => this == UserRole.admin;
  bool get canViewOnly => this == UserRole.viewer;
} 