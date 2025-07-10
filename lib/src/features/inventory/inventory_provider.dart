import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_repository.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';


part 'inventory_provider.g.dart';

@riverpod
InventoryRepository inventoryRepository(InventoryRepositoryRef ref) {
  // This will be overridden in tests and dependency injection
  throw UnimplementedError('inventoryRepository must be overridden');
}

@riverpod
Future<List<InventoryItem>> inventoryItems(InventoryItemsRef ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  final result = await repository.getInventoryItems();
  if (result.isSuccess) {
    return result.data;
  } else {
    throw Exception(result.errorMessage);
  }
}

@riverpod
Future<List<InventoryItem>> lowStockItems(LowStockItemsRef ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  final result = await repository.getLowStockItems();
  if (result.isSuccess) {
    return result.data;
  } else {
    throw Exception(result.errorMessage);
  }
}

@riverpod
Future<List<String>> categories(CategoriesRef ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  final result = await repository.getCategories();
  if (result.isSuccess) {
    return result.data;
  } else {
    throw Exception(result.errorMessage);
  }
}

@riverpod
class Inventory extends _$Inventory {
  @override
  InventoryState build() {
    return const InventoryState();
  }

  Future<void> loadInventoryItems() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.getInventoryItems();
      
      if (result.isSuccess) {
        state = state.copyWith(
          items: result.data,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createInventoryItem(InventoryItem item) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.createInventoryItem(item);
      
      if (result.isSuccess) {
        // Reload the list after successful creation
        loadInventoryItems();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.updateInventoryItem(item);
      
      if (result.isSuccess) {
        // Reload the list after successful update
        loadInventoryItems();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteInventoryItem(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.deleteInventoryItem(id);
      
      if (result.isSuccess) {
        if (result.data) {
          // Reload the list after successful deletion
          loadInventoryItems();
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Item not found',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateStockLevel(String id, int newQuantity) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.updateStockLevel(id, newQuantity);
      
      if (result.isSuccess) {
        // Reload the list after successful update
        loadInventoryItems();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchItems(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        searchResults: [],
        searchQuery: '',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.searchItems(query);
      
      if (result.isSuccess) {
        state = state.copyWith(
          searchResults: result.data,
          searchQuery: query,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(
      searchResults: [],
      searchQuery: '',
    );
  }

  Future<void> filterByCategory(String category) async {
    if (category.isEmpty) {
      state = state.copyWith(
        filteredItems: [],
        selectedCategory: null,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.getItemsByCategory(category);
      
      if (result.isSuccess) {
        state = state.copyWith(
          filteredItems: result.data,
          selectedCategory: category,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearCategoryFilter() {
    state = state.copyWith(
      filteredItems: [],
      selectedCategory: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class InventoryState {
  final List<InventoryItem> items;
  final List<InventoryItem> searchResults;
  final List<InventoryItem> filteredItems;
  final String searchQuery;
  final String? selectedCategory;
  final bool isLoading;
  final String? error;

  const InventoryState({
    this.items = const [],
    this.searchResults = const [],
    this.filteredItems = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.isLoading = false,
    this.error,
  });

  InventoryState copyWith({
    List<InventoryItem>? items,
    List<InventoryItem>? searchResults,
    List<InventoryItem>? filteredItems,
    String? searchQuery,
    String? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return InventoryState(
      items: items ?? this.items,
      searchResults: searchResults ?? this.searchResults,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<InventoryItem> get displayItems {
    if (searchResults.isNotEmpty) {
      return searchResults;
    }
    if (filteredItems.isNotEmpty) {
      return filteredItems;
    }
    return items;
  }

  List<InventoryItem> get lowStockItems {
    return items.where((item) => item.isLowStock).toList();
  }

  List<InventoryItem> get outOfStockItems {
    return items.where((item) => item.isOutOfStock).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryState &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          searchResults == other.searchResults &&
          filteredItems == other.filteredItems &&
          searchQuery == other.searchQuery &&
          selectedCategory == other.selectedCategory &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode =>
      items.hashCode ^
      searchResults.hashCode ^
      filteredItems.hashCode ^
      searchQuery.hashCode ^
      selectedCategory.hashCode ^
      isLoading.hashCode ^
      error.hashCode;
} 