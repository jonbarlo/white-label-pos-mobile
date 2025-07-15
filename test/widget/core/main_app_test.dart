import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/login_screen.dart';
import 'package:white_label_pos_mobile/src/core/main_app.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('MainApp', () {
    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const MainApp()));
      await tester.pumpAndSettle();

      // Should render without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
} 