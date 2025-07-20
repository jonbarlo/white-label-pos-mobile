// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recipeRepositoryHash() => r'9b3e8faf1dcdc0654c0829259ce32c9966451263';

/// See also [recipeRepository].
@ProviderFor(recipeRepository)
final recipeRepositoryProvider =
    AutoDisposeFutureProvider<RecipeRepository>.internal(
  recipeRepository,
  name: r'recipeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecipeRepositoryRef = AutoDisposeFutureProviderRef<RecipeRepository>;
String _$recipesHash() => r'3aaab9bf97f3b2aa40a2db21c0351a15dddedc4c';

/// See also [recipes].
@ProviderFor(recipes)
final recipesProvider = AutoDisposeFutureProvider<List<Recipe>>.internal(
  recipes,
  name: r'recipesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecipesRef = AutoDisposeFutureProviderRef<List<Recipe>>;
String _$recipeHash() => r'ad70cc735b4a80dec1a2581a7894f9eb56033e13';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recipe].
@ProviderFor(recipe)
const recipeProvider = RecipeFamily();

/// See also [recipe].
class RecipeFamily extends Family<AsyncValue<Recipe>> {
  /// See also [recipe].
  const RecipeFamily();

  /// See also [recipe].
  RecipeProvider call(
    int recipeId,
  ) {
    return RecipeProvider(
      recipeId,
    );
  }

  @override
  RecipeProvider getProviderOverride(
    covariant RecipeProvider provider,
  ) {
    return call(
      provider.recipeId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recipeProvider';
}

/// See also [recipe].
class RecipeProvider extends AutoDisposeFutureProvider<Recipe> {
  /// See also [recipe].
  RecipeProvider(
    int recipeId,
  ) : this._internal(
          (ref) => recipe(
            ref as RecipeRef,
            recipeId,
          ),
          from: recipeProvider,
          name: r'recipeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recipeHash,
          dependencies: RecipeFamily._dependencies,
          allTransitiveDependencies: RecipeFamily._allTransitiveDependencies,
          recipeId: recipeId,
        );

  RecipeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recipeId,
  }) : super.internal();

  final int recipeId;

  @override
  Override overrideWith(
    FutureOr<Recipe> Function(RecipeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecipeProvider._internal(
        (ref) => create(ref as RecipeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recipeId: recipeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Recipe> createElement() {
    return _RecipeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeProvider && other.recipeId == recipeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recipeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecipeRef on AutoDisposeFutureProviderRef<Recipe> {
  /// The parameter `recipeId` of this provider.
  int get recipeId;
}

class _RecipeProviderElement extends AutoDisposeFutureProviderElement<Recipe>
    with RecipeRef {
  _RecipeProviderElement(super.provider);

  @override
  int get recipeId => (origin as RecipeProvider).recipeId;
}

String _$recipeSearchHash() => r'c65dd65075568f69094d4a5b091abb31ef9184c1';

/// See also [recipeSearch].
@ProviderFor(recipeSearch)
const recipeSearchProvider = RecipeSearchFamily();

/// See also [recipeSearch].
class RecipeSearchFamily extends Family<AsyncValue<List<Recipe>>> {
  /// See also [recipeSearch].
  const RecipeSearchFamily();

  /// See also [recipeSearch].
  RecipeSearchProvider call(
    String query,
  ) {
    return RecipeSearchProvider(
      query,
    );
  }

  @override
  RecipeSearchProvider getProviderOverride(
    covariant RecipeSearchProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recipeSearchProvider';
}

/// See also [recipeSearch].
class RecipeSearchProvider extends AutoDisposeFutureProvider<List<Recipe>> {
  /// See also [recipeSearch].
  RecipeSearchProvider(
    String query,
  ) : this._internal(
          (ref) => recipeSearch(
            ref as RecipeSearchRef,
            query,
          ),
          from: recipeSearchProvider,
          name: r'recipeSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recipeSearchHash,
          dependencies: RecipeSearchFamily._dependencies,
          allTransitiveDependencies:
              RecipeSearchFamily._allTransitiveDependencies,
          query: query,
        );

  RecipeSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Recipe>> Function(RecipeSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecipeSearchProvider._internal(
        (ref) => create(ref as RecipeSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Recipe>> createElement() {
    return _RecipeSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecipeSearchRef on AutoDisposeFutureProviderRef<List<Recipe>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _RecipeSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Recipe>>
    with RecipeSearchRef {
  _RecipeSearchProviderElement(super.provider);

  @override
  String get query => (origin as RecipeSearchProvider).query;
}

String _$recipesByDifficultyHash() =>
    r'2ce8182ce14f897ff7e668fc183b00626d634a6d';

/// See also [recipesByDifficulty].
@ProviderFor(recipesByDifficulty)
const recipesByDifficultyProvider = RecipesByDifficultyFamily();

/// See also [recipesByDifficulty].
class RecipesByDifficultyFamily extends Family<AsyncValue<List<Recipe>>> {
  /// See also [recipesByDifficulty].
  const RecipesByDifficultyFamily();

  /// See also [recipesByDifficulty].
  RecipesByDifficultyProvider call(
    RecipeDifficulty difficulty,
  ) {
    return RecipesByDifficultyProvider(
      difficulty,
    );
  }

  @override
  RecipesByDifficultyProvider getProviderOverride(
    covariant RecipesByDifficultyProvider provider,
  ) {
    return call(
      provider.difficulty,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recipesByDifficultyProvider';
}

/// See also [recipesByDifficulty].
class RecipesByDifficultyProvider
    extends AutoDisposeFutureProvider<List<Recipe>> {
  /// See also [recipesByDifficulty].
  RecipesByDifficultyProvider(
    RecipeDifficulty difficulty,
  ) : this._internal(
          (ref) => recipesByDifficulty(
            ref as RecipesByDifficultyRef,
            difficulty,
          ),
          from: recipesByDifficultyProvider,
          name: r'recipesByDifficultyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recipesByDifficultyHash,
          dependencies: RecipesByDifficultyFamily._dependencies,
          allTransitiveDependencies:
              RecipesByDifficultyFamily._allTransitiveDependencies,
          difficulty: difficulty,
        );

  RecipesByDifficultyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.difficulty,
  }) : super.internal();

  final RecipeDifficulty difficulty;

  @override
  Override overrideWith(
    FutureOr<List<Recipe>> Function(RecipesByDifficultyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecipesByDifficultyProvider._internal(
        (ref) => create(ref as RecipesByDifficultyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        difficulty: difficulty,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Recipe>> createElement() {
    return _RecipesByDifficultyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipesByDifficultyProvider &&
        other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecipesByDifficultyRef on AutoDisposeFutureProviderRef<List<Recipe>> {
  /// The parameter `difficulty` of this provider.
  RecipeDifficulty get difficulty;
}

class _RecipesByDifficultyProviderElement
    extends AutoDisposeFutureProviderElement<List<Recipe>>
    with RecipesByDifficultyRef {
  _RecipesByDifficultyProviderElement(super.provider);

  @override
  RecipeDifficulty get difficulty =>
      (origin as RecipesByDifficultyProvider).difficulty;
}

String _$recipeStatsHash() => r'e124ece427416b8778ae49f089338ca2d9ebd5b8';

/// See also [recipeStats].
@ProviderFor(recipeStats)
final recipeStatsProvider = AutoDisposeFutureProvider<RecipeStats>.internal(
  recipeStats,
  name: r'recipeStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recipeStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecipeStatsRef = AutoDisposeFutureProviderRef<RecipeStats>;
String _$easyRecipesHash() => r'eb72241ba615df9ee907304b57eb14a633459123';

/// See also [easyRecipes].
@ProviderFor(easyRecipes)
final easyRecipesProvider = AutoDisposeFutureProvider<List<Recipe>>.internal(
  easyRecipes,
  name: r'easyRecipesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$easyRecipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EasyRecipesRef = AutoDisposeFutureProviderRef<List<Recipe>>;
String _$mediumRecipesHash() => r'301d59c2a954476e683f6005213fc45271ca8d65';

/// See also [mediumRecipes].
@ProviderFor(mediumRecipes)
final mediumRecipesProvider = AutoDisposeFutureProvider<List<Recipe>>.internal(
  mediumRecipes,
  name: r'mediumRecipesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mediumRecipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MediumRecipesRef = AutoDisposeFutureProviderRef<List<Recipe>>;
String _$hardRecipesHash() => r'89b37bea9b2bf8df89b642685c2bcfa0f8081c70';

/// See also [hardRecipes].
@ProviderFor(hardRecipes)
final hardRecipesProvider = AutoDisposeFutureProvider<List<Recipe>>.internal(
  hardRecipes,
  name: r'hardRecipesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hardRecipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HardRecipesRef = AutoDisposeFutureProviderRef<List<Recipe>>;
String _$activeRecipesHash() => r'6920a7f197781789d90223f9b1c49adef812d7ee';

/// See also [activeRecipes].
@ProviderFor(activeRecipes)
final activeRecipesProvider = AutoDisposeFutureProvider<List<Recipe>>.internal(
  activeRecipes,
  name: r'activeRecipesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeRecipesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveRecipesRef = AutoDisposeFutureProviderRef<List<Recipe>>;
String _$recipeNotifierHash() => r'8dbe3644388e01e23b927157ccbff8139d185deb';

/// See also [RecipeNotifier].
@ProviderFor(RecipeNotifier)
final recipeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RecipeNotifier, List<Recipe>>.internal(
  RecipeNotifier.new,
  name: r'recipeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecipeNotifier = AutoDisposeAsyncNotifier<List<Recipe>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
