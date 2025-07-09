// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesReport _$SalesReportFromJson(Map<String, dynamic> json) => SalesReport(
      totalSales: (json['totalSales'] as num).toDouble(),
      totalTransactions: (json['totalTransactions'] as num).toInt(),
      averageTransactionValue:
          (json['averageTransactionValue'] as num).toDouble(),
      topSellingItems: (json['topSellingItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      salesByHour: (json['salesByHour'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$SalesReportToJson(SalesReport instance) =>
    <String, dynamic>{
      'totalSales': instance.totalSales,
      'totalTransactions': instance.totalTransactions,
      'averageTransactionValue': instance.averageTransactionValue,
      'topSellingItems': instance.topSellingItems,
      'salesByHour': instance.salesByHour,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
