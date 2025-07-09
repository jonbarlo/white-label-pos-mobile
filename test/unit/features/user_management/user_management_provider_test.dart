import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/user_management/user_management_provider.dart';
import 'package:white_label_pos_mobile/src/features/user_management/user_management_repository.dart';
import 'package:white_label_pos_mobile/src/features/user_management/models/user.dart';

import 'user_management_provider_test.mocks.dart';

@GenerateMocks([UserManagementRepository])
void main() {
  late MockUserManagementRepository mockUserManagementRepository;
  late ProviderContainer container;

  setUp(() {
    mockUserManagementRepository = MockUserManagementRepository();
    container = ProviderContainer(
      overrides: [
        userManagementRepositoryProvider.overrideWithValue(mockUserManagementRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('UserManagementProvider', () {
    group('usersProvider', () {
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

        final result = await container.read(usersProvider.future);

        expect(result.length, 2);
        expect(result.first.name, 'John Doe');
        expect(result.first.role, 'admin');
        expect(result.last.name, 'Jane Smith');
        expect(result.last.role, 'cashier');
        verify(mockUserManagementRepository.getUsers()).called(1);
      });

      test('handles error when repository fails', () async {
        when(mockUserManagementRepository.getUsers())
            .thenThrow(Exception('Network error'));

        expect(
          () => container.read(usersProvider.future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('userProvider', () {
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

        final result = await container.read(userProvider('1').future);

        expect(result.name, 'John Doe');
        expect(result.email, 'john@example.com');
        expect(result.role, 'admin');
        verify(mockUserManagementRepository.getUser('1')).called(1);
      });
    });

    group('userRolesProvider', () {
      test('returns list of available roles', () async {
        final expectedRoles = ['admin', 'manager', 'cashier', 'viewer'];

        when(mockUserManagementRepository.getUserRoles())
            .thenAnswer((_) async => expectedRoles);

        final result = await container.read(userRolesProvider.future);

        expect(result.length, 4);
        expect(result, contains('admin'));
        expect(result, contains('manager'));
        expect(result, contains('cashier'));
        expect(result, contains('viewer'));
        verify(mockUserManagementRepository.getUserRoles()).called(1);
      });
    });

    group('userPermissionsProvider', () {
      test('returns user permissions', () async {
        final expectedPermissions = [
          'pos:read',
          'pos:write',
          'inventory:read',
          'reports:read',
        ];

        when(mockUserManagementRepository.getUserPermissions('1'))
            .thenAnswer((_) async => expectedPermissions);

        final result = await container.read(userPermissionsProvider('1').future);

        expect(result.length, 4);
        expect(result, contains('pos:read'));
        expect(result, contains('pos:write'));
        expect(result, contains('inventory:read'));
        expect(result, contains('reports:read'));
        verify(mockUserManagementRepository.getUserPermissions('1')).called(1);
      });
    });

    group('searchUsersProvider', () {
      test('returns search results', () async {
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
        ];

        when(mockUserManagementRepository.searchUsers('john'))
            .thenAnswer((_) async => expectedUsers);

        final result = await container.read(searchUsersProvider('john').future);

        expect(result.length, 1);
        expect(result.first.name, 'John Doe');
        verify(mockUserManagementRepository.searchUsers('john')).called(1);
      });
    });

    group('usersByRoleProvider', () {
      test('returns users filtered by role', () async {
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
        ];

        when(mockUserManagementRepository.getUsersByRole('admin'))
            .thenAnswer((_) async => expectedUsers);

        final result = await container.read(usersByRoleProvider('admin').future);

        expect(result.length, 1);
        expect(result.first.role, 'admin');
        verify(mockUserManagementRepository.getUsersByRole('admin')).called(1);
      });
    });

    group('activeUsersCountProvider', () {
      test('returns active users count', () async {
        when(mockUserManagementRepository.getActiveUsersCount())
            .thenAnswer((_) async => 5);

        final result = await container.read(activeUsersCountProvider.future);

        expect(result, equals(5));
        verify(mockUserManagementRepository.getActiveUsersCount()).called(1);
      });
    });
  });
} 