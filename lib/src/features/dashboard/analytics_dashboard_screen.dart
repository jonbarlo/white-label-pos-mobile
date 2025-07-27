import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../pos/pos_provider.dart';
import '../pos/models/analytics.dart';

class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends ConsumerState<AnalyticsDashboardScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Analytics providers
    final itemAnalytics = ref.watch(itemAnalyticsProvider(
      startDate: _startDate,
      endDate: _endDate,
      limit: 10,
    ));
    
    final revenueAnalytics = ref.watch(revenueAnalyticsProvider(
      startDate: _startDate,
      endDate: _endDate,
    ));
    
    final staffAnalytics = ref.watch(staffAnalyticsProvider(
      startDate: _startDate,
      endDate: _endDate,
      limit: 10,
    ));
    
    final customerAnalytics = ref.watch(customerAnalyticsProvider(
      startDate: _startDate,
      endDate: _endDate,
      limit: 10,
    ));
    
    final inventoryAnalytics = ref.watch(inventoryAnalyticsProvider(limit: 20));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Business Analytics',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          _buildDateRangeSelector(theme),
          _buildTabBar(theme),
          Expanded(
            child: _buildTabContent(
              theme,
              itemAnalytics,
              revenueAnalytics,
              staffAnalytics,
              customerAnalytics,
              inventoryAnalytics,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Card(
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Analysis Period',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateButton(
                      context: context,
                      theme: theme,
                      date: _startDate,
                      onTap: () => _selectDate(true),
                      isStartDate: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'to',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildDateButton(
                      context: context,
                      theme: theme,
                      date: _endDate,
                      onTap: () => _selectDate(false),
                      isStartDate: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required BuildContext context,
    required ThemeData theme,
    required DateTime date,
    required VoidCallback onTap,
    required bool isStartDate,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isStartDate ? 'Start Date' : 'End Date',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM dd, yyyy').format(date),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    final tabs = ['Revenue', 'Menu', 'Features', 'Staff', 'Customers', 'Inventory'];
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isSelected = _selectedTabIndex == index;
            
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTabIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? theme.colorScheme.primary 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected 
                          ? theme.colorScheme.onPrimary 
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    ThemeData theme,
    AsyncValue<ItemAnalytics> itemAnalytics,
    AsyncValue<RevenueAnalytics> revenueAnalytics,
    AsyncValue<StaffAnalytics> staffAnalytics,
    AsyncValue<CustomerAnalytics> customerAnalytics,
    AsyncValue<InventoryAnalytics> inventoryAnalytics,
  ) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildRevenueTab(revenueAnalytics, theme);
      case 1:
        return _buildMenuTab(itemAnalytics, theme);
      case 2:
        return _buildFeaturesTab(theme);
      case 3:
        return _buildStaffTab(staffAnalytics, theme);
      case 4:
        return _buildCustomersTab(customerAnalytics, theme);
      case 5:
        return _buildInventoryTab(inventoryAnalytics, theme);
      default:
        return _buildRevenueTab(revenueAnalytics, theme);
    }
  }

  Widget _buildRevenueTab(AsyncValue<RevenueAnalytics> revenueAnalytics, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(revenueAnalyticsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Revenue Performance',
              subtitle: 'Track your business revenue and trends',
              icon: Icons.analytics,
              theme: theme,
            ),
            revenueAnalytics.when(
              data: (analytics) => Column(
                children: [
                  // Key Metrics
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMetricCard(
                          'Total Revenue',
                          '\$${NumberFormat('#,##0.00').format(analytics.totalRevenue)}',
                          Icons.attach_money,
                          theme.colorScheme.primary,
                          theme,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricCard(
                          'Total Orders',
                          analytics.totalOrders.toString(),
                          Icons.receipt,
                          theme.colorScheme.secondary,
                          theme,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricCard(
                          'Average Order Value',
                          '\$${NumberFormat('#,##0.00').format(analytics.averageOrderValue)}',
                          Icons.trending_up,
                          theme.colorScheme.tertiary,
                          theme,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Revenue Trends
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timeline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Revenue Trends',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...analytics.dailyTrends.take(7).map((trend) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      elevation: 1,
                      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: theme.colorScheme.primary,
                            size: 16,
                          ),
                        ),
                        title: Text(
                          trend.period,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${trend.orders} orders',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        trailing: Text(
                          '\$${NumberFormat('#,##0.00').format(trend.revenue)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => _buildErrorCard('Revenue data', error.toString(), theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTab(AsyncValue<ItemAnalytics> itemAnalytics, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(itemAnalyticsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Menu Optimization',
              subtitle: 'Analyze your menu performance and trends',
              icon: Icons.restaurant_menu,
              theme: theme,
            ),
            itemAnalytics.when(
              data: (analytics) => Column(
                children: [
                                     // Summary Metrics
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         _buildMetricCard(
                           'Total Items Sold',
                           analytics.totalItemsSold.toString(),
                           Icons.inventory_2,
                           theme.colorScheme.primary,
                           theme,
                         ),
                         const SizedBox(width: 12),
                         _buildMetricCard(
                           'Total Revenue',
                           '\$${NumberFormat('#,##0.00').format(analytics.totalRevenue)}',
                           Icons.attach_money,
                           theme.colorScheme.secondary,
                           theme,
                         ),
                       ],
                     ),
                   ),
                  const SizedBox(height: 16),
                  
                  // Top Performers
                  Text(
                    '🏆 Top Selling Items',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.topSellers.take(5).map((item) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          item.itemName.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: theme.colorScheme.onPrimary),
                        ),
                      ),
                      title: Text(item.itemName),
                      subtitle: Text('${item.quantitySold} sold • \$${NumberFormat('#,##0.00').format(item.averagePrice)} avg'),
                      trailing: Text(
                        '\$${NumberFormat('#,##0.00').format(item.totalRevenue)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  
                  // Underperformers
                  Text(
                    '⚠️ Underperforming Items',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.worstSellers.take(3).map((item) => Card(
                    color: Colors.orange.withValues(alpha: 0.1),
                    child: ListTile(
                      leading: Icon(
                        Icons.warning,
                        color: Colors.orange,
                      ),
                      title: Text(item.itemName),
                      subtitle: Text('Only ${item.quantitySold} sold'),
                      trailing: Text(
                        '\$${NumberFormat('#,##0.00').format(item.totalRevenue)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  
                  // Profit Margins
                  Text(
                    '💰 Profit Margins',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.profitMargins.take(5).map((item) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.profitMargin > 50 ? Colors.green : 
                                        item.profitMargin > 30 ? Colors.orange : Colors.red,
                        child: Text(
                          '${item.profitMargin.toInt()}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(item.itemName),
                      subtitle: Text('Revenue: \$${NumberFormat('#,##0.00').format(item.revenue)}'),
                      trailing: Text(
                        '${item.profitMargin.toStringAsFixed(1)}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: item.profitMargin > 50 ? Colors.green : 
                                 item.profitMargin > 30 ? Colors.orange : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => _buildErrorCard('Menu data', error.toString(), theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffTab(AsyncValue<StaffAnalytics> staffAnalytics, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(staffAnalyticsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Staff Performance',
              subtitle: 'Monitor your team productivity and sales',
              icon: Icons.people,
              theme: theme,
            ),
            staffAnalytics.when(
              data: (analytics) => Column(
                children: [
                                     // Summary Metrics
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         _buildMetricCard(
                           'Total Staff',
                           analytics.totalStaff.toString(),
                           Icons.people,
                           theme.colorScheme.primary,
                           theme,
                         ),
                         const SizedBox(width: 12),
                         _buildMetricCard(
                           'Avg Sales/Staff',
                           '\$${NumberFormat('#,##0.00').format(analytics.averageSalesPerStaff)}',
                           Icons.trending_up,
                           theme.colorScheme.secondary,
                           theme,
                         ),
                       ],
                     ),
                   ),
                  const SizedBox(height: 16),
                  
                  // Top Performers
                  Text(
                    '🏆 Top Performers',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.topPerformers.take(5).map((staff) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.secondary,
                        child: Text(
                          staff.userName.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: theme.colorScheme.onSecondary),
                        ),
                      ),
                      title: Text(staff.userName),
                      subtitle: Text('${staff.salesCount} sales • ${staff.itemsSold} items'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${NumberFormat('#,##0.00').format(staff.totalSales)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${NumberFormat('#,##0.00').format(staff.averageSaleValue)} avg',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  
                  // All Staff Performance
                  Text(
                    '📊 All Staff Performance',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.allStaff.take(10).map((staff) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: staff.totalSales > analytics.averageSalesPerStaff 
                            ? Colors.green : Colors.grey,
                        child: Text(
                          staff.userName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(staff.userName),
                      subtitle: Text('${staff.salesCount} sales'),
                      trailing: Text(
                        '\$${NumberFormat('#,##0.00').format(staff.totalSales)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: staff.totalSales > analytics.averageSalesPerStaff 
                              ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => _buildErrorCard('Staff data', error.toString(), theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomersTab(AsyncValue<CustomerAnalytics> customerAnalytics, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(customerAnalyticsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Customer Insights',
              subtitle: 'Understand your customer behavior and loyalty',
              icon: Icons.insights,
              theme: theme,
            ),
            customerAnalytics.when(
              data: (analytics) => Column(
                children: [
                                     // Summary Metrics
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         _buildMetricCard(
                           'Total Customers',
                           analytics.totalCustomers.toString(),
                           Icons.people,
                           theme.colorScheme.primary,
                           theme,
                         ),
                         const SizedBox(width: 12),
                         _buildMetricCard(
                           'Avg Customer Spend',
                           '\$${NumberFormat('#,##0.00').format(analytics.averageCustomerSpend)}',
                           Icons.attach_money,
                           theme.colorScheme.secondary,
                           theme,
                         ),
                         const SizedBox(width: 12),
                         _buildMetricCard(
                           'Retention Rate',
                           '${analytics.retentionRate.toStringAsFixed(1)}%',
                           Icons.loyalty,
                           theme.colorScheme.tertiary,
                           theme,
                         ),
                       ],
                     ),
                   ),
                  const SizedBox(height: 16),
                  
                  // VIP Customers
                  Text(
                    '👑 VIP Customers',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.topCustomers.take(5).map((customer) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.tertiary,
                        child: Text(
                          (customer.customerName ?? customer.customerEmail).substring(0, 1).toUpperCase(),
                          style: TextStyle(color: theme.colorScheme.onTertiary),
                        ),
                      ),
                      title: Text(customer.customerName ?? 'Guest'),
                      subtitle: Text('${customer.visitCount} visits • Last: ${DateFormat('MMM dd').format(customer.lastVisit)}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${NumberFormat('#,##0.00').format(customer.totalSpent)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${NumberFormat('#,##0.00').format(customer.averageSpend)} avg',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  
                  // Customer Segments
                  Text(
                    '📈 Customer Segments',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildCustomerSegmentCard('High Value', analytics.topCustomers.take(3).toList(), Colors.green, theme),
                  _buildCustomerSegmentCard('Regular', analytics.allCustomers.take(5).toList(), Colors.blue, theme),
                ],
              ),
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => _buildErrorCard('Customer data', error.toString(), theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTab(AsyncValue<InventoryAnalytics> inventoryAnalytics, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(inventoryAnalyticsProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Inventory Management',
              subtitle: 'Track stock levels and turnover rates',
              icon: Icons.inventory,
              theme: theme,
            ),
            inventoryAnalytics.when(
              data: (analytics) => Column(
                children: [
                                     // Summary Metrics
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         _buildMetricCard(
                           'Total Items',
                           analytics.totalItems.toString(),
                           Icons.inventory,
                           theme.colorScheme.primary,
                           theme,
                         ),
                         const SizedBox(width: 12),
                         _buildMetricCard(
                           'Total Value',
                           '\$${NumberFormat('#,##0.00').format(analytics.totalInventoryValue)}',
                           Icons.attach_money,
                           theme.colorScheme.secondary,
                           theme,
                         ),
                       ],
                     ),
                   ),
                  const SizedBox(height: 16),
                  
                  // Critical Alerts
                  if (analytics.outOfStockItems.isNotEmpty) ...[
                    Text(
                      '🚨 Out of Stock Items',
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ...analytics.outOfStockItems.take(5).map((item) => Card(
                      color: Colors.red.withValues(alpha: 0.1),
                      child: ListTile(
                        leading: Icon(Icons.error, color: Colors.red),
                        title: Text(item.itemName),
                        subtitle: Text('Unit Cost: \$${NumberFormat('#,##0.00').format(item.unitCost)}'),
                        trailing: const Text(
                          'REORDER NOW',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                    const SizedBox(height: 16),
                  ],
                  
                  // Low Stock Warnings
                  if (analytics.lowStockItems.isNotEmpty) ...[
                    Text(
                      '⚠️ Low Stock Items',
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.orange),
                    ),
                    const SizedBox(height: 8),
                    ...analytics.lowStockItems.take(5).map((item) => Card(
                      color: Colors.orange.withValues(alpha: 0.1),
                      child: ListTile(
                        leading: Icon(Icons.warning, color: Colors.orange),
                        title: Text(item.itemName),
                        subtitle: Text('${item.currentStock} remaining (Min: ${item.minimumStock})'),
                        trailing: Text(
                          '\$${NumberFormat('#,##0.00').format(item.totalValue)}',
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.orange),
                        ),
                      ),
                    )),
                    const SizedBox(height: 16),
                  ],
                  
                  // Turnover Analysis
                  Text(
                    '📊 Turnover Analysis',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.turnoverRates.take(5).map((item) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.turnoverRate > 10 ? Colors.green : 
                                        item.turnoverRate > 5 ? Colors.orange : Colors.red,
                        child: Text(
                          '${item.turnoverRate.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(item.itemName),
                      subtitle: Text('${item.quantitySold} sold • ${item.daysToSell} days to sell'),
                      trailing: Text(
                        '${item.turnoverRate.toStringAsFixed(1)}x',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: item.turnoverRate > 10 ? Colors.green : 
                                 item.turnoverRate > 5 ? Colors.orange : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                  
                  // All Good Message
                  if (analytics.lowStockItems.isEmpty && analytics.outOfStockItems.isEmpty)
                    Card(
                      color: Colors.green.withValues(alpha: 0.1),
                      child: const ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('All items are well stocked!'),
                        subtitle: Text('No immediate inventory concerns'),
                      ),
                    ),
                ],
              ),
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => _buildErrorCard('Inventory data', error.toString(), theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTab(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh features data when providers are available
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Recipe & Promotion Performance',
              subtitle: 'Monitor your features and engagement metrics',
              icon: Icons.auto_awesome,
              theme: theme,
            ),
            
                         // Key Metrics Row
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 children: [
                   _buildMetricCard(
                     'Active Recipes',
                     '12',
                     Icons.restaurant_menu,
                     Colors.green,
                     theme,
                   ),
                   const SizedBox(width: 12),
                   _buildMetricCard(
                     'Active Promotions',
                     '3',
                     Icons.local_offer,
                     Colors.orange,
                     theme,
                   ),
                   const SizedBox(width: 12),
                   _buildMetricCard(
                     'Notifications Sent',
                     '45',
                     Icons.notifications,
                     Colors.blue,
                     theme,
                   ),
                 ],
               ),
             ),
            const SizedBox(height: 24),
            
            // Recipe Performance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant_menu, color: Colors.green, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Top Performing Recipes',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRecipePerformanceItem('Classic Burger', '156 views', '4.8★', Colors.green),
                    _buildRecipePerformanceItem('Caesar Salad', '89 views', '4.6★', Colors.green),
                    _buildRecipePerformanceItem('Margherita Pizza', '67 views', '4.4★', Colors.orange),
                    _buildRecipePerformanceItem('Chocolate Cake', '45 views', '4.2★', Colors.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Promotion Performance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.orange, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Promotion Effectiveness',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPromotionPerformanceItem('Happy Hour Special', '67 uses', '45% conversion', Colors.orange),
                    _buildPromotionPerformanceItem('Student Discount', '89 uses', '38% conversion', Colors.blue),
                    _buildPromotionPerformanceItem('Weekend Brunch', '34 uses', '52% conversion', Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Notification Analytics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications, color: Colors.blue, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Notification Engagement',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNotificationMetric('Open Rate', '78%', Colors.green),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildNotificationMetric('Click Rate', '23%', Colors.blue),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildNotificationMetric('Conversion', '12%', Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            'Smart Suggestions',
                            Icons.psychology,
                            Colors.green,
                            () {
                              context.go('/smart-suggestions');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionButton(
                            'Inventory Alerts',
                            Icons.warning,
                            Colors.orange,
                            () {
                              context.go('/inventory-alerts');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionButton(
                            'Create Recipe',
                            Icons.add,
                            Colors.blue,
                            () {
                              // TODO: Navigate to recipe creation
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            'View Full Reports',
                            Icons.assessment,
                            Colors.purple,
                            () {
                              // Navigate to detailed reports
                              context.go('/reports');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionButton(
                            'Feature Dashboard',
                            Icons.dashboard,
                            Colors.indigo,
                            () {
                              // Navigate to feature dashboard
                              context.go('/feature-dashboard');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipePerformanceItem(String name, String views, String rating, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              views,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              rating,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionPerformanceItem(String name, String uses, String conversion, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              uses,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              conversion,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Flexible(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        minimumSize: const Size(0, 48),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.08),
              color.withValues(alpha: 0.04),
            ],
          ),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.trending_up,
                    color: color.withValues(alpha: 0.6),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSegmentCard(String title, List<CustomerInsight> customers, Color color, ThemeData theme) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...customers.map((customer) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      customer.customerName ?? customer.customerEmail,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(customer.totalSpent)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String dataType, String error, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.error.withValues(alpha: 0.08),
                theme.colorScheme.error.withValues(alpha: 0.04),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.error,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to Load $dataType',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection and try again',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  // Trigger refresh based on current tab
                  switch (_selectedTabIndex) {
                    case 0:
                      ref.invalidate(revenueAnalyticsProvider);
                      break;
                    case 1:
                      ref.invalidate(itemAnalyticsProvider);
                      break;
                    case 3:
                      ref.invalidate(staffAnalyticsProvider);
                      break;
                    case 4:
                      ref.invalidate(customerAnalyticsProvider);
                      break;
                    case 5:
                      ref.invalidate(inventoryAnalyticsProvider);
                      break;
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}