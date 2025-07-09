import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'business_repository_provider.dart';
import 'models/business.dart';

part 'business_provider.g.dart';

@riverpod
class Businesses extends _$Businesses {
  @override
  Future<List<Business>> build() async {
    final repository = await ref.read(businessRepositoryProvider.future);
    return repository.getBusinesses();
  }

  Future<void> createBusiness(Business business) async {
    final repository = await ref.read(businessRepositoryProvider.future);
    await repository.createBusiness(business);
    ref.invalidateSelf();
  }

  Future<void> updateBusiness(Business business) async {
    final repository = await ref.read(businessRepositoryProvider.future);
    await repository.updateBusiness(business);
    ref.invalidateSelf();
  }

  Future<void> deleteBusiness(int businessId) async {
    final repository = await ref.read(businessRepositoryProvider.future);
    await repository.deleteBusiness(businessId);
    ref.invalidateSelf();
  }
}

@riverpod
class BusinessNotifier extends _$BusinessNotifier {
  @override
  Future<Business?> build(int businessId) async {
    if (businessId == 0) return null;
    final repository = await ref.read(businessRepositoryProvider.future);
    return repository.getBusiness(businessId);
  }

  Future<void> updateBusiness(Business business) async {
    final repository = await ref.read(businessRepositoryProvider.future);
    await repository.updateBusiness(business);
    ref.invalidateSelf();
  }
} 