import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

/// A test helper class to properly handle Riverpod in widget tests
class RiverpodTestHelper {
  static late ProviderContainer _container;

  /// Initialize the test container with overrides
  static void setUpContainer(List<Override> overrides) {
    _container = ProviderContainer(overrides: overrides);
  }

  /// Dispose the test container and wait for cleanup
  static Future<void> tearDownContainer() async {
    _container.dispose();
    // Wait a bit for Riverpod to clean up its timers
    await Future.delayed(const Duration(milliseconds: 10));
  }

  /// Create a test widget with proper Riverpod setup
  static Widget createTestWidget(
    Widget child, {
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      parent: _container,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  /// Pump and settle with proper cleanup handling
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pump();
    await tester.pumpAndSettle();
    // Give Riverpod time to clean up any pending operations
    await Future.delayed(const Duration(milliseconds: 10));
  }

  /// Pump widget with proper cleanup handling
  static Future<void> pumpWidget(
    WidgetTester tester,
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(createTestWidget(widget, overrides: overrides));
    await pumpAndSettle(tester);
  }
}

/// A mixin for test classes to easily use Riverpod test helpers
mixin RiverpodTestMixin {
  late ProviderContainer container;

  /// Set up the test container
  void setUpContainer(List<Override> overrides) {
    container = ProviderContainer(overrides: overrides);
  }

  /// Tear down the test container
  Future<void> tearDownContainer() async {
    container.dispose();
    // Wait for Riverpod cleanup
    await Future.delayed(const Duration(milliseconds: 10));
  }

  /// Create a test widget
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      parent: container,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  /// Pump and settle with cleanup
  Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pump();
    await tester.pumpAndSettle();
    // Give Riverpod time to clean up
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

/// Extension on WidgetTester for easier Riverpod testing
extension RiverpodWidgetTesterExtension on WidgetTester {
  /// Pump widget with Riverpod container
  Future<void> pumpWidgetWithRiverpod(
    Widget widget, {
    required ProviderContainer container,
  }) async {
    await pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(home: widget),
      ),
    );
    await pumpAndSettle();
    // Give Riverpod time to clean up
    await Future.delayed(const Duration(milliseconds: 10));
  }
} 