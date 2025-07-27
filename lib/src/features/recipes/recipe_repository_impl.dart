import 'package:dio/dio.dart';
import 'recipe_repository.dart';
import 'models/recipe.dart';
import '../../core/network/dio_client.dart';
import '../auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final Dio _dio;
  final Ref _ref;

  RecipeRepositoryImpl(this._dio, this._ref);

  @override
  Future<List<Recipe>> getRecipes({int? businessId}) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final effectiveBusinessId = businessId ?? authState.business?.id;
      
      if (effectiveBusinessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/recipes', queryParameters: {
        'businessId': effectiveBusinessId,
      });

      final responseData = response.data;
      List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        data = responseData['data'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        data = responseData;
      } else {
        throw Exception('Unexpected response format');
      }
      
      return data.map((json) => _mapApiResponseToRecipe(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get recipes: ${e.message}');
    }
  }

  @override
  Future<Recipe> getRecipe(int recipeId) async {
    try {
      final response = await _dio.get('/recipes/$recipeId');
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return Recipe.fromJson(responseData['data']);
      } else {
        return Recipe.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to get recipe: ${e.message}');
    }
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      final response = await _dio.post('/recipes', data: recipe.toJson());
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return Recipe.fromJson(responseData['data']);
      } else {
        return Recipe.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to create recipe: ${e.message}');
    }
  }

  @override
  Future<Recipe> updateRecipe(int recipeId, Recipe recipe) async {
    try {
      final response = await _dio.put('/recipes/$recipeId', data: recipe.toJson());
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return Recipe.fromJson(responseData['data']);
      } else {
        return Recipe.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to update recipe: ${e.message}');
    }
  }

  @override
  Future<void> deleteRecipe(int recipeId) async {
    try {
      await _dio.delete('/recipes/$recipeId');
    } on DioException catch (e) {
      throw Exception('Failed to delete recipe: ${e.message}');
    }
  }

  @override
  Future<List<Recipe>> searchRecipes(String query, {int? businessId}) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final effectiveBusinessId = businessId ?? authState.business?.id;
      
      if (effectiveBusinessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/recipes/search', queryParameters: {
        'q': query,
        'businessId': effectiveBusinessId,
      });

      final responseData = response.data;
      List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        data = responseData['data'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        data = responseData;
      } else {
        throw Exception('Unexpected response format');
      }
      
      return data.map((json) => _mapApiResponseToRecipe(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to search recipes: ${e.message}');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByDifficulty(RecipeDifficulty difficulty, {int? businessId}) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final effectiveBusinessId = businessId ?? authState.business?.id;
      
      if (effectiveBusinessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/recipes/difficulty/${difficulty.name}', queryParameters: {
        'businessId': effectiveBusinessId,
      });

      final responseData = response.data;
      List<dynamic> data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        data = responseData['data'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        data = responseData;
      } else {
        throw Exception('Unexpected response format');
      }
      
      return data.map((json) => _mapApiResponseToRecipe(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get recipes by difficulty: ${e.message}');
    }
  }

  @override
  Future<RecipeStats> getRecipeStats({int? businessId}) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final effectiveBusinessId = businessId ?? authState.business?.id;
      
      if (effectiveBusinessId == null) {
        throw Exception('No businessId found in auth state');
      }

      final response = await _dio.get('/recipes/stats', queryParameters: {
        'businessId': effectiveBusinessId,
      });

      final responseData = response.data;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        return RecipeStats.fromJson(responseData['data']);
      } else {
        return RecipeStats.fromJson(responseData);
      }
    } on DioException catch (e) {
      throw Exception('Failed to get recipe stats: ${e.message}');
    }
  }

  /// Maps API response data to Recipe model
  Recipe _mapApiResponseToRecipe(Map<String, dynamic> json) {
    try {
      // Parse difficulty enum
      RecipeDifficulty difficulty;
      final difficultyStr = json['difficulty']?.toString().toLowerCase() ?? 'easy';
      switch (difficultyStr) {
        case 'easy':
          difficulty = RecipeDifficulty.easy;
          break;
        case 'medium':
          difficulty = RecipeDifficulty.medium;
          break;
        case 'hard':
          difficulty = RecipeDifficulty.hard;
          break;
        default:
          difficulty = RecipeDifficulty.easy;
      }

      // Parse times
      final prepTime = (json['prepTime'] as num?)?.toInt() ?? 0;
      final cookTime = (json['cookTime'] as num?)?.toInt() ?? 0;
      final totalTime = prepTime + cookTime;

      // Parse instructions into steps
      final instructionsStr = json['instructions']?.toString() ?? '';
      final steps = <RecipeStep>[
        RecipeStep(
          stepNumber: 1,
          instruction: instructionsStr.isNotEmpty ? instructionsStr : 'No instructions provided',
        ),
      ];

      // Parse ingredients string into ingredient objects
      final ingredientsStr = json['ingredients']?.toString() ?? '';
      final ingredientsList = ingredientsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final ingredients = ingredientsList.asMap().entries.map((entry) {
        return RecipeIngredient(
          name: entry.value,
          quantity: 1,
          unit: 'piece',
        );
      }).toList();

      // Parse dates
      DateTime parseDate(String? dateStr) {
        if (dateStr == null || dateStr.isEmpty) return DateTime.now();
        try {
          return DateTime.parse(dateStr);
        } catch (e) {
          return DateTime.now();
        }
      }

      return Recipe(
        id: (json['id'] as num?)?.toInt() ?? 0,
        businessId: (json['businessId'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? 'Untitled Recipe',
        description: json['description']?.toString() ?? '',
        difficulty: difficulty,
        steps: steps,
        ingredients: ingredients,
        prepTimeMinutes: prepTime,
        cookTimeMinutes: cookTime,
        totalTimeMinutes: totalTime,
        servings: (json['servings'] as num?)?.toInt() ?? 1,
        imageUrl: json['imageUrl']?.toString(),
        tags: [], // API doesn't provide tags, so use empty list
        isActive: json['isActive'] as bool? ?? true,
        createdAt: parseDate(json['createdAt']?.toString()),
        updatedAt: parseDate(json['updatedAt']?.toString()),
      );
    } catch (e) {
      print('Error mapping recipe data: $e');
      print('Raw JSON: $json');
      
      // Return a fallback recipe to prevent crashes
      return Recipe(
        id: (json['id'] as num?)?.toInt() ?? 0,
        businessId: (json['businessId'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? 'Untitled Recipe',
        description: json['description']?.toString() ?? '',
        difficulty: RecipeDifficulty.easy,
        steps: [const RecipeStep(stepNumber: 1, instruction: 'No instructions available')],
        ingredients: [const RecipeIngredient(name: 'No ingredients listed', quantity: 1, unit: 'piece')],
        prepTimeMinutes: 0,
        cookTimeMinutes: 0,
        totalTimeMinutes: 0,
        servings: 1,
        imageUrl: json['imageUrl']?.toString(),
        tags: [],
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
} 