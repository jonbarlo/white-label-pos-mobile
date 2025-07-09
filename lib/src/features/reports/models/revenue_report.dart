import 'package:json_annotation/json_annotation.dart';

part 'revenue_report.g.dart';

@JsonSerializable()
class RevenueReport {
  final double totalRevenue;
  final double totalCost;
  final double grossProfit;
  final double profitMargin;
  final Map<String, double> revenueByDay;
  final DateTime startDate;
  final DateTime endDate;

  const RevenueReport({
    required this.totalRevenue,
    required this.totalCost,
    required this.grossProfit,
    required this.profitMargin,
    required this.revenueByDay,
    required this.startDate,
    required this.endDate,
  });

  factory RevenueReport.fromJson(Map<String, dynamic> json) =>
      _$RevenueReportFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueReportToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevenueReport &&
          runtimeType == other.runtimeType &&
          totalRevenue == other.totalRevenue &&
          totalCost == other.totalCost &&
          grossProfit == other.grossProfit &&
          profitMargin == other.profitMargin &&
          revenueByDay == other.revenueByDay &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode =>
      totalRevenue.hashCode ^
      totalCost.hashCode ^
      grossProfit.hashCode ^
      profitMargin.hashCode ^
      revenueByDay.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;

  @override
  String toString() {
    return 'RevenueReport{totalRevenue: $totalRevenue, totalCost: $totalCost, grossProfit: $grossProfit, profitMargin: $profitMargin, revenueByDay: $revenueByDay, startDate: $startDate, endDate: $endDate}';
  }
} 