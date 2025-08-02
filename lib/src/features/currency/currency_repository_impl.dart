import 'package:dio/dio.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/core/errors/app_exception.dart';
import 'currency_repository.dart';
import 'models/currency.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final Dio _dio;

  CurrencyRepositoryImpl(this._dio);

  @override
  Future<Result<List<Currency>>> getAllCurrencies() async {
    try {
      final response = await _dio.get('/currencies');
      
      final responseData = response.data;
      List<dynamic> currencies;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('currencies')) {
        currencies = responseData['currencies'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        currencies = responseData;
      } else {
        return Result.failure('Invalid response format');
      }
      
      final currencyList = currencies
          .map((json) => Currency.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return Result.success(currencyList);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<Currency>> getCurrencyById(int id) async {
    try {
      final response = await _dio.get('/currencies/$id');
      final currency = Currency.fromJson(response.data);
      return Result.success(currency);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<Currency>> getCurrencyByCode(String code) async {
    try {
      final response = await _dio.get('/currencies/code/$code');
      final currency = Currency.fromJson(response.data);
      return Result.success(currency);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<Currency>> getDefaultCurrency() async {
    try {
      final response = await _dio.get('/currencies/default');
      final currency = Currency.fromJson(response.data);
      return Result.success(currency);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<List<ExchangeRate>>> getExchangeRates(int currencyId) async {
    try {
      final response = await _dio.get('/currencies/$currencyId/exchange-rates');
      
      final responseData = response.data;
      List<dynamic> exchangeRates;
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('exchangeRates')) {
        exchangeRates = responseData['exchangeRates'] as List<dynamic>;
      } else if (responseData is List<dynamic>) {
        exchangeRates = responseData;
      } else {
        return Result.failure('Invalid response format');
      }
      
      final ratesList = exchangeRates
          .map((json) => ExchangeRate.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return Result.success(ratesList);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<ExchangeRate>> getExchangeRate(int fromCurrencyId, int toCurrencyId) async {
    try {
      final response = await _dio.get('/currencies/exchange-rate/$fromCurrencyId/$toCurrencyId');
      final exchangeRate = ExchangeRate.fromJson(response.data);
      return Result.success(exchangeRate);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<Currency>> createCurrency(Map<String, dynamic> currencyData) async {
    try {
      final response = await _dio.post('/currencies', data: currencyData);
      final currency = Currency.fromJson(response.data);
      return Result.success(currency);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<ExchangeRate>> createExchangeRate(Map<String, dynamic> exchangeRateData) async {
    try {
      final response = await _dio.post('/currencies/exchange-rate', data: exchangeRateData);
      final exchangeRate = ExchangeRate.fromJson(response.data);
      return Result.success(exchangeRate);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<Currency>> updateCurrency(int id, Map<String, dynamic> currencyData) async {
    try {
      final response = await _dio.put('/currencies/$id', data: currencyData);
      final currency = Currency.fromJson(response.data);
      return Result.success(currency);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<ExchangeRate>> updateExchangeRate(int id, Map<String, dynamic> exchangeRateData) async {
    try {
      final response = await _dio.put('/currencies/exchange-rate/$id', data: exchangeRateData);
      final exchangeRate = ExchangeRate.fromJson(response.data);
      return Result.success(exchangeRate);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<void>> deleteCurrency(int id) async {
    try {
      await _dio.delete('/currencies/$id');
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<CurrencyConversion>> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    try {
      final response = await _dio.post('/currencies/convert', data: {
        'fromCurrency': fromCurrency,
        'toCurrency': toCurrency,
        'amount': amount,
      });
      
      final conversion = CurrencyConversion.fromJson(response.data);
      return Result.success(conversion);
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<Currency>> updateCustomerCurrencyPreference(int customerId, int currencyId) async {
    try {
      final response = await _dio.put('/customers/$customerId/currency-preference', data: {
        'preferredCurrencyId': currencyId,
      });
      
      // The response might contain the updated currency preference
      if (response.data is Map<String, dynamic> && response.data.containsKey('preferredCurrency')) {
        final currency = Currency.fromJson(response.data['preferredCurrency']);
        return Result.success(currency);
      } else {
        // If the response doesn't contain currency data, we'll need to fetch it separately
        return await getCurrencyById(currencyId);
      }
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }

  @override
  Future<Result<Currency>> getCustomerCurrencyPreference(int customerId) async {
    try {
      final response = await _dio.get('/customers/$customerId/currency-preference');
      
      if (response.data is Map<String, dynamic> && response.data.containsKey('preferredCurrency')) {
        final currency = Currency.fromJson(response.data['preferredCurrency']);
        return Result.success(currency);
      } else {
        return Result.failure('Invalid response format');
      }
    } on DioException catch (e) {
      return Result.failure(AppException.fromDioException(e).message);
    } catch (e) {
      return Result.failure(AppException.unknown(e.toString()).message);
    }
  }
} 