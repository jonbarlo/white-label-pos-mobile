import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:white_label_pos_mobile/src/features/admin/admin_menu_management_screen.dart';

void main() {
  group('AdminMenuManagementScreen', () {
    testWidgets('renders without crashing', (tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminMenuManagementScreen(),
          ),
        ),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Assert - should show access denied for non-admin users
      expect(find.byType(AdminMenuManagementScreen), findsOneWidget);
    });

    testWidgets('shows access denied message', (tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminMenuManagementScreen(),
          ),
        ),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Assert - should find at least one access denied message
      expect(find.text('Access Denied'), findsAtLeastNWidgets(1));
      expect(find.text('This feature is only available to system administrators.'), findsOneWidget);
    });
  });
} 