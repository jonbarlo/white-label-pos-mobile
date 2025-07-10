import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/data/repositories/auth_repository.dart';
import 'package:white_label_pos_mobile/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('AuthProvider - NO CACHE FALLBACK TESTS', () {
    late ProviderContainer container;
    late MockAuthRepository mockAuthRepository;

    setUp(() async {
      mockAuthRepository = MockAuthRepository();

      // Override the auth repository provider with our mock
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => mockAuthRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('🔴 PROOF: Login fails when API is unreachable - NO CACHE FALLBACK', () async {
      // Arrange: Mock API failure (network error)
      when(mockAuthRepository.login(any, any))
          .thenAnswer((_) async => Result<LoginResponse>.failure(
                'No internet connection. Please check your network settings.',
                Exception('Network error'),
              ));

      // Act: Attempt to login
      final authNotifier = container.read(authNotifierProvider.notifier);
      await authNotifier.login(
        email: 'test@example.com',
        password: 'password',
        businessSlug: 'test-business',
      );

      // Assert: Verify the auth state is ERROR, not authenticated
      final authState = container.read(authNotifierProvider);
      
      expect(authState.status, equals(AuthStatus.error), 
          reason: '🔴 FAILED: Auth state should be ERROR when API is unreachable');
      expect(authState.user, isNull, 
          reason: '🔴 FAILED: User should be NULL when API is unreachable');
      expect(authState.token, isNull, 
          reason: '🔴 FAILED: Token should be NULL when API is unreachable');
      expect(authState.errorMessage, contains('No internet connection'), 
          reason: '🔴 FAILED: Should show network error message');
      
      print('✅ SUCCESS: Login correctly fails when API is unreachable');
    });

    test('🔴 PROOF: checkAuthStatus fails when API is unreachable - NO CACHE FALLBACK', () async {
      // Arrange: Mock API failure for auth check
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => Result<User>.failure(
                'No internet connection. Please check your network settings.',
                Exception('Network error'),
              ));

      // Act: Check authentication status
      final authNotifier = container.read(authNotifierProvider.notifier);
      await authNotifier.checkAuthStatus();

      // Assert: Verify the auth state is ERROR, not authenticated
      final authState = container.read(authNotifierProvider);
      
      expect(authState.status, equals(AuthStatus.error), 
          reason: '🔴 FAILED: Auth state should be ERROR when API check fails');
      expect(authState.user, isNull, 
          reason: '🔴 FAILED: User should be NULL when API check fails');
      expect(authState.token, isNull, 
          reason: '🔴 FAILED: Token should be NULL when API check fails');
      expect(authState.errorMessage, contains('No internet connection'), 
          reason: '🔴 FAILED: Should show network error message');
      
      print('✅ SUCCESS: Auth check correctly fails when API is unreachable');
    });

    test('🔴 PROOF: Initial auth state is unauthenticated', () {
      // Act: Get initial auth state
      final authState = container.read(authNotifierProvider);
      
      // Assert: Verify initial state is unauthenticated
      expect(authState.status, equals(AuthStatus.initial), 
          reason: '🔴 FAILED: Initial auth state should be initial');
      expect(authState.user, isNull, 
          reason: '🔴 FAILED: Initial user should be NULL');
      expect(authState.token, isNull, 
          reason: '🔴 FAILED: Initial token should be NULL');
      
      print('✅ SUCCESS: Initial auth state is correctly unauthenticated');
    });

    test('🔴 PROOF: Successful login requires valid API response', () async {
      // Arrange: Mock successful API response
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
      
      final mockBusiness = Business(
        id: 1,
        name: 'Test Business',
        slug: 'test-business',
        type: BusinessType.restaurant,
        taxRate: 8.5,
        currency: 'USD',
        timezone: 'America/New_York',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final mockLoginResponse = LoginResponse(
        user: mockUser,
        token: 'valid-token-123',
        business: mockBusiness,
      );

      when(mockAuthRepository.login(any, any, any))
          .thenAnswer((_) async => Result<LoginResponse>.success(mockLoginResponse));

      // Act: Attempt to login
      final authNotifier = container.read(authNotifierProvider.notifier);
      await authNotifier.login(
        email: 'test@example.com',
        password: 'password',
        businessSlug: 'test-business',
      );

      // Assert: Verify successful authentication
      final authState = container.read(authNotifierProvider);
      
      expect(authState.status, equals(AuthStatus.authenticated), 
          reason: '🔴 FAILED: Auth state should be authenticated after successful API response');
      expect(authState.user, equals(mockUser), 
          reason: '🔴 FAILED: User should match API response');
      expect(authState.business, equals(mockBusiness), 
          reason: '🔴 FAILED: Business should match API response');
      expect(authState.token, equals('valid-token-123'), 
          reason: '🔴 FAILED: Token should match API response');
      expect(authState.errorMessage, isNull, 
          reason: '🔴 FAILED: Error message should be NULL on success');
      
      print('✅ SUCCESS: Authentication only works with valid API response');
    });
  });
} 