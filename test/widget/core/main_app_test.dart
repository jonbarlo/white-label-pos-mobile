import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_repository.dart';
import 'package:white_label_pos_mobile/src/features/auth/login_screen.dart';
import 'package:white_label_pos_mobile/src/core/main_app.dart';

import 'main_app_test.mocks.dart';

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

  group('MainApp', () {
    testWidgets('shows login screen when not authenticated', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => false);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Should show login screen
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Login'), findsNWidgets(2)); // AppBar title and button
    });

    testWidgets('shows main dashboard when authenticated', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Should show main dashboard with bottom navigation
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('has correct bottom navigation items', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Check for bottom navigation items
      expect(find.text('Dashboard'), findsNWidgets(2)); // AppBar + bottom nav
      expect(find.text('POS'), findsOneWidget); // Only in bottom nav
      expect(find.text('Inventory'), findsOneWidget); // Only in bottom nav
      expect(find.text('Reports'), findsOneWidget); // Only in bottom nav
      expect(find.text('Profile'), findsOneWidget); // Only in bottom nav
    });

    testWidgets('shows dashboard as initial screen when authenticated', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Dashboard should be the initial screen
      expect(find.text('Sales Overview'), findsOneWidget);
    });

    testWidgets('navigates to POS screen when POS tab is tapped', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Tap POS tab in bottom navigation
      await tester.tap(find.text('POS'));
      await tester.pumpAndSettle();

      // Should show POS screen (check for Cart text which is unique to POS screen)
      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('navigates to Inventory screen when Inventory tab is tapped', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Tap Inventory tab in bottom navigation
      await tester.tap(find.text('Inventory'));
      await tester.pumpAndSettle();

      // Should show Inventory screen
      expect(find.text('Inventory'), findsOneWidget);
    });

    testWidgets('navigates to Reports screen when Reports tab is tapped', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Tap Reports tab in bottom navigation
      await tester.tap(find.text('Reports'));
      await tester.pumpAndSettle();

      // Should show Reports screen
      expect(find.text('Sales Analytics'), findsOneWidget);
    });

    testWidgets('navigates to Profile screen when Profile tab is tapped', (WidgetTester tester) async {
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Tap Profile tab in bottom navigation
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Should show Profile screen
      expect(find.text('User Settings'), findsOneWidget);
    });
  });
} 