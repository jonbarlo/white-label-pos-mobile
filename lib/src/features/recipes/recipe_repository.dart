import 'models/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes({int? businessId});
  Future<Recipe> getRecipe(int recipeId);
  Future<Recipe> createRecipe(Recipe recipe);
  Future<Recipe> updateRecipe(int recipeId, Recipe recipe);
  Future<void> deleteRecipe(int recipeId);
  Future<List<Recipe>> searchRecipes(String query, {int? businessId});
  Future<List<Recipe>> getRecipesByDifficulty(RecipeDifficulty difficulty, {int? businessId});
  Future<RecipeStats> getRecipeStats({int? businessId});
} 