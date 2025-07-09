import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_repository.dart';
import 'auth_repository_impl.dart';
import 'models/user.dart';
import '../business/models/business.dart';

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
  bool get isKitchen => userRole == UserRole.kitchen;
  
  bool get canAccessBusinessManagement => userRole?.canAccessBusinessManagement ?? false;
  bool get canAccessPOS => userRole?.canAccessPOS ?? false;
  bool get canAccessKitchen => userRole?.canAccessKitchen ?? false;
  bool get canAccessReports => userRole?.canAccessReports ?? false;
  bool get canManageUsers => userRole?.canManageUsers ?? false;
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
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final repository = await ref.read(authRepositoryProvider.future);
      final loginResponse = await repository.login(
        email: email,
        password: password,
        businessSlug: businessSlug,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        token: loginResponse.token,
        user: loginResponse.user,
        business: loginResponse.business,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      final repository = await ref.read(authRepositoryProvider.future);
      await repository.logout();
      
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      
      final repository = await ref.read(authRepositoryProvider.future);
      final isLoggedIn = await repository.isLoggedIn().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );
      
      if (isLoggedIn) {
        state = state.copyWith(status: AuthStatus.authenticated);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

@riverpod
Future<AuthRepository> authRepository(AuthRepositoryRef ref) async {
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  return AuthRepositoryImpl(dio, prefs);
} 