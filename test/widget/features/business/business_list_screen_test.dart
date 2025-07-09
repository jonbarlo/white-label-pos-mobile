import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:white_label_pos_mobile/src/features/business/business_list_screen.dart';
import 'package:white_label_pos_mobile/src/features/business/business_repository.dart';
import 'package:white_label_pos_mobile/src/features/business/models/business.dart';
import 'package:white_label_pos_mobile/test/helpers/riverpod_test_helper.dart';

import 'business_list_screen_test.mocks.dart';

@GenerateMocks([BusinessRepository])
void main() {
  group('BusinessListScreen', () {
    late MockBusinessRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockBusinessRepository();
      container = createContainer(
        overrides: [
          businessRepositoryProvider.overrideWithValue(
            Future.value(mockRepository),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      when(mockRepository.getBusinesses()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(
            home: BusinessListScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Business Management'), findsOneWidget);
    });

    testWidgets('should show empty state when no businesses', (tester) async {
      // Arrange
      when(mockRepository.getBusinesses()).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(
            home: BusinessListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No businesses found'), findsOneWidget);
      expect(find.text('Add your first business to get started'), findsOneWidget);
      expect(find.byIcon(Icons.business_outlined), findsOneWidget);
    });

    testWidgets('should show list of businesses', (tester) async {
      // Arrange
      final businesses = [
        Business(
          id: 1,
          name: 'Test Restaurant',
          slug: 'test-restaurant',
          type: BusinessType.restaurant,
          description: 'A test restaurant',
          taxRate: 8.5,
          currency: 'USD',
          timezone: 'America/New_York',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Business(
          id: 2,
          name: 'Test Retail',
          slug: 'test-retail',
          type: BusinessType.retail,
          description: 'A test retail store',
          taxRate: 7.0,
          currency: 'EUR',
          timezone: 'Europe/London',
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(mockRepository.getBusinesses()).thenAnswer((_) async => businesses);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(
            home: BusinessListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Restaurant'), findsOneWidget);
      expect(find.text('Test Retail'), findsOneWidget);
      expect(find.text('Restaurant'), findsOneWidget);
      expect(find.text('Retail'), findsOneWidget);
      expect(find.text('A test restaurant'), findsOneWidget);
      expect(find.text('A test retail store'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('should show error state when API fails', (tester) async {
      // Arrange
      when(mockRepository.getBusinesses()).thenThrow(Exception('Network error'));

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(
            home: BusinessListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Error loading businesses'), findsOneWidget);
      expect(find.text('Exception: Network error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show add button in app bar', (tester) async {
      // Arrange
      when(mockRepository.getBusinesses()).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(
            home: BusinessListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should show popup menu for each business', (tester) async {
      // Arrange
      final businesses = [
        Business(
          id: 1,
          name: 'Test Business',
          slug: 'test-business',
          type: BusinessType.restaurant,
          taxRate: 8.5,
          currency: 'USD',
          timezone: 'America/New_York',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(mockRepository.getBusinesses()).thenAnswer((_) async => businesses);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(
            home: BusinessListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the popup menu button
      final popupButton = find.byType(PopupMenuButton<String>);
      expect(popupButton, findsOneWidget);
      await tester.tap(popupButton);
      await tester.pumpAndSettle();

      // Assert popup menu items are shown
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should show delete confirmation dialog', (tester) async {
      // Arrange
      final businesses = [
        Business(
          id: 1,
          name: 'Test Business',
          slug: 'test-business',
          type: BusinessType.restaurant,
          taxRate: 8.5,
          currency: 'USD',
          timezone: 'America/New_York',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(mockRepository.getBusinesses()).thenAnswer((_) async => businesses);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(
            home: BusinessListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open popup menu and select delete
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert confirmation dialog is shown
      expect(find.text('Delete Business'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Test Business"? This action cannot be undone.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
} 