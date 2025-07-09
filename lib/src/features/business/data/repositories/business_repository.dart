import '../../../../shared/models/result.dart';
import '../../models/business.dart';

/// Abstract interface for business repository
abstract class BusinessRepository {
  /// Get all businesses for the current user
  Future<Result<List<Business>>> getBusinesses();

  /// Get a specific business by ID
  Future<Result<Business>> getBusiness(int id);

  /// Create a new business
  Future<Result<Business>> createBusiness(Business business);

  /// Update an existing business
  Future<Result<Business>> updateBusiness(Business business);

  /// Delete a business
  Future<Result<void>> deleteBusiness(int id);

  /// Get business statistics
  Future<Result<Map<String, dynamic>>> getBusinessStats(int businessId);

  /// Get business settings
  Future<Result<Map<String, dynamic>>> getBusinessSettings(int businessId);

  /// Update business settings
  Future<Result<Map<String, dynamic>>> updateBusinessSettings(
    int businessId,
    Map<String, dynamic> settings,
  );
} 