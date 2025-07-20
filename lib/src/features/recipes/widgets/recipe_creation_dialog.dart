import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../recipe_provider.dart';
import 'package:another_flushbar/flushbar.dart';

class RecipeCreationDialog extends ConsumerStatefulWidget {
  final Recipe? recipe; // If provided, we're editing an existing recipe

  const RecipeCreationDialog({super.key, this.recipe});

  @override
  ConsumerState<RecipeCreationDialog> createState() => _RecipeCreationDialogState();
}

class _RecipeCreationDialogState extends ConsumerState<RecipeCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  
  RecipeDifficulty _selectedDifficulty = RecipeDifficulty.medium;
  bool _isActive = true;
  
  final List<RecipeStep> _steps = [];
  final List<RecipeIngredient> _ingredients = [];
  
  final _stepController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();
  final _ingredientUnitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      // Editing existing recipe
      final recipe = widget.recipe!;
      _nameController.text = recipe.name;
      _descriptionController.text = recipe.description;
      _prepTimeController.text = recipe.prepTimeMinutes.toString();
      _cookTimeController.text = recipe.cookTimeMinutes.toString();
      _servingsController.text = recipe.servings.toString();
      _selectedDifficulty = recipe.difficulty;
      _isActive = recipe.isActive;
      _steps.addAll(recipe.steps);
      _ingredients.addAll(recipe.ingredients);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _stepController.dispose();
    _ingredientNameController.dispose();
    _ingredientQuantityController.dispose();
    _ingredientUnitController.dispose();
    super.dispose();
  }

  void _addStep() {
    if (_stepController.text.trim().isNotEmpty) {
      setState(() {
        _steps.add(RecipeStep(
          stepNumber: _steps.length + 1,
          instruction: _stepController.text.trim(),
          timeMinutes: 5, // Default 5 minutes
        ));
        _stepController.clear();
      });
    }
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
      // Reorder step numbers
      for (int i = 0; i < _steps.length; i++) {
        _steps[i] = RecipeStep(
          stepNumber: i + 1,
          instruction: _steps[i].instruction,
          timeMinutes: _steps[i].timeMinutes,
          notes: _steps[i].notes,
        );
      }
    });
  }

  void _addIngredient() {
    if (_ingredientNameController.text.trim().isNotEmpty &&
        _ingredientQuantityController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(RecipeIngredient(
          name: _ingredientNameController.text.trim(),
          quantity: double.tryParse(_ingredientQuantityController.text) ?? 1.0,
          unit: _ingredientUnitController.text.trim(),
        ));
        _ingredientNameController.clear();
        _ingredientQuantityController.clear();
        _ingredientUnitController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;
    if (_steps.isEmpty) {
      Flushbar(
        title: 'Missing Steps',
        message: 'Please add at least one step to the recipe.',
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    if (_ingredients.isEmpty) {
      Flushbar(
        title: 'Missing Ingredients',
        message: 'Please add at least one ingredient to the recipe.',
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    try {
      final prepTime = int.tryParse(_prepTimeController.text) ?? 0;
      final cookTime = int.tryParse(_cookTimeController.text) ?? 0;
      final totalTime = prepTime + cookTime;
      
      final recipe = Recipe(
        id: widget.recipe?.id ?? 0,
        businessId: 1, // TODO: Get from auth state
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        difficulty: _selectedDifficulty,
        prepTimeMinutes: prepTime,
        cookTimeMinutes: cookTime,
        totalTimeMinutes: totalTime,
        servings: int.tryParse(_servingsController.text) ?? 1,
        isActive: _isActive,
        steps: _steps,
        ingredients: _ingredients,
        imageUrl: widget.recipe?.imageUrl,
        tags: [], // TODO: Add tag selection
        createdAt: widget.recipe?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.recipe != null) {
        // Update existing recipe
        await ref.read(recipeNotifierProvider.notifier).updateRecipe(recipe.id, recipe);
        Flushbar(
          title: 'Success',
          message: 'Recipe updated successfully!',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ).show(context);
      } else {
        // Create new recipe
        await ref.read(recipeNotifierProvider.notifier).createRecipe(recipe);
        Flushbar(
          title: 'Success',
          message: 'Recipe created successfully!',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ).show(context);
      }

      Navigator.of(context).pop();
    } catch (e) {
      Flushbar(
        title: 'Error',
        message: 'Failed to save recipe: $e',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  widget.recipe != null ? Icons.edit : Icons.add,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.recipe != null ? 'Edit Recipe' : 'Create New Recipe',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      Text(
                        'Basic Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Recipe Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Recipe name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _prepTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Prep Time (minutes)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _cookTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Cook Time (minutes)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _servingsController,
                              decoration: const InputDecoration(
                                labelText: 'Servings',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<RecipeDifficulty>(
                              value: _selectedDifficulty,
                              decoration: const InputDecoration(
                                labelText: 'Difficulty',
                                border: OutlineInputBorder(),
                              ),
                              items: RecipeDifficulty.values.map((difficulty) {
                                return DropdownMenuItem(
                                  value: difficulty,
                                  child: Text(difficulty.name.toUpperCase()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDifficulty = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      _isActive = value ?? true;
                                    });
                                  },
                                ),
                                const Text('Active'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Ingredients Section
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _ingredientNameController,
                              decoration: const InputDecoration(
                                labelText: 'Ingredient Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _ingredientQuantityController,
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _ingredientUnitController,
                              decoration: const InputDecoration(
                                labelText: 'Unit',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addIngredient,
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_ingredients.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: _ingredients.asMap().entries.map((entry) {
                              final index = entry.key;
                              final ingredient = entry.value;
                              return ListTile(
                                title: Text('${ingredient.quantity} ${ingredient.unit} ${ingredient.name}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeIngredient(index),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Steps Section
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _stepController,
                              decoration: const InputDecoration(
                                labelText: 'Step Description',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addStep,
                            child: const Text('Add Step'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_steps.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: _steps.asMap().entries.map((entry) {
                              final index = entry.key;
                              final step = entry.value;
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text('${step.stepNumber}'),
                                ),
                                title: Text(step.instruction),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeStep(index),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: Text(widget.recipe != null ? 'Update Recipe' : 'Create Recipe'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 