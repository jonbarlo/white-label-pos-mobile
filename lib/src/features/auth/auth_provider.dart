import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'models/user.dart';
import '../business/models/business.dart';
import '../business/data/repositories/business_repository_impl.dart';
import '../../core/config/env_config.dart';

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
  bool get canManageUsers => userRole?.canManageUsers ?? false;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    if (EnvConfig.isDebugMode) {
      print('🔐 AUTH PROVIDER: Building initial state - status: ${const AuthState().status}');
    }
    return const AuthState();
  }

  Future<void> login({
    required String email,
    required String password,
    required String businessSlug,
  }) async {
    if (EnvConfig.isDebugMode) {
      print('🔐 AUTH PROVIDER: Starting login process');
      print('🔐 AUTH PROVIDER: Business Slug: $businessSlug');
      print('🔐 AUTH PROVIDER: Email: $email');
      print('🔐 AUTH PROVIDER: Current state before login: ${state.status}');
    }
    
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final repository = ref.read(authRepositoryProvider);
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: Calling repository.login()');
      }
      final result = await repository.login(email, password, businessSlug);

      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: Repository result - isSuccess: ${result.isSuccess}');
        print('🔐 AUTH PROVIDER: Repository result - errorMessage: ${result.errorMessage}');
        print('🔐 AUTH PROVIDER: Repository result - data: ${result.data}');
      }

      if (result.isSuccess && result.data != null) {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: Login successful');
          print('🔐 AUTH PROVIDER: User: ${result.data!.user.name}');
          print('🔐 AUTH PROVIDER: Business: ${result.data!.business.name}');
          print('🔐 AUTH PROVIDER: Token received');
          print('🔐 AUTH PROVIDER: Setting state to authenticated');
        }

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: result.data!.user,
          business: result.data!.business,
          token: result.data!.token,
          errorMessage: null,
        );
        
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: State after successful login: ${state.status}');
        }
      } else {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: Login failed - ${result.errorMessage}');
          print('🔐 AUTH PROVIDER: Setting state to error');
        }
        
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: result.errorMessage,
        );
        
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: State after failed login: ${state.status}');
        }
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: Login failed - Error: ${e.toString()}');
        print('🔐 AUTH PROVIDER: Setting state to error with message');
      }
      
      // When API is unreachable, show error message to user
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: State after error: ${state.status}');
        print('🔐 AUTH PROVIDER: Error message: ${state.errorMessage}');
      }
    }
  }

  Future<void> logout() async {
    if (EnvConfig.isDebugMode) {
      print('🔐 AUTH PROVIDER: Logging out');
    }
    
    try {
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.logout();
      
      if (result.isSuccess) {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: Logout successful');
        }
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: Logout failed - ${result.errorMessage}');
        }
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: result.errorMessage,
        );
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: Logout failed - Error: ${e.toString()}');
      }
      
      // Even if logout fails, clear the auth state
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> checkAuthStatus() async {
    if (EnvConfig.isDebugMode) {
      print('🔐 AUTH PROVIDER: Checking authentication status');
    }
    
    try {
      state = state.copyWith(status: AuthStatus.loading);
      
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.getCurrentUser().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          if (EnvConfig.isDebugMode) {
            print('🔐 AUTH PROVIDER: Authentication check timed out');
          }
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );
      
      if (result.isSuccess && result.data != null) {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: User is authenticated');
          print('🔐 AUTH PROVIDER: Current user: ${result.data!.name}');
          print('🔐 AUTH PROVIDER: User businessId: ${result.data!.businessId}');
        }
        
        // Preserve existing business data if available, otherwise we'll need to fetch it
        final currentBusiness = state.business;
        
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: result.data,
          business: currentBusiness, // Preserve existing business data
        );
        
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: Preserved business data: ${currentBusiness?.name} (ID: ${currentBusiness?.id})');
        }
        
        // If business data is missing, try to fetch it
        if (currentBusiness == null) {
          await fetchBusinessDataIfNeeded();
        }
      } else {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: User is not authenticated - ${result.errorMessage}');
        }
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: Authentication check failed - Error: ${e.toString()}');
      }
      
      // When API is unreachable, treat user as unauthenticated (not error)
      // This ensures they are redirected to login screen
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Clear any error state and reset to unauthenticated
  void clearError() {
    if (EnvConfig.isDebugMode) {
      print('🔐 AUTH PROVIDER: Clearing error state');
    }
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Fetch business data if it's missing from auth state
  Future<void> fetchBusinessDataIfNeeded() async {
    if (state.business != null) {
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: Business data already available: ${state.business!.name}');
      }
      return;
    }

    if (state.user?.businessId == null) {
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: No business ID available from user data');
      }
      return;
    }

    if (EnvConfig.isDebugMode) {
      print('🔐 AUTH PROVIDER: Fetching business data for ID: ${state.user!.businessId}');
    }

    try {
      // Import the business repository
      final businessRepository = ref.read(businessRepositoryProvider);
      final result = await businessRepository.getBusiness(state.user!.businessId);

      if (result.isSuccess && result.data != null) {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: Successfully fetched business: ${result.data!.name}');
        }
        state = state.copyWith(business: result.data);
      } else {
        if (EnvConfig.isDebugMode) {
          print('🔐 AUTH PROVIDER: Failed to fetch business: ${result.errorMessage}');
        }
      }
    } catch (e) {
      if (EnvConfig.isDebugMode) {
        print('🔐 AUTH PROVIDER: Error fetching business data: $e');
      }
    }
  }
}

 