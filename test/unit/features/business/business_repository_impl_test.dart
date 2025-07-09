import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/features/business/business_repository_impl.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';

import 'business_repository_impl_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('BusinessRepositoryImpl', () {
    late MockDio mockDio;
    late BusinessRepositoryImpl repository;

    setUp(() {
      mockDio = MockDio();
      repository = BusinessRepositoryImpl(mockDio);
    });

    group('getBusinesses', () {
      test('should return list of businesses', () async {
        // Arrange
        final responseData = [
          {
            'id': 1,
            'name': 'Test Business 1',
            'slug': 'test-business-1',
            'type': 'restaurant',
            'taxRate': 8.5,
            'currency': 'USD',
            'timezone': 'America/New_York',
            'isActive': true,
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-01-01T00:00:00Z',
          },
          {
            'id': 2,
            'name': 'Test Business 2',
            'slug': 'test-business-2',
            'type': 'retail',
            'taxRate': 7.0,
            'currency': 'EUR',
            'timezone': 'Europe/London',
            'isActive': true,
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-01-01T00:00:00Z',
          },
        ];

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/businesses'),
        );

        when(mockDio.get('/businesses')).thenAnswer((_) async => response);

        // Act
        final result = await repository.getBusinesses();

        // Assert
        expect(result, hasLength(2));
        expect(result[0].name, equals('Test Business 1'));
        expect(result[0].type, equals(BusinessType.restaurant));
        expect(result[1].name, equals('Test Business 2'));
        expect(result[1].type, equals(BusinessType.retail));
        verify(mockDio.get('/businesses')).called(1);
      });

      test('should handle paginated response', () async {
        // Arrange
        final responseData = {
          'data': [
            {
              'id': 1,
              'name': 'Test Business',
              'slug': 'test-business',
              'type': 'restaurant',
              'taxRate': 8.5,
              'currency': 'USD',
              'timezone': 'America/New_York',
              'isActive': true,
              'createdAt': '2024-01-01T00:00:00Z',
              'updatedAt': '2024-01-01T00:00:00Z',
            },
          ],
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/businesses'),
        );

        when(mockDio.get('/businesses')).thenAnswer((_) async => response);

        // Act
        final result = await repository.getBusinesses();

        // Assert
        expect(result, hasLength(1));
        expect(result[0].name, equals('Test Business'));
        verify(mockDio.get('/businesses')).called(1);
      });

      test('should throw exception on error', () async {
        // Arrange
        when(mockDio.get('/businesses')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/businesses'),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/businesses'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getBusinesses(),
          throwsA(isA<Exception>()),
        );
        verify(mockDio.get('/businesses')).called(1);
      });
    });

    group('getBusiness', () {
      test('should return business by id', () async {
        // Arrange
        const businessId = 1;
        final responseData = {
          'id': businessId,
          'name': 'Test Business',
          'slug': 'test-business',
          'type': 'restaurant',
          'taxRate': 8.5,
          'currency': 'USD',
          'timezone': 'America/New_York',
          'isActive': true,
          'createdAt': '2024-01-01T00:00:00Z',
          'updatedAt': '2024-01-01T00:00:00Z',
        };

        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/businesses/$businessId'),
        );

        when(mockDio.get('/businesses/$businessId')).thenAnswer((_) async => response);

        // Act
        final result = await repository.getBusiness(businessId);

        // Assert
        expect(result, isNotNull);
        expect(result!.name, equals('Test Business'));
        expect(result.type, equals(BusinessType.restaurant));
        verify(mockDio.get('/businesses/$businessId')).called(1);
      });

      test('should return null for non-existent business', () async {
        // Arrange
        const businessId = 999;
        when(mockDio.get('/businesses/$businessId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/businesses/$businessId'),
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/businesses/$businessId'),
            ),
          ),
        );

        // Act
        final result = await repository.getBusiness(businessId);

        // Assert
        expect(result, isNull);
        verify(mockDio.get('/businesses/$businessId')).called(1);
      });

      test('should throw exception on other errors', () async {
        // Arrange
        const businessId = 1;
        when(mockDio.get('/businesses/$businessId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/businesses/$businessId'),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/businesses/$businessId'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getBusiness(businessId),
          throwsA(isA<Exception>()),
        );
        verify(mockDio.get('/businesses/$businessId')).called(1);
      });
    });

    group('createBusiness', () {
      test('should create business successfully', () async {
        // Arrange
        final business = Business(
          id: 0,
          name: 'New Business',
          slug: 'new-business',
          type: BusinessType.service,
          taxRate: 9.0,
          currency: 'USD',
          timezone: 'America/New_York',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final responseData = business.copyWith(id: 1).toJson();
        final response = Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/businesses'),
        );

        when(mockDio.post('/businesses', data: business.toJson())).thenAnswer((_) async => response);

        // Act
        final result = await repository.createBusiness(business);

        // Assert
        expect(result.id, equals(1));
        expect(result.name, equals('New Business'));
        verify(mockDio.post('/businesses', data: business.toJson())).called(1);
      });

      test('should throw exception on error', () async {
        // Arrange
        final business = Business(
          id: 0,
          name: 'New Business',
          slug: 'new-business',
          type: BusinessType.service,
          taxRate: 9.0,
          currency: 'USD',
          timezone: 'America/New_York',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(mockDio.post('/businesses', data: business.toJson())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/businesses'),
            response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: '/businesses'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.createBusiness(business),
          throwsA(isA<Exception>()),
        );
        verify(mockDio.post('/businesses', data: business.toJson())).called(1);
      });
    });

    group('updateBusiness', () {
      test('should update business successfully', () async {
        // Arrange
        final business = Business(
          id: 1,
          name: 'Updated Business',
          slug: 'updated-business',
          type: BusinessType.restaurant,
          taxRate: 8.5,
          currency: 'USD',
          timezone: 'America/New_York',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final response = Response(
          data: business.toJson(),
          statusCode: 200,
          requestOptions: RequestOptions(path: '/businesses/${business.id}'),
        );

        when(mockDio.put('/businesses/${business.id}', data: business.toJson())).thenAnswer((_) async => response);

        // Act
        final result = await repository.updateBusiness(business);

        // Assert
        expect(result.id, equals(1));
        expect(result.name, equals('Updated Business'));
        verify(mockDio.put('/businesses/${business.id}', data: business.toJson())).called(1);
      });
    });

    group('deleteBusiness', () {
      test('should delete business successfully', () async {
        // Arrange
        const businessId = 1;
        final response = Response(
          statusCode: 204,
          requestOptions: RequestOptions(path: '/businesses/$businessId'),
        );

        when(mockDio.delete('/businesses/$businessId')).thenAnswer((_) async => response);

        // Act
        await repository.deleteBusiness(businessId);

        // Assert
        verify(mockDio.delete('/businesses/$businessId')).called(1);
      });

      test('should throw exception on error', () async {
        // Arrange
        const businessId = 1;
        when(mockDio.delete('/businesses/$businessId')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/businesses/$businessId'),
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/businesses/$businessId'),
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.deleteBusiness(businessId),
          throwsA(isA<Exception>()),
        );
        verify(mockDio.delete('/businesses/$businessId')).called(1);
      });
    });
  });
} 