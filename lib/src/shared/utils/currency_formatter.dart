import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Map currencyId to currency symbols
  static const Map<int, String> _currencySymbols = {
    1: '\$', // USD
    2: '₡',  // CRC
  };

  // Map currencyId to currency codes
  static const Map<int, String> _currencyCodes = {
    1: 'USD',
    2: 'CRC',
  };

  // Get currency symbol by ID
  static String getCurrencySymbol(int currencyId) {
    return _currencySymbols[currencyId] ?? '₡'; // Default to CRC for unknown currencies
  }

  // Get currency code by ID
  static String getCurrencyCode(int currencyId) {
    return _currencyCodes[currencyId] ?? 'CRC'; // Default to CRC for unknown currencies
  }

  // Format currency by currencyId
  static String formatCurrencyByCurrencyId(double amount, int currencyId, {int decimalPlaces = 2}) {
    final symbol = getCurrencySymbol(currencyId);
    return formatCurrency(amount, symbol: symbol, decimalPlaces: decimalPlaces);
  }

  // Format currency with business currency (to be used with currentBusinessCurrencyIdProvider)
  static String formatBusinessCurrency(double amount, int businessCurrencyId, {int decimalPlaces = 2}) {
    return formatCurrencyByCurrencyId(amount, businessCurrencyId, decimalPlaces: decimalPlaces);
  }

  static String formatCurrency(double amount, {String? symbol, int decimalPlaces = 2}) {
    if (symbol == null) {
      // Default to USD symbol if no currency is specified
      return '\$${amount.toStringAsFixed(decimalPlaces)}';
    }
    
    return '$symbol${amount.toStringAsFixed(decimalPlaces)}';
  }

  static String formatCurrencyWithLocale(double amount, {String? locale, String? symbol}) {
    if (locale == null) {
      return formatCurrency(amount, symbol: symbol);
    }
    
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol ?? '\$',
    );
    
    return formatter.format(amount);
  }

  // Common currency symbols
  static const String usdSymbol = '\$';
  static const String crcSymbol = '₡';
  static const String eurSymbol = '€';
  static const String gbpSymbol = '£';
  
  // Format with common currencies
  static String formatUSD(double amount) => formatCurrency(amount, symbol: usdSymbol);
  static String formatCRC(double amount) => formatCurrency(amount, symbol: crcSymbol);
  static String formatEUR(double amount) => formatCurrency(amount, symbol: eurSymbol);
  static String formatGBP(double amount) => formatCurrency(amount, symbol: gbpSymbol);
} 