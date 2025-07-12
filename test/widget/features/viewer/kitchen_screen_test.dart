import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:white_label_pos_mobile/src/features/viewer/kitchen_screen.dart';
import 'package:white_label_pos_mobile/src/features/viewer/kitchen_order.dart';

void main() {
  group('KitchenOrderCard UI', () {
    testWidgets('displays order information correctly and toggles item status', (WidgetTester tester) async {
      // Arrange: Create a sample order with two items
      final order = KitchenOrder(
        id: 1,
        businessId: 1,
        orderId: 1,
        orderNumber: 'ORD-123',
        status: 'pending',
        priority: 'normal',
        items: [
          KitchenOrderItem(id: 1, itemName: 'Burger', quantity: 1, status: 'pending'),
          KitchenOrderItem(id: 2, itemName: 'Fries', quantity: 1, status: 'pending'),
        ],
        totalItems: 2,
        completedItems: 0,
      );
      KitchenOrder? updatedOrder;

      // Act: Render the card
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KitchenOrderCard(
              order: order,
              onStatusChanged: (o) {
                updatedOrder = o;
              },
            ),
          ),
        ),
      );

      // Assert: Order information is displayed correctly
      expect(find.text('ORD-123'), findsOneWidget);
      expect(find.text('1x Burger, 1x Fries'), findsOneWidget); // Only in main dish names now
      expect(find.text('Items:'), findsOneWidget);
      expect(find.text('0/2 items'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
      expect(find.byType(Switch), findsNWidgets(2));
      // Check for individual item rows
      expect(find.text('1x Burger'), findsOneWidget);
      expect(find.text('1x Fries'), findsOneWidget);
      // Check for action buttons
      expect(find.text('Start Preparing'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);

      // Act: Toggle the first item
      await tester.tap(find.byType(Switch).first);
      await tester.pump();

      // Assert: onStatusChanged is called and progress updates
      expect(updatedOrder, isNotNull);
      expect(updatedOrder!.completedItems, 1);
      expect(find.text('1/2 items'), findsOneWidget);
    });

    testWidgets('displays different status chips correctly', (WidgetTester tester) async {
      // Arrange: Create orders with different statuses
      final pendingOrder = KitchenOrder(
        id: 1,
        businessId: 1,
        orderId: 1,
        orderNumber: 'ORD-001',
        status: 'pending',
        priority: 'normal',
        items: [],
        totalItems: 0,
        completedItems: 0,
      );

      final preparingOrder = KitchenOrder(
        id: 2,
        businessId: 1,
        orderId: 2,
        orderNumber: 'ORD-002',
        status: 'preparing',
        priority: 'normal',
        items: [],
        totalItems: 0,
        completedItems: 0,
      );

      // Act & Assert: Test pending status
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KitchenOrderCard(
              order: pendingOrder,
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.text('Start Preparing'), findsOneWidget);

      // Act & Assert: Test preparing status
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KitchenOrderCard(
              order: preparingOrder,
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('PREPARING'), findsOneWidget);
      expect(find.text('Mark Ready'), findsOneWidget);
    });

    testWidgets('shows priority badges correctly', (WidgetTester tester) async {
      // Arrange: Create orders with different priorities
      final highPriorityOrder = KitchenOrder(
        id: 1,
        businessId: 1,
        orderId: 1,
        orderNumber: 'ORD-001',
        status: 'pending',
        priority: 'high',
        items: [],
        totalItems: 0,
        completedItems: 0,
      );

      // Act: Render the card
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KitchenOrderCard(
              order: highPriorityOrder,
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert: Priority badge is displayed
      expect(find.text('HIGH'), findsOneWidget);
    });

    testWidgets('displays progress bar correctly', (WidgetTester tester) async {
      // Arrange: Create an order with progress
      final order = KitchenOrder(
        id: 1,
        businessId: 1,
        orderId: 1,
        orderNumber: 'ORD-001',
        status: 'preparing',
        priority: 'normal',
        items: [
          KitchenOrderItem(id: 1, itemName: 'Burger', quantity: 1, status: 'completed'),
          KitchenOrderItem(id: 2, itemName: 'Fries', quantity: 1, status: 'pending'),
        ],
        totalItems: 2,
        completedItems: 1,
      );

      // Act: Render the card
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KitchenOrderCard(
              order: order,
              onStatusChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert: Progress is displayed correctly
      expect(find.text('1/2 items'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
} 