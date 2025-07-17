import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/auth_provider.dart';
import '../features/floor_plan/floor_plan_provider.dart';
import 'navigation/app_router.dart';
import 'theme/theme_provider.dart';

/// Provider for app initialization state
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  ref.read(sharedPreferencesProvider.notifier).state = prefs;
  
  // Don't check auth status during initialization - let the router handle it
  // This prevents hanging on API calls when no token is stored
});

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeDataProvider);
    final themeMode = ref.watch(themeModeProvider);
    final initializationState = ref.watch(appInitializationProvider);
    
    // Test floor plan provider initialization
    try {
      final floorPlanState = ref.watch(floorPlanNotifierProvider);
      print('🔍 DEBUG: MainApp: Floor plan state = $floorPlanState');
    } catch (e) {
      print('🔍 DEBUG: MainApp: Error watching floor plan provider: $e');
    }
    
    print('MainApp build - Theme mode: $themeMode');

    return initializationState.when(
      loading: () => MaterialApp(
        title: 'White Label POS',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => MaterialApp(
        title: 'White Label POS',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Initialization Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(appInitializationProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (_) {
        // Watch the router provider so it rebuilds on auth changes
        final router = ref.watch(goRouterProvider);

        return MaterialApp.router(
          title: 'White Label POS',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          routerConfig: router,
        );
      },
    );
  }
} 