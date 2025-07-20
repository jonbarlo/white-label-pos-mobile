import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_flushbar/flushbar.dart';
import 'models/recipe.dart';
import 'recipe_provider.dart';
import 'widgets/recipe_card.dart';
import 'widgets/recipe_search_bar.dart';
import 'widgets/recipe_filter_chips.dart';
import 'widgets/recipe_creation_dialog.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/navigation_service.dart';
import '../auth/auth_provider.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  RecipeDifficulty? _selectedDifficulty;
  bool _showOnlyActive = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final canManageRecipes = authState.canAccessKitchen || authState.isManager || authState.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (canManageRecipes)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showCreateRecipeDialog(),
              tooltip: 'Create New Recipe',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(recipeNotifierProvider.notifier).refreshRecipes(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Easy'),
            Tab(text: 'Medium'),
            Tab(text: 'Hard'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                RecipeSearchBar(
                  controller: _searchController,
                  onSearchChanged: (query) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                RecipeFilterChips(
                  selectedDifficulty: _selectedDifficulty,
                  showOnlyActive: _showOnlyActive,
                  onDifficultyChanged: (difficulty) {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                  onActiveChanged: (showActive) {
                    setState(() {
                      _showOnlyActive = showActive;
                    });
                  },
                ),
              ],
            ),
          ),
          // Recipes list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRecipesList(null),
                _buildRecipesList(RecipeDifficulty.easy),
                _buildRecipesList(RecipeDifficulty.medium),
                _buildRecipesList(RecipeDifficulty.hard),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList(RecipeDifficulty? difficulty) {
    final searchQuery = _searchController.text.trim();
    
    if (searchQuery.isNotEmpty) {
      return _buildSearchResults(searchQuery);
    }

    if (difficulty != null) {
      return _buildDifficultyFilteredList(difficulty);
    }

    return _buildAllRecipesList();
  }

  Widget _buildSearchResults(String query) {
    return FutureBuilder<List<Recipe>>(
      future: ref.read(recipeSearchProvider(query).future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final recipes = snapshot.data ?? [];
        final filteredRecipes = _filterRecipes(recipes);

        if (filteredRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('No recipes found for "$query"'),
              ],
            ),
          );
        }

        return _buildRecipesGrid(filteredRecipes);
      },
    );
  }

  Widget _buildDifficultyFilteredList(RecipeDifficulty difficulty) {
    return FutureBuilder<List<Recipe>>(
      future: ref.read(recipesByDifficultyProvider(difficulty).future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final recipes = snapshot.data ?? [];
        final filteredRecipes = _filterRecipes(recipes);

        if (filteredRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('No ${difficulty.name} recipes found'),
              ],
            ),
          );
        }

        return _buildRecipesGrid(filteredRecipes);
      },
    );
  }

  Widget _buildAllRecipesList() {
    return FutureBuilder<List<Recipe>>(
      future: ref.read(recipesProvider.future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final recipes = snapshot.data ?? [];
        final filteredRecipes = _filterRecipes(recipes);

        if (filteredRecipes.isEmpty) {
          // Show mock data for demonstration
          return _buildRecipesGrid(_getMockRecipes());
        }

        return _buildRecipesGrid(filteredRecipes);
      },
    );
  }

  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    var filtered = recipes;

    // Filter by active status
    if (_showOnlyActive) {
      filtered = filtered.where((recipe) => recipe.isActive).toList();
    }

    // Filter by selected difficulty
    if (_selectedDifficulty != null) {
      filtered = filtered.where((recipe) => recipe.difficulty == _selectedDifficulty).toList();
    }

    return filtered;
  }

  List<Recipe> _getMockRecipes() {
    return [
      Recipe(
        id: 1,
        businessId: 1,
        name: 'Margherita Pizza',
        description: 'Classic Italian pizza with tomato sauce, mozzarella, and basil',
        difficulty: RecipeDifficulty.medium,
        prepTimeMinutes: 30,
        cookTimeMinutes: 15,
        totalTimeMinutes: 45,
        servings: 4,
        isActive: true,
        steps: [
          RecipeStep(stepNumber: 1, instruction: 'Preheat oven to 450°F (230°C)'),
          RecipeStep(stepNumber: 2, instruction: 'Roll out pizza dough'),
          RecipeStep(stepNumber: 3, instruction: 'Add tomato sauce and mozzarella'),
          RecipeStep(stepNumber: 4, instruction: 'Bake for 15 minutes'),
        ],
        ingredients: [
          RecipeIngredient(name: 'Pizza dough', quantity: 1, unit: 'piece'),
          RecipeIngredient(name: 'Tomato sauce', quantity: 0.5, unit: 'cup'),
          RecipeIngredient(name: 'Mozzarella cheese', quantity: 200, unit: 'g'),
          RecipeIngredient(name: 'Fresh basil', quantity: 10, unit: 'leaves'),
        ],
        tags: ['Italian', 'Pizza', 'Vegetarian'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
      Recipe(
        id: 2,
        businessId: 1,
        name: 'Caesar Salad',
        description: 'Fresh romaine lettuce with Caesar dressing and croutons',
        difficulty: RecipeDifficulty.easy,
        prepTimeMinutes: 15,
        cookTimeMinutes: 0,
        totalTimeMinutes: 15,
        servings: 2,
        isActive: true,
        steps: [
          RecipeStep(stepNumber: 1, instruction: 'Wash and chop romaine lettuce'),
          RecipeStep(stepNumber: 2, instruction: 'Make Caesar dressing'),
          RecipeStep(stepNumber: 3, instruction: 'Toss lettuce with dressing'),
          RecipeStep(stepNumber: 4, instruction: 'Add croutons and serve'),
        ],
        ingredients: [
          RecipeIngredient(name: 'Romaine lettuce', quantity: 1, unit: 'head'),
          RecipeIngredient(name: 'Caesar dressing', quantity: 0.25, unit: 'cup'),
          RecipeIngredient(name: 'Croutons', quantity: 0.5, unit: 'cup'),
          RecipeIngredient(name: 'Parmesan cheese', quantity: 50, unit: 'g'),
        ],
        tags: ['Salad', 'Healthy', 'Quick'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
      Recipe(
        id: 3,
        businessId: 1,
        name: 'Tiramisu',
        description: 'Classic Italian dessert with coffee-soaked ladyfingers and mascarpone cream',
        difficulty: RecipeDifficulty.hard,
        prepTimeMinutes: 45,
        cookTimeMinutes: 0,
        totalTimeMinutes: 45,
        servings: 8,
        isActive: true,
        steps: [
          RecipeStep(stepNumber: 1, instruction: 'Brew strong coffee and let cool'),
          RecipeStep(stepNumber: 2, instruction: 'Beat egg yolks with sugar'),
          RecipeStep(stepNumber: 3, instruction: 'Fold in mascarpone cheese'),
          RecipeStep(stepNumber: 4, instruction: 'Layer ladyfingers and cream mixture'),
          RecipeStep(stepNumber: 5, instruction: 'Refrigerate for 4 hours'),
        ],
        ingredients: [
          RecipeIngredient(name: 'Ladyfingers', quantity: 24, unit: 'pieces'),
          RecipeIngredient(name: 'Mascarpone cheese', quantity: 500, unit: 'g'),
          RecipeIngredient(name: 'Strong coffee', quantity: 1.5, unit: 'cups'),
          RecipeIngredient(name: 'Eggs', quantity: 6, unit: 'pieces'),
          RecipeIngredient(name: 'Sugar', quantity: 150, unit: 'g'),
        ],
        tags: ['Dessert', 'Italian', 'Coffee'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Widget _buildRecipesGrid(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeCard(
          recipe: recipe,
          onTap: () => _showRecipeDetails(recipe),
          onEdit: () => _showEditRecipeDialog(recipe),
          onDelete: () => _showDeleteRecipeDialog(recipe),
        );
      },
    );
  }

  void _showRecipeDetails(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(recipe.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(recipe.description),
              const SizedBox(height: 16),
              Text('Difficulty: ${recipe.difficulty.name.toUpperCase()}'),
              Text('Prep Time: ${recipe.prepTimeMinutes} minutes'),
              Text('Cook Time: ${recipe.cookTimeMinutes} minutes'),
              Text('Servings: ${recipe.servings}'),
              const SizedBox(height: 16),
              const Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...recipe.ingredients.map((ingredient) => 
                Text('• ${ingredient.quantity} ${ingredient.unit} ${ingredient.name}'),
              ),
              const SizedBox(height: 16),
              const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...recipe.steps.map((step) => 
                Text('${step.stepNumber}. ${step.instruction}'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreateRecipeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const RecipeCreationDialog(),
    );
  }

  void _showEditRecipeDialog(Recipe recipe) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RecipeCreationDialog(recipe: recipe),
    );
  }

  void _showDeleteRecipeDialog(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Are you sure you want to delete "${recipe.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(recipeNotifierProvider.notifier).deleteRecipe(recipe.id);
                if (mounted) {
                  Flushbar(
                    message: 'Recipe deleted successfully',
                    backgroundColor: Colors.green,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                  ).show(context);
                }
              } catch (e) {
                if (mounted) {
                  Flushbar(
                    message: 'Failed to delete recipe: $e',
                    backgroundColor: Colors.red,
                    icon: const Icon(Icons.error, color: Colors.white),
                  ).show(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
} 