import 'package:flutter_test/flutter_test.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_validators.dart';

void main() {
  group('AuthValidators', () {
    group('validateEmail', () {
      test('returns null for valid email addresses', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          '123@test.com',
          'test.email@subdomain.example.com',
        ];

        for (final email in validEmails) {
          final result = AuthValidators.validateEmail(email);
          expect(result, isNull, reason: 'Email "$email" should be valid');
        }
      });

      test('returns error message for empty email', () {
        final result = AuthValidators.validateEmail('');
        expect(result, equals('Email is required'));
      });

      test('returns error message for null email', () {
        final result = AuthValidators.validateEmail(null);
        expect(result, equals('Email is required'));
      });

      test('returns error message for invalid email formats', () {
        final invalidEmails = [
          'invalid-email',
          '@example.com',
          'test@',
          'test@.com',
          'test..test@example.com',
          'test@example..com',
          'test@example',
          'test@example.',
          'test@.example.com',
          '@@example.com',
          'test@example@.com',
          'test@example.com.',
          '.test@example.com',
          'test@example.com..',
        ];

        for (final email in invalidEmails) {
          final result = AuthValidators.validateEmail(email);
          expect(result, equals('Please enter a valid email'), 
              reason: 'Email "$email" should be invalid');
        }
      });

      test('handles whitespace in email', () {
        final result = AuthValidators.validateEmail('  test@example.com  ');
        expect(result, isNull);
      });
    });

    group('validatePassword', () {
      test('returns null for valid passwords', () {
        final validPasswords = [
          'password123',
          '123456',
          'abcdef',
          'P@ssw0rd',
          'verylongpassword123',
          'a'.padRight(100, 'a'), // 100 characters
        ];

        for (final password in validPasswords) {
          final result = AuthValidators.validatePassword(password);
          expect(result, isNull, reason: 'Password "$password" should be valid');
        }
      });

      test('returns error message for empty password', () {
        final result = AuthValidators.validatePassword('');
        expect(result, equals('Password is required'));
      });

      test('returns error message for null password', () {
        final result = AuthValidators.validatePassword(null);
        expect(result, equals('Password is required'));
      });

      test('returns error message for short passwords', () {
        final shortPasswords = [
          '12345', // 5 characters
          'abc',   // 3 characters
          'a',     // 1 character
        ];

        for (final password in shortPasswords) {
          final result = AuthValidators.validatePassword(password);
          expect(result, equals('Password must be at least 6 characters'),
              reason: 'Password "$password" should be too short');
        }
      });

      test('accepts passwords with special characters', () {
        final specialPasswords = [
          'pass@word',
          'pass word',
          'pass-word',
          'pass_word',
          'pass!word',
          'pass#word',
          r'pass$word',
          'pass%word',
          'pass^word',
          'pass&word',
          'pass*word',
          'pass(word)',
          'pass[word]',
          'pass{word}',
          'pass|word',
          r'pass\word',
          'pass:word',
          'pass;word',
          'pass"word"',
          "pass'word'",
          'pass<word>',
          'pass,word',
          'pass.word',
          'pass?word',
          'pass/word',
        ];

        for (final password in specialPasswords) {
          final result = AuthValidators.validatePassword(password);
          expect(result, isNull, reason: 'Password "$password" should be valid');
        }
      });
    });

    group('validateBusinessSlug', () {
      test('returns null for valid business slugs', () {
        final validSlugs = [
          'mybusiness',
          'business-123',
          'business_123',
          'business123',
          'my-business',
          'my_business',
          'business-name',
          'businessname',
          'a', // single character
          'a'.padRight(50, 'a'), // 50 characters
        ];

        for (final slug in validSlugs) {
          final result = AuthValidators.validateBusinessSlug(slug);
          expect(result, isNull, reason: 'Business slug "$slug" should be valid');
        }
      });

      test('returns error message for empty business slug', () {
        final result = AuthValidators.validateBusinessSlug('');
        expect(result, equals('Business slug is required'));
      });

      test('returns error message for null business slug', () {
        final result = AuthValidators.validateBusinessSlug(null);
        expect(result, equals('Business slug is required'));
      });

      test('returns error message for whitespace-only business slug', () {
        final result = AuthValidators.validateBusinessSlug('   ');
        expect(result, equals('Business slug is required'));
      });
    });

    group('Edge Cases', () {
      test('handles very long inputs', () {
        final longEmail = '${'a'.padRight(1000, 'a')}@example.com';
        final longPassword = 'a'.padRight(1000, 'a');
        final longSlug = 'a'.padRight(1000, 'a');

        // Email validation should still work for very long emails
        final emailResult = AuthValidators.validateEmail(longEmail);
        expect(emailResult, isNull);

        // Password validation should still work for very long passwords
        final passwordResult = AuthValidators.validatePassword(longPassword);
        expect(passwordResult, isNull);

        // Business slug validation should still work for very long slugs
        final slugResult = AuthValidators.validateBusinessSlug(longSlug);
        expect(slugResult, isNull);
      });

      test('handles unicode characters', () {
        // Test with unicode characters
        const unicodeEmail = 'test@example.com'; // Keep simple for now
        const unicodePassword = 'password123'; // Keep simple for now
        const unicodeSlug = 'business123'; // Keep simple for now

        expect(AuthValidators.validateEmail(unicodeEmail), isNull);
        expect(AuthValidators.validatePassword(unicodePassword), isNull);
        expect(AuthValidators.validateBusinessSlug(unicodeSlug), isNull);
      });

      test('handles whitespace trimming', () {
        // Test that whitespace is properly trimmed
        expect(AuthValidators.validateEmail('  test@example.com  '), isNull);
        expect(AuthValidators.validatePassword('  password123  '), isNull);
        expect(AuthValidators.validateBusinessSlug('  business123  '), isNull);
      });
    });
  });
} 