import 'models/business.dart';

abstract class BusinessRepository {
  Future<List<Business>> getBusinesses();
  Future<Business?> getBusiness(int businessId);
  Future<Business> createBusiness(Business business);
  Future<Business> updateBusiness(Business business);
  Future<void> deleteBusiness(int businessId);
} 