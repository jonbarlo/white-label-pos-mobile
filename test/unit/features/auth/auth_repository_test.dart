import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_repository.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('AuthRepository', () {
    group('login', () {
      test('returns token on success', () async {
        when(mockAuthRepository.login(email: 'test@example.com', password: 'password', businessSlug: 'biz1'))
            .thenAnswer((_) async => 'mock_token');

        final token = await mockAuthRepository.login(email: 'test@example.com', password: 'password', businessSlug: 'biz1');
        expect(token, 'mock_token');
      });

      test('throws on failure', () async {
        when(mockAuthRepository.login(email: 'fail@example.com', password: 'wrong', businessSlug: 'biz1'))
            .thenThrow(Exception('Login failed'));

        expect(
          () async => await mockAuthRepository.login(email: 'fail@example.com', password: 'wrong', businessSlug: 'biz1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('logout', () {
      test('completes successfully', () async {
        when(mockAuthRepository.logout()).thenAnswer((_) async {});

        expect(() async => await mockAuthRepository.logout(), returnsNormally);
      });
    });

    group('isLoggedIn', () {
      test('returns true when user is logged in', () async {
        when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

        final isLoggedIn = await mockAuthRepository.isLoggedIn();
        expect(isLoggedIn, true);
      });

      test('returns false when user is not logged in', () async {
        when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => false);

        final isLoggedIn = await mockAuthRepository.isLoggedIn();
        expect(isLoggedIn, false);
      });
    });
  });
} 