import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

enum RecipeDifficulty { easy, medium, hard }

@JsonSerializable()
class Recipe {
  final int id;
  final int businessId;
  final String name;
  final String description;
  final RecipeDifficulty difficulty;
  final List<RecipeStep> steps;
  final List<RecipeIngredient> ingredients;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int totalTimeMinutes;
  final int servings;
  final String? imageUrl;
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Recipe({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.steps,
    required this.ingredients,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.totalTimeMinutes,
    required this.servings,
    this.imageUrl,
    required this.tags,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe copyWith({
    int? id,
    int? businessId,
    String? name,
    String? description,
    RecipeDifficulty? difficulty,
    List<RecipeStep>? steps,
    List<RecipeIngredient>? ingredients,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? totalTimeMinutes,
    int? servings,
    String? imageUrl,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      steps: steps ?? this.steps,
      ingredients: ingredients ?? this.ingredients,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      servings: servings ?? this.servings,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class RecipeStep {
  final int stepNumber;
  final String instruction;
  final int? timeMinutes;
  final String? notes;

  const RecipeStep({
    required this.stepNumber,
    required this.instruction,
    this.timeMinutes,
    this.notes,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => _$RecipeStepFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeStepToJson(this);
}

@JsonSerializable()
class RecipeIngredient {
  final String name;
  final double quantity;
  final String unit;
  final String? notes;

  const RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.notes,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeIngredientToJson(this);
}

@JsonSerializable()
class RecipeStats {
  final int totalRecipes;
  final int activeRecipes;
  final Map<RecipeDifficulty, int> recipesByDifficulty;
  final double averagePrepTime;
  final double averageCookTime;
  final List<String> mostUsedTags;

  const RecipeStats({
    required this.totalRecipes,
    required this.activeRecipes,
    required this.recipesByDifficulty,
    required this.averagePrepTime,
    required this.averageCookTime,
    required this.mostUsedTags,
  });

  factory RecipeStats.fromJson(Map<String, dynamic> json) => _$RecipeStatsFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeStatsToJson(this);
} 