// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemAnalytics _$ItemAnalyticsFromJson(Map<String, dynamic> json) =>
    ItemAnalytics(
      topSellers: (json['topSellers'] as List<dynamic>?)
              ?.map((e) => ItemPerformance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      worstSellers: (json['worstSellers'] as List<dynamic>?)
              ?.map((e) => ItemPerformance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      profitMargins: (json['profitMargins'] as List<dynamic>?)
              ?.map((e) => ItemProfitMargin.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalItemsSold: (json['totalItemsSold'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ItemAnalyticsToJson(ItemAnalytics instance) =>
    <String, dynamic>{
      'topSellers': instance.topSellers,
      'worstSellers': instance.worstSellers,
      'profitMargins': instance.profitMargins,
      'totalItemsSold': instance.totalItemsSold,
      'totalRevenue': instance.totalRevenue,
    };

ItemPerformance _$ItemPerformanceFromJson(Map<String, dynamic> json) =>
    ItemPerformance(
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String,
      quantitySold: (json['quantitySold'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
    );

Map<String, dynamic> _$ItemPerformanceToJson(ItemPerformance instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'quantitySold': instance.quantitySold,
      'totalRevenue': instance.totalRevenue,
      'averagePrice': instance.averagePrice,
    };

ItemProfitMargin _$ItemProfitMarginFromJson(Map<String, dynamic> json) =>
    ItemProfitMargin(
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String,
      cost: (json['cost'] as num).toDouble(),
      revenue: (json['revenue'] as num).toDouble(),
      profitMargin: (json['profitMargin'] as num).toDouble(),
    );

Map<String, dynamic> _$ItemProfitMarginToJson(ItemProfitMargin instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'cost': instance.cost,
      'revenue': instance.revenue,
      'profitMargin': instance.profitMargin,
    };

RevenueAnalytics _$RevenueAnalyticsFromJson(Map<String, dynamic> json) =>
    RevenueAnalytics(
      dailyTrends: (json['dailyTrends'] as List<dynamic>?)
              ?.map((e) => RevenueTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weeklyTrends: (json['weeklyTrends'] as List<dynamic>?)
              ?.map((e) => RevenueTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyTrends: (json['monthlyTrends'] as List<dynamic>?)
              ?.map((e) => RevenueTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      yearlyTrends: (json['yearlyTrends'] as List<dynamic>?)
              ?.map((e) => RevenueTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      averageOrderValue: (json['averageOrderValue'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RevenueAnalyticsToJson(RevenueAnalytics instance) =>
    <String, dynamic>{
      'dailyTrends': instance.dailyTrends,
      'weeklyTrends': instance.weeklyTrends,
      'monthlyTrends': instance.monthlyTrends,
      'yearlyTrends': instance.yearlyTrends,
      'totalRevenue': instance.totalRevenue,
      'averageOrderValue': instance.averageOrderValue,
      'totalOrders': instance.totalOrders,
    };

RevenueTrend _$RevenueTrendFromJson(Map<String, dynamic> json) => RevenueTrend(
      period: json['period'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      orders: (json['orders'] as num).toInt(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
    );

Map<String, dynamic> _$RevenueTrendToJson(RevenueTrend instance) =>
    <String, dynamic>{
      'period': instance.period,
      'revenue': instance.revenue,
      'orders': instance.orders,
      'averageOrderValue': instance.averageOrderValue,
    };

StaffAnalytics _$StaffAnalyticsFromJson(Map<String, dynamic> json) =>
    StaffAnalytics(
      topPerformers: (json['topPerformers'] as List<dynamic>?)
              ?.map((e) => StaffPerformance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allStaff: (json['allStaff'] as List<dynamic>?)
              ?.map((e) => StaffPerformance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      averageSalesPerStaff:
          (json['averageSalesPerStaff'] as num?)?.toDouble() ?? 0.0,
      totalStaff: (json['totalStaff'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StaffAnalyticsToJson(StaffAnalytics instance) =>
    <String, dynamic>{
      'topPerformers': instance.topPerformers,
      'allStaff': instance.allStaff,
      'averageSalesPerStaff': instance.averageSalesPerStaff,
      'totalStaff': instance.totalStaff,
    };

StaffPerformance _$StaffPerformanceFromJson(Map<String, dynamic> json) =>
    StaffPerformance(
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      salesCount: (json['salesCount'] as num).toInt(),
      totalSales: (json['totalSales'] as num).toDouble(),
      averageSaleValue: (json['averageSaleValue'] as num).toDouble(),
      itemsSold: (json['itemsSold'] as num).toInt(),
    );

Map<String, dynamic> _$StaffPerformanceToJson(StaffPerformance instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'salesCount': instance.salesCount,
      'totalSales': instance.totalSales,
      'averageSaleValue': instance.averageSaleValue,
      'itemsSold': instance.itemsSold,
    };

CustomerAnalytics _$CustomerAnalyticsFromJson(Map<String, dynamic> json) =>
    CustomerAnalytics(
      topCustomers: (json['topCustomers'] as List<dynamic>?)
              ?.map((e) => CustomerInsight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allCustomers: (json['allCustomers'] as List<dynamic>?)
              ?.map((e) => CustomerInsight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      averageCustomerSpend:
          (json['averageCustomerSpend'] as num?)?.toDouble() ?? 0.0,
      totalCustomers: (json['totalCustomers'] as num?)?.toInt() ?? 0,
      retentionRate: (json['retentionRate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$CustomerAnalyticsToJson(CustomerAnalytics instance) =>
    <String, dynamic>{
      'topCustomers': instance.topCustomers,
      'allCustomers': instance.allCustomers,
      'averageCustomerSpend': instance.averageCustomerSpend,
      'totalCustomers': instance.totalCustomers,
      'retentionRate': instance.retentionRate,
    };

CustomerInsight _$CustomerInsightFromJson(Map<String, dynamic> json) =>
    CustomerInsight(
      customerEmail: json['customerEmail'] as String,
      customerName: json['customerName'] as String?,
      visitCount: (json['visitCount'] as num).toInt(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      averageSpend: (json['averageSpend'] as num).toDouble(),
      lastVisit: DateTime.parse(json['lastVisit'] as String),
    );

Map<String, dynamic> _$CustomerInsightToJson(CustomerInsight instance) =>
    <String, dynamic>{
      'customerEmail': instance.customerEmail,
      'customerName': instance.customerName,
      'visitCount': instance.visitCount,
      'totalSpent': instance.totalSpent,
      'averageSpend': instance.averageSpend,
      'lastVisit': instance.lastVisit.toIso8601String(),
    };

InventoryAnalytics _$InventoryAnalyticsFromJson(Map<String, dynamic> json) =>
    InventoryAnalytics(
      lowStockItems: (json['lowStockItems'] as List<dynamic>?)
              ?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      outOfStockItems: (json['outOfStockItems'] as List<dynamic>?)
              ?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      turnoverRates: (json['turnoverRates'] as List<dynamic>?)
              ?.map(
                  (e) => InventoryTurnover.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalInventoryValue:
          (json['totalInventoryValue'] as num?)?.toDouble() ?? 0.0,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$InventoryAnalyticsToJson(InventoryAnalytics instance) =>
    <String, dynamic>{
      'lowStockItems': instance.lowStockItems,
      'outOfStockItems': instance.outOfStockItems,
      'turnoverRates': instance.turnoverRates,
      'totalInventoryValue': instance.totalInventoryValue,
      'totalItems': instance.totalItems,
    };

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String,
      currentStock: (json['currentStock'] as num).toInt(),
      minimumStock: (json['minimumStock'] as num).toInt(),
      unitCost: (json['unitCost'] as num).toDouble(),
      totalValue: (json['totalValue'] as num).toDouble(),
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'currentStock': instance.currentStock,
      'minimumStock': instance.minimumStock,
      'unitCost': instance.unitCost,
      'totalValue': instance.totalValue,
    };

InventoryTurnover _$InventoryTurnoverFromJson(Map<String, dynamic> json) =>
    InventoryTurnover(
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String,
      turnoverRate: (json['turnoverRate'] as num).toDouble(),
      daysToSell: (json['daysToSell'] as num).toInt(),
      quantitySold: (json['quantitySold'] as num).toInt(),
    );

Map<String, dynamic> _$InventoryTurnoverToJson(InventoryTurnover instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'turnoverRate': instance.turnoverRate,
      'daysToSell': instance.daysToSell,
      'quantitySold': instance.quantitySold,
    };
