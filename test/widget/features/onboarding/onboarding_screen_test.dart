import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/features/onboarding/onboarding_screen.dart';

void main() {
  group('OnboardingScreen', () {
    setUp(() async {
      // Clear SharedPreferences before each test
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: child,
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Screen')),
        },
      );
    }

    testWidgets('displays onboarding content with correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Check for skip button
      expect(find.text('Skip'), findsOneWidget);

      // Check for page indicators (4 pages)
      expect(find.byType(AnimatedContainer), findsNWidgets(4));

      // Check for navigation buttons
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Back'), findsNothing); // Back button not shown on first page
    });

    testWidgets('shows correct first page content', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Check first page content
      expect(find.text('Welcome to Your POS'), findsOneWidget);
      expect(find.text('Streamline your business operations with our powerful point-of-sale system designed for modern retailers.'), findsOneWidget);
      expect(find.byIcon(Icons.point_of_sale), findsOneWidget);
    });

    testWidgets('navigates to next page when Next button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Tap Next button
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Should show second page content
      expect(find.text('Quick Sales'), findsOneWidget);
      expect(find.text('Process transactions quickly with our intuitive POS interface. Search items, manage cart, and complete sales in seconds.'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);

      // Back button should now be visible
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('navigates back when Back button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Go to second page
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Go back to first page
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      // Should show first page content again
      expect(find.text('Welcome to Your POS'), findsOneWidget);
      expect(find.text('Back'), findsNothing); // Back button hidden again
    });

    testWidgets('shows all four onboarding pages', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Navigate through all pages
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Should be on last page
      expect(find.text('Smart Analytics'), findsOneWidget);
      expect(find.text('Get insights into your business performance with detailed reports and analytics to help you make informed decisions.'), findsOneWidget);
      expect(find.byIcon(Icons.analytics), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget); // Button text changes on last page
    });

    testWidgets('completes onboarding and navigates to login when Get Started is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Navigate to last page
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Tap Get Started
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Should navigate to login screen
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('skips onboarding and navigates to login when Skip is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Tap Skip
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Should navigate to login screen
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('updates page indicators correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Check initial state - first indicator should be active
      final indicators = find.byType(AnimatedContainer);
      expect(indicators, findsNWidgets(4));

      // Navigate to second page
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Second indicator should now be active
      // Note: We can't easily test the visual state of AnimatedContainer,
      // but we can verify the navigation worked
      expect(find.text('Quick Sales'), findsOneWidget);
    });

    testWidgets('handles swipe navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Swipe to next page
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      // Should show second page
      expect(find.text('Quick Sales'), findsOneWidget);
    });

    testWidgets('saves onboarding completion status', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingScreen()));

      // Complete onboarding
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Check that onboarding completion was saved
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboarding_completed');
      expect(onboardingCompleted, isTrue);
    });
  });
} 