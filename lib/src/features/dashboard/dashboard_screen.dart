import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/theme_toggle_button.dart';
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
  @override
  void initState() {
    super.initState();
    // Load recent sales when the dashboard is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentSalesNotifierProvider.notifier).loadRecentSales(limit: 10);
    });
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
          await ref.read(recentSalesNotifierProvider.notifier).loadRecentSales(limit: 10);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sales Overview',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Sales',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      todaySalesAsync.when(
                        data: (salesSummary) {
                          final totalSales = salesSummary['totalSales'] as double? ?? 0.0;
                          return Text(
                            '\$${NumberFormat('#,##0.00').format(totalSales)}',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) {
                          // Fallback: calculate total from recent sales
                          final recentTotal = recentSales.fold<double>(0.0, (sum, sale) => sum + sale.total);
                          return Text(
                            '\$${NumberFormat('#,##0.00').format(recentTotal)}',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Recent Activity',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              recentSales.isEmpty
                  ? Card(
                      child: ListTile(
                        leading: Icon(Icons.receipt, color: theme.colorScheme.primary),
                        title: Text(
                          'No recent transactions',
                          style: theme.textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          'Start making sales to see activity here',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    )
                  : Column(
                      children: recentSales.take(5).map((sale) => _buildTransactionCard(sale, theme)).toList(),
                    ),
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