import 'package:json_annotation/json_annotation.dart';

part 'analytics.g.dart';

// Item Analytics Models
@JsonSerializable()
class ItemAnalytics {
  @JsonKey(defaultValue: [])
  final List<ItemPerformance> topSellers;
  @JsonKey(defaultValue: [])
  final List<ItemPerformance> worstSellers;
  @JsonKey(defaultValue: [])
  final List<ItemProfitMargin> profitMargins;
  @JsonKey(defaultValue: 0)
  final int totalItemsSold;
  @JsonKey(defaultValue: 0.0)
  final double totalRevenue;

  const ItemAnalytics({
    required this.topSellers,
    required this.worstSellers,
    required this.profitMargins,
    required this.totalItemsSold,
    required this.totalRevenue,
  });

  factory ItemAnalytics.fromJson(Map<String, dynamic> json) => _$ItemAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemAnalyticsToJson(this);
}

@JsonSerializable()
class ItemPerformance {
  final int itemId;
  final String itemName;
  final int quantitySold;
  final double totalRevenue;
  final double averagePrice;

  const ItemPerformance({
    required this.itemId,
    required this.itemName,
    required this.quantitySold,
    required this.totalRevenue,
    required this.averagePrice,
  });

  factory ItemPerformance.fromJson(Map<String, dynamic> json) => _$ItemPerformanceFromJson(json);
  Map<String, dynamic> toJson() => _$ItemPerformanceToJson(this);
}

@JsonSerializable()
class ItemProfitMargin {
  final int itemId;
  final String itemName;
  final double cost;
  final double revenue;
  final double profitMargin;

  const ItemProfitMargin({
    required this.itemId,
    required this.itemName,
    required this.cost,
    required this.revenue,
    required this.profitMargin,
  });

  factory ItemProfitMargin.fromJson(Map<String, dynamic> json) => _$ItemProfitMarginFromJson(json);
  Map<String, dynamic> toJson() => _$ItemProfitMarginToJson(this);
}

// Revenue Analytics Models
@JsonSerializable()
class RevenueAnalytics {
  @JsonKey(defaultValue: [])
  final List<RevenueTrend> dailyTrends;
  @JsonKey(defaultValue: [])
  final List<RevenueTrend> weeklyTrends;
  @JsonKey(defaultValue: [])
  final List<RevenueTrend> monthlyTrends;
  @JsonKey(defaultValue: [])
  final List<RevenueTrend> yearlyTrends;
  @JsonKey(defaultValue: 0.0)
  final double totalRevenue;
  @JsonKey(defaultValue: 0.0)
  final double averageOrderValue;
  @JsonKey(defaultValue: 0)
  final int totalOrders;

  const RevenueAnalytics({
    required this.dailyTrends,
    required this.weeklyTrends,
    required this.monthlyTrends,
    required this.yearlyTrends,
    required this.totalRevenue,
    required this.averageOrderValue,
    required this.totalOrders,
  });

  factory RevenueAnalytics.fromJson(Map<String, dynamic> json) => _$RevenueAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$RevenueAnalyticsToJson(this);
}

@JsonSerializable()
class RevenueTrend {
  final String period;
  final double revenue;
  final int orders;
  final double averageOrderValue;

  const RevenueTrend({
    required this.period,
    required this.revenue,
    required this.orders,
    required this.averageOrderValue,
  });

  factory RevenueTrend.fromJson(Map<String, dynamic> json) => _$RevenueTrendFromJson(json);
  Map<String, dynamic> toJson() => _$RevenueTrendToJson(this);
}

// Staff Analytics Models
@JsonSerializable()
class StaffAnalytics {
  @JsonKey(defaultValue: [])
  final List<StaffPerformance> topPerformers;
  @JsonKey(defaultValue: [])
  final List<StaffPerformance> allStaff;
  @JsonKey(defaultValue: 0.0)
  final double averageSalesPerStaff;
  @JsonKey(defaultValue: 0)
  final int totalStaff;

  const StaffAnalytics({
    required this.topPerformers,
    required this.allStaff,
    required this.averageSalesPerStaff,
    required this.totalStaff,
  });

  factory StaffAnalytics.fromJson(Map<String, dynamic> json) => _$StaffAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$StaffAnalyticsToJson(this);
}

@JsonSerializable()
class StaffPerformance {
  final int userId;
  final String userName;
  final int salesCount;
  final double totalSales;
  final double averageSaleValue;
  final int itemsSold;

  const StaffPerformance({
    required this.userId,
    required this.userName,
    required this.salesCount,
    required this.totalSales,
    required this.averageSaleValue,
    required this.itemsSold,
  });

  factory StaffPerformance.fromJson(Map<String, dynamic> json) => _$StaffPerformanceFromJson(json);
  Map<String, dynamic> toJson() => _$StaffPerformanceToJson(this);
}

// Customer Analytics Models
@JsonSerializable()
class CustomerAnalytics {
  @JsonKey(defaultValue: [])
  final List<CustomerInsight> topCustomers;
  @JsonKey(defaultValue: [])
  final List<CustomerInsight> allCustomers;
  @JsonKey(defaultValue: 0.0)
  final double averageCustomerSpend;
  @JsonKey(defaultValue: 0)
  final int totalCustomers;
  @JsonKey(defaultValue: 0.0)
  final double retentionRate;

  const CustomerAnalytics({
    required this.topCustomers,
    required this.allCustomers,
    required this.averageCustomerSpend,
    required this.totalCustomers,
    required this.retentionRate,
  });

  factory CustomerAnalytics.fromJson(Map<String, dynamic> json) => _$CustomerAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerAnalyticsToJson(this);
}

@JsonSerializable()
class CustomerInsight {
  final String customerEmail;
  final String? customerName;
  final int visitCount;
  final double totalSpent;
  final double averageSpend;
  final DateTime lastVisit;

  const CustomerInsight({
    required this.customerEmail,
    this.customerName,
    required this.visitCount,
    required this.totalSpent,
    required this.averageSpend,
    required this.lastVisit,
  });

  factory CustomerInsight.fromJson(Map<String, dynamic> json) => _$CustomerInsightFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerInsightToJson(this);
}

// Inventory Analytics Models
@JsonSerializable()
class InventoryAnalytics {
  @JsonKey(defaultValue: [])
  final List<InventoryItem> lowStockItems;
  @JsonKey(defaultValue: [])
  final List<InventoryItem> outOfStockItems;
  @JsonKey(defaultValue: [])
  final List<InventoryTurnover> turnoverRates;
  @JsonKey(defaultValue: 0.0)
  final double totalInventoryValue;
  @JsonKey(defaultValue: 0)
  final int totalItems;

  const InventoryAnalytics({
    required this.lowStockItems,
    required this.outOfStockItems,
    required this.turnoverRates,
    required this.totalInventoryValue,
    required this.totalItems,
  });

  factory InventoryAnalytics.fromJson(Map<String, dynamic> json) => _$InventoryAnalyticsFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryAnalyticsToJson(this);
}

@JsonSerializable()
class InventoryItem {
  final int itemId;
  final String itemName;
  final int currentStock;
  final int minimumStock;
  final double unitCost;
  final double totalValue;

  const InventoryItem({
    required this.itemId,
    required this.itemName,
    required this.currentStock,
    required this.minimumStock,
    required this.unitCost,
    required this.totalValue,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);
}

@JsonSerializable()
class InventoryTurnover {
  final int itemId;
  final String itemName;
  final double turnoverRate;
  final int daysToSell;
  final int quantitySold;

  const InventoryTurnover({
    required this.itemId,
    required this.itemName,
    required this.turnoverRate,
    required this.daysToSell,
    required this.quantitySold,
  });

  factory InventoryTurnover.fromJson(Map<String, dynamic> json) => _$InventoryTurnoverFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryTurnoverToJson(this);
} 