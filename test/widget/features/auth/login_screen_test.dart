import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/data/repositories/auth_repository.dart';
import 'package:white_label_pos_mobile/src/features/auth/login_screen.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('displays login form with all required fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.byType(TextFormField), findsNWidgets(3)); // email, password, business slug
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsNWidgets(2)); // AppBar title and button text
    });

    testWidgets('validates required fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Try to login without filling fields
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Business slug is required'), findsOneWidget);
    });

    testWidgets('validates email format', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      // Enter invalid email
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.enterText(find.byKey(const Key('password_field')), 'password');
      await tester.enterText(find.byKey(const Key('business_slug_field')), 'biz1');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should show email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('has correct form field labels', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Business Slug'), findsOneWidget);
    });

    testWidgets('has correct form field hints', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text('Enter your business slug'), findsOneWidget);
    });

    testWidgets('has POS icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.byIcon(Icons.point_of_sale), findsOneWidget);
    });

    testWidgets('has business icon in business slug field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.byIcon(Icons.business), findsOneWidget);
    });

    testWidgets('has email icon in email field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('has lock icon in password field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LoginScreen()));

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
  });
} 