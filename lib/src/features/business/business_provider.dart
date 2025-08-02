import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repositories/business_repository_impl.dart';
import 'models/business.dart';
import '../auth/auth_provider.dart';
import '../../shared/utils/currency_formatter.dart';

/// Provider to get business by slug
final businessBySlugProvider = FutureProvider.family<Business?, String>((ref, slug) async {
  debugPrint('🔵 BusinessProvider: businessBySlugProvider called with slug: "$slug"');
  if (slug.isEmpty) {
    debugPrint('🔵 BusinessProvider: slug is empty, returning null');
    return null;
  }
  
  final repository = ref.watch(businessRepositoryProvider);
  debugPrint('🔵 BusinessProvider: calling repository.getBusinessBySlug');
  final result = await repository.getBusinessBySlug(slug);
  
  if (result.isSuccess) {
    debugPrint('🔵 BusinessProvider: Success! Business: ${result.data?.name ?? 'null'}');
    return result.data;
  } else {
    debugPrint('🔵 BusinessProvider: Error: ${result.errorMessage}');
    // Return null if business not found, don't throw error
    return null;
  }
});

/// Provider to get all businesses
final businessesProvider = FutureProvider<List<Business>>((ref) async {
  final repository = ref.watch(businessRepositoryProvider);
  final result = await repository.getBusinesses();
  
  if (result.isSuccess) {
    return result.data;
  } else {
    throw Exception(result.errorMessage);
  }
});

/// Provider to get business by ID
final businessByIdProvider = FutureProvider.family<Business?, int>((ref, id) async {
  final repository = ref.watch(businessRepositoryProvider);
  final result = await repository.getBusiness(id);
  
  if (result.isSuccess) {
    return result.data;
  } else {
    return null;
  }
});

// Provider for current business currency information
final currentBusinessCurrencyProvider = Provider<Map<String, dynamic>>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  if (authState.status == AuthStatus.authenticated && authState.business != null) {
    final business = authState.business!;
    return {
      'currencyId': business.currencyId,
      'symbol': CurrencyFormatter.getCurrencySymbol(business.currencyId),
      'code': CurrencyFormatter.getCurrencyCode(business.currencyId),
    };
  }
  
  // Default to CRC if not authenticated or no business
  return {
    'currencyId': 2,
    'symbol': '₡',
    'code': 'CRC',
  };
});

// Provider for current business currency symbol
final currentBusinessCurrencySymbolProvider = Provider<String>((ref) {
  final currencyData = ref.watch(currentBusinessCurrencyProvider);
  return currencyData['symbol'] as String;
});

// Provider for current business currency ID
final currentBusinessCurrencyIdProvider = Provider<int>((ref) {
  final currencyData = ref.watch(currentBusinessCurrencyProvider);
  return currencyData['currencyId'] as int;
}); 