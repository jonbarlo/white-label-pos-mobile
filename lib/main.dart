import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/main_app.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/config/env_config.dart';
import 'src/core/di/dependency_injection.dart';
import 'src/core/network/dio_client.dart';
import 'src/features/auth/data/repositories/auth_repository_impl.dart';
import 'src/features/business/data/repositories/business_repository_impl.dart';
import 'src/features/inventory/inventory_repository_impl.dart';
import 'src/features/inventory/inventory_provider.dart';
import 'src/core/mock/mock_inventory_repository.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment configuration
  await EnvConfig.initialize();
  
  // Initialize dependency injection
  await DependencyInjection.initialize();
  
  runApp(
    ProviderScope(
      overrides: [
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
        
        // Inventory repository (using real implementation)
        inventoryRepositoryProvider.overrideWith(
          (ref) => InventoryRepositoryImpl(ref.watch(dioClientProvider)),
        ),
      ],
      child: const WhiteLabelPOSApp(),
    ),
  );
}

class WhiteLabelPOSApp extends StatelessWidget {
  const WhiteLabelPOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: EnvConfig.appName,
      theme: AppTheme.lightTheme,
      home: const MainApp(),
      debugShowCheckedModeBanner: EnvConfig.isDebugMode,
    );
  }
}
