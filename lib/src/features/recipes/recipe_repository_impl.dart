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
      
      return data.map((json) => Recipe.fromJson(json)).toList();
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
      
      return data.map((json) => Recipe.fromJson(json)).toList();
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
      
      return data.map((json) => Recipe.fromJson(json)).toList();
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
} 