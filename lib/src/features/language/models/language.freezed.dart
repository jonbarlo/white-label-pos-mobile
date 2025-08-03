// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Language _$LanguageFromJson(Map<String, dynamic> json) {
  return _Language.fromJson(json);
}

/// @nodoc
mixin _$Language {
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nativeName => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this Language to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageCopyWith<Language> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageCopyWith<$Res> {
  factory $LanguageCopyWith(Language value, $Res Function(Language) then) =
      _$LanguageCopyWithImpl<$Res, Language>;
  @useResult
  $Res call({String code, String name, String nativeName, bool isDefault});
}

/// @nodoc
class _$LanguageCopyWithImpl<$Res, $Val extends Language>
    implements $LanguageCopyWith<$Res> {
  _$LanguageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? nativeName = null,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nativeName: null == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguageImplCopyWith<$Res>
    implements $LanguageCopyWith<$Res> {
  factory _$$LanguageImplCopyWith(
          _$LanguageImpl value, $Res Function(_$LanguageImpl) then) =
      __$$LanguageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String name, String nativeName, bool isDefault});
}

/// @nodoc
class __$$LanguageImplCopyWithImpl<$Res>
    extends _$LanguageCopyWithImpl<$Res, _$LanguageImpl>
    implements _$$LanguageImplCopyWith<$Res> {
  __$$LanguageImplCopyWithImpl(
      _$LanguageImpl _value, $Res Function(_$LanguageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? nativeName = null,
    Object? isDefault = null,
  }) {
    return _then(_$LanguageImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nativeName: null == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageImpl implements _Language {
  const _$LanguageImpl(
      {required this.code,
      required this.name,
      required this.nativeName,
      required this.isDefault});

  factory _$LanguageImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageImplFromJson(json);

  @override
  final String code;
  @override
  final String name;
  @override
  final String nativeName;
  @override
  final bool isDefault;

  @override
  String toString() {
    return 'Language(code: $code, name: $name, nativeName: $nativeName, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nativeName, nativeName) ||
                other.nativeName == nativeName) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, code, name, nativeName, isDefault);

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageImplCopyWith<_$LanguageImpl> get copyWith =>
      __$$LanguageImplCopyWithImpl<_$LanguageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageImplToJson(
      this,
    );
  }
}

abstract class _Language implements Language {
  const factory _Language(
      {required final String code,
      required final String name,
      required final String nativeName,
      required final bool isDefault}) = _$LanguageImpl;

  factory _Language.fromJson(Map<String, dynamic> json) =
      _$LanguageImpl.fromJson;

  @override
  String get code;
  @override
  String get name;
  @override
  String get nativeName;
  @override
  bool get isDefault;

  /// Create a copy of Language
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageImplCopyWith<_$LanguageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LanguageResponse _$LanguageResponseFromJson(Map<String, dynamic> json) {
  return _LanguageResponse.fromJson(json);
}

/// @nodoc
mixin _$LanguageResponse {
  String get currentLanguage => throw _privateConstructorUsedError;
  List<Language> get supportedLanguages => throw _privateConstructorUsedError;

  /// Serializes this LanguageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageResponseCopyWith<LanguageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageResponseCopyWith<$Res> {
  factory $LanguageResponseCopyWith(
          LanguageResponse value, $Res Function(LanguageResponse) then) =
      _$LanguageResponseCopyWithImpl<$Res, LanguageResponse>;
  @useResult
  $Res call({String currentLanguage, List<Language> supportedLanguages});
}

/// @nodoc
class _$LanguageResponseCopyWithImpl<$Res, $Val extends LanguageResponse>
    implements $LanguageResponseCopyWith<$Res> {
  _$LanguageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLanguage = null,
    Object? supportedLanguages = null,
  }) {
    return _then(_value.copyWith(
      currentLanguage: null == currentLanguage
          ? _value.currentLanguage
          : currentLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      supportedLanguages: null == supportedLanguages
          ? _value.supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<Language>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguageResponseImplCopyWith<$Res>
    implements $LanguageResponseCopyWith<$Res> {
  factory _$$LanguageResponseImplCopyWith(_$LanguageResponseImpl value,
          $Res Function(_$LanguageResponseImpl) then) =
      __$$LanguageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentLanguage, List<Language> supportedLanguages});
}

/// @nodoc
class __$$LanguageResponseImplCopyWithImpl<$Res>
    extends _$LanguageResponseCopyWithImpl<$Res, _$LanguageResponseImpl>
    implements _$$LanguageResponseImplCopyWith<$Res> {
  __$$LanguageResponseImplCopyWithImpl(_$LanguageResponseImpl _value,
      $Res Function(_$LanguageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLanguage = null,
    Object? supportedLanguages = null,
  }) {
    return _then(_$LanguageResponseImpl(
      currentLanguage: null == currentLanguage
          ? _value.currentLanguage
          : currentLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      supportedLanguages: null == supportedLanguages
          ? _value._supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<Language>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageResponseImpl implements _LanguageResponse {
  const _$LanguageResponseImpl(
      {required this.currentLanguage,
      required final List<Language> supportedLanguages})
      : _supportedLanguages = supportedLanguages;

  factory _$LanguageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageResponseImplFromJson(json);

  @override
  final String currentLanguage;
  final List<Language> _supportedLanguages;
  @override
  List<Language> get supportedLanguages {
    if (_supportedLanguages is EqualUnmodifiableListView)
      return _supportedLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedLanguages);
  }

  @override
  String toString() {
    return 'LanguageResponse(currentLanguage: $currentLanguage, supportedLanguages: $supportedLanguages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageResponseImpl &&
            (identical(other.currentLanguage, currentLanguage) ||
                other.currentLanguage == currentLanguage) &&
            const DeepCollectionEquality()
                .equals(other._supportedLanguages, _supportedLanguages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentLanguage,
      const DeepCollectionEquality().hash(_supportedLanguages));

  /// Create a copy of LanguageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageResponseImplCopyWith<_$LanguageResponseImpl> get copyWith =>
      __$$LanguageResponseImplCopyWithImpl<_$LanguageResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageResponseImplToJson(
      this,
    );
  }
}

abstract class _LanguageResponse implements LanguageResponse {
  const factory _LanguageResponse(
          {required final String currentLanguage,
          required final List<Language> supportedLanguages}) =
      _$LanguageResponseImpl;

  factory _LanguageResponse.fromJson(Map<String, dynamic> json) =
      _$LanguageResponseImpl.fromJson;

  @override
  String get currentLanguage;
  @override
  List<Language> get supportedLanguages;

  /// Create a copy of LanguageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageResponseImplCopyWith<_$LanguageResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LanguagePreferenceResponse _$LanguagePreferenceResponseFromJson(
    Map<String, dynamic> json) {
  return _LanguagePreferenceResponse.fromJson(json);
}

/// @nodoc
mixin _$LanguagePreferenceResponse {
  String get language => throw _privateConstructorUsedError;
  List<String> get supportedLanguages => throw _privateConstructorUsedError;

  /// Serializes this LanguagePreferenceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguagePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguagePreferenceResponseCopyWith<LanguagePreferenceResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguagePreferenceResponseCopyWith<$Res> {
  factory $LanguagePreferenceResponseCopyWith(LanguagePreferenceResponse value,
          $Res Function(LanguagePreferenceResponse) then) =
      _$LanguagePreferenceResponseCopyWithImpl<$Res,
          LanguagePreferenceResponse>;
  @useResult
  $Res call({String language, List<String> supportedLanguages});
}

/// @nodoc
class _$LanguagePreferenceResponseCopyWithImpl<$Res,
        $Val extends LanguagePreferenceResponse>
    implements $LanguagePreferenceResponseCopyWith<$Res> {
  _$LanguagePreferenceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguagePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? supportedLanguages = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      supportedLanguages: null == supportedLanguages
          ? _value.supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguagePreferenceResponseImplCopyWith<$Res>
    implements $LanguagePreferenceResponseCopyWith<$Res> {
  factory _$$LanguagePreferenceResponseImplCopyWith(
          _$LanguagePreferenceResponseImpl value,
          $Res Function(_$LanguagePreferenceResponseImpl) then) =
      __$$LanguagePreferenceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String language, List<String> supportedLanguages});
}

/// @nodoc
class __$$LanguagePreferenceResponseImplCopyWithImpl<$Res>
    extends _$LanguagePreferenceResponseCopyWithImpl<$Res,
        _$LanguagePreferenceResponseImpl>
    implements _$$LanguagePreferenceResponseImplCopyWith<$Res> {
  __$$LanguagePreferenceResponseImplCopyWithImpl(
      _$LanguagePreferenceResponseImpl _value,
      $Res Function(_$LanguagePreferenceResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguagePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? supportedLanguages = null,
  }) {
    return _then(_$LanguagePreferenceResponseImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      supportedLanguages: null == supportedLanguages
          ? _value._supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguagePreferenceResponseImpl implements _LanguagePreferenceResponse {
  const _$LanguagePreferenceResponseImpl(
      {required this.language, required final List<String> supportedLanguages})
      : _supportedLanguages = supportedLanguages;

  factory _$LanguagePreferenceResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$LanguagePreferenceResponseImplFromJson(json);

  @override
  final String language;
  final List<String> _supportedLanguages;
  @override
  List<String> get supportedLanguages {
    if (_supportedLanguages is EqualUnmodifiableListView)
      return _supportedLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedLanguages);
  }

  @override
  String toString() {
    return 'LanguagePreferenceResponse(language: $language, supportedLanguages: $supportedLanguages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguagePreferenceResponseImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality()
                .equals(other._supportedLanguages, _supportedLanguages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, language,
      const DeepCollectionEquality().hash(_supportedLanguages));

  /// Create a copy of LanguagePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguagePreferenceResponseImplCopyWith<_$LanguagePreferenceResponseImpl>
      get copyWith => __$$LanguagePreferenceResponseImplCopyWithImpl<
          _$LanguagePreferenceResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguagePreferenceResponseImplToJson(
      this,
    );
  }
}

abstract class _LanguagePreferenceResponse
    implements LanguagePreferenceResponse {
  const factory _LanguagePreferenceResponse(
          {required final String language,
          required final List<String> supportedLanguages}) =
      _$LanguagePreferenceResponseImpl;

  factory _LanguagePreferenceResponse.fromJson(Map<String, dynamic> json) =
      _$LanguagePreferenceResponseImpl.fromJson;

  @override
  String get language;
  @override
  List<String> get supportedLanguages;

  /// Create a copy of LanguagePreferenceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguagePreferenceResponseImplCopyWith<_$LanguagePreferenceResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LanguageUpdateRequest _$LanguageUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return _LanguageUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$LanguageUpdateRequest {
  String get language => throw _privateConstructorUsedError;

  /// Serializes this LanguageUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguageUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageUpdateRequestCopyWith<LanguageUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageUpdateRequestCopyWith<$Res> {
  factory $LanguageUpdateRequestCopyWith(LanguageUpdateRequest value,
          $Res Function(LanguageUpdateRequest) then) =
      _$LanguageUpdateRequestCopyWithImpl<$Res, LanguageUpdateRequest>;
  @useResult
  $Res call({String language});
}

/// @nodoc
class _$LanguageUpdateRequestCopyWithImpl<$Res,
        $Val extends LanguageUpdateRequest>
    implements $LanguageUpdateRequestCopyWith<$Res> {
  _$LanguageUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguageUpdateRequestImplCopyWith<$Res>
    implements $LanguageUpdateRequestCopyWith<$Res> {
  factory _$$LanguageUpdateRequestImplCopyWith(
          _$LanguageUpdateRequestImpl value,
          $Res Function(_$LanguageUpdateRequestImpl) then) =
      __$$LanguageUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String language});
}

/// @nodoc
class __$$LanguageUpdateRequestImplCopyWithImpl<$Res>
    extends _$LanguageUpdateRequestCopyWithImpl<$Res,
        _$LanguageUpdateRequestImpl>
    implements _$$LanguageUpdateRequestImplCopyWith<$Res> {
  __$$LanguageUpdateRequestImplCopyWithImpl(_$LanguageUpdateRequestImpl _value,
      $Res Function(_$LanguageUpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguageUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
  }) {
    return _then(_$LanguageUpdateRequestImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageUpdateRequestImpl implements _LanguageUpdateRequest {
  const _$LanguageUpdateRequestImpl({required this.language});

  factory _$LanguageUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageUpdateRequestImplFromJson(json);

  @override
  final String language;

  @override
  String toString() {
    return 'LanguageUpdateRequest(language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageUpdateRequestImpl &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, language);

  /// Create a copy of LanguageUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageUpdateRequestImplCopyWith<_$LanguageUpdateRequestImpl>
      get copyWith => __$$LanguageUpdateRequestImplCopyWithImpl<
          _$LanguageUpdateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _LanguageUpdateRequest implements LanguageUpdateRequest {
  const factory _LanguageUpdateRequest({required final String language}) =
      _$LanguageUpdateRequestImpl;

  factory _LanguageUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$LanguageUpdateRequestImpl.fromJson;

  @override
  String get language;

  /// Create a copy of LanguageUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageUpdateRequestImplCopyWith<_$LanguageUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
