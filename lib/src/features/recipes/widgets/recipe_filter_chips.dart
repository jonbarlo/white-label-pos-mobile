import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeFilterChips extends StatelessWidget {
  final RecipeDifficulty? selectedDifficulty;
  final bool showOnlyActive;
  final Function(RecipeDifficulty?) onDifficultyChanged;
  final Function(bool) onActiveChanged;

  const RecipeFilterChips({
    super.key,
    this.selectedDifficulty,
    required this.showOnlyActive,
    required this.onDifficultyChanged,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Active/All filter
        FilterChip(
          label: Text(showOnlyActive ? 'Active Only' : 'All'),
          selected: showOnlyActive,
          onSelected: onActiveChanged,
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
          checkmarkColor: Theme.of(context).primaryColor,
        ),
        // Difficulty filters
        FilterChip(
          label: const Text('Easy'),
          selected: selectedDifficulty == RecipeDifficulty.easy,
          onSelected: (selected) {
            onDifficultyChanged(selected ? RecipeDifficulty.easy : null);
          },
          selectedColor: Colors.green.withOpacity(0.2),
          checkmarkColor: Colors.green,
        ),
        FilterChip(
          label: const Text('Medium'),
          selected: selectedDifficulty == RecipeDifficulty.medium,
          onSelected: (selected) {
            onDifficultyChanged(selected ? RecipeDifficulty.medium : null);
          },
          selectedColor: Colors.orange.withOpacity(0.2),
          checkmarkColor: Colors.orange,
        ),
        FilterChip(
          label: const Text('Hard'),
          selected: selectedDifficulty == RecipeDifficulty.hard,
          onSelected: (selected) {
            onDifficultyChanged(selected ? RecipeDifficulty.hard : null);
          },
          selectedColor: Colors.red.withOpacity(0.2),
          checkmarkColor: Colors.red,
        ),
      ],
    );
  }
} 