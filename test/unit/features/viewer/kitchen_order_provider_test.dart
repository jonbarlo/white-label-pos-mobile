import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/viewer/kitchen_order_provider.dart';
import 'package:white_label_pos_mobile/src/features/viewer/kitchen_order_repository.dart';
import 'package:white_label_pos_mobile/src/features/viewer/kitchen_order.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';

import 'kitchen_order_provider_test.mocks.dart';

class StubAuthNotifier extends AuthNotifier {
  final AuthState _stubState;
  StubAuthNotifier(this._stubState) : super();
  @override
  AuthState build() => _stubState;
}

@GenerateMocks([KitchenOrderRepository])
void main() {
  group('KitchenOrderProvider', () {
    late MockKitchenOrderRepository mockRepository;
    late ProviderContainer container;
    late User mockUser;

    setUp(() {
      mockRepository = MockKitchenOrderRepository();
      mockUser = User(
        id: 1,
        businessId: 1,
        name: 'Test User',
        email: 'test@example.com',
        role: UserRole.admin,
        isActive: true,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('kitchenOrdersProvider', () {
      test('should fetch kitchen orders successfully', () async {
        // Arrange
        final mockAuthState = AuthState(
          status: AuthStatus.authenticated,
          user: mockUser,
          token: 'token',
        );
        container = ProviderContainer(
          overrides: [
            kitchenOrderRepositoryProvider.overrideWithValue(mockRepository),
            authNotifierProvider.overrideWith(() => StubAuthNotifier(mockAuthState)),
          ],
        );

        final mockOrders = [
          const KitchenOrder(
            id: 1,
            businessId: 1,
            orderId: 1,
            orderNumber: 'ORD-001',
            status: 'pending',
            items: [
              KitchenOrderItem(
                id: 1,
                itemName: 'Burger',
                quantity: 2,
                status: 'pending',
              ),
            ],
          ),
        ];

        when(mockRepository.fetchKitchenOrders(businessId: 1))
            .thenAnswer((_) async => mockOrders);

        // Act
        final result = await container.read(kitchenOrdersProvider.future);

        // Assert
        expect(result, equals(mockOrders));
        verify(mockRepository.fetchKitchenOrders(businessId: 1)).called(1);
      });

      test('should throw exception when user is not authenticated', () async {
        // Arrange
        const mockAuthState = AuthState(
          status: AuthStatus.unauthenticated,
          user: null,
          token: null,
        );
        container = ProviderContainer(
          overrides: [
            kitchenOrderRepositoryProvider.overrideWithValue(mockRepository),
            authNotifierProvider.overrideWith(() => StubAuthNotifier(mockAuthState)),
          ],
        );

        // Act & Assert
        expect(
          () => container.read(kitchenOrdersProvider.future),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockRepository.fetchKitchenOrders(businessId: anyNamed('businessId')));
      });

      test('should sort orders by order number', () async {
        // Arrange
        final mockAuthState = AuthState(
          status: AuthStatus.authenticated,
          user: mockUser,
          token: 'token',
        );
        container = ProviderContainer(
          overrides: [
            kitchenOrderRepositoryProvider.overrideWithValue(mockRepository),
            authNotifierProvider.overrideWith(() => StubAuthNotifier(mockAuthState)),
          ],
        );

        final mockOrders = [
          const KitchenOrder(
            id: 2,
            businessId: 1,
            orderId: 2,
            orderNumber: 'ORD-002',
            status: 'preparing',
            items: [],
          ),
          const KitchenOrder(
            id: 1,
            businessId: 1,
            orderId: 1,
            orderNumber: 'ORD-001',
            status: 'pending',
            items: [],
          ),
        ];

        when(mockRepository.fetchKitchenOrders(businessId: 1))
            .thenAnswer((_) async => mockOrders);

        // Act
        final result = await container.read(kitchenOrdersProvider.future);

        // Assert
        expect(result.length, 2);
        expect(result[0].orderNumber, 'ORD-001');
        expect(result[1].orderNumber, 'ORD-002');
      });
    });

    group('updateOrderStatusProvider', () {
      setUp(() {
        final mockAuthState = AuthState(
          status: AuthStatus.authenticated,
          user: mockUser,
          token: 'token',
        );
        container = ProviderContainer(
          overrides: [
            kitchenOrderRepositoryProvider.overrideWithValue(mockRepository),
            authNotifierProvider.overrideWith(() => StubAuthNotifier(mockAuthState)),
          ],
        );
      });

      test('should update order status successfully', () async {
        // Arrange
        when(mockRepository.updateOrderStatus(1, 'preparing'))
            .thenAnswer((_) async {});

        // Act
        await container.read(updateOrderStatusProvider((orderId: 1, status: 'preparing')).future);

        // Assert
        verify(mockRepository.updateOrderStatus(1, 'preparing')).called(1);
      });

      test('should throw exception when status update fails', () async {
        // Arrange
        when(mockRepository.updateOrderStatus(1, 'preparing'))
            .thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => container.read(updateOrderStatusProvider((orderId: 1, status: 'preparing')).future),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
} 