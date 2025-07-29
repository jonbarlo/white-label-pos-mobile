import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:white_label_pos_mobile/src/features/admin/admin_dashboard_screen.dart';

void main() {
  group('AdminDashboardScreen', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdminDashboardScreen), findsOneWidget);
    });

    testWidgets('shows access denied for non-admin users', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Access Denied'), findsAtLeastNWidgets(1));
      expect(find.text('This feature is only available to system administrators.'), findsOneWidget);
    });

    testWidgets('shows system administration title for admin users', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('System Administration'), findsAtLeastNWidgets(1));
    });
  });
}