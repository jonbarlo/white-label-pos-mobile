import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/pos/pos_screen.dart';
import '../features/inventory/inventory_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/users/profile_screen.dart';
import '../features/business/business_list_screen.dart';
import '../core/config/env_config.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  int _currentIndex = 0;
  bool _authChecked = false;
  bool _onboardingChecked = false;
  bool _onboardingCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingAndAuth();
  }

  Future<void> _checkOnboardingAndAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    
    setState(() {
      _onboardingCompleted = onboardingCompleted;
      _onboardingChecked = true;
    });

    // Check authentication status after onboarding check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
      setState(() {
        _authChecked = true;
      });
    });
  }

  void _onOnboardingComplete() {
    setState(() {
      _onboardingCompleted = true;
    });
  }

  List<Widget> _getScreensForRole(AuthState authState) {
    if (authState.isAdmin) {
      // Admin screens - no POS, includes business management
      return [
        const DashboardScreen(),
        const BusinessListScreen(),
        const InventoryScreen(),
        const ReportsScreen(),
        const ProfileScreen(),
      ];
    } else {
      // Non-admin screens - includes POS, no business management
      return [
        const DashboardScreen(),
        const PosScreen(),
        const InventoryScreen(),
        const ReportsScreen(),
        const ProfileScreen(),
      ];
    }
  }

  List<BottomNavigationBarItem> _getNavigationItemsForRole(AuthState authState) {
    if (authState.isAdmin) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Businesses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale),
          label: 'POS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    if (EnvConfig.isDebugMode) {
      print('🔐 MAIN APP: Building with auth state: ${authState.status}');
      print('🔐 MAIN APP: Onboarding checked: $_onboardingChecked');
      print('🔐 MAIN APP: Auth checked: $_authChecked');
      print('🔐 MAIN APP: Onboarding completed: $_onboardingCompleted');
    }

    // Show loading screen while checking onboarding and auth status
    if (!_onboardingChecked || !_authChecked || authState.status == AuthStatus.initial) {
      if (EnvConfig.isDebugMode) {
        print('🔐 MAIN APP: Showing loading screen');
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show onboarding screen if not completed
    if (!_onboardingCompleted) {
      if (EnvConfig.isDebugMode) {
        print('🔐 MAIN APP: Showing onboarding screen');
      }
      return OnboardingScreen(
        onOnboardingComplete: _onOnboardingComplete,
      );
    }

    // Show login screen if not authenticated
    if (authState.status == AuthStatus.unauthenticated || 
        authState.status == AuthStatus.error ||
        authState.status == AuthStatus.loading ||
        authState.user == null) {
      if (EnvConfig.isDebugMode) {
        print('🔐 MAIN APP: Showing login screen - user not authenticated');
        print('🔐 MAIN APP: Status: ${authState.status}');
        print('🔐 MAIN APP: User: ${authState.user}');
      }
      return const LoginScreen();
    }

    // Show main app with role-based navigation if authenticated
    if (EnvConfig.isDebugMode) {
      print('🔐 MAIN APP: Showing main app - user is authenticated');
      print('🔐 MAIN APP: User role: ${authState.userRole}');
      print('🔐 MAIN APP: User name: ${authState.user?.name}');
    }
    
    final screens = _getScreensForRole(authState);
    final navigationItems = _getNavigationItemsForRole(authState);

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navigationItems,
      ),
    );
  }
} 