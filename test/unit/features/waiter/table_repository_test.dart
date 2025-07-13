import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/features/waiter/table_repository.dart';
import 'package:white_label_pos_mobile/src/features/waiter/models/table.dart' as waiter_table;

import 'table_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('TableRepository', () {
    late MockDio mockDio;
    late TableRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = TableRepository(mockDio);
    });

    group('getTables', () {
      test('should return list of tables when API call is successful', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'data': [
              {
                'id': 1,
                'businessId': 1,
                'tableNumber': 'A1',
                'status': 'available',
                'capacity': 4,
                'currentOrderId': null,
                'currentOrderNumber': null,
                'currentOrderTotal': null,
                'currentOrderItemCount': null,
                'customerName': null,
                'notes': null,
                'lastActivity': null,
                'reservationTime': null,
                'assignedWaiter': null,
                'assignedWaiterId': null,
                'metadata': null,
              },
              {
                'id': 2,
                'businessId': 1,
                'tableNumber': 'A2',
                'status': 'occupied',
                'capacity': 6,
                'currentOrderId': 'ORD-001',
                'currentOrderNumber': '001',
                'currentOrderTotal': 45.50,
                'currentOrderItemCount': 3,
                'customerName': 'John Doe',
                'notes': 'Window seat preferred',
                'lastActivity': '2024-01-15T14:30:00Z',
                'reservationTime': null,
                'assignedWaiter': 'Jane Smith',
                'assignedWaiterId': 1,
                'metadata': {'section': 'main'},
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/tables'),
        );

        when(mockDio.get('/api/tables')).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getTables();

        // Assert
        expect(result, isA<List<waiter_table.Table>>());
        expect(result.length, 2);
        
        final firstTable = result[0];
        expect(firstTable.id, 1);
        expect(firstTable.tableNumber, 'A1');
        expect(firstTable.status, waiter_table.TableStatus.available);
        expect(firstTable.capacity, 4);
        expect(firstTable.currentOrderId, isNull);
        
        final secondTable = result[1];
        expect(secondTable.id, 2);
        expect(secondTable.tableNumber, 'A2');
        expect(secondTable.status, waiter_table.TableStatus.occupied);
        expect(secondTable.capacity, 6);
        expect(secondTable.currentOrderId, 'ORD-001');
        expect(secondTable.currentOrderNumber, '001');
        expect(secondTable.currentOrderTotal, 45.50);
        expect(secondTable.customerName, 'John Doe');
        expect(secondTable.assignedWaiter, 'Jane Smith');
        expect(secondTable.assignedWaiterId, 1);

        verify(mockDio.get('/api/tables')).called(1);
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockDio.get('/api/tables')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/tables'),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/api/tables'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getTables(),
          throwsA(isA<DioException>()),
        );

        verify(mockDio.get('/api/tables')).called(1);
      });
    });

    group('getTable', () {
      test('should return single table when API call is successful', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'data': {
              'id': 1,
              'businessId': 1,
              'tableNumber': 'A1',
              'status': 'available',
              'capacity': 4,
              'currentOrderId': null,
              'currentOrderNumber': null,
              'currentOrderTotal': null,
              'currentOrderItemCount': null,
              'customerName': null,
              'notes': null,
              'lastActivity': null,
              'reservationTime': null,
              'assignedWaiter': null,
              'assignedWaiterId': null,
              'metadata': null,
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/tables/1'),
        );

        when(mockDio.get('/api/tables/1')).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getTable(1);

        // Assert
        expect(result, isA<waiter_table.Table>());
        expect(result.id, 1);
        expect(result.tableNumber, 'A1');
        expect(result.status, waiter_table.TableStatus.available);
        expect(result.capacity, 4);

        verify(mockDio.get('/api/tables/1')).called(1);
      });
    });

    group('updateTableStatus', () {
      test('should update table status successfully', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'data': {
              'id': 1,
              'businessId': 1,
              'tableNumber': 'A1',
              'status': 'occupied',
              'capacity': 4,
              'currentOrderId': 'ORD-001',
              'currentOrderNumber': '001',
              'currentOrderTotal': 25.00,
              'currentOrderItemCount': 2,
              'customerName': 'Jane Doe',
              'notes': null,
              'lastActivity': '2024-01-15T15:00:00Z',
              'reservationTime': null,
              'assignedWaiter': 'John Smith',
              'assignedWaiterId': 2,
              'metadata': null,
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/tables/1/status'),
        );

        when(mockDio.put(
          '/api/tables/1/status',
          data: {'status': 'occupied'},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.updateTableStatus(1, waiter_table.TableStatus.occupied);

        // Assert
        expect(result, isA<waiter_table.Table>());
        expect(result.id, 1);
        expect(result.status, waiter_table.TableStatus.occupied);
        expect(result.currentOrderId, 'ORD-001');
        expect(result.customerName, 'Jane Doe');

        verify(mockDio.put(
          '/api/tables/1/status',
          data: {'status': 'occupied'},
        )).called(1);
      });
    });

    group('assignTable', () {
      test('should assign table to waiter successfully', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'data': {
              'id': 1,
              'businessId': 1,
              'tableNumber': 'A1',
              'status': 'available',
              'capacity': 4,
              'currentOrderId': null,
              'currentOrderNumber': null,
              'currentOrderTotal': null,
              'currentOrderItemCount': null,
              'customerName': null,
              'notes': null,
              'lastActivity': null,
              'reservationTime': null,
              'assignedWaiter': 'John Smith',
              'assignedWaiterId': 2,
              'metadata': null,
            },
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/tables/1/assign'),
        );

        when(mockDio.put(
          '/api/tables/1/assign',
          data: {'waiterId': 2},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.assignTable(1, 2);

        // Assert
        expect(result, isA<waiter_table.Table>());
        expect(result.id, 1);
        expect(result.assignedWaiter, 'John Smith');
        expect(result.assignedWaiterId, 2);

        verify(mockDio.put(
          '/api/tables/1/assign',
          data: {'waiterId': 2},
        )).called(1);
      });
    });

    group('clearTable', () {
      test('should clear table successfully', () async {
        // Arrange
        when(mockDio.post('/api/tables/1/clear')).thenAnswer((_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/tables/1/clear'),
        ));

        // Act
        await repository.clearTable(1);

        // Assert
        verify(mockDio.post('/api/tables/1/clear')).called(1);
      });
    });

    group('getTablesByStatus', () {
      test('should return tables filtered by status', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'data': [
              {
                'id': 1,
                'businessId': 1,
                'tableNumber': 'A1',
                'status': 'available',
                'capacity': 4,
                'currentOrderId': null,
                'currentOrderNumber': null,
                'currentOrderTotal': null,
                'currentOrderItemCount': null,
                'customerName': null,
                'notes': null,
                'lastActivity': null,
                'reservationTime': null,
                'assignedWaiter': null,
                'assignedWaiterId': null,
                'metadata': null,
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/tables'),
        );

        when(mockDio.get(
          '/api/tables',
          queryParameters: {'status': 'available'},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getTablesByStatus(waiter_table.TableStatus.available);

        // Assert
        expect(result, isA<List<waiter_table.Table>>());
        expect(result.length, 1);
        expect(result.first.status, waiter_table.TableStatus.available);

        verify(mockDio.get(
          '/api/tables',
          queryParameters: {'status': 'available'},
        )).called(1);
      });
    });

    group('getMyAssignedTables', () {
      test('should return tables assigned to specific waiter', () async {
        // Arrange
        final mockResponse = Response(
          data: {
            'data': [
              {
                'id': 1,
                'businessId': 1,
                'tableNumber': 'A1',
                'status': 'occupied',
                'capacity': 4,
                'currentOrderId': 'ORD-001',
                'currentOrderNumber': '001',
                'currentOrderTotal': 35.00,
                'currentOrderItemCount': 2,
                'customerName': 'Jane Doe',
                'notes': null,
                'lastActivity': '2024-01-15T15:00:00Z',
                'reservationTime': null,
                'assignedWaiter': 'John Smith',
                'assignedWaiterId': 2,
                'metadata': null,
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/tables'),
        );

        when(mockDio.get(
          '/api/tables',
          queryParameters: {'assignedWaiterId': 2},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getMyAssignedTables(2);

        // Assert
        expect(result, isA<List<waiter_table.Table>>());
        expect(result.length, 1);
        expect(result.first.assignedWaiterId, 2);
        expect(result.first.assignedWaiter, 'John Smith');

        verify(mockDio.get(
          '/api/tables',
          queryParameters: {'assignedWaiterId': 2},
        )).called(1);
      });
    });
  });
} 