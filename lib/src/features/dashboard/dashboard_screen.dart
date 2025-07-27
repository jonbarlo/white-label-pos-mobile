import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../pos/pos_provider.dart';
import '../pos/models/sale.dart';
import '../../core/navigation/app_router.dart';
import '../auth/auth_provider.dart';
import '../auth/models/user.dart';
import 'waitstaff_dashboard_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isLoadingRecentSales = false;

  @override
  void initState() {
    super.initState();
    // Load recent sales when the dashboard is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentSales();
    });
  }

  Future<void> _loadRecentSales() async {
    setState(() {
      _isLoadingRecentSales = true;
    });
    
    try {
      await ref.read(recentSalesNotifierProvider.notifier).loadRecentSales(limit: 10);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRecentSales = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    
    // Show waitstaff dashboard for waitstaff users
    if (authState.user?.role == UserRole.waiter || authState.user?.role == UserRole.waitstaff) {
      return const WaitstaffDashboardScreen();
    }
    
    final theme = Theme.of(context);
    
    // Get today's sales summary - use today's date only
    final today = DateTime.now();
    final todaySalesAsync = ref.watch(salesSummaryProvider(
      DateTime(today.year, today.month, today.day),
      DateTime(today.year, today.month, today.day, 23, 59, 59),
    ));
    
    // Get recent sales
    final recentSales = ref.watch(recentSalesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.go(AppRouter.analyticsRoute),
            icon: const Icon(Icons.analytics),
            tooltip: 'Analytics Dashboard',
          ),
          IconButton(
            onPressed: () => context.go(AppRouter.featureDashboardRoute),
            icon: const Icon(Icons.featured_play_list),
            tooltip: 'Recipe & Promotion Features',
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh both sales summary and recent sales
          final today = DateTime.now();
          ref.invalidate(salesSummaryProvider(
            DateTime(today.year, today.month, today.day),
            DateTime(today.year, today.month, today.day, 23, 59, 59),
          ));
          await _loadRecentSales();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Metrics Section
              Text(
                'Sales Overview',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Metrics Cards Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildMetricCard(
                      'Today\'s Sales',
                      todaySalesAsync.when(
                        data: (salesSummary) {
                          final totalSales = salesSummary['totalSales'] as double? ?? 0.0;
                          return '\$${NumberFormat('#,##0.00').format(totalSales)}';
                        },
                        loading: () => null,
                        error: (error, stack) {
                          // Fallback: calculate total from recent sales today
                          final today = DateTime.now();
                          final todayStart = DateTime(today.year, today.month, today.day);
                          final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);
                          
                          final todaySales = recentSales.where((sale) => 
                            sale.createdAt.isAfter(todayStart) && 
                            sale.createdAt.isBefore(todayEnd)
                          );
                          final recentTotal = todaySales.fold<double>(0.0, (sum, sale) => sum + sale.total);
                          return '\$${NumberFormat('#,##0.00').format(recentTotal)}';
                        },
                      ),
                      Icons.attach_money,
                      theme.colorScheme.primary,
                      isLoading: todaySalesAsync.isLoading,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Transactions',
                      '${recentSales.where((sale) {
                        final today = DateTime.now();
                        final todayStart = DateTime(today.year, today.month, today.day);
                        final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);
                        return sale.createdAt.isAfter(todayStart) && sale.createdAt.isBefore(todayEnd);
                      }).length}',
                      Icons.receipt,
                      theme.colorScheme.secondary,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      'Avg Order',
                      () {
                        final today = DateTime.now();
                        final todayStart = DateTime(today.year, today.month, today.day);
                        final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);
                        
                        final todaySales = recentSales.where((sale) => 
                          sale.createdAt.isAfter(todayStart) && 
                          sale.createdAt.isBefore(todayEnd)
                        ).toList();
                        
                        if (todaySales.isEmpty) return '\$0.00';
                        
                        final avgValue = todaySales.fold<double>(0.0, (sum, sale) => sum + sale.total) / todaySales.length;
                        return '\$${NumberFormat('#,##0.00').format(avgValue)}';
                      }(),
                      Icons.trending_up,
                      theme.colorScheme.tertiary,
                      theme: theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Quick Access to New Features
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.featured_play_list, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'New Features Available',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Explore our new Recipe & Promotion System with mobile notifications.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                print('🔍 DEBUG: Explore Features button pressed');
                                print('🔍 DEBUG: Navigating to: ${AppRouter.featureDashboardRoute}');
                                context.go(AppRouter.featureDashboardRoute);
                              },
                              icon: const Icon(Icons.explore, size: 18),
                              label: const Text('Explore Features'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go(AppRouter.analyticsRoute),
                              icon: const Icon(Icons.analytics, size: 18),
                              label: const Text('View Analytics'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Recent Activity Section with Loading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isLoadingRecentSales)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Recent Activity Content
              _buildRecentActivitySection(recentSales, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Sale sale, ThemeData theme) {
    final timeAgo = _getTimeAgo(sale.createdAt);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Icon(
            Icons.receipt,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        title: Text(
          'Sale #${sale.receiptNumber}',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${sale.itemCount} items • ${sale.paymentMethod.name}',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              timeAgo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        trailing: Text(
          '\$${NumberFormat('#,##0.00').format(sale.total)}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String? value,
    IconData icon,
    Color color, {
    bool isLoading = false,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const SizedBox(
                height: 24,
                width: 60,
                child: ShimmerLoading(
                  child: SkeletonLoading(height: 24),
                ),
              )
            else
              Text(
                value ?? '\$0.00',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(List<Sale> recentSales, ThemeData theme) {
    // Show loading skeleton while loading
    if (_isLoadingRecentSales && recentSales.isEmpty) {
      return Column(
        children: List.generate(3, (index) => 
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const ShimmerLoading(
                    child: CircleAvatar(radius: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerLoading(
                          child: SkeletonLoading(width: 120, height: 16),
                        ),
                        const SizedBox(height: 4),
                        const ShimmerLoading(
                          child: SkeletonLoading(width: 80, height: 14),
                        ),
                      ],
                    ),
                  ),
                  const ShimmerLoading(
                    child: SkeletonLoading(width: 60, height: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // Show empty state if no data
    if (recentSales.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No recent transactions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start making sales to see activity here',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRouter.posRoute),
                icon: const Icon(Icons.point_of_sale, size: 18),
                label: const Text('Start Selling'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: [
        ...recentSales.take(5).map((sale) => _buildTransactionCard(sale, theme)),
        if (recentSales.length > 5)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () => context.go(AppRouter.reportsRoute),
              child: const Text('View All Transactions'),
            ),
          ),
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }
} 