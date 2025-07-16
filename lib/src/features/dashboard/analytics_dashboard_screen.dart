import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../shared/widgets/theme_toggle_button.dart';
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
      appBar: AppBar(
        title: const Text('Business Analytics'),
        centerTitle: true,
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
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis Period',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('MMM dd, yyyy').format(_startDate)),
                  ),
                ),
                const Text(' to '),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _selectDate(false),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('MMM dd, yyyy').format(_endDate)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabButton('Revenue', 0, theme),
            _buildTabButton('Menu', 1, theme),
            _buildTabButton('Staff', 2, theme),
            _buildTabButton('Customers', 3, theme),
            _buildTabButton('Inventory', 4, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, ThemeData theme) {
    final isSelected = _selectedTabIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedTabIndex = index),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          foregroundColor: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
        ),
        child: Text(label),
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
        return _buildStaffTab(staffAnalytics, theme);
      case 3:
        return _buildCustomersTab(customerAnalytics, theme);
      case 4:
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
            Text(
              'Revenue Performance',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            revenueAnalytics.when(
              data: (analytics) => Column(
                children: [
                  // Key Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Total Revenue',
                          '\$${NumberFormat('#,##0.00').format(analytics.totalRevenue)}',
                          Icons.attach_money,
                          theme.colorScheme.primary,
                          theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Total Orders',
                          analytics.totalOrders.toString(),
                          Icons.receipt,
                          theme.colorScheme.secondary,
                          theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMetricCard(
                    'Average Order Value',
                    '\$${NumberFormat('#,##0.00').format(analytics.averageOrderValue)}',
                    Icons.trending_up,
                    theme.colorScheme.tertiary,
                    theme,
                  ),
                  const SizedBox(height: 16),
                  
                  // Revenue Trends
                  Text(
                    'Revenue Trends',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...analytics.dailyTrends.take(7).map((trend) => Card(
                    child: ListTile(
                      title: Text(trend.period),
                      subtitle: Text('${trend.orders} orders'),
                      trailing: Text(
                        '\$${NumberFormat('#,##0.00').format(trend.revenue)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
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
            Text(
              'Menu Optimization',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            itemAnalytics.when(
              data: (analytics) => Column(
                children: [
                  // Summary Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Total Items Sold',
                          analytics.totalItemsSold.toString(),
                          Icons.inventory_2,
                          theme.colorScheme.primary,
                          theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Total Revenue',
                          '\$${NumberFormat('#,##0.00').format(analytics.totalRevenue)}',
                          Icons.attach_money,
                          theme.colorScheme.secondary,
                          theme,
                        ),
                      ),
                    ],
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
              loading: () => const Center(child: CircularProgressIndicator()),
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
            Text(
              'Staff Performance',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            staffAnalytics.when(
              data: (analytics) => Column(
                children: [
                  // Summary Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Total Staff',
                          analytics.totalStaff.toString(),
                          Icons.people,
                          theme.colorScheme.primary,
                          theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Avg Sales/Staff',
                          '\$${NumberFormat('#,##0.00').format(analytics.averageSalesPerStaff)}',
                          Icons.trending_up,
                          theme.colorScheme.secondary,
                          theme,
                        ),
                      ),
                    ],
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
              loading: () => const Center(child: CircularProgressIndicator()),
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
            Text(
              'Customer Insights',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            customerAnalytics.when(
              data: (analytics) => Column(
                children: [
                  // Summary Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Total Customers',
                          analytics.totalCustomers.toString(),
                          Icons.people,
                          theme.colorScheme.primary,
                          theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Avg Customer Spend',
                          '\$${NumberFormat('#,##0.00').format(analytics.averageCustomerSpend)}',
                          Icons.attach_money,
                          theme.colorScheme.secondary,
                          theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMetricCard(
                    'Retention Rate',
                    '${analytics.retentionRate.toStringAsFixed(1)}%',
                    Icons.loyalty,
                    theme.colorScheme.tertiary,
                    theme,
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
              loading: () => const Center(child: CircularProgressIndicator()),
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
            Text(
              'Inventory Management',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            inventoryAnalytics.when(
              data: (analytics) => Column(
                children: [
                  // Summary Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Total Items',
                          analytics.totalItems.toString(),
                          Icons.inventory,
                          theme.colorScheme.primary,
                          theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricCard(
                          'Total Value',
                          '\$${NumberFormat('#,##0.00').format(analytics.totalInventoryValue)}',
                          Icons.attach_money,
                          theme.colorScheme.secondary,
                          theme,
                        ),
                      ),
                    ],
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorCard('Inventory data', error.toString(), theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
    return Card(
      color: theme.colorScheme.error.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.error, color: theme.colorScheme.error, size: 48),
            const SizedBox(height: 8),
            Text(
              'Error loading $dataType',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
            ),
            const SizedBox(height: 4),
            Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
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
} 