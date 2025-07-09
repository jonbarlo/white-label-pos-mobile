import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/user_management/user_management_repository.dart';
import 'package:white_label_pos_mobile/src/features/user_management/models/user.dart';

import 'user_management_repository_test.mocks.dart';

@GenerateMocks([UserManagementRepository])
void main() {
  late MockUserManagementRepository mockUserManagementRepository;

  setUp(() {
    mockUserManagementRepository = MockUserManagementRepository();
  });

  group('UserManagementRepository', () {
    group('getUsers', () {
      test('returns list of users', () async {
        final expectedUsers = [
          User(
            id: '1',
            name: 'John Doe',
            email: 'john@example.com',
            role: 'admin',
            isActive: true,
            createdAt: DateTime(2024, 1, 1),
            lastLogin: DateTime(2024, 1, 15),
          ),
          User(
            id: '2',
            name: 'Jane Smith',
            email: 'jane@example.com',
            role: 'cashier',
            isActive: true,
            createdAt: DateTime(2024, 1, 2),
            lastLogin: DateTime(2024, 1, 14),
          ),
        ];

        when(mockUserManagementRepository.getUsers())
            .thenAnswer((_) async => expectedUsers);

        final result = await mockUserManagementRepository.getUsers();

        expect(result.length, 2);
        expect(result.first.name, 'John Doe');
        expect(result.first.role, 'admin');
        expect(result.last.name, 'Jane Smith');
        expect(result.last.role, 'cashier');
        verify(mockUserManagementRepository.getUsers()).called(1);
      });

      test('returns empty list when no users', () async {
        when(mockUserManagementRepository.getUsers())
            .thenAnswer((_) async => []);

        final result = await mockUserManagementRepository.getUsers();

        expect(result, isEmpty);
        verify(mockUserManagementRepository.getUsers()).called(1);
      });
    });

    group('getUser', () {
      test('returns specific user by ID', () async {
        final expectedUser = User(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          role: 'admin',
          isActive: true,
          createdAt: DateTime(2024, 1, 1),
          lastLogin: DateTime(2024, 1, 15),
        );

        when(mockUserManagementRepository.getUser('1'))
            .thenAnswer((_) async => expectedUser);

        final result = await mockUserManagementRepository.getUser('1');

        expect(result.name, 'John Doe');
        expect(result.email, 'john@example.com');
        expect(result.role, 'admin');
        verify(mockUserManagementRepository.getUser('1')).called(1);
      });
    });

    group('createUser', () {
      test('creates new user successfully', () async {
        final newUser = User(
          id: '',
          name: 'New User',
          email: 'newuser@example.com',
          role: 'cashier',
          isActive: true,
          createdAt: DateTime.now(),
          lastLogin: null,
        );

        final createdUser = User(
          id: '3',
          name: 'New User',
          email: 'newuser@example.com',
          role: 'cashier',
          isActive: true,
          createdAt: DateTime.now(),
          lastLogin: null,
        );

        when(mockUserManagementRepository.createUser(newUser))
            .thenAnswer((_) async => createdUser);

        final result = await mockUserManagementRepository.createUser(newUser);

        expect(result.id, '3');
        expect(result.name, 'New User');
        expect(result.email, 'newuser@example.com');
        verify(mockUserManagementRepository.createUser(newUser)).called(1);
      });
    });

    group('updateUser', () {
      test('updates existing user successfully', () async {
        final updatedUser = User(
          id: '1',
          name: 'John Doe Updated',
          email: 'john.updated@example.com',
          role: 'manager',
          isActive: true,
          createdAt: DateTime(2024, 1, 1),
          lastLogin: DateTime(2024, 1, 15),
        );

        when(mockUserManagementRepository.updateUser(updatedUser))
            .thenAnswer((_) async => updatedUser);

        final result = await mockUserManagementRepository.updateUser(updatedUser);

        expect(result.name, 'John Doe Updated');
        expect(result.email, 'john.updated@example.com');
        expect(result.role, 'manager');
        verify(mockUserManagementRepository.updateUser(updatedUser)).called(1);
      });
    });

    group('deleteUser', () {
      test('deletes user successfully', () async {
        when(mockUserManagementRepository.deleteUser('1'))
            .thenAnswer((_) async => true);

        final result = await mockUserManagementRepository.deleteUser('1');

        expect(result, isTrue);
        verify(mockUserManagementRepository.deleteUser('1')).called(1);
      });

      test('returns false when user not found', () async {
        when(mockUserManagementRepository.deleteUser('999'))
            .thenAnswer((_) async => false);

        final result = await mockUserManagementRepository.deleteUser('999');

        expect(result, isFalse);
        verify(mockUserManagementRepository.deleteUser('999')).called(1);
      });
    });

    group('updateUserRole', () {
      test('updates user role successfully', () async {
        final updatedUser = User(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          role: 'manager',
          isActive: true,
          createdAt: DateTime(2024, 1, 1),
          lastLogin: DateTime(2024, 1, 15),
        );

        when(mockUserManagementRepository.updateUserRole('1', 'manager'))
            .thenAnswer((_) async => updatedUser);

        final result = await mockUserManagementRepository.updateUserRole('1', 'manager');

        expect(result.role, 'manager');
        verify(mockUserManagementRepository.updateUserRole('1', 'manager')).called(1);
      });
    });

    group('toggleUserStatus', () {
      test('toggles user active status', () async {
        final deactivatedUser = User(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          role: 'admin',
          isActive: false,
          createdAt: DateTime(2024, 1, 1),
          lastLogin: DateTime(2024, 1, 15),
        );

        when(mockUserManagementRepository.toggleUserStatus('1'))
            .thenAnswer((_) async => deactivatedUser);

        final result = await mockUserManagementRepository.toggleUserStatus('1');

        expect(result.isActive, isFalse);
        verify(mockUserManagementRepository.toggleUserStatus('1')).called(1);
      });
    });

    group('getUserRoles', () {
      test('returns list of available roles', () async {
        final expectedRoles = ['admin', 'manager', 'cashier', 'viewer'];

        when(mockUserManagementRepository.getUserRoles())
            .thenAnswer((_) async => expectedRoles);

        final result = await mockUserManagementRepository.getUserRoles();

        expect(result.length, 4);
        expect(result, contains('admin'));
        expect(result, contains('manager'));
        expect(result, contains('cashier'));
        expect(result, contains('viewer'));
        verify(mockUserManagementRepository.getUserRoles()).called(1);
      });
    });

    group('getUserPermissions', () {
      test('returns user permissions', () async {
        final expectedPermissions = [
          'pos:read',
          'pos:write',
          'inventory:read',
          'reports:read',
        ];

        when(mockUserManagementRepository.getUserPermissions('1'))
            .thenAnswer((_) async => expectedPermissions);

        final result = await mockUserManagementRepository.getUserPermissions('1');

        expect(result.length, 4);
        expect(result, contains('pos:read'));
        expect(result, contains('pos:write'));
        expect(result, contains('inventory:read'));
        expect(result, contains('reports:read'));
        verify(mockUserManagementRepository.getUserPermissions('1')).called(1);
      });
    });
  });
} 