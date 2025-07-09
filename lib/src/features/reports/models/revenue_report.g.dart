// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenueReport _$RevenueReportFromJson(Map<String, dynamic> json) =>
    RevenueReport(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      grossProfit: (json['grossProfit'] as num).toDouble(),
      profitMargin: (json['profitMargin'] as num).toDouble(),
      revenueByDay: (json['revenueByDay'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$RevenueReportToJson(RevenueReport instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'totalCost': instance.totalCost,
      'grossProfit': instance.grossProfit,
      'profitMargin': instance.profitMargin,
      'revenueByDay': instance.revenueByDay,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
