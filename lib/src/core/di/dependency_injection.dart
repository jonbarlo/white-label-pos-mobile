import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/business/data/repositories/business_repository_impl.dart';
import '../../features/inventory/inventory_repository_impl.dart';
import '../../features/inventory/inventory_provider.dart';
import '../../features/floor_plan/floor_plan_repository_impl.dart';
import '../../features/floor_plan/floor_plan_provider.dart';
import '../../features/promotions/promotion_repository_impl.dart';
import '../../core/config/env_config.dart';

/// Global providers for dependency injection
class DependencyInjection {
  static late ProviderContainer _container;
  static late SharedPreferences _prefs;
  static late Dio _dio;

  /// Initialize all dependencies
  static Future<void> initialize() async {
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize Dio client
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl, // Use API URL from .env
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Create provider container with overrides
    _container = ProviderContainer(
      overrides: [
        // Auth repository (uses Dio from provider)
        authRepositoryProvider.overrideWith(
          (ref) => AuthRepositoryImpl(ref.watch(dioClientProvider)),
        ),
        
        // Business repository (uses Dio from provider)
        businessRepositoryProvider.overrideWith(
          (ref) => BusinessRepositoryImpl(ref.watch(dioClientProvider)),
        ),
        
          // Inventory repository (uses Dio from provider)
  inventoryRepositoryProvider.overrideWith(
    (ref) => InventoryRepositoryImpl(ref.watch(dioClientProvider)),
  ),
  
    // Floor plan repository (uses Dio from provider)
  floorPlanRepositoryProvider.overrideWith(
    (ref) => FloorPlanRepositoryImpl(ref.watch(dioClientProvider)),
  ),
  
  // Promotion repository (uses Dio from provider)
  promotionRepositoryProvider.overrideWith(
    (ref) => PromotionRepositoryImpl(ref.watch(dioClientProvider), ref),
  ),
      ],
    );
  }

  /// Get the provider container
  static ProviderContainer get container => _container;

  /// Get SharedPreferences instance
  static SharedPreferences get prefs => _prefs;

  /// Get Dio client instance
  static Dio get dio => _dio;

  /// Dispose all dependencies
  static void dispose() {
    _container.dispose();
  }
}

/// Provider overrides for testing
final testOverrides = [
  // Override Dio client to use our configured instance
  dioClientProvider.overrideWith((ref) => DependencyInjection.dio),
  
  // Auth repository (uses Dio from provider)
  authRepositoryProvider.overrideWith(
    (ref) => AuthRepositoryImpl(ref.watch(dioClientProvider)),
  ),
  
  // Business repository (uses Dio from provider)
  businessRepositoryProvider.overrideWith(
    (ref) => BusinessRepositoryImpl(ref.watch(dioClientProvider)),
  ),
  
  // Inventory repository (uses Dio from provider)
  inventoryRepositoryProvider.overrideWith(
    (ref) => InventoryRepositoryImpl(ref.watch(dioClientProvider)),
  ),
  
  // Floor plan repository (uses Dio from provider)
  floorPlanRepositoryProvider.overrideWith(
    (ref) => FloorPlanRepositoryImpl(ref.watch(dioClientProvider)),
  ),
]; 