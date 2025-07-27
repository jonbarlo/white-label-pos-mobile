import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env_config.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/dashboard/analytics_dashboard_screen.dart';
import '../../features/dashboard/feature_dashboard_screen.dart';
import '../../features/pos/pos_screen.dart';
import '../../features/inventory/inventory_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/users/profile_screen.dart';
import '../../features/business/business_list_screen.dart';
import '../../features/waiter/table_selection_screen.dart';
import '../../features/waiter/waiter_dashboard_screen.dart';
import '../../features/waiter/order_taking_screen.dart';
import '../../features/waiter/tables_screen.dart';
import '../../features/waiter/messages_screen.dart';
import '../../features/dashboard/waitstaff_dashboard_screen.dart';
import '../../features/waiter/models/table.dart' as waiter_table;
import '../../features/viewer/kitchen_screen.dart';
import '../../features/viewer/bar_screen.dart';
import '../../features/pos/split_billing_screen.dart';
import '../../features/floor_plan/floor_plan_viewer_screen.dart';
import '../../features/floor_plan/floor_plan_management_screen.dart';
import '../../features/auth/models/user.dart';
import '../../features/recipes/smart_suggestions_screen.dart';
import '../../features/recipes/inventory_alerts_screen.dart';
import '../../features/promotions/promotions_screen.dart';


/// Provider for SharedPreferences
final sharedPreferencesProvider = StateProvider<SharedPreferences?>((ref) => null);

/// Provider for onboarding completion status
final onboardingCompletedProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs?.getBool('onboarding_completed') ?? false;
});

/// Provider for onboarding actions
final onboardingProvider = Provider<OnboardingActions>((ref) {
  return OnboardingActions(ref);
});

/// Class to handle onboarding actions
class OnboardingActions {
  final Ref _ref;
  
  OnboardingActions(this._ref);
  
  Future<void> completeOnboarding() async {
    final prefs = _ref.read(sharedPreferencesProvider);
    await prefs?.setBool('onboarding_completed', true);
    _ref.read(onboardingCompletedProvider.notifier).state = true;
  }
}

/// Centralized routing configuration for the app
class AppRouter {
  static const String loginRoute = '/login';
  static const String onboardingRoute = '/onboarding';
  static const String dashboardRoute = '/dashboard';
  static const String analyticsRoute = '/analytics';
  static const String featureDashboardRoute = '/feature-dashboard';
  static const String smartSuggestionsRoute = '/smart-suggestions';
  static const String inventoryAlertsRoute = '/inventory-alerts';
  static const String promotionsRoute = '/promotions';
  static const String posRoute = '/pos';
  static const String inventoryRoute = '/inventory';
  static const String reportsRoute = '/reports';
  static const String profileRoute = '/profile';
  static const String businessRoute = '/business';
  static const String waiterRoute = '/waiter';
  static const String tableSelectionRoute = '/waiter/tables';
  static const String orderTakingRoute = '/waiter/order';
  static const String tablesRoute = '/tables';
  static const String messagesRoute = '/messages';
  static const String kitchenRoute = '/kitchen';
  static const String barRoute = '/bar';
  static const String splitBillingRoute = '/split-billing';
  static const String floorPlanViewerRoute = '/floor-plan-viewer';
  static const String floorPlanManagementRoute = '/floor-plan-management';

  /// Create the main router configuration
  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: EnvConfig.isDebugMode,
      redirect: (context, state) => AppRouter.handleRedirect(context, state, ref),
      routes: [
        // Root route - will be redirected based on auth/onboarding status
        GoRoute(
          path: '/',
          name: 'root',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        
        // Auth routes
        GoRoute(
          path: loginRoute,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        
        // Onboarding route
        GoRoute(
          path: onboardingRoute,
          name: 'onboarding',
          builder: (context, state) => OnboardingScreen(
            onOnboardingComplete: () {
              context.go(dashboardRoute);
            },
          ),
        ),
        
        // Main app routes with nested navigation
        ShellRoute(
          builder: (context, state, child) => _MainAppShell(child: child),
          routes: [
            // Dashboard
            GoRoute(
              path: dashboardRoute,
              name: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            
            // Analytics Dashboard
            GoRoute(
              path: analyticsRoute,
              name: 'analytics',
              builder: (context, state) => const AnalyticsDashboardScreen(),
            ),
            
            // Feature Dashboard
            GoRoute(
              path: featureDashboardRoute,
              name: 'feature-dashboard',
              builder: (context, state) {
                print('🔍 DEBUG: FeatureDashboard route builder called');
                return const FeatureDashboardScreen();
              },
            ),
            
            // Smart Recipe Suggestions
            GoRoute(
              path: smartSuggestionsRoute,
              name: 'smart-suggestions',
              builder: (context, state) => const SmartSuggestionsScreen(),
            ),
            
            // Inventory Alerts
            GoRoute(
              path: inventoryAlertsRoute,
              name: 'inventory-alerts',
              builder: (context, state) => const InventoryAlertsScreen(),
            ),
            
            // Promotions
            GoRoute(
              path: promotionsRoute,
              name: 'promotions',
              builder: (context, state) => const PromotionsScreen(),
            ),
            
            // POS
            GoRoute(
              path: posRoute,
              name: 'pos',
              builder: (context, state) => const PosScreen(),
            ),
            
            // Inventory
            GoRoute(
              path: inventoryRoute,
              name: 'inventory',
              builder: (context, state) => const InventoryScreen(),
            ),
            
            // Reports
            GoRoute(
              path: reportsRoute,
              name: 'reports',
              builder: (context, state) => const ReportsScreen(),
            ),
            
            // Floor Plan Management
            GoRoute(
              path: floorPlanManagementRoute,
              name: 'floor-plan-management',
              builder: (context, state) => const FloorPlanManagementScreen(),
            ),
            
            // Profile
            GoRoute(
              path: profileRoute,
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            
            // Business Management
            GoRoute(
              path: businessRoute,
              name: 'business',
              builder: (context, state) => const BusinessListScreen(),
            ),
          ],
        ),
        
        // Waiter-specific routes
        GoRoute(
          path: waiterRoute,
          name: 'waiter',
          builder: (context, state) => const WaiterDashboardScreen(),
          routes: [
            GoRoute(
              path: 'tables',
              name: 'table-selection',
              builder: (context, state) => const TableSelectionScreen(),
            ),
            GoRoute(
              path: 'order/:tableId',
              name: 'order-taking',
              builder: (context, state) {
                final tableId = int.tryParse(state.pathParameters['tableId'] ?? '') ?? 0;
                final extra = state.extra as Map<String, dynamic>?;
                
                print('🔍 DEBUG: Waiter order route builder called');
                print('🔍 DEBUG: tableId from path: $tableId');
                print('🔍 DEBUG: extra: $extra');
                print('🔍 DEBUG: extra table type: ${extra?['table']?.runtimeType}');
                
                // Check if we have a complete Table object
                waiter_table.Table? table;
                if (extra != null && extra['table'] is waiter_table.Table) {
                  table = extra['table'] as waiter_table.Table;
                  print('🔍 DEBUG: Using complete Table object');
                  print('🔍 DEBUG: Table customer: ${table.customer}');
                  print('🔍 DEBUG: Table customerName: ${table.customerName}');
                  print('🔍 DEBUG: Table notes: ${table.notes}');
                } else {
                  print('🔍 DEBUG: Using fallback map data');
                  // Fallback to map data
                  final tableData = extra?['table'] as Map<String, dynamic>?;
                  
                  // Convert JSON map to Table object
                  table = tableData != null ? waiter_table.Table.fromJson({
                    'id': tableData['id'] ?? tableId,
                    'businessId': 1, // Default business ID
                    'name': tableData['tableNumber'] ?? tableData['name'] ?? 'Table $tableId',
                    'status': tableData['status'] ?? 'available',
                    'capacity': tableData['capacity'] ?? 4,
                    'location': tableData['section'] ?? tableData['location'] ?? 'Main Floor',
                    'isActive': true,
                  }) : waiter_table.Table(
                    id: tableId,
                    businessId: 1,
                    name: 'Table $tableId',
                    status: waiter_table.TableStatus.available,
                    capacity: 4,
                    location: 'Main Floor',
                    isActive: true,
                  );
                }
                
                print('🔍 DEBUG: Final table object:');
                print('🔍 DEBUG: - ID: ${table.id}');
                print('🔍 DEBUG: - Name: ${table.name}');
                print('🔍 DEBUG: - Customer: ${table.customer}');
                print('🔍 DEBUG: - Customer Name: ${table.customerName}');
                print('🔍 DEBUG: - Notes: ${table.notes}');
                
                return OrderTakingScreen(
                  table: table,
                  prefillOrder: extra?['prefillOrder'],
                );
              },
            ),
          ],
        ),
        
        // Kitchen/Bar routes
        GoRoute(
          path: kitchenRoute,
          name: 'kitchen',
          builder: (context, state) => const KitchenScreen(),
        ),
        
        GoRoute(
          path: barRoute,
          name: 'bar',
          builder: (context, state) => const BarScreen(),
        ),
        
        // Split billing route
        GoRoute(
          path: splitBillingRoute,
          name: 'split-billing',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>?;
            return SplitBillingScreen(
              table: args?['table'],
              cartItems: args?['cartItems'] ?? [],
            );
          },
        ),
        
        // Floor plan viewer route (waitstaff view)
        GoRoute(
          path: floorPlanViewerRoute,
          name: 'floor-plan-viewer',
          builder: (context, state) => const FloorPlanViewerScreen(),
        ),
        
        // Tables route (waitstaff view)
        GoRoute(
          path: tablesRoute,
          name: 'tables',
          builder: (context, state) => const TablesScreen(),
        ),
        
        // Messages route (waitstaff view)
        GoRoute(
          path: messagesRoute,
          name: 'messages',
          builder: (context, state) => const MessagesScreen(),
        ),
      ],
    );
  }

  /// Handle route redirects based on authentication and onboarding status
  static String? handleRedirect(BuildContext context, GoRouterState state, Ref ref) {
    debugPrint('🔵 Router: handleRedirect() called');
    debugPrint('🔵 Router: Current location: ${state.matchedLocation}');
    
    final authState = ref.read(authNotifierProvider);
    debugPrint('🔵 Router: Auth status: ${authState.status}');
    
    final onboardingCompleted = ref.read(onboardingCompletedProvider);
    debugPrint('🔵 Router: Onboarding completed: $onboardingCompleted');

    // 1. If onboarding not completed, always redirect to onboarding (except if already there)
    if (!onboardingCompleted && state.matchedLocation != onboardingRoute) {
      debugPrint('🔵 Router: Redirecting to onboarding');
      return onboardingRoute;
    }
    // 2. If onboarding not completed and already on onboarding, do not redirect
    if (!onboardingCompleted && state.matchedLocation == onboardingRoute) {
      debugPrint('🔵 Router: Already on onboarding, no redirect');
      return null;
    }
    // 3. If onboarding completed, but not authenticated, redirect to login (except if already there)
    if (onboardingCompleted &&
        (authState.status == AuthStatus.unauthenticated || authState.status == AuthStatus.initial) &&
        state.matchedLocation != loginRoute) {
      debugPrint('🔵 Router: Redirecting to login');
      return loginRoute;
    }
    // 4. If authenticated and on login, redirect to appropriate dashboard
    if (authState.status == AuthStatus.authenticated && state.matchedLocation == loginRoute) {
      final targetRoute = _getRoleBasedRoute(authState);
      debugPrint('🔵 Router: Authenticated user on login, redirecting to $targetRoute');
      return targetRoute;
    }
    // 5. If on root path and authenticated, redirect to appropriate dashboard
    if (state.matchedLocation == '/' && authState.status == AuthStatus.authenticated) {
      final targetRoute = _getRoleBasedRoute(authState);
      debugPrint('🔵 Router: On root path and authenticated user, redirecting to $targetRoute');
      return targetRoute;
    }
    // 6. If authenticated and not on a protected route, redirect to appropriate dashboard
    if (authState.status == AuthStatus.authenticated && 
        !_isProtectedRoute(state.matchedLocation)) {
      final targetRoute = _getRoleBasedRoute(authState);
      debugPrint('🔵 Router: Authenticated user on unprotected route, redirecting to $targetRoute');
      return targetRoute;
    }
    // 7. If on root path and onboarding completed but not authenticated, redirect to login
    if (state.matchedLocation == '/' && onboardingCompleted && 
        (authState.status == AuthStatus.unauthenticated || authState.status == AuthStatus.initial)) {
      debugPrint('🔵 Router: On root path, onboarding completed, not authenticated, redirecting to login');
      return loginRoute;
    }
    // No redirect needed
    debugPrint('🔵 Router: No redirect needed');
    return null;
  }

  /// Check if a route is protected (requires authentication)
  static bool _isProtectedRoute(String location) {
    return location == dashboardRoute ||
           location == analyticsRoute ||
           location == featureDashboardRoute ||
           location == smartSuggestionsRoute ||
           location == inventoryAlertsRoute ||
           location == promotionsRoute ||
           location == posRoute ||
           location == inventoryRoute ||
           location == reportsRoute ||
           location == floorPlanViewerRoute ||
           location == floorPlanManagementRoute ||
           location == tablesRoute ||
           location == messagesRoute ||
           location == profileRoute ||
           location == businessRoute ||
           location == waiterRoute ||
           location.startsWith('$waiterRoute/') ||
           location == kitchenRoute ||
           location == barRoute ||
           location == splitBillingRoute;
  }

  /// Get the appropriate route based on user role and assignment
  static String _getRoleBasedRoute(AuthState authState) {
    final user = authState.user;
    if (user == null) return dashboardRoute;

    switch (user.role) {
      case UserRole.viewer:
        final assignment = user.assignment?.toLowerCase();
        if (assignment == 'kitchen' || assignment == 'kitchen_read') {
          return kitchenRoute;
        } else if (assignment == 'bar' || assignment == 'bar_read') {
          return barRoute;
        } else {
          return dashboardRoute;
        }
      case UserRole.waiter:
      case UserRole.waitstaff:
        return dashboardRoute; // Use dashboard for waitstaff
      case UserRole.admin:
      case UserRole.owner:
      case UserRole.manager:
      case UserRole.cashier:
      case UserRole.kitchen_staff:
      default:
        return dashboardRoute;
    }
  }
}

/// Main app shell with bottom navigation
class _MainAppShell extends ConsumerWidget {
  final Widget child;

  const _MainAppShell({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    
    // Don't show shell if not authenticated
    if (authState.status != AuthStatus.authenticated) {
      return child;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(context, ref),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
    // Build navigation items based on user role
    final navigationItems = <BottomNavigationBarItem>[];
    final navigationRoutes = <String>[];
    
    // Dashboard - available to all authenticated users
    navigationItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ));
    navigationRoutes.add(AppRouter.dashboardRoute);
    
    // Analytics - available to admin, manager, and owner
    if (authState.canAccessAnalytics) {
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.analytics),
        label: 'Analytics',
      ));
      navigationRoutes.add(AppRouter.analyticsRoute);
    }
    
    // POS - available to non-admin, non-viewer, non-waitstaff users
    if (authState.canAccessPOS && 
        authState.user?.role != UserRole.waiter && 
        authState.user?.role != UserRole.waitstaff) {
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.point_of_sale),
        label: 'POS',
      ));
      navigationRoutes.add(AppRouter.posRoute);
    }
    
    // Inventory - available to non-viewer, non-waitstaff users
    if (!authState.canViewOnly && 
        authState.user?.role != UserRole.waiter && 
        authState.user?.role != UserRole.waitstaff) {
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.inventory),
        label: 'Inventory',
      ));
      navigationRoutes.add(AppRouter.inventoryRoute);
    }
    
        // Reports - available to admin and manager
    if (authState.canAccessReports) {
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.assessment),
        label: 'Reports',
      ));
      navigationRoutes.add(AppRouter.reportsRoute);
    }
    
    // Floor Plans - available to admin, owner, and manager
    if (authState.canAccessFloorPlans) {
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Floor Plans',
      ));
      navigationRoutes.add(AppRouter.floorPlanManagementRoute);
    }
    
    // Waitstaff-specific navigation
    if (authState.user?.role == UserRole.waiter || authState.user?.role == UserRole.waitstaff) {
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Floor Plan',
      ));
      navigationRoutes.add(AppRouter.floorPlanViewerRoute);
      
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Messages',
      ));
      navigationRoutes.add(AppRouter.messagesRoute);
    }
    
    // Profile - available to all authenticated users
    navigationItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ));
    navigationRoutes.add(AppRouter.profileRoute);
    
    // Determine current index based on route
    int currentIndex = navigationRoutes.indexOf(currentLocation);
    if (currentIndex == -1) currentIndex = 0;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index < navigationRoutes.length) {
          context.go(navigationRoutes[index]);
        }
      },
      items: navigationItems,
    );
  }
}

/// Riverpod provider for GoRouter that reacts to auth state changes
final goRouterProvider = Provider<GoRouter>((ref) {
  // Watch auth state to trigger router rebuilds
  final authState = ref.watch(authNotifierProvider);
  debugPrint('🔵 GoRouter: Rebuilding router, auth status: ${authState.status}');
  return AppRouter.createRouter(ref);
}); 