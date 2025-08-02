import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:white_label_pos_mobile/src/shared/models/result.dart';
import 'package:white_label_pos_mobile/src/core/network/dio_client.dart';
import 'currency_repository.dart';
import 'currency_repository_impl.dart';
import 'models/currency.dart';
import '../../shared/utils/currency_formatter.dart';

part 'currency_provider.g.dart';

@riverpod
CurrencyRepository currencyRepository(CurrencyRepositoryRef ref) {
  final dio = ref.watch(dioClientProvider);
  return CurrencyRepositoryImpl(dio);
}

@riverpod
class CurrencyNotifier extends _$CurrencyNotifier {
  @override
  Future<Result<List<Currency>>> build() async {
    return await _loadCurrencies();
  }

  Future<Result<List<Currency>>> _loadCurrencies() async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.getAllCurrencies();
  }

  Future<Result<Currency>> getCurrencyById(int id) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.getCurrencyById(id);
  }

  Future<Result<Currency>> getCurrencyByCode(String code) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.getCurrencyByCode(code);
  }

  Future<Result<Currency>> getDefaultCurrency() async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.getDefaultCurrency();
  }

  Future<Result<List<ExchangeRate>>> getExchangeRates(int currencyId) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.getExchangeRates(currencyId);
  }

  Future<Result<ExchangeRate>> getExchangeRate(int fromCurrencyId, int toCurrencyId) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.getExchangeRate(fromCurrencyId, toCurrencyId);
  }

  // Create operations
  Future<Result<Currency>> createCurrency(Map<String, dynamic> currencyData) async {
    final repository = ref.read(currencyRepositoryProvider);
    final result = await repository.createCurrency(currencyData);
    if (result.isSuccess) {
      // Refresh the currencies list after creating
      await refreshCurrencies();
    }
    return result;
  }

  Future<Result<ExchangeRate>> createExchangeRate(Map<String, dynamic> exchangeRateData) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.createExchangeRate(exchangeRateData);
  }

  // Update operations
  Future<Result<Currency>> updateCurrency(int id, Map<String, dynamic> currencyData) async {
    final repository = ref.read(currencyRepositoryProvider);
    final result = await repository.updateCurrency(id, currencyData);
    if (result.isSuccess) {
      // Refresh the currencies list after updating
      await refreshCurrencies();
    }
    return result;
  }

  Future<Result<ExchangeRate>> updateExchangeRate(int id, Map<String, dynamic> exchangeRateData) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.updateExchangeRate(id, exchangeRateData);
  }

  // Delete operations
  Future<Result<void>> deleteCurrency(int id) async {
    final repository = ref.read(currencyRepositoryProvider);
    final result = await repository.deleteCurrency(id);
    if (result.isSuccess) {
      // Refresh the currencies list after deleting
      await refreshCurrencies();
    }
    return result;
  }

  Future<Result<CurrencyConversion>> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.convertCurrency(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      amount: amount,
    );
  }

  // Currency preferences
  Future<Result<Currency>> updateCustomerCurrencyPreference(int customerId, int currencyId) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.updateCustomerCurrencyPreference(customerId, currencyId);
  }

  Future<Result<Currency>> getCustomerCurrencyPreference(int customerId) async {
    final repository = ref.read(currencyRepositoryProvider);
    return await repository.getCustomerCurrencyPreference(customerId);
  }

  Future<void> refreshCurrencies() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadCurrencies());
  }
}

@riverpod
Currency? defaultCurrency(DefaultCurrencyRef ref) {
  final currenciesAsync = ref.watch(currencyNotifierProvider);
  
  return currenciesAsync.when(
    data: (result) {
      if (result.isSuccess) {
        return result.data?.firstWhere(
          (currency) => currency.isDefault,
          orElse: () => result.data!.first,
        );
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
}

@riverpod
String formatCurrency(FormatCurrencyRef ref, double amount, {Currency? currency}) {
  final defaultCurrency = ref.watch(defaultCurrencyProvider);
  final selectedCurrency = currency ?? defaultCurrency;
  
  if (selectedCurrency == null) {
    // Fallback to USD if no currency is available
    return '${CurrencyFormatter.formatCRC(amount)}';
  }
  
  return '${selectedCurrency.symbol}${amount.toStringAsFixed(selectedCurrency.decimalPlaces)}';
} 