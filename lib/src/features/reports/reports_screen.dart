import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:white_label_pos_mobile/src/features/reports/reports_provider.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/sales_report.dart';
import 'package:white_label_pos_mobile/src/features/reports/models/revenue_report.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/app_button.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/error_widget.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/loading_widget.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedPeriod = '30d';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setDateRange(String period) {
    setState(() {
      _selectedPeriod = period;
      final now = DateTime.now();
      switch (period) {
        case '7d':
          _startDate = now.subtract(const Duration(days: 7));
          break;
        case '30d':
          _startDate = now.subtract(const Duration(days: 30));
          break;
        case '90d':
          _startDate = now.subtract(const Duration(days: 90));
          break;
        case '1y':
          _startDate = now.subtract(const Duration(days: 365));
          break;
      }
      _endDate = now;
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedPeriod = 'custom';
      });
    }
  }

  Future<void> _exportReport() async {
    try {
      final notifier = ref.read(reportsNotifierProvider.notifier);
      final downloadUrl = await notifier.exportReport(
        reportType: 'sales',
        startDate: _startDate,
        endDate: _endDate,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Sales'),
            Tab(text: 'Revenue'),
            Tab(text: 'Customers'),
            Tab(text: 'Inventory'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date range selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.date_range, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Date Range',
                      style: theme.textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Text(
                      '${DateFormat('MMM dd').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _PeriodChip(
                              label: '7D',
                              value: '7d',
                              selected: _selectedPeriod == '7d',
                              onTap: () => _setDateRange('7d'),
                            ),
                            const SizedBox(width: 8),
                            _PeriodChip(
                              label: '30D',
                              value: '30d',
                              selected: _selectedPeriod == '30d',
                              onTap: () => _setDateRange('30d'),
                            ),
                            const SizedBox(width: 8),
                            _PeriodChip(
                              label: '90D',
                              value: '90d',
                              selected: _selectedPeriod == '90d',
                              onTap: () => _setDateRange('90d'),
                            ),
                            const SizedBox(width: 8),
                            _PeriodChip(
                              label: '1Y',
                              value: '1y',
                              selected: _selectedPeriod == '1y',
                              onTap: () => _setDateRange('1y'),
                            ),
                            const SizedBox(width: 8),
                            _PeriodChip(
                              label: 'Custom',
                              value: 'custom',
                              selected: _selectedPeriod == 'custom',
                              onTap: _selectDateRange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(startDate: _startDate, endDate: _endDate),
                _SalesTab(startDate: _startDate, endDate: _endDate),
                _RevenueTab(startDate: _startDate, endDate: _endDate),
                _CustomersTab(startDate: _startDate, endDate: _endDate),
                _InventoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? theme.colorScheme.primary : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  const _OverviewTab({
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesReportAsync = ref.watch(salesReportProvider(
      startDate: startDate,
      endDate: endDate,
    ));
    final revenueReportAsync = ref.watch(revenueReportProvider(
      startDate: startDate,
      endDate: endDate,
    ));

    return salesReportAsync.when(
      data: (salesReport) => revenueReportAsync.when(
        data: (revenueReport) => _buildOverviewContent(context, salesReport, revenueReport),
        loading: () => const LoadingWidget(),
        error: (error, stack) => AppErrorWidget(message: error.toString()),
      ),
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(message: error.toString()),
    );
  }

  Widget _buildOverviewContent(BuildContext context, SalesReport salesReport, RevenueReport revenueReport) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics
          Text(
            'Key Metrics',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Total Sales',
                  value: currencyFormat.format(salesReport.totalSales),
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  title: 'Transactions',
                  value: salesReport.totalTransactions.toString(),
                  icon: Icons.receipt,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Avg. Transaction',
                  value: currencyFormat.format(salesReport.averageTransactionValue),
                  icon: Icons.trending_up,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  title: 'Profit Margin',
                  value: '${revenueReport.profitMargin.toStringAsFixed(1)}%',
                  icon: Icons.percent,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Top Selling Items
          Text(
            'Top Selling Items',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: salesReport.topSellingItems.take(5).map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item)),
                      Text(
                        'Popular',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          
          // Sales by Hour
          Text(
            'Sales by Hour',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: _buildSalesChart(salesReport.salesByHour, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart(Map<String, double> salesByHour, ThemeData theme) {
    if (salesByHour.isEmpty) {
      return Center(
        child: Text(
          'No sales data available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    final maxSales = salesByHour.values.reduce((a, b) => a > b ? a : b);
    final sortedHours = salesByHour.keys.toList()..sort();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: sortedHours.map((hour) {
        final sales = salesByHour[hour] ?? 0;
        final height = maxSales > 0 ? (sales / maxSales) : 0;
        
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: (120 * height).toDouble(),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hour,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SalesTab extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  const _SalesTab({
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesReportAsync = ref.watch(salesReportProvider(
      startDate: startDate,
      endDate: endDate,
    ));

    return salesReportAsync.when(
      data: (salesReport) => _buildSalesContent(context, salesReport),
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(message: error.toString()),
    );
  }

  Widget _buildSalesContent(BuildContext context, SalesReport report) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sales Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Summary',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Sales',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            currencyFormat.format(report.totalSales),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transactions',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            report.totalTransactions.toString(),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Average Transaction: ${currencyFormat.format(report.averageTransactionValue)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Top Selling Items
          Text(
            'Top Selling Items',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.topSellingItems.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final item = report.topSellingItems[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(item),
                  subtitle: Text('Top seller'),
                  trailing: Icon(
                    Icons.trending_up,
                    color: Colors.green,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueTab extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  const _RevenueTab({
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueReportAsync = ref.watch(revenueReportProvider(
      startDate: startDate,
      endDate: endDate,
    ));

    return revenueReportAsync.when(
      data: (revenueReport) => _buildRevenueContent(context, revenueReport),
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(message: error.toString()),
    );
  }

  Widget _buildRevenueContent(BuildContext context, RevenueReport report) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Summary',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Revenue',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            currencyFormat.format(report.totalRevenue),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gross Profit',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            currencyFormat.format(report.grossProfit),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Profit Margin: ${report.profitMargin.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Revenue by Day
          Text(
            'Revenue by Day',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: _buildRevenueChart(report.revenueByDay, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(Map<String, double> revenueByDay, ThemeData theme) {
    if (revenueByDay.isEmpty) {
      return Center(
        child: Text(
          'No revenue data available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    final maxRevenue = revenueByDay.values.reduce((a, b) => a > b ? a : b);
    final sortedDays = revenueByDay.keys.toList()..sort();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: sortedDays.take(7).map((day) {
        final revenue = revenueByDay[day] ?? 0;
        final height = maxRevenue > 0 ? (revenue / maxRevenue) : 0;
        
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: (120 * height).toDouble(),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                day,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CustomersTab extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  const _CustomersTab({
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAnalyticsAsync = ref.watch(customerAnalyticsProvider(
      startDate: startDate,
      endDate: endDate,
    ));

    return customerAnalyticsAsync.when(
      data: (analytics) => _buildCustomersContent(context, analytics),
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(message: error.toString()),
    );
  }

  Widget _buildCustomersContent(BuildContext context, Map<String, dynamic> analytics) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Analytics Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.purple.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Analytics',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Customers',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${analytics['totalCustomers'] ?? 0}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Customers',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${analytics['newCustomers'] ?? 0}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Avg. Order Value: \$${analytics['averageOrderValue']?.toStringAsFixed(2) ?? '0.00'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Customer Segments
          Text(
            'Customer Segments',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final segments = ['VIP Customers', 'Regular Customers', 'New Customers'];
                final counts = [analytics['vipCustomers'] ?? 0, analytics['regularCustomers'] ?? 0, analytics['newCustomers'] ?? 0];
                final colors = [Colors.amber, Colors.blue, Colors.green];
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colors[index].withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: colors[index],
                      size: 20,
                    ),
                  ),
                  title: Text(segments[index]),
                  subtitle: Text('${counts[index]} customers'),
                  trailing: Text(
                    '${((counts[index] / (analytics['totalCustomers'] ?? 1)) * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: colors[index],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          
          // Customer Retention
          Text(
            'Customer Retention',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: 'Retention Rate',
                        value: '${analytics['retentionRate']?.toStringAsFixed(1) ?? '0.0'}%',
                        icon: Icons.trending_up,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: 'Churn Rate',
                        value: '${analytics['churnRate']?.toStringAsFixed(1) ?? '0.0'}%',
                        icon: Icons.trending_down,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryTab extends ConsumerWidget {
  const _InventoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryReportAsync = ref.watch(inventoryReportProvider);

    return inventoryReportAsync.when(
      data: (report) => _buildInventoryContent(context, report),
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(message: error.toString()),
    );
  }

  Widget _buildInventoryContent(BuildContext context, Map<String, dynamic> report) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inventory Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.orange.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inventory Summary',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Items',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${report['totalItems'] ?? 0}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Low Stock',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${report['lowStockItems'] ?? 0}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Low Stock Alerts
          Text(
            'Low Stock Alerts',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    child: Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('Stock: ${5 - index} units'),
                  trailing: Text(
                    'Low',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 