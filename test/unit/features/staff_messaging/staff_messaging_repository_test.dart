import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/features/staff_messaging/staff_messaging_repository.dart';
import 'package:white_label_pos_mobile/src/features/staff_messaging/models/staff_message.dart';

import 'staff_messaging_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('StaffMessagingRepository', () {
    late MockDio mockDio;
    late StaffMessagingRepository repository;

    setUp(() {
      mockDio = MockDio();
      repository = StaffMessagingRepository(mockDio);
    });

    group('createStaffMessage', () {
      test('should create staff message successfully', () async {
        // Arrange
        final mockResponse = {
          'data': {
            'id': 1,
            'businessId': 1,
            'title': 'Test Message',
            'content': 'Test content',
            'messageType': 'announcement',
            'priority': 'normal',
            'status': 'active',
            'targetRoles': ['waiter', 'cashier'],
            'targetUserIds': null,
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': null,
            'expiresAt': null,
            'isRead': false,
            'isAcknowledged': false,
            'readAt': null,
            'acknowledgedAt': null,
            'readByUserId': null,
            'acknowledgedByUserId': null,
            'metadata': null,
          }
        };

        when(mockDio.post(
          '/api/staff-messages',
          data: {
            'title': 'Test Message',
            'content': 'Test content',
            'messageType': 'announcement',
            'priority': 'normal',
            'targetRoles': ['waiter', 'cashier'],
          },
        )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/api/staff-messages'),
        ));

        // Act
        final result = await repository.createStaffMessage(
          title: 'Test Message',
          content: 'Test content',
          messageType: 'announcement',
          priority: 'normal',
          targetRoles: ['waiter', 'cashier'],
        );

        // Assert
        expect(result, isA<StaffMessage>());
        expect(result.id, 1);
        expect(result.title, 'Test Message');
        expect(result.content, 'Test content');
        expect(result.messageType, 'announcement');
        expect(result.priority, 'normal');
        expect(result.targetRoles, ['waiter', 'cashier']);

        verify(mockDio.post(
          '/api/staff-messages',
          data: {
            'title': 'Test Message',
            'content': 'Test content',
            'messageType': 'announcement',
            'priority': 'normal',
            'targetRoles': ['waiter', 'cashier'],
          },
        )).called(1);
      });
    });

    group('getStaffMessages', () {
      test('should fetch staff messages successfully', () async {
        // Arrange
        final mockResponse = {
          'data': [
            {
              'id': 1,
              'businessId': 1,
              'title': 'Test Message 1',
              'content': 'Test content 1',
              'messageType': 'announcement',
              'priority': 'normal',
              'status': 'active',
              'targetRoles': ['waiter'],
              'targetUserIds': null,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': null,
              'expiresAt': null,
              'isRead': false,
              'isAcknowledged': false,
              'readAt': null,
              'acknowledgedAt': null,
              'readByUserId': null,
              'acknowledgedByUserId': null,
              'metadata': null,
            },
            {
              'id': 2,
              'businessId': 1,
              'title': 'Test Message 2',
              'content': 'Test content 2',
              'messageType': 'promotion',
              'priority': 'high',
              'status': 'active',
              'targetRoles': ['cashier'],
              'targetUserIds': null,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': null,
              'expiresAt': null,
              'isRead': false,
              'isAcknowledged': false,
              'readAt': null,
              'acknowledgedAt': null,
              'readByUserId': null,
              'acknowledgedByUserId': null,
              'metadata': null,
            },
          ]
        };

        when(mockDio.get(
          '/api/staff-messages',
          queryParameters: null,
        )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/staff-messages'),
        ));

        // Act
        final result = await repository.getStaffMessages();

        // Assert
        expect(result, isA<List<StaffMessage>>());
        expect(result.length, 2);
        expect(result[0].title, 'Test Message 1');
        expect(result[1].title, 'Test Message 2');

        verify(mockDio.get(
          '/api/staff-messages',
          queryParameters: null,
        )).called(1);
      });

      test('should fetch staff messages with filters', () async {
        // Arrange
        final mockResponse = {
          'data': [
            {
              'id': 1,
              'businessId': 1,
              'title': 'Test Message',
              'content': 'Test content',
              'messageType': 'announcement',
              'priority': 'normal',
              'status': 'active',
              'targetRoles': ['waiter'],
              'targetUserIds': null,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': null,
              'expiresAt': null,
              'isRead': false,
              'isAcknowledged': false,
              'readAt': null,
              'acknowledgedAt': null,
              'readByUserId': null,
              'acknowledgedByUserId': null,
              'metadata': null,
            },
          ]
        };

        when(mockDio.get(
          '/api/staff-messages',
          queryParameters: {
            'messageType': 'announcement',
            'status': 'active',
            'priority': 'normal',
          },
        )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/staff-messages'),
        ));

        // Act
        final result = await repository.getStaffMessages(
          messageType: 'announcement',
          status: 'active',
          priority: 'normal',
        );

        // Assert
        expect(result, isA<List<StaffMessage>>());
        expect(result.length, 1);
        expect(result[0].messageType, 'announcement');

        verify(mockDio.get(
          '/api/staff-messages',
          queryParameters: {
            'messageType': 'announcement',
            'status': 'active',
            'priority': 'normal',
          },
        )).called(1);
      });
    });

    group('getUserMessages', () {
      test('should fetch user messages successfully', () async {
        // Arrange
        final mockResponse = {
          'data': [
            {
              'id': 1,
              'businessId': 1,
              'title': 'User Message',
              'content': 'User content',
              'messageType': 'announcement',
              'priority': 'normal',
              'status': 'active',
              'targetRoles': ['waiter'],
              'targetUserIds': null,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': null,
              'expiresAt': null,
              'isRead': false,
              'isAcknowledged': false,
              'readAt': null,
              'acknowledgedAt': null,
              'readByUserId': null,
              'acknowledgedByUserId': null,
              'metadata': null,
            },
          ]
        };

        when(mockDio.get('/api/staff-messages/user/me'))
            .thenAnswer((_) async => Response(
                  data: mockResponse,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/staff-messages/user/me'),
                ));

        // Act
        final result = await repository.getUserMessages();

        // Assert
        expect(result, isA<List<StaffMessage>>());
        expect(result.length, 1);
        expect(result[0].title, 'User Message');

        verify(mockDio.get('/api/staff-messages/user/me')).called(1);
      });
    });

    group('getActiveMessages', () {
      test('should fetch active messages successfully', () async {
        // Arrange
        final mockResponse = {
          'data': [
            {
              'id': 1,
              'businessId': 1,
              'title': 'Active Message',
              'content': 'Active content',
              'messageType': 'promotion',
              'priority': 'high',
              'status': 'active',
              'targetRoles': ['waiter'],
              'targetUserIds': null,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': null,
              'expiresAt': null,
              'isRead': false,
              'isAcknowledged': false,
              'readAt': null,
              'acknowledgedAt': null,
              'readByUserId': null,
              'acknowledgedByUserId': null,
              'metadata': null,
            },
          ]
        };

        when(mockDio.get('/api/staff-messages/active'))
            .thenAnswer((_) async => Response(
                  data: mockResponse,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/staff-messages/active'),
                ));

        // Act
        final result = await repository.getActiveMessages();

        // Assert
        expect(result, isA<List<StaffMessage>>());
        expect(result.length, 1);
        expect(result[0].title, 'Active Message');
        expect(result[0].status, 'active');

        verify(mockDio.get('/api/staff-messages/active')).called(1);
      });
    });

    group('getUnreadMessageCount', () {
      test('should fetch unread message count successfully', () async {
        // Arrange
        final mockResponse = {'unreadCount': 5};

        when(mockDio.get('/api/staff-messages/user/me/unread-count'))
            .thenAnswer((_) async => Response(
                  data: mockResponse,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/staff-messages/user/me/unread-count'),
                ));

        // Act
        final result = await repository.getUnreadMessageCount();

        // Assert
        expect(result, 5);

        verify(mockDio.get('/api/staff-messages/user/me/unread-count')).called(1);
      });
    });

    group('markMessageAsRead', () {
      test('should mark message as read successfully', () async {
        // Arrange
        when(mockDio.post('/api/staff-messages/1/read'))
            .thenAnswer((_) async => Response(
                  data: {'success': true},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/staff-messages/1/read'),
                ));

        // Act
        await repository.markMessageAsRead(1);

        // Assert
        verify(mockDio.post('/api/staff-messages/1/read')).called(1);
      });
    });

    group('acknowledgeMessage', () {
      test('should acknowledge message successfully', () async {
        // Arrange
        when(mockDio.post('/api/staff-messages/1/acknowledge'))
            .thenAnswer((_) async => Response(
                  data: {'success': true},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/api/staff-messages/1/acknowledge'),
                ));

        // Act
        await repository.acknowledgeMessage(1);

        // Assert
        verify(mockDio.post('/api/staff-messages/1/acknowledge')).called(1);
      });
    });

    group('updateStaffMessage', () {
      test('should update staff message successfully', () async {
        // Arrange
        final mockResponse = {
          'data': {
            'id': 1,
            'businessId': 1,
            'title': 'Updated Message',
            'content': 'Updated content',
            'messageType': 'announcement',
            'priority': 'high',
            'status': 'active',
            'targetRoles': ['waiter'],
            'targetUserIds': null,
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-01-01T01:00:00Z',
            'expiresAt': null,
            'isRead': false,
            'isAcknowledged': false,
            'readAt': null,
            'acknowledgedAt': null,
            'readByUserId': null,
            'acknowledgedByUserId': null,
            'metadata': null,
          }
        };

        when(mockDio.put(
          '/api/staff-messages/1',
          data: {
            'title': 'Updated Message',
            'priority': 'high',
          },
        )).thenAnswer((_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/staff-messages/1'),
        ));

        // Act
        final result = await repository.updateStaffMessage(
          1,
          title: 'Updated Message',
          priority: 'high',
        );

        // Assert
        expect(result, isA<StaffMessage>());
        expect(result.title, 'Updated Message');
        expect(result.priority, 'high');

        verify(mockDio.put(
          '/api/staff-messages/1',
          data: {
            'title': 'Updated Message',
            'priority': 'high',
          },
        )).called(1);
      });
    });

    group('deleteStaffMessage', () {
      test('should delete staff message successfully', () async {
        // Arrange
        when(mockDio.delete('/api/staff-messages/1'))
            .thenAnswer((_) async => Response(
                  data: null,
                  statusCode: 204,
                  requestOptions: RequestOptions(path: '/api/staff-messages/1'),
                ));

        // Act
        await repository.deleteStaffMessage(1);

        // Assert
        verify(mockDio.delete('/api/staff-messages/1')).called(1);
      });
    });
  });
} 