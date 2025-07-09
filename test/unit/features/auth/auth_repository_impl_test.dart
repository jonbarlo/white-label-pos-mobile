import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_repository_impl.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([Dio, SharedPreferences])
void main() {
  late MockDio mockDio;
  late MockSharedPreferences mockPrefs;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    mockDio = MockDio();
    mockPrefs = MockSharedPreferences();
    authRepository = AuthRepositoryImpl(mockDio, mockPrefs);
  });

  group('AuthRepositoryImpl', () {
    group('login', () {
      test('returns token and saves to preferences on success', () async {
        when(mockDio.post('/auth/login', data: {
          'email': 'test@example.com',
          'password': 'password',
          'businessSlug': 'biz1',
        })).thenAnswer((_) async => Response(
          data: {'token': 'test_token'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        ));

        when(mockPrefs.setString('auth_token', 'test_token')).thenAnswer((_) async => true);
        when(mockPrefs.setString('business_slug', 'biz1')).thenAnswer((_) async => true);

        final token = await authRepository.login(
          email: 'test@example.com',
          password: 'password',
          businessSlug: 'biz1',
        );

        expect(token, 'test_token');
        verify(mockPrefs.setString('auth_token', 'test_token')).called(1);
        verify(mockPrefs.setString('business_slug', 'biz1')).called(1);
      });

      test('throws exception on network error', () async {
        when(mockDio.post('/auth/login', data: anyNamed('data')))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: '/auth/login'),
              message: 'Network error',
            ));

        expect(
          () async => await authRepository.login(
            email: 'test@example.com',
            password: 'password',
            businessSlug: 'biz1',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('logout', () {
      test('removes token and business slug from preferences', () async {
        when(mockPrefs.remove('auth_token')).thenAnswer((_) async => true);
        when(mockPrefs.remove('business_slug')).thenAnswer((_) async => true);

        await authRepository.logout();

        verify(mockPrefs.remove('auth_token')).called(1);
        verify(mockPrefs.remove('business_slug')).called(1);
      });
    });

    group('isLoggedIn', () {
      test('returns true when token exists', () async {
        when(mockPrefs.getString('auth_token')).thenReturn('valid_token');

        final isLoggedIn = await authRepository.isLoggedIn();

        expect(isLoggedIn, true);
      });

      test('returns false when token is null', () async {
        when(mockPrefs.getString('auth_token')).thenReturn(null);

        final isLoggedIn = await authRepository.isLoggedIn();

        expect(isLoggedIn, false);
      });

      test('returns false when token is empty', () async {
        when(mockPrefs.getString('auth_token')).thenReturn('');

        final isLoggedIn = await authRepository.isLoggedIn();

        expect(isLoggedIn, false);
      });
    });
  });
} 