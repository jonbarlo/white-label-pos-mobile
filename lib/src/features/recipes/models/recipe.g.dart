// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: (json['id'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      difficulty: $enumDecode(_$RecipeDifficultyEnumMap, json['difficulty']),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      prepTimeMinutes: (json['prepTimeMinutes'] as num).toInt(),
      cookTimeMinutes: (json['cookTimeMinutes'] as num).toInt(),
      totalTimeMinutes: (json['totalTimeMinutes'] as num).toInt(),
      servings: (json['servings'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'description': instance.description,
      'difficulty': _$RecipeDifficultyEnumMap[instance.difficulty]!,
      'steps': instance.steps,
      'ingredients': instance.ingredients,
      'prepTimeMinutes': instance.prepTimeMinutes,
      'cookTimeMinutes': instance.cookTimeMinutes,
      'totalTimeMinutes': instance.totalTimeMinutes,
      'servings': instance.servings,
      'imageUrl': instance.imageUrl,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$RecipeDifficultyEnumMap = {
  RecipeDifficulty.easy: 'easy',
  RecipeDifficulty.medium: 'medium',
  RecipeDifficulty.hard: 'hard',
};

RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) => RecipeStep(
      stepNumber: (json['stepNumber'] as num).toInt(),
      instruction: json['instruction'] as String,
      timeMinutes: (json['timeMinutes'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RecipeStepToJson(RecipeStep instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
      'timeMinutes': instance.timeMinutes,
      'notes': instance.notes,
    };

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) =>
    RecipeIngredient(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RecipeIngredientToJson(RecipeIngredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'notes': instance.notes,
    };

RecipeStats _$RecipeStatsFromJson(Map<String, dynamic> json) => RecipeStats(
      totalRecipes: (json['totalRecipes'] as num).toInt(),
      activeRecipes: (json['activeRecipes'] as num).toInt(),
      recipesByDifficulty:
          (json['recipesByDifficulty'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$RecipeDifficultyEnumMap, k), (e as num).toInt()),
      ),
      averagePrepTime: (json['averagePrepTime'] as num).toDouble(),
      averageCookTime: (json['averageCookTime'] as num).toDouble(),
      mostUsedTags: (json['mostUsedTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RecipeStatsToJson(RecipeStats instance) =>
    <String, dynamic>{
      'totalRecipes': instance.totalRecipes,
      'activeRecipes': instance.activeRecipes,
      'recipesByDifficulty': instance.recipesByDifficulty
          .map((k, e) => MapEntry(_$RecipeDifficultyEnumMap[k]!, e)),
      'averagePrepTime': instance.averagePrepTime,
      'averageCookTime': instance.averageCookTime,
      'mostUsedTags': instance.mostUsedTags,
    };
