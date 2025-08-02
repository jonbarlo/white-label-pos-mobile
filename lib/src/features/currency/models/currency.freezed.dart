// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return _Currency.fromJson(json);
}

/// @nodoc
mixin _$Currency {
  int get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  int get decimalPlaces => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Currency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyCopyWith<Currency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyCopyWith<$Res> {
  factory $CurrencyCopyWith(Currency value, $Res Function(Currency) then) =
      _$CurrencyCopyWithImpl<$Res, Currency>;
  @useResult
  $Res call(
      {int id,
      String code,
      String name,
      String symbol,
      int decimalPlaces,
      bool isActive,
      bool isDefault,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$CurrencyCopyWithImpl<$Res, $Val extends Currency>
    implements $CurrencyCopyWith<$Res> {
  _$CurrencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? symbol = null,
    Object? decimalPlaces = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      decimalPlaces: null == decimalPlaces
          ? _value.decimalPlaces
          : decimalPlaces // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyImplCopyWith<$Res>
    implements $CurrencyCopyWith<$Res> {
  factory _$$CurrencyImplCopyWith(
          _$CurrencyImpl value, $Res Function(_$CurrencyImpl) then) =
      __$$CurrencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String code,
      String name,
      String symbol,
      int decimalPlaces,
      bool isActive,
      bool isDefault,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$CurrencyImplCopyWithImpl<$Res>
    extends _$CurrencyCopyWithImpl<$Res, _$CurrencyImpl>
    implements _$$CurrencyImplCopyWith<$Res> {
  __$$CurrencyImplCopyWithImpl(
      _$CurrencyImpl _value, $Res Function(_$CurrencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? symbol = null,
    Object? decimalPlaces = null,
    Object? isActive = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CurrencyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      decimalPlaces: null == decimalPlaces
          ? _value.decimalPlaces
          : decimalPlaces // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyImpl implements _Currency {
  const _$CurrencyImpl(
      {required this.id,
      required this.code,
      required this.name,
      required this.symbol,
      required this.decimalPlaces,
      required this.isActive,
      required this.isDefault,
      required this.createdAt,
      required this.updatedAt});

  factory _$CurrencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyImplFromJson(json);

  @override
  final int id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String symbol;
  @override
  final int decimalPlaces;
  @override
  final bool isActive;
  @override
  final bool isDefault;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Currency(id: $id, code: $code, name: $name, symbol: $symbol, decimalPlaces: $decimalPlaces, isActive: $isActive, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.decimalPlaces, decimalPlaces) ||
                other.decimalPlaces == decimalPlaces) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, symbol,
      decimalPlaces, isActive, isDefault, createdAt, updatedAt);

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      __$$CurrencyImplCopyWithImpl<_$CurrencyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyImplToJson(
      this,
    );
  }
}

abstract class _Currency implements Currency {
  const factory _Currency(
      {required final int id,
      required final String code,
      required final String name,
      required final String symbol,
      required final int decimalPlaces,
      required final bool isActive,
      required final bool isDefault,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CurrencyImpl;

  factory _Currency.fromJson(Map<String, dynamic> json) =
      _$CurrencyImpl.fromJson;

  @override
  int get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String get symbol;
  @override
  int get decimalPlaces;
  @override
  bool get isActive;
  @override
  bool get isDefault;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrencyResponse _$CurrencyResponseFromJson(Map<String, dynamic> json) {
  return _CurrencyResponse.fromJson(json);
}

/// @nodoc
mixin _$CurrencyResponse {
  List<Currency> get currencies => throw _privateConstructorUsedError;

  /// Serializes this CurrencyResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyResponseCopyWith<CurrencyResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyResponseCopyWith<$Res> {
  factory $CurrencyResponseCopyWith(
          CurrencyResponse value, $Res Function(CurrencyResponse) then) =
      _$CurrencyResponseCopyWithImpl<$Res, CurrencyResponse>;
  @useResult
  $Res call({List<Currency> currencies});
}

/// @nodoc
class _$CurrencyResponseCopyWithImpl<$Res, $Val extends CurrencyResponse>
    implements $CurrencyResponseCopyWith<$Res> {
  _$CurrencyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencies = null,
  }) {
    return _then(_value.copyWith(
      currencies: null == currencies
          ? _value.currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyResponseImplCopyWith<$Res>
    implements $CurrencyResponseCopyWith<$Res> {
  factory _$$CurrencyResponseImplCopyWith(_$CurrencyResponseImpl value,
          $Res Function(_$CurrencyResponseImpl) then) =
      __$$CurrencyResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Currency> currencies});
}

/// @nodoc
class __$$CurrencyResponseImplCopyWithImpl<$Res>
    extends _$CurrencyResponseCopyWithImpl<$Res, _$CurrencyResponseImpl>
    implements _$$CurrencyResponseImplCopyWith<$Res> {
  __$$CurrencyResponseImplCopyWithImpl(_$CurrencyResponseImpl _value,
      $Res Function(_$CurrencyResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencies = null,
  }) {
    return _then(_$CurrencyResponseImpl(
      currencies: null == currencies
          ? _value._currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyResponseImpl implements _CurrencyResponse {
  const _$CurrencyResponseImpl({required final List<Currency> currencies})
      : _currencies = currencies;

  factory _$CurrencyResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyResponseImplFromJson(json);

  final List<Currency> _currencies;
  @override
  List<Currency> get currencies {
    if (_currencies is EqualUnmodifiableListView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencies);
  }

  @override
  String toString() {
    return 'CurrencyResponse(currencies: $currencies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_currencies));

  /// Create a copy of CurrencyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyResponseImplCopyWith<_$CurrencyResponseImpl> get copyWith =>
      __$$CurrencyResponseImplCopyWithImpl<_$CurrencyResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyResponseImplToJson(
      this,
    );
  }
}

abstract class _CurrencyResponse implements CurrencyResponse {
  const factory _CurrencyResponse({required final List<Currency> currencies}) =
      _$CurrencyResponseImpl;

  factory _CurrencyResponse.fromJson(Map<String, dynamic> json) =
      _$CurrencyResponseImpl.fromJson;

  @override
  List<Currency> get currencies;

  /// Create a copy of CurrencyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyResponseImplCopyWith<_$CurrencyResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExchangeRate _$ExchangeRateFromJson(Map<String, dynamic> json) {
  return _ExchangeRate.fromJson(json);
}

/// @nodoc
mixin _$ExchangeRate {
  int get id => throw _privateConstructorUsedError;
  int get fromCurrencyId => throw _privateConstructorUsedError;
  int get toCurrencyId => throw _privateConstructorUsedError;
  double get rate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExchangeRate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeRateCopyWith<ExchangeRate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeRateCopyWith<$Res> {
  factory $ExchangeRateCopyWith(
          ExchangeRate value, $Res Function(ExchangeRate) then) =
      _$ExchangeRateCopyWithImpl<$Res, ExchangeRate>;
  @useResult
  $Res call(
      {int id,
      int fromCurrencyId,
      int toCurrencyId,
      double rate,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ExchangeRateCopyWithImpl<$Res, $Val extends ExchangeRate>
    implements $ExchangeRateCopyWith<$Res> {
  _$ExchangeRateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromCurrencyId = null,
    Object? toCurrencyId = null,
    Object? rate = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fromCurrencyId: null == fromCurrencyId
          ? _value.fromCurrencyId
          : fromCurrencyId // ignore: cast_nullable_to_non_nullable
              as int,
      toCurrencyId: null == toCurrencyId
          ? _value.toCurrencyId
          : toCurrencyId // ignore: cast_nullable_to_non_nullable
              as int,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExchangeRateImplCopyWith<$Res>
    implements $ExchangeRateCopyWith<$Res> {
  factory _$$ExchangeRateImplCopyWith(
          _$ExchangeRateImpl value, $Res Function(_$ExchangeRateImpl) then) =
      __$$ExchangeRateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int fromCurrencyId,
      int toCurrencyId,
      double rate,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ExchangeRateImplCopyWithImpl<$Res>
    extends _$ExchangeRateCopyWithImpl<$Res, _$ExchangeRateImpl>
    implements _$$ExchangeRateImplCopyWith<$Res> {
  __$$ExchangeRateImplCopyWithImpl(
      _$ExchangeRateImpl _value, $Res Function(_$ExchangeRateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromCurrencyId = null,
    Object? toCurrencyId = null,
    Object? rate = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ExchangeRateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fromCurrencyId: null == fromCurrencyId
          ? _value.fromCurrencyId
          : fromCurrencyId // ignore: cast_nullable_to_non_nullable
              as int,
      toCurrencyId: null == toCurrencyId
          ? _value.toCurrencyId
          : toCurrencyId // ignore: cast_nullable_to_non_nullable
              as int,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeRateImpl implements _ExchangeRate {
  const _$ExchangeRateImpl(
      {required this.id,
      required this.fromCurrencyId,
      required this.toCurrencyId,
      required this.rate,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});

  factory _$ExchangeRateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeRateImplFromJson(json);

  @override
  final int id;
  @override
  final int fromCurrencyId;
  @override
  final int toCurrencyId;
  @override
  final double rate;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ExchangeRate(id: $id, fromCurrencyId: $fromCurrencyId, toCurrencyId: $toCurrencyId, rate: $rate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeRateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromCurrencyId, fromCurrencyId) ||
                other.fromCurrencyId == fromCurrencyId) &&
            (identical(other.toCurrencyId, toCurrencyId) ||
                other.toCurrencyId == toCurrencyId) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fromCurrencyId, toCurrencyId,
      rate, isActive, createdAt, updatedAt);

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeRateImplCopyWith<_$ExchangeRateImpl> get copyWith =>
      __$$ExchangeRateImplCopyWithImpl<_$ExchangeRateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeRateImplToJson(
      this,
    );
  }
}

abstract class _ExchangeRate implements ExchangeRate {
  const factory _ExchangeRate(
      {required final int id,
      required final int fromCurrencyId,
      required final int toCurrencyId,
      required final double rate,
      required final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ExchangeRateImpl;

  factory _ExchangeRate.fromJson(Map<String, dynamic> json) =
      _$ExchangeRateImpl.fromJson;

  @override
  int get id;
  @override
  int get fromCurrencyId;
  @override
  int get toCurrencyId;
  @override
  double get rate;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ExchangeRate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeRateImplCopyWith<_$ExchangeRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrencyConversion _$CurrencyConversionFromJson(Map<String, dynamic> json) {
  return _CurrencyConversion.fromJson(json);
}

/// @nodoc
mixin _$CurrencyConversion {
  String get originalCurrency => throw _privateConstructorUsedError;
  String get convertedCurrency => throw _privateConstructorUsedError;
  double get originalAmount => throw _privateConstructorUsedError;
  double get convertedAmount => throw _privateConstructorUsedError;
  double get exchangeRate => throw _privateConstructorUsedError;

  /// Serializes this CurrencyConversion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyConversion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyConversionCopyWith<CurrencyConversion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyConversionCopyWith<$Res> {
  factory $CurrencyConversionCopyWith(
          CurrencyConversion value, $Res Function(CurrencyConversion) then) =
      _$CurrencyConversionCopyWithImpl<$Res, CurrencyConversion>;
  @useResult
  $Res call(
      {String originalCurrency,
      String convertedCurrency,
      double originalAmount,
      double convertedAmount,
      double exchangeRate});
}

/// @nodoc
class _$CurrencyConversionCopyWithImpl<$Res, $Val extends CurrencyConversion>
    implements $CurrencyConversionCopyWith<$Res> {
  _$CurrencyConversionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyConversion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalCurrency = null,
    Object? convertedCurrency = null,
    Object? originalAmount = null,
    Object? convertedAmount = null,
    Object? exchangeRate = null,
  }) {
    return _then(_value.copyWith(
      originalCurrency: null == originalCurrency
          ? _value.originalCurrency
          : originalCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      convertedCurrency: null == convertedCurrency
          ? _value.convertedCurrency
          : convertedCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      originalAmount: null == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      convertedAmount: null == convertedAmount
          ? _value.convertedAmount
          : convertedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      exchangeRate: null == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyConversionImplCopyWith<$Res>
    implements $CurrencyConversionCopyWith<$Res> {
  factory _$$CurrencyConversionImplCopyWith(_$CurrencyConversionImpl value,
          $Res Function(_$CurrencyConversionImpl) then) =
      __$$CurrencyConversionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String originalCurrency,
      String convertedCurrency,
      double originalAmount,
      double convertedAmount,
      double exchangeRate});
}

/// @nodoc
class __$$CurrencyConversionImplCopyWithImpl<$Res>
    extends _$CurrencyConversionCopyWithImpl<$Res, _$CurrencyConversionImpl>
    implements _$$CurrencyConversionImplCopyWith<$Res> {
  __$$CurrencyConversionImplCopyWithImpl(_$CurrencyConversionImpl _value,
      $Res Function(_$CurrencyConversionImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyConversion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalCurrency = null,
    Object? convertedCurrency = null,
    Object? originalAmount = null,
    Object? convertedAmount = null,
    Object? exchangeRate = null,
  }) {
    return _then(_$CurrencyConversionImpl(
      originalCurrency: null == originalCurrency
          ? _value.originalCurrency
          : originalCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      convertedCurrency: null == convertedCurrency
          ? _value.convertedCurrency
          : convertedCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      originalAmount: null == originalAmount
          ? _value.originalAmount
          : originalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      convertedAmount: null == convertedAmount
          ? _value.convertedAmount
          : convertedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      exchangeRate: null == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyConversionImpl implements _CurrencyConversion {
  const _$CurrencyConversionImpl(
      {required this.originalCurrency,
      required this.convertedCurrency,
      required this.originalAmount,
      required this.convertedAmount,
      required this.exchangeRate});

  factory _$CurrencyConversionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyConversionImplFromJson(json);

  @override
  final String originalCurrency;
  @override
  final String convertedCurrency;
  @override
  final double originalAmount;
  @override
  final double convertedAmount;
  @override
  final double exchangeRate;

  @override
  String toString() {
    return 'CurrencyConversion(originalCurrency: $originalCurrency, convertedCurrency: $convertedCurrency, originalAmount: $originalAmount, convertedAmount: $convertedAmount, exchangeRate: $exchangeRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyConversionImpl &&
            (identical(other.originalCurrency, originalCurrency) ||
                other.originalCurrency == originalCurrency) &&
            (identical(other.convertedCurrency, convertedCurrency) ||
                other.convertedCurrency == convertedCurrency) &&
            (identical(other.originalAmount, originalAmount) ||
                other.originalAmount == originalAmount) &&
            (identical(other.convertedAmount, convertedAmount) ||
                other.convertedAmount == convertedAmount) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, originalCurrency,
      convertedCurrency, originalAmount, convertedAmount, exchangeRate);

  /// Create a copy of CurrencyConversion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyConversionImplCopyWith<_$CurrencyConversionImpl> get copyWith =>
      __$$CurrencyConversionImplCopyWithImpl<_$CurrencyConversionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyConversionImplToJson(
      this,
    );
  }
}

abstract class _CurrencyConversion implements CurrencyConversion {
  const factory _CurrencyConversion(
      {required final String originalCurrency,
      required final String convertedCurrency,
      required final double originalAmount,
      required final double convertedAmount,
      required final double exchangeRate}) = _$CurrencyConversionImpl;

  factory _CurrencyConversion.fromJson(Map<String, dynamic> json) =
      _$CurrencyConversionImpl.fromJson;

  @override
  String get originalCurrency;
  @override
  String get convertedCurrency;
  @override
  double get originalAmount;
  @override
  double get convertedAmount;
  @override
  double get exchangeRate;

  /// Create a copy of CurrencyConversion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyConversionImplCopyWith<_$CurrencyConversionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
