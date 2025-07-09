import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_repository.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier', () {
    test('initial state is correct', () {
      final authNotifier = container.read(authNotifierProvider.notifier);
      expect(authNotifier.state.status, AuthStatus.initial);
      expect(authNotifier.state.token, isNull);
      expect(authNotifier.state.businessSlug, isNull);
      expect(authNotifier.state.errorMessage, isNull);
    });

    group('login', () {
      test('successful login updates state correctly', () async {
        when(mockAuthRepository.login(
          email: 'test@example.com',
          password: 'password',
          businessSlug: 'biz1',
        )).thenAnswer((_) async => 'test_token');

        final authNotifier = container.read(authNotifierProvider.notifier);

        await authNotifier.login(
          email: 'test@example.com',
          password: 'password',
          businessSlug: 'biz1',
        );

        expect(authNotifier.state.status, AuthStatus.authenticated);
        expect(authNotifier.state.token, 'test_token');
        expect(authNotifier.state.businessSlug, 'biz1');
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('login failure sets error state', () async {
        when(mockAuthRepository.login(
          email: 'fail@example.com',
          password: 'wrong',
          businessSlug: 'biz1',
        )).thenThrow(Exception('Login failed'));

        final authNotifier = container.read(authNotifierProvider.notifier);

        await authNotifier.login(
          email: 'fail@example.com',
          password: 'wrong',
          businessSlug: 'biz1',
        );

        expect(authNotifier.state.status, AuthStatus.error);
        expect(authNotifier.state.errorMessage, contains('Login failed'));
      });

      test('login sets loading state during operation', () async {
        when(mockAuthRepository.login(
          email: 'test@example.com',
          password: 'password',
          businessSlug: 'biz1',
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return 'test_token';
        });

        final authNotifier = container.read(authNotifierProvider.notifier);
        final future = authNotifier.login(
          email: 'test@example.com',
          password: 'password',
          businessSlug: 'biz1',
        );

        // Check that state is loading immediately
        expect(authNotifier.state.status, AuthStatus.loading);

        await future;
      });
    });

    group('logout', () {
      test('successful logout resets state', () async {
        when(mockAuthRepository.logout()).thenAnswer((_) async {});

        final authNotifier = container.read(authNotifierProvider.notifier);
        
        // Set initial authenticated state
        authNotifier.state = authNotifier.state.copyWith(
          status: AuthStatus.authenticated,
          token: 'test_token',
          businessSlug: 'biz1',
        );

        await authNotifier.logout();

        expect(authNotifier.state.status, AuthStatus.unauthenticated);
        expect(authNotifier.state.token, isNull);
        expect(authNotifier.state.businessSlug, isNull);
      });

      test('logout failure sets error state', () async {
        when(mockAuthRepository.logout()).thenThrow(Exception('Logout failed'));

        final authNotifier = container.read(authNotifierProvider.notifier);

        await authNotifier.logout();

        expect(authNotifier.state.status, AuthStatus.error);
        expect(authNotifier.state.errorMessage, contains('Logout failed'));
      });
    });

    group('checkAuthStatus', () {
      test('sets authenticated state when user is logged in', () async {
        when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

        final authNotifier = container.read(authNotifierProvider.notifier);

        await authNotifier.checkAuthStatus();

        expect(authNotifier.state.status, AuthStatus.authenticated);
      });

      test('sets unauthenticated state when user is not logged in', () async {
        when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => false);

        final authNotifier = container.read(authNotifierProvider.notifier);

        await authNotifier.checkAuthStatus();

        expect(authNotifier.state.status, AuthStatus.unauthenticated);
      });

      test('sets error state when check fails', () async {
        when(mockAuthRepository.isLoggedIn()).thenThrow(Exception('Check failed'));

        final authNotifier = container.read(authNotifierProvider.notifier);

        await authNotifier.checkAuthStatus();

        expect(authNotifier.state.status, AuthStatus.error);
        expect(authNotifier.state.errorMessage, contains('Check failed'));
      });
    });
  });
} 