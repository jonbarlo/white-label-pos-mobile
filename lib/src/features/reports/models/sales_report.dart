import 'package:json_annotation/json_annotation.dart';

part 'sales_report.g.dart';

@JsonSerializable()
class SalesReport {
  final double totalSales;
  final int totalTransactions;
  final double averageTransactionValue;
  final List<String> topSellingItems;
  final Map<String, double> salesByHour;
  final DateTime startDate;
  final DateTime endDate;

  const SalesReport({
    required this.totalSales,
    required this.totalTransactions,
    required this.averageTransactionValue,
    required this.topSellingItems,
    required this.salesByHour,
    required this.startDate,
    required this.endDate,
  });

  factory SalesReport.fromJson(Map<String, dynamic> json) =>
      _$SalesReportFromJson(json);

  Map<String, dynamic> toJson() => _$SalesReportToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesReport &&
          runtimeType == other.runtimeType &&
          totalSales == other.totalSales &&
          totalTransactions == other.totalTransactions &&
          averageTransactionValue == other.averageTransactionValue &&
          topSellingItems == other.topSellingItems &&
          salesByHour == other.salesByHour &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode =>
      totalSales.hashCode ^
      totalTransactions.hashCode ^
      averageTransactionValue.hashCode ^
      topSellingItems.hashCode ^
      salesByHour.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;

  @override
  String toString() {
    return 'SalesReport{totalSales: $totalSales, totalTransactions: $totalTransactions, averageTransactionValue: $averageTransactionValue, topSellingItems: $topSellingItems, salesByHour: $salesByHour, startDate: $startDate, endDate: $endDate}';
  }
} 