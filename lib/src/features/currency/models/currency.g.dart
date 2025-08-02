// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencyImpl _$$CurrencyImplFromJson(Map<String, dynamic> json) =>
    _$CurrencyImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: (json['decimalPlaces'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CurrencyImplToJson(_$CurrencyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'decimalPlaces': instance.decimalPlaces,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CurrencyResponseImpl _$$CurrencyResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrencyResponseImpl(
      currencies: (json['currencies'] as List<dynamic>)
          .map((e) => Currency.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CurrencyResponseImplToJson(
        _$CurrencyResponseImpl instance) =>
    <String, dynamic>{
      'currencies': instance.currencies,
    };

_$ExchangeRateImpl _$$ExchangeRateImplFromJson(Map<String, dynamic> json) =>
    _$ExchangeRateImpl(
      id: (json['id'] as num).toInt(),
      fromCurrencyId: (json['fromCurrencyId'] as num).toInt(),
      toCurrencyId: (json['toCurrencyId'] as num).toInt(),
      rate: (json['rate'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExchangeRateImplToJson(_$ExchangeRateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromCurrencyId': instance.fromCurrencyId,
      'toCurrencyId': instance.toCurrencyId,
      'rate': instance.rate,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CurrencyConversionImpl _$$CurrencyConversionImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrencyConversionImpl(
      originalCurrency: json['originalCurrency'] as String,
      convertedCurrency: json['convertedCurrency'] as String,
      originalAmount: (json['originalAmount'] as num).toDouble(),
      convertedAmount: (json['convertedAmount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$CurrencyConversionImplToJson(
        _$CurrencyConversionImpl instance) =>
    <String, dynamic>{
      'originalCurrency': instance.originalCurrency,
      'convertedCurrency': instance.convertedCurrency,
      'originalAmount': instance.originalAmount,
      'convertedAmount': instance.convertedAmount,
      'exchangeRate': instance.exchangeRate,
    };
