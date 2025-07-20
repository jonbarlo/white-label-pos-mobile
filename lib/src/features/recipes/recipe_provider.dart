import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'recipe_repository.dart';
import 'recipe_repository_impl.dart';
import 'models/recipe.dart';
import '../../core/network/dio_client.dart';

part 'recipe_provider.g.dart';

@riverpod
Future<RecipeRepository> recipeRepository(RecipeRepositoryRef ref) async {
  final dio = ref.watch(dioClientProvider);
  return RecipeRepositoryImpl(dio, ref);
}

@riverpod
Future<List<Recipe>> recipes(RecipesRef ref) async {
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.getRecipes();
}

@riverpod
Future<Recipe> recipe(RecipeRef ref, int recipeId) async {
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.getRecipe(recipeId);
}

@riverpod
Future<List<Recipe>> recipeSearch(RecipeSearchRef ref, String query) async {
  if (query.trim().isEmpty) return [];
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.searchRecipes(query);
}

@riverpod
Future<List<Recipe>> recipesByDifficulty(RecipesByDifficultyRef ref, RecipeDifficulty difficulty) async {
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.getRecipesByDifficulty(difficulty);
}

@riverpod
Future<RecipeStats> recipeStats(RecipeStatsRef ref) async {
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.getRecipeStats();
}

@riverpod
class RecipeNotifier extends _$RecipeNotifier {
  @override
  Future<List<Recipe>> build() async {
    final repository = await ref.read(recipeRepositoryProvider.future);
    return await repository.getRecipes();
  }

  Future<void> createRecipe(Recipe recipe) async {
    final repository = await ref.read(recipeRepositoryProvider.future);
    await repository.createRecipe(recipe);
    ref.invalidate(recipesProvider);
    ref.invalidate(recipeStatsProvider);
  }

  Future<void> updateRecipe(int recipeId, Recipe recipe) async {
    final repository = await ref.read(recipeRepositoryProvider.future);
    await repository.updateRecipe(recipeId, recipe);
    ref.invalidate(recipesProvider);
    ref.invalidate(recipeProvider(recipeId));
    ref.invalidate(recipeStatsProvider);
  }

  Future<void> deleteRecipe(int recipeId) async {
    final repository = await ref.read(recipeRepositoryProvider.future);
    await repository.deleteRecipe(recipeId);
    ref.invalidate(recipesProvider);
    ref.invalidate(recipeStatsProvider);
  }

  Future<void> refreshRecipes() async {
    ref.invalidate(recipesProvider);
  }
}

// Computed providers for filtered views
@riverpod
Future<List<Recipe>> easyRecipes(EasyRecipesRef ref) async {
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.getRecipesByDifficulty(RecipeDifficulty.easy);
}

@riverpod
Future<List<Recipe>> mediumRecipes(MediumRecipesRef ref) async {
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.getRecipesByDifficulty(RecipeDifficulty.medium);
}

@riverpod
Future<List<Recipe>> hardRecipes(HardRecipesRef ref) async {
  final repository = await ref.read(recipeRepositoryProvider.future);
  return await repository.getRecipesByDifficulty(RecipeDifficulty.hard);
}

@riverpod
Future<List<Recipe>> activeRecipes(ActiveRecipesRef ref) async {
  final allRecipes = await ref.read(recipesProvider.future);
  return allRecipes.where((recipe) => recipe.isActive).toList();
} 