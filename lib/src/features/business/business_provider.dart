import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repositories/business_repository_impl.dart';
import 'models/business.dart';

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