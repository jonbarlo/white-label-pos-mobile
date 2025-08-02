import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';
part 'currency.g.dart';

@freezed
class Currency with _$Currency {
  const factory Currency({
    required int id,
    required String code,
    required String name,
    required String symbol,
    required int decimalPlaces,
    required bool isActive,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Currency;

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
}

@freezed
class CurrencyResponse with _$CurrencyResponse {
  const factory CurrencyResponse({
    required List<Currency> currencies,
  }) = _CurrencyResponse;

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) => _$CurrencyResponseFromJson(json);
}

@freezed
class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    required int id,
    required int fromCurrencyId,
    required int toCurrencyId,
    required double rate,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExchangeRate;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) => _$ExchangeRateFromJson(json);
}

@freezed
class CurrencyConversion with _$CurrencyConversion {
  const factory CurrencyConversion({
    required String originalCurrency,
    required String convertedCurrency,
    required double originalAmount,
    required double convertedAmount,
    required double exchangeRate,
  }) = _CurrencyConversion;

  factory CurrencyConversion.fromJson(Map<String, dynamic> json) => _$CurrencyConversionFromJson(json);
} 