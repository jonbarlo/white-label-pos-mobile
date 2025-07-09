// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userManagementRepositoryHash() =>
    r'94e577d8f72610b213223db593a52438ed83539b';

/// See also [userManagementRepository].
@ProviderFor(userManagementRepository)
final userManagementRepositoryProvider =
    AutoDisposeProvider<UserManagementRepository>.internal(
  userManagementRepository,
  name: r'userManagementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userManagementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserManagementRepositoryRef
    = AutoDisposeProviderRef<UserManagementRepository>;
String _$usersHash() => r'f843842fd4f64664b6644577089e2a97c092b7b7';

/// See also [users].
@ProviderFor(users)
final usersProvider = AutoDisposeFutureProvider<List<User>>.internal(
  users,
  name: r'usersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsersRef = AutoDisposeFutureProviderRef<List<User>>;
String _$userHash() => r'97b82758fd5bda53227fe2f54ce42da3770ab4fa';

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

/// See also [user].
@ProviderFor(user)
const userProvider = UserFamily();

/// See also [user].
class UserFamily extends Family<AsyncValue<User>> {
  /// See also [user].
  const UserFamily();

  /// See also [user].
  UserProvider call(
    String userId,
  ) {
    return UserProvider(
      userId,
    );
  }

  @override
  UserProvider getProviderOverride(
    covariant UserProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userProvider';
}

/// See also [user].
class UserProvider extends AutoDisposeFutureProvider<User> {
  /// See also [user].
  UserProvider(
    String userId,
  ) : this._internal(
          (ref) => user(
            ref as UserRef,
            userId,
          ),
          from: userProvider,
          name: r'userProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
          dependencies: UserFamily._dependencies,
          allTransitiveDependencies: UserFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<User> Function(UserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProvider._internal(
        (ref) => create(ref as UserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<User> createElement() {
    return _UserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserRef on AutoDisposeFutureProviderRef<User> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProviderElement extends AutoDisposeFutureProviderElement<User>
    with UserRef {
  _UserProviderElement(super.provider);

  @override
  String get userId => (origin as UserProvider).userId;
}

String _$userRolesHash() => r'45f86b85be892b33e904c0f02bd8f17d94f67a5a';

/// See also [userRoles].
@ProviderFor(userRoles)
final userRolesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  userRoles,
  name: r'userRolesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userRolesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRolesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$userPermissionsHash() => r'24c72132db1a83f41115766b2f84cfcc74ab65b3';

/// See also [userPermissions].
@ProviderFor(userPermissions)
const userPermissionsProvider = UserPermissionsFamily();

/// See also [userPermissions].
class UserPermissionsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [userPermissions].
  const UserPermissionsFamily();

  /// See also [userPermissions].
  UserPermissionsProvider call(
    String userId,
  ) {
    return UserPermissionsProvider(
      userId,
    );
  }

  @override
  UserPermissionsProvider getProviderOverride(
    covariant UserPermissionsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userPermissionsProvider';
}

/// See also [userPermissions].
class UserPermissionsProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [userPermissions].
  UserPermissionsProvider(
    String userId,
  ) : this._internal(
          (ref) => userPermissions(
            ref as UserPermissionsRef,
            userId,
          ),
          from: userPermissionsProvider,
          name: r'userPermissionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPermissionsHash,
          dependencies: UserPermissionsFamily._dependencies,
          allTransitiveDependencies:
              UserPermissionsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserPermissionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(UserPermissionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserPermissionsProvider._internal(
        (ref) => create(ref as UserPermissionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _UserPermissionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPermissionsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserPermissionsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserPermissionsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with UserPermissionsRef {
  _UserPermissionsProviderElement(super.provider);

  @override
  String get userId => (origin as UserPermissionsProvider).userId;
}

String _$searchUsersHash() => r'2ba38722d77c053cd8b3e21850f8849a74486213';

/// See also [searchUsers].
@ProviderFor(searchUsers)
const searchUsersProvider = SearchUsersFamily();

/// See also [searchUsers].
class SearchUsersFamily extends Family<AsyncValue<List<User>>> {
  /// See also [searchUsers].
  const SearchUsersFamily();

  /// See also [searchUsers].
  SearchUsersProvider call(
    String query,
  ) {
    return SearchUsersProvider(
      query,
    );
  }

  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
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
  String? get name => r'searchUsersProvider';
}

/// See also [searchUsers].
class SearchUsersProvider extends AutoDisposeFutureProvider<List<User>> {
  /// See also [searchUsers].
  SearchUsersProvider(
    String query,
  ) : this._internal(
          (ref) => searchUsers(
            ref as SearchUsersRef,
            query,
          ),
          from: searchUsersProvider,
          name: r'searchUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchUsersHash,
          dependencies: SearchUsersFamily._dependencies,
          allTransitiveDependencies:
              SearchUsersFamily._allTransitiveDependencies,
          query: query,
        );

  SearchUsersProvider._internal(
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
    FutureOr<List<User>> Function(SearchUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersProvider._internal(
        (ref) => create(ref as SearchUsersRef),
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
  AutoDisposeFutureProviderElement<List<User>> createElement() {
    return _SearchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider && other.query == query;
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
mixin SearchUsersRef on AutoDisposeFutureProviderRef<List<User>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<User>> with SearchUsersRef {
  _SearchUsersProviderElement(super.provider);

  @override
  String get query => (origin as SearchUsersProvider).query;
}

String _$usersByRoleHash() => r'a2339545d862b39ab4d33661cecdb5fc232c5233';

/// See also [usersByRole].
@ProviderFor(usersByRole)
const usersByRoleProvider = UsersByRoleFamily();

/// See also [usersByRole].
class UsersByRoleFamily extends Family<AsyncValue<List<User>>> {
  /// See also [usersByRole].
  const UsersByRoleFamily();

  /// See also [usersByRole].
  UsersByRoleProvider call(
    String role,
  ) {
    return UsersByRoleProvider(
      role,
    );
  }

  @override
  UsersByRoleProvider getProviderOverride(
    covariant UsersByRoleProvider provider,
  ) {
    return call(
      provider.role,
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
  String? get name => r'usersByRoleProvider';
}

/// See also [usersByRole].
class UsersByRoleProvider extends AutoDisposeFutureProvider<List<User>> {
  /// See also [usersByRole].
  UsersByRoleProvider(
    String role,
  ) : this._internal(
          (ref) => usersByRole(
            ref as UsersByRoleRef,
            role,
          ),
          from: usersByRoleProvider,
          name: r'usersByRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersByRoleHash,
          dependencies: UsersByRoleFamily._dependencies,
          allTransitiveDependencies:
              UsersByRoleFamily._allTransitiveDependencies,
          role: role,
        );

  UsersByRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.role,
  }) : super.internal();

  final String role;

  @override
  Override overrideWith(
    FutureOr<List<User>> Function(UsersByRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersByRoleProvider._internal(
        (ref) => create(ref as UsersByRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        role: role,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<User>> createElement() {
    return _UsersByRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByRoleProvider && other.role == role;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersByRoleRef on AutoDisposeFutureProviderRef<List<User>> {
  /// The parameter `role` of this provider.
  String get role;
}

class _UsersByRoleProviderElement
    extends AutoDisposeFutureProviderElement<List<User>> with UsersByRoleRef {
  _UsersByRoleProviderElement(super.provider);

  @override
  String get role => (origin as UsersByRoleProvider).role;
}

String _$activeUsersCountHash() => r'16e42695b7ea3b9fc85866eb2c9bf6d1ac024db3';

/// See also [activeUsersCount].
@ProviderFor(activeUsersCount)
final activeUsersCountProvider = AutoDisposeFutureProvider<int>.internal(
  activeUsersCount,
  name: r'activeUsersCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeUsersCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveUsersCountRef = AutoDisposeFutureProviderRef<int>;
String _$usersByDateRangeHash() => r'fbfdc8ee6aa40a53b3bfdef78e4c1e4faacd890c';

/// See also [usersByDateRange].
@ProviderFor(usersByDateRange)
const usersByDateRangeProvider = UsersByDateRangeFamily();

/// See also [usersByDateRange].
class UsersByDateRangeFamily extends Family<AsyncValue<List<User>>> {
  /// See also [usersByDateRange].
  const UsersByDateRangeFamily();

  /// See also [usersByDateRange].
  UsersByDateRangeProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return UsersByDateRangeProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  UsersByDateRangeProvider getProviderOverride(
    covariant UsersByDateRangeProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  String? get name => r'usersByDateRangeProvider';
}

/// See also [usersByDateRange].
class UsersByDateRangeProvider extends AutoDisposeFutureProvider<List<User>> {
  /// See also [usersByDateRange].
  UsersByDateRangeProvider({
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => usersByDateRange(
            ref as UsersByDateRangeRef,
            startDate: startDate,
            endDate: endDate,
          ),
          from: usersByDateRangeProvider,
          name: r'usersByDateRangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersByDateRangeHash,
          dependencies: UsersByDateRangeFamily._dependencies,
          allTransitiveDependencies:
              UsersByDateRangeFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  UsersByDateRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<List<User>> Function(UsersByDateRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersByDateRangeProvider._internal(
        (ref) => create(ref as UsersByDateRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<User>> createElement() {
    return _UsersByDateRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByDateRangeProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersByDateRangeRef on AutoDisposeFutureProviderRef<List<User>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _UsersByDateRangeProviderElement
    extends AutoDisposeFutureProviderElement<List<User>>
    with UsersByDateRangeRef {
  _UsersByDateRangeProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as UsersByDateRangeProvider).startDate;
  @override
  DateTime get endDate => (origin as UsersByDateRangeProvider).endDate;
}

String _$userManagementNotifierHash() =>
    r'a3291bd1c33292c5215fec338d8320addfec6100';

/// See also [UserManagementNotifier].
@ProviderFor(UserManagementNotifier)
final userManagementNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UserManagementNotifier, void>.internal(
  UserManagementNotifier.new,
  name: r'userManagementNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userManagementNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserManagementNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
