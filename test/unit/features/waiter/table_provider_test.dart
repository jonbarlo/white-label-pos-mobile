import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';

@GenerateMocks([TableRepository, Dio])
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/waiter/table_provider.dart';
import 'package:white_label_pos_mobile/src/features/waiter/table_repository.dart';
import 'package:white_label_pos_mobile/src/features/waiter/models/table.dart' as waiter_table;
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';

import 'table_provider_test.mocks.dart';

class FakeAuthNotifier extends AuthNotifier {
  final AuthState _state;
  FakeAuthNotifier(this._state);
  @override
  AuthState build() => _state;
}

void main() {
  group('TableProvider', () {
    late MockTableRepository mockRepository;
    late MockDio mockDio;
    late ProviderContainer container;

    final mockUser = User(
      id: 1,
      businessId: 1,
      name: 'John Doe',
      email: 'john@example.com',
      role: UserRole.waitstaff,
      isActive: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
      assignment: null,
    );

    final mockTables = [
      const waiter_table.Table(
        id: 1,
        businessId: 1,
        name: 'A1',
        status: waiter_table.TableStatus.available,
        capacity: 4,
        partySize: null,
        currentOrderId: null,
        currentOrderNumber: null,
        currentOrderTotal: null,
        currentOrderItemCount: null,
        customerName: null,
        notes: null,
        lastActivity: null,
        reservationTime: null,
        assignedWaiter: null,
        assignedWaiterId: null,
        metadata: null,
      ),
      waiter_table.Table(
        id: 2,
        businessId: 1,
        name: 'A2',
        status: waiter_table.TableStatus.occupied,
        capacity: 6,
        partySize: 3,
        currentOrderId: 1,
        currentOrderNumber: '001',
        currentOrderTotal: 45.50,
        currentOrderItemCount: 3,
        customerName: 'Jane Doe',
        notes: 'Window seat preferred',
        lastActivity: DateTime.parse('2024-01-15T14:30:00Z'),
        reservationTime: null,
        assignedWaiter: 'John Smith',
        assignedWaiterId: 1,
        metadata: {'section': 'main'},
      ),
    ];

    setUp(() {
      mockRepository = MockTableRepository();
      mockDio = MockDio();

      container = ProviderContainer(
        overrides: [
          tableRepositoryProvider.overrideWithValue(mockRepository),
          dioClientProvider.overrideWithValue(mockDio),
          authNotifierProvider.overrideWith(() => FakeAuthNotifier(
            AuthState(
              status: AuthStatus.authenticated,
              user: mockUser,
            ),
          )),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('tablesProvider', () {
      test('should return list of tables when successful', () async {
        // Arrange
        when(mockRepository.getTables()).thenAnswer((_) async => mockTables);

        // Act
        final result = await container.read(tablesProvider.future);

        // Assert
        expect(result, equals(mockTables));
        expect(result.length, 2);
        expect(result[0].name, 'A1');
        expect(result[1].name, 'A2');
        verify(mockRepository.getTables()).called(1);
      });

      test('should throw exception when user is not authenticated', () async {
        // Arrange
        final unauthContainer = ProviderContainer(
          overrides: [
            tableRepositoryProvider.overrideWithValue(mockRepository),
            dioClientProvider.overrideWithValue(mockDio),
            authNotifierProvider.overrideWith(() => FakeAuthNotifier(
              const AuthState(
                status: AuthStatus.unauthenticated,
                user: null,
              ),
            )),
          ],
        );

        // Act & Assert
        expect(
          () => unauthContainer.read(tablesProvider.future),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockRepository.getTables());
        unauthContainer.dispose();
      });

      test('should throw exception when repository fails', () async {
        // Arrange
        when(mockRepository.getTables()).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => container.read(tablesProvider.future),
          throwsA(isA<Exception>()),
        );
        verify(mockRepository.getTables()).called(1);
      });
    });

    group('tablesByStatusProvider', () {
      test('should return tables filtered by status', () async {
        // Arrange
        final availableTables = mockTables.where((t) => t.status == waiter_table.TableStatus.available).toList();
        when(mockRepository.getTablesByStatus(waiter_table.TableStatus.available))
            .thenAnswer((_) async => availableTables);

        // Act
        final result = await container.read(
          tablesByStatusProvider(waiter_table.TableStatus.available).future,
        );

        // Assert
        expect(result, equals(availableTables));
        expect(result.length, 1);
        expect(result[0].status, waiter_table.TableStatus.available);
        verify(mockRepository.getTablesByStatus(waiter_table.TableStatus.available)).called(1);
      });
    });

    group('myAssignedTablesProvider', () {
      test('should return tables assigned to current waiter', () async {
        // Arrange
        final assignedTables = mockTables.where((t) => t.assignedWaiterId == mockUser.id).toList();
        when(mockRepository.getMyAssignedTables(mockUser.id))
            .thenAnswer((_) async => assignedTables);

        // Act
        final result = await container.read(myAssignedTablesProvider.future);

        // Assert
        expect(result, equals(assignedTables));
        verify(mockRepository.getMyAssignedTables(mockUser.id)).called(1);
      });
    });

    group('tableProvider', () {
      test('should return specific table', () async {
        // Arrange
        final table = mockTables[0];
        when(mockRepository.getTable(1)).thenAnswer((_) async => table);

        // Act
        final result = await container.read(tableProvider(1).future);

        // Assert
        expect(result, equals(table));
        expect(result.id, 1);
        expect(result.name, 'A1');
        verify(mockRepository.getTable(1)).called(1);
      });
    });

    group('updateTableStatusProvider', () {
      test('should update table status successfully', () async {
        // Arrange
        final updatedTable = mockTables[0].copyWith(
          status: waiter_table.TableStatus.occupied,
          currentOrderId: 2,
        );
        when(mockRepository.updateTableStatus(1, waiter_table.TableStatus.occupied))
            .thenAnswer((_) async => updatedTable);

        // Act
        final result = await container.read(
          updateTableStatusProvider((tableId: 1, status: waiter_table.TableStatus.occupied)).future,
        );

        // Assert
        expect(result, equals(updatedTable));
        expect(result.status, waiter_table.TableStatus.occupied);
        expect(result.currentOrderId, 2);
        verify(mockRepository.updateTableStatus(1, waiter_table.TableStatus.occupied)).called(1);
      });
    });

    group('assignTableProvider', () {
      test('should assign table to waiter successfully', () async {
        // Arrange
        final assignedTable = mockTables[0].copyWith(
          assignedWaiter: 'John Doe',
          assignedWaiterId: 2,
        );
        when(mockRepository.assignTable(1, 2))
            .thenAnswer((_) async => assignedTable);

        // Act
        final result = await container.read(
          assignTableProvider((tableId: 1, waiterId: 2)).future,
        );

        // Assert
        expect(result, equals(assignedTable));
        expect(result.assignedWaiter, 'John Doe');
        expect(result.assignedWaiterId, 2);
        verify(mockRepository.assignTable(1, 2)).called(1);
      });
    });

    group('clearTableProvider', () {
      test('should clear table successfully', () async {
        // Arrange
        when(mockRepository.clearTable(1)).thenAnswer((_) async {});

        // Act
        await container.read(clearTableProvider(1).future);

        // Assert
        verify(mockRepository.clearTable(1)).called(1);
      });
    });

    group('seatCustomerProvider', () {
      test('should call seatCustomer on repository with correct arguments', () async {
        // Arrange
        when(mockRepository.seatCustomer(1, 'Alice', 2, 'Birthday')).thenAnswer((_) async {});

        // Act
        await container.read(seatCustomerProvider((1, 'Alice', 2, 'Birthday')).future);

        // Assert
        verify(mockRepository.seatCustomer(1, 'Alice', 2, 'Birthday')).called(1);
      });
    });

    group('computed providers', () {
      test('availableTablesProvider should return available tables', () async {
        // Arrange
        when(mockRepository.getTablesByStatus(waiter_table.TableStatus.available))
            .thenAnswer((_) async => mockTables.where((t) => t.status == waiter_table.TableStatus.available).toList());

        // Act - First await the underlying FutureProvider to populate the computed provider
        await container.read(tablesByStatusProvider(waiter_table.TableStatus.available).future);
        
        // Then read the computed provider
        final asyncValue = container.read(availableTablesProvider);
        final result = asyncValue.when(data: (data) => data, loading: () => [], error: (_, __) => []);

        // Assert
        expect(result.length, 1);
        expect(result[0].status, waiter_table.TableStatus.available);
        verify(mockRepository.getTablesByStatus(waiter_table.TableStatus.available)).called(1);
      });

      test('occupiedTablesProvider should return occupied tables', () async {
        // Arrange
        when(mockRepository.getTablesByStatus(waiter_table.TableStatus.occupied))
            .thenAnswer((_) async => mockTables.where((t) => t.status == waiter_table.TableStatus.occupied).toList());

        // Act - First await the underlying FutureProvider to populate the computed provider
        await container.read(tablesByStatusProvider(waiter_table.TableStatus.occupied).future);
        
        // Then read the computed provider
        final asyncValue = container.read(occupiedTablesProvider);
        final result = asyncValue.when(data: (data) => data, loading: () => [], error: (_, __) => []);

        // Assert
        expect(result.length, 1);
        expect(result[0].status, waiter_table.TableStatus.occupied);
        verify(mockRepository.getTablesByStatus(waiter_table.TableStatus.occupied)).called(1);
      });

      test('tableStatsProvider should return correct statistics', () async {
        // Arrange
        when(mockRepository.getTables()).thenAnswer((_) async => mockTables);

        // Act - First await the underlying FutureProvider to populate the computed provider
        await container.read(tablesProvider.future);
        
        // Then read the computed provider
        final asyncValue = container.read(tableStatsProvider);
        final result = asyncValue.when(data: (data) => data, loading: () => {}, error: (_, __) => {});

        // Assert
        expect(result, isA<Map<String, int>>());
        expect(result['available'] ?? 0, 1);
        expect(result['occupied'] ?? 0, 1);
        expect(result['reserved'] ?? 0, 0);
        expect(result['cleaning'] ?? 0, 0);
        expect(result['out_of_service'] ?? 0, 0);
        verify(mockRepository.getTables()).called(1);
      });
    });
  });
} 