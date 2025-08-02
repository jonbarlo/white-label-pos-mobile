import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'models/currency.dart';

abstract class CurrencyRepository {
  // Read operations
  Future<Result<List<Currency>>> getAllCurrencies();
  Future<Result<Currency>> getCurrencyById(int id);
  Future<Result<Currency>> getCurrencyByCode(String code);
  Future<Result<Currency>> getDefaultCurrency();
  Future<Result<List<ExchangeRate>>> getExchangeRates(int currencyId);
  Future<Result<ExchangeRate>> getExchangeRate(int fromCurrencyId, int toCurrencyId);
  
  // Create operations
  Future<Result<Currency>> createCurrency(Map<String, dynamic> currencyData);
  Future<Result<ExchangeRate>> createExchangeRate(Map<String, dynamic> exchangeRateData);
  
  // Update operations
  Future<Result<Currency>> updateCurrency(int id, Map<String, dynamic> currencyData);
  Future<Result<ExchangeRate>> updateExchangeRate(int id, Map<String, dynamic> exchangeRateData);
  
  // Delete operations
  Future<Result<void>> deleteCurrency(int id);
  
  // Currency conversion
  Future<Result<CurrencyConversion>> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });
  
  // Currency preferences
  Future<Result<Currency>> updateCustomerCurrencyPreference(int customerId, int currencyId);
  Future<Result<Currency>> getCustomerCurrencyPreference(int customerId);
} 