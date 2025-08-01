// Mocks generated by Mockito 5.4.5 from annotations
// in white_label_pos_mobile/test/unit/features/user_management/user_management_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:white_label_pos_mobile/src/features/user_management/models/user.dart'
    as _i2;
import 'package:white_label_pos_mobile/src/features/user_management/user_management_repository.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUser_0 extends _i1.SmartFake implements _i2.User {
  _FakeUser_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserManagementRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserManagementRepository extends _i1.Mock
    implements _i3.UserManagementRepository {
  MockUserManagementRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.User>> getUsers() => (super.noSuchMethod(
        Invocation.method(
          #getUsers,
          [],
        ),
        returnValue: _i4.Future<List<_i2.User>>.value(<_i2.User>[]),
      ) as _i4.Future<List<_i2.User>>);

  @override
  _i4.Future<_i2.User> getUser(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [id],
        ),
        returnValue: _i4.Future<_i2.User>.value(_FakeUser_0(
          this,
          Invocation.method(
            #getUser,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.User>);

  @override
  _i4.Future<_i2.User> createUser(_i2.User? user) => (super.noSuchMethod(
        Invocation.method(
          #createUser,
          [user],
        ),
        returnValue: _i4.Future<_i2.User>.value(_FakeUser_0(
          this,
          Invocation.method(
            #createUser,
            [user],
          ),
        )),
      ) as _i4.Future<_i2.User>);

  @override
  _i4.Future<_i2.User> updateUser(_i2.User? user) => (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [user],
        ),
        returnValue: _i4.Future<_i2.User>.value(_FakeUser_0(
          this,
          Invocation.method(
            #updateUser,
            [user],
          ),
        )),
      ) as _i4.Future<_i2.User>);

  @override
  _i4.Future<bool> deleteUser(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteUser,
          [id],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<_i2.User> updateUserRole(
    String? userId,
    String? newRole,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserRole,
          [
            userId,
            newRole,
          ],
        ),
        returnValue: _i4.Future<_i2.User>.value(_FakeUser_0(
          this,
          Invocation.method(
            #updateUserRole,
            [
              userId,
              newRole,
            ],
          ),
        )),
      ) as _i4.Future<_i2.User>);

  @override
  _i4.Future<_i2.User> toggleUserStatus(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #toggleUserStatus,
          [userId],
        ),
        returnValue: _i4.Future<_i2.User>.value(_FakeUser_0(
          this,
          Invocation.method(
            #toggleUserStatus,
            [userId],
          ),
        )),
      ) as _i4.Future<_i2.User>);

  @override
  _i4.Future<List<String>> getUserRoles() => (super.noSuchMethod(
        Invocation.method(
          #getUserRoles,
          [],
        ),
        returnValue: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);

  @override
  _i4.Future<List<String>> getUserPermissions(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserPermissions,
          [userId],
        ),
        returnValue: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);

  @override
  _i4.Future<List<_i2.User>> searchUsers(String? query) => (super.noSuchMethod(
        Invocation.method(
          #searchUsers,
          [query],
        ),
        returnValue: _i4.Future<List<_i2.User>>.value(<_i2.User>[]),
      ) as _i4.Future<List<_i2.User>>);

  @override
  _i4.Future<List<_i2.User>> getUsersByRole(String? role) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUsersByRole,
          [role],
        ),
        returnValue: _i4.Future<List<_i2.User>>.value(<_i2.User>[]),
      ) as _i4.Future<List<_i2.User>>);

  @override
  _i4.Future<int> getActiveUsersCount() => (super.noSuchMethod(
        Invocation.method(
          #getActiveUsersCount,
          [],
        ),
        returnValue: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);

  @override
  _i4.Future<List<_i2.User>> getUsersByDateRange(
    DateTime? startDate,
    DateTime? endDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUsersByDateRange,
          [
            startDate,
            endDate,
          ],
        ),
        returnValue: _i4.Future<List<_i2.User>>.value(<_i2.User>[]),
      ) as _i4.Future<List<_i2.User>>);
}
