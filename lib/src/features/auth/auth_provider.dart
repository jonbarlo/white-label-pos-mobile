import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'models/user.dart';
import '../business/models/business.dart';
import '../business/data/repositories/business_repository_impl.dart';
import '../language/language_provider.dart';
import 'package:flutter/foundation.dart';

part 'auth_provider.g.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? token;
  final User? user;
  final Business? business;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.user,
    this.business,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    User? user,
    Business? business,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      user: user ?? this.user,
      business: business ?? this.business,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Helper getters for role-based access
  UserRole? get userRole => user?.role;
  bool get isAdmin => userRole == UserRole.admin;
  bool get isManager => userRole == UserRole.manager;
  bool get isCashier => userRole == UserRole.cashier;
  bool get isKitchen => userRole == UserRole.viewer && user?.assignment?.toLowerCase() == 'kitchen';
  
  bool get canAccessBusinessManagement => userRole?.canAccessBusinessManagement ?? false;
  bool get canAccessPOS => userRole?.canAccessPOS ?? false;
  bool get canAccessKitchen => userRole?.canAccessKitchen ?? false;
  bool get canAccessWaiterDashboard => userRole?.canAccessWaiterDashboard ?? false;
  bool get canAccessReports => userRole?.canAccessReports ?? false;
  bool get canAccessAnalytics => userRole?.canAccessAnalytics ?? false;
  bool get canAccessBasicAnalytics => userRole?.canAccessBasicAnalytics ?? false;
  bool get canManageUsers => userRole?.canManageUsers ?? false;
  bool get canAccessFloorPlans => userRole?.canAccessFloorPlans ?? false;
  bool get canViewOnly => userRole == UserRole.viewer;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> login({
    required String email,
    required String password,
    required String businessSlug,
  }) async {
    debugPrint('🔵 AuthNotifier: login() called');
    debugPrint('🔵 AuthNotifier: Email: $email');
    debugPrint('🔵 AuthNotifier: Business Slug: $businessSlug');
    debugPrint('🔵 AuthNotifier: Password length: ${password.length}');
    
    state = state.copyWith(status: AuthStatus.loading);
    debugPrint('🔵 AuthNotifier: State set to loading');

    try {
      debugPrint('🔵 AuthNotifier: Getting repository');
      final repository = ref.read(authRepositoryProvider);
      debugPrint('🔵 AuthNotifier: Calling repository.login()');
      final result = await repository.login(email, password, businessSlug);
      debugPrint('🔵 AuthNotifier: Repository call completed');

      if (result.isSuccess) {
        debugPrint('🔵 AuthNotifier: Login successful');
        debugPrint('🔵 AuthNotifier: User: ${result.data.user.name}');
        debugPrint('🔵 AuthNotifier: Business: ${result.data.business.name}');
        
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: result.data.user,
          business: result.data.business,
          token: result.data.token,
          errorMessage: null,
        );
        debugPrint('🔵 AuthNotifier: State set to authenticated');
        
        // Initialize language preferences after successful login
        await _initializeLanguagePreferences();
      } else {
        debugPrint('🔴 AuthNotifier: Login failed');
        debugPrint('🔴 AuthNotifier: Error: ${result.errorMessage}');
        
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: result.errorMessage,
        );
        debugPrint('🔴 AuthNotifier: State set to error');
      }
    } catch (e) {
      debugPrint('🔴 AuthNotifier: Exception caught: $e');
      
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      debugPrint('🔴 AuthNotifier: State set to error due to exception');
    }
  }

  // Initialize language preferences after login
  Future<void> _initializeLanguagePreferences() async {
    try {
      debugPrint('🌐 AuthNotifier: Initializing language preferences...');
      final languageNotifier = ref.read(languageNotifierProvider.notifier);
      await languageNotifier.initializeLanguage();
      debugPrint('🌐 AuthNotifier: Language preferences initialized');
    } catch (e) {
      debugPrint('⚠️ AuthNotifier: Failed to initialize language preferences: $e');
      // Don't fail the login if language initialization fails
    }
  }

  Future<void> logout() async {
    
    try {
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.logout();
      
      if (result.isSuccess) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: result.errorMessage,
        );
      }
    } catch (e) {
      
      // Even if logout fails, clear the auth state
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> checkAuthStatus() async {
    
    try {
      state = state.copyWith(status: AuthStatus.loading);
      
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.getCurrentUser().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );
      
      if (result.isSuccess) {
        
        // Preserve existing business data if available, otherwise we'll need to fetch it
        final currentBusiness = state.business;
        
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: result.data,
          business: currentBusiness, // Preserve existing business data
        );
        
        // If business data is missing, try to fetch it
        if (currentBusiness == null) {
          await fetchBusinessDataIfNeeded();
        }
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      
      // When API is unreachable, treat user as unauthenticated (not error)
      // This ensures they are redirected to login screen
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Clear any error state and reset to unauthenticated
  void clearError() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Fetch business data if it's missing from auth state
  Future<void> fetchBusinessDataIfNeeded() async {
    if (state.business != null) {
      return;
    }

    if (state.user?.businessId == null) {
      return;
    }

    try {
      // Import the business repository
      final businessRepository = ref.read(businessRepositoryProvider);
      final result = await businessRepository.getBusiness(state.user!.businessId);

      if (result.isSuccess) {
        state = state.copyWith(business: result.data);
      } else {
      }
    } catch (e) {
    }
  }
}

 