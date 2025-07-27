import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_flushbar/flushbar.dart';
import 'models/recipe.dart';
import 'recipe_provider.dart';
import 'widgets/recipe_card.dart';
import 'widgets/recipe_search_bar.dart';
import 'widgets/recipe_filter_chips.dart';
import 'widgets/recipe_creation_dialog.dart';
import '../../shared/widgets/loading_indicator.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Recipes',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          if (canManageRecipes)
            FilledButton.icon(
              onPressed: () => _showCreateRecipeDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size(80, 36),
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(recipeNotifierProvider.notifier).refreshRecipes(),
            tooltip: 'Refresh Recipes',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Easy'),
                Tab(text: 'Medium'),
                Tab(text: 'Hard'),
              ],
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.colorScheme.primary,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              labelColor: theme.colorScheme.onPrimary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              dividerColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and filter section with HIG design
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Search Bar with HIG styling
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search recipes...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Filter Chips with HIG styling
                Row(
                  children: [
                    // Active Only Filter
                    FilterChip(
                      label: Text('Active Only'),
                      selected: _showOnlyActive,
                      onSelected: (selected) {
                        setState(() {
                          _showOnlyActive = selected;
                        });
                      },
                      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                      checkmarkColor: theme.colorScheme.primary,
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: _showOnlyActive 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: _showOnlyActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Difficulty Filter
                    if (_selectedDifficulty != null)
                      FilterChip(
                        label: Text(_selectedDifficulty!.name.toUpperCase()),
                        selected: true,
                        onSelected: (_) {
                          setState(() {
                            _selectedDifficulty = null;
                          });
                        },
                        selectedColor: theme.colorScheme.secondary.withValues(alpha: 0.12),
                        checkmarkColor: theme.colorScheme.secondary,
                        labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Recipes content
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
    final theme = Theme.of(context);
    
    return FutureBuilder<List<Recipe>?>(
      future: ref.read(recipeSearchProvider(query).future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingIndicator(message: 'Searching recipes...'),
          );
        }
        
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString(), theme);
        }

        final recipes = snapshot.data ?? [];
        final filteredRecipes = _filterRecipes(recipes);

        if (filteredRecipes.isEmpty) {
          return _buildEmptySearchState(query, theme);
        }

        return _buildRecipesGrid(filteredRecipes, theme);
      },
    );
  }

  Widget _buildDifficultyFilteredList(RecipeDifficulty difficulty) {
    final theme = Theme.of(context);
    
    return FutureBuilder<List<Recipe>?>(
      future: ref.read(recipesByDifficultyProvider(difficulty).future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingIndicator(message: 'Loading recipes...'),
          );
        }
        
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString(), theme);
        }

        final recipes = snapshot.data ?? [];
        final filteredRecipes = _filterRecipes(recipes);

        if (filteredRecipes.isEmpty) {
          return _buildEmptyDifficultyState(difficulty, theme);
        }

        return _buildRecipesGrid(filteredRecipes, theme);
      },
    );
  }

  Widget _buildAllRecipesList() {
    final theme = Theme.of(context);
    
    return FutureBuilder<List<Recipe>?>(
      future: ref.read(recipesProvider.future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingIndicator(message: 'Loading recipes...'),
          );
        }
        
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString(), theme);
        }

        final recipes = snapshot.data ?? [];
        final filteredRecipes = _filterRecipes(recipes);

        if (filteredRecipes.isEmpty) {
          // Show mock data for demonstration
          return _buildRecipesGrid(_getMockRecipes(), theme);
        }

        return _buildRecipesGrid(filteredRecipes, theme);
      },
    );
  }

  Widget _buildErrorState(String error, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Unable to Load Recipes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState(String query, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Recipes Found',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No recipes found for "$query"',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.clear, size: 18),
            label: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDifficultyState(RecipeDifficulty difficulty, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: 48,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No ${difficulty.name.toUpperCase()} Recipes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different difficulty level or create a new recipe',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  Widget _buildRecipesGrid(List<Recipe> recipes, ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
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
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          recipe.name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                recipe.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _buildRecipeInfoRow('Difficulty', recipe.difficulty.name.toUpperCase(), theme),
              _buildRecipeInfoRow('Prep Time', '${recipe.prepTimeMinutes} minutes', theme),
              _buildRecipeInfoRow('Cook Time', '${recipe.cookTimeMinutes} minutes', theme),
              _buildRecipeInfoRow('Servings', '${recipe.servings}', theme),
              const SizedBox(height: 16),
              Text(
                'Ingredients:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((ingredient) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Instructions:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...recipe.steps.map((step) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${step.stepNumber}. ${step.instruction}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
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

  Widget _buildRecipeInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
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
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Delete Recipe',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${recipe.name}"? This action cannot be undone.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(recipeNotifierProvider.notifier).deleteRecipe(recipe.id);
                if (mounted) {
                  Flushbar(
                    message: 'Recipe deleted successfully',
                    backgroundColor: theme.colorScheme.primary,
                    icon: Icon(Icons.check_circle, color: theme.colorScheme.onPrimary),
                    duration: const Duration(seconds: 3),
                  ).show(context);
                }
              } catch (e) {
                if (mounted) {
                  Flushbar(
                    message: 'Failed to delete recipe: $e',
                    backgroundColor: theme.colorScheme.error,
                    icon: Icon(Icons.error, color: theme.colorScheme.onError),
                    duration: const Duration(seconds: 4),
                  ).show(context);
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: Text(
              'Delete',
              style: TextStyle(color: theme.colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }
} 