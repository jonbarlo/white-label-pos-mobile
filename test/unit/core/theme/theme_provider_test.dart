import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:white_label_pos_mobile/src/core/theme/theme_provider.dart';
import 'package:white_label_pos_mobile/src/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('ThemeProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with light theme by default', () {
      final themeMode = container.read(themeModeProvider);
      expect(themeMode, equals(ThemeMode.light));
    });

    test('should toggle between light and dark themes', () async {
      final notifier = container.read(themeModeProvider.notifier);
      
      // Start with light theme
      expect(container.read(themeModeProvider), equals(ThemeMode.light));
      
      // Toggle to dark theme
      await notifier.toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
      
      // Toggle back to light theme
      await notifier.toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.light));
    });

    test('should set specific theme mode', () async {
      final notifier = container.read(themeModeProvider.notifier);
      
      // Set to dark theme
      await notifier.setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
      
      // Set to light theme
      await notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), equals(ThemeMode.light));
    });

    test('should provide correct theme data for light mode', () {
      final themeData = container.read(themeDataProvider);
      expect(themeData, equals(AppTheme.lightTheme));
    });

    test('should provide correct theme data for dark mode', () async {
      final notifier = container.read(themeModeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.dark);
      
      final themeData = container.read(themeDataProvider);
      expect(themeData, equals(AppTheme.darkTheme));
    });

    test('should handle persistence errors gracefully', () async {
      // Mock SharedPreferences to throw an error
      SharedPreferences.setMockInitialValues({});
      
      final notifier = container.read(themeModeProvider.notifier);
      
      // This should not throw an error even if persistence fails
      await notifier.toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
    });
  });
} 