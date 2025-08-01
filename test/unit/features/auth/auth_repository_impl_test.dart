import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('AuthRepositoryImpl', () {
    late MockDio mockDio;
    late AuthRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      repository = AuthRepositoryImpl(mockDio);
    });

    group('login', () {
      test('should return success result when login is successful', () async {
        // Arrange
        final user = User(
          id: 1,
          businessId: 1,
          name: 'Test User',
          email: 'test@example.com',
          role: UserRole.cashier,
          isActive: true,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final business = Business(
          id: 1,
          name: 'Test Business',
          slug: 'test-business',
          type: BusinessType.restaurant,
          taxRate: 8.5,
          currencyId: 2,
          timezone: 'America/New_York',
          isActive: true,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final responseData = {
          'message': 'Login successful',
          'user': {
            'id': user.id,
            'businessId': user.businessId,
            'name': user.name,
            'email': user.email,
            'role': 'cashier',
            'isActive': user.isActive,
            'createdAt': user.createdAt.toIso8601String(),
            'updatedAt': user.updatedAt.toIso8601String(),
          },
          'token': 'valid-token-123',
          'business': {
            'id': business.id,
            'name': business.name,
            'slug': business.slug,
            'type': 'restaurant',
            'taxRate': business.taxRate,
            'currencyId': business.currencyId,
            'timezone': business.timezone,
            'isActive': business.isActive,
            'createdAt': business.createdAt?.toIso8601String(),
            'updatedAt': business.updatedAt?.toIso8601String(),
          },
        };

        when(mockDio.post('/auth/login', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/auth/login'),
                ));

        // Act
        final result = await repository.login('test@example.com', 'password', 'test-business');

        // Assert
        expect(result.isSuccess, true);
        expect(result.data.user.id, user.id);
        expect(result.data.user.email, user.email);
        expect(result.data.user.role, user.role);
        expect(result.data.token, 'valid-token-123');
        expect(result.data.business.id, business.id);
        expect(result.data.business.name, business.name);
      });

      test('should return failure result when login fails', () async {
        // Arrange
        final responseData = {
          'success': false,
          'message': 'Invalid credentials',
        };

        when(mockDio.post('/auth/login', data: anyNamed('data')))
            .thenAnswer((_) async => Response(
                  data: responseData,
                  statusCode: 401,
                  requestOptions: RequestOptions(path: '/auth/login'),
                ));

        // Act
        final result = await repository.login('test@example.com', 'wrongpassword', 'test-business');

        // Assert
        expect(result.isFailure, true);
        expect(result.errorMessage, 'Invalid credentials');
      });

      test('should return failure result when network error occurs', () async {
        // Arrange
        when(mockDio.post('/auth/login', data: anyNamed('data')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/auth/login'),
              type: DioExceptionType.connectionError,
            ));

        // Act
        final result = await repository.login('test@example.com', 'password', 'test-business');

        // Assert
        expect(result.isFailure, true);
        expect(result.errorMessage, contains('internet connection'));
      });
    });

    group('logout', () {
      test('should return success result when logout is successful', () async {
        // Arrange
        when(mockDio.post('/auth/logout'))
            .thenAnswer((_) async => Response(
                  data: {'success': true},
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '/auth/logout'),
                ));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isSuccess, true);
      });

      test('should return failure result when logout fails', () async {
        // Arrange
        when(mockDio.post('/auth/logout'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/auth/logout'),
              type: DioExceptionType.badResponse,
              response: Response(
                statusCode: 500,
                requestOptions: RequestOptions(path: '/auth/logout'),
              ),
            ));

        // Act
        final result = await repository.logout();

        // Assert
        expect(result.isFailure, true);
        expect(result.errorMessage, contains('Server error'));
      });
    });
  });
} 