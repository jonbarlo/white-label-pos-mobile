import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/auth/data/repositories/auth_repository.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('AuthRepository', () {
    group('login', () {
      test('returns LoginResponse on success', () async {
        final mockUser = User(
          id: 1,
          businessId: 1,
          name: 'Test User',
          email: 'test@example.com',
          role: UserRole.cashier,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        const mockBusiness = Business(
          id: 1,
          name: 'Test Business',
          slug: 'test-business',
          taxRate: 0.08,
          currency: 'USD',
          timezone: 'UTC',
        );
        
        final mockLoginResponse = LoginResponse(
          user: mockUser,
          token: 'mock_token',
          business: mockBusiness,
        );

        when(mockAuthRepository.login('test@example.com', 'password', 'biz1'))
            .thenAnswer((_) async => Result.success(mockLoginResponse));

        final result = await mockAuthRepository.login('test@example.com', 'password', 'biz1');
        expect(result.isSuccess, true);
        expect(result.data.token, 'mock_token');
        expect(result.data.user.email, 'test@example.com');
        expect(result.data.business.slug, 'test-business');
      });

      test('returns failure on error', () async {
        when(mockAuthRepository.login('fail@example.com', 'wrong', 'biz1'))
            .thenAnswer((_) async => Result.failure('Login failed'));

        final result = await mockAuthRepository.login('fail@example.com', 'wrong', 'biz1');
        expect(result.isSuccess, false);
        expect(result.errorMessage, 'Login failed');
      });
    });

    group('logout', () {
      test('completes successfully', () async {
        when(mockAuthRepository.logout()).thenAnswer((_) async => Result.success(null));

        final result = await mockAuthRepository.logout();
        expect(result.isSuccess, true);
      });
    });

    group('getCurrentUser', () {
      test('returns user when authenticated', () async {
        final mockUser = User(
          id: 1,
          businessId: 1,
          name: 'Test User',
          email: 'test@example.com',
          role: UserRole.cashier,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => Result.success(mockUser));

        final result = await mockAuthRepository.getCurrentUser();
        expect(result.isSuccess, true);
        expect(result.data.email, 'test@example.com');
      });

      test('returns failure when not authenticated', () async {
        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => Result.failure('Not authenticated'));

        final result = await mockAuthRepository.getCurrentUser();
        expect(result.isSuccess, false);
        expect(result.errorMessage, 'Not authenticated');
      });
    });
  });
} 