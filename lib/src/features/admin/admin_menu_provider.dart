import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/config/env_config.dart';
import '../auth/auth_provider.dart';
import 'models/admin_menu_item.dart';

// Repository for admin menu operations
class AdminMenuRepository {
  final Dio _dio;

  AdminMenuRepository(this._dio);

  Future<List<AdminBusiness>> getBusinesses() async {
    try {
      print('🔍 DEBUG: Loading businesses...');
      final response = await _dio.get('/businesses');
      print('🔍 DEBUG: Businesses response: ${response.statusCode}');
      final responseData = response.data;
      print('🔍 DEBUG: Businesses data type: ${responseData.runtimeType}');
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as List<dynamic>
          : responseData as List<dynamic>;
      
      final businesses = data.map((json) => AdminBusiness.fromJson(json as Map<String, dynamic>)).toList();
      print('🔍 DEBUG: Loaded ${businesses.length} businesses');
      return businesses;
    } catch (e) {
      print('❌ ERROR: Failed to load businesses: $e');
      throw Exception('Failed to load businesses: $e');
    }
  }

  Future<List<AdminCategory>> getCategories({int? businessId}) async {
    try {
      print('🔍 DEBUG: Loading categories for businessId: $businessId');
      final queryParams = <String, dynamic>{};
      if (businessId != null) queryParams['businessId'] = businessId;

      final response = await _dio.get('/menu/categories', queryParameters: queryParams);
      print('🔍 DEBUG: Categories response: ${response.statusCode}');
      final responseData = response.data;
      print('🔍 DEBUG: Categories data type: ${responseData.runtimeType}');
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as List<dynamic>
          : responseData as List<dynamic>;
      
      final categories = data.map((json) => AdminCategory.fromJson(json as Map<String, dynamic>)).toList();
      print('🔍 DEBUG: Loaded ${categories.length} categories');
      return categories;
    } catch (e) {
      print('❌ ERROR: Failed to load categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<AdminMenuItem>> getMenuItems({
    String? businessId,
    String? categoryId,
    String? search,
    bool? availableOnly,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      // Always include businessId, default to 1 if not provided
      queryParams['businessId'] = businessId ?? 1;
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (availableOnly != null) queryParams['available'] = availableOnly;

      print('🔍 DEBUG: Loading menu items with params: $queryParams');
      final response = await _dio.get('/menu/items', queryParameters: queryParams);
      print('🔍 DEBUG: Menu items response: ${response.statusCode}');
      final responseData = response.data;
      print('🔍 DEBUG: Menu items data type: ${responseData.runtimeType}');
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as List<dynamic>
          : responseData as List<dynamic>;

      print('🔍 DEBUG: Parsing ${data.length} menu items...');
      final menuItems = <AdminMenuItem>[];
      
      for (int i = 0; i < data.length; i++) {
        try {
          final json = data[i] as Map<String, dynamic>;
          print('🔍 DEBUG: Parsing item $i: ${json['name']}');
          final item = AdminMenuItem.fromJson(json);
          menuItems.add(item);
          print('🔍 DEBUG: Successfully parsed item $i');
        } catch (e) {
          print('❌ ERROR: Failed to parse item $i: $e');
          print('❌ ERROR: Item data: ${data[i]}');
        }
      }
      
      print('🔍 DEBUG: Successfully parsed ${menuItems.length} menu items');
      return menuItems;
    } catch (e) {
      print('❌ ERROR: Failed to load menu items: $e');
      throw Exception('Failed to load menu items: $e');
    }
  }

  Future<AdminMenuItem> getMenuItemById(int id) async {
    try {
      final response = await _dio.get('/menu/items/$id');
      final responseData = response.data;
      final data = responseData is Map<String, dynamic> && responseData.containsKey('data')
          ? responseData['data'] as Map<String, dynamic>
          : responseData as Map<String, dynamic>;

      return AdminMenuItem.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load menu item: $e');
    }
  }

  Future<void> createMenuItem({
    required String name,
    required String description,
    required double price,
    required int businessId,
    required int categoryId,
    String? imageUrl,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'price': price,
        'businessId': businessId,
        'categoryId': categoryId,
      };
      
      if (imageUrl != null && imageUrl.isNotEmpty) {
        data['imageUrl'] = imageUrl;
      }

      await _dio.post('/menu/items', data: data);
    } catch (e) {
      throw Exception('Failed to create menu item: $e');
    }
  }

  Future<void> updateMenuItem({
    required int id,
    required String name,
    required String description,
    required double price,
    required int businessId,
    required int categoryId,
    String? imageUrl,
    bool? isAvailable,
  }) async {
    try {
      final payload = {
        'name': name,
        'description': description,
        'price': price,
        'businessId': businessId,
        'categoryId': categoryId,
      };
      
      if (imageUrl != null && imageUrl.isNotEmpty) {
        payload['imageUrl'] = imageUrl;
      }
      
      if (isAvailable != null) {
        payload['isAvailable'] = isAvailable;
      }

      await _dio.put('/menu/items/$id', data: payload);
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  Future<void> deleteMenuItem(int id) async {
    try {
      await _dio.delete('/menu/items/$id');
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  Future<void> toggleMenuItemAvailability(int id, bool isAvailable) async {
    try {
      await _dio.put('/menu/items/$id', data: {
        'isAvailable': isAvailable,
      });
    } catch (e) {
      throw Exception('Failed to toggle menu item availability: $e');
    }
  }
}

// Provider for the repository
final adminMenuRepositoryProvider = Provider<AdminMenuRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AdminMenuRepository(dio);
});

// Notifier for admin menu state management
class AdminMenuNotifier extends StateNotifier<AsyncValue<List<AdminMenuItem>>> {
  final AdminMenuRepository _repository;
  final Ref _ref;
  int? _selectedBusinessId;
  
  // Store current filters for refresh operations
  String? _currentBusinessId;
  String? _currentCategoryId;
  String? _currentSearch;
  bool? _currentAvailableOnly;

  AdminMenuNotifier(this._repository, this._ref) : super(const AsyncValue.loading());

  int? get selectedBusinessId => _selectedBusinessId;

  void setSelectedBusiness(int businessId) {
    _selectedBusinessId = businessId;
  }

  Future<void> loadMenuItems({
    String? businessId,
    String? categoryId,
    String? search,
    bool? availableOnly,
  }) async {
    // Set the selected business ID if provided
    if (businessId != null) {
      _selectedBusinessId = int.tryParse(businessId);
    }
    
    // Store current filters for refresh operations
    _currentBusinessId = businessId;
    _currentCategoryId = categoryId;
    _currentSearch = search;
    _currentAvailableOnly = availableOnly;
    
    state = const AsyncValue.loading();
    try {
      final menuItems = await _repository.getMenuItems(
        businessId: businessId,
        categoryId: categoryId,
        search: search,
        availableOnly: availableOnly,
      );
      state = AsyncValue.data(menuItems);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadBusinesses() async {
    try {
      await _repository.getBusinesses();
    } catch (error) {
      print('Error loading businesses: $error');
    }
  }

  Future<void> loadCategories({int? businessId}) async {
    try {
      await _repository.getCategories(businessId: businessId ?? _selectedBusinessId);
    } catch (error) {
      print('Error loading categories: $error');
    }
  }

  Future<void> createMenuItem({
    required String name,
    required String description,
    required double price,
    required int businessId,
    required int categoryId,
    String? imageUrl,
  }) async {
    try {
      await _repository.createMenuItem(
        name: name,
        description: description,
        price: price,
        businessId: businessId,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      // Refresh the menu items with current filters after creation
      await loadMenuItems(
        businessId: _currentBusinessId,
        categoryId: _currentCategoryId,
        search: _currentSearch,
        availableOnly: _currentAvailableOnly,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateMenuItem({
    required int id,
    required String name,
    required String description,
    required double price,
    required int businessId,
    required int categoryId,
    String? imageUrl,
    bool? isAvailable,
  }) async {
    try {
      await _repository.updateMenuItem(
        id: id,
        name: name,
        description: description,
        price: price,
        businessId: businessId,
        categoryId: categoryId,
        imageUrl: imageUrl,
        isAvailable: isAvailable,
      );
      // Refresh the menu items with current filters after update
      await loadMenuItems(
        businessId: _currentBusinessId,
        categoryId: _currentCategoryId,
        search: _currentSearch,
        availableOnly: _currentAvailableOnly,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteMenuItem(int id) async {
    try {
      await _repository.deleteMenuItem(id);
      // Refresh the menu items with current filters after deletion
      await loadMenuItems(
        businessId: _currentBusinessId,
        categoryId: _currentCategoryId,
        search: _currentSearch,
        availableOnly: _currentAvailableOnly,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> toggleMenuItemAvailability(int id, bool isAvailable) async {
    try {
      await _repository.toggleMenuItemAvailability(id, isAvailable);
      // Refresh the menu items after toggle
      await loadMenuItems();
    } catch (error) {
      rethrow;
    }
  }
}

// Provider for the notifier
final adminMenuProvider = StateNotifierProvider<AdminMenuNotifier, AsyncValue<List<AdminMenuItem>>>(
  (ref) => AdminMenuNotifier(
    ref.watch(adminMenuRepositoryProvider),
    ref,
  ),
);

// Providers for businesses and categories
final adminBusinessesProvider = FutureProvider<List<AdminBusiness>>((ref) async {
  try {
    final repository = ref.watch(adminMenuRepositoryProvider);
    return await repository.getBusinesses();
  } catch (e) {
    print('❌ ERROR: Failed to load businesses in provider: $e');
    return []; // Return empty list on error
  }
});

final adminCategoriesProvider = FutureProvider<List<AdminCategory>>((ref) async {
  try {
    final repository = ref.watch(adminMenuRepositoryProvider);
    // Get the selected business ID from the notifier
    final selectedBusinessId = ref.watch(adminMenuProvider.notifier).selectedBusinessId;
    return await repository.getCategories(businessId: selectedBusinessId);
  } catch (e) {
    print('❌ ERROR: Failed to load categories in provider: $e');
    return []; // Return empty list on error
  }
}); 