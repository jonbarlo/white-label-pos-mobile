import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/theme_toggle_button.dart';
import '../auth/auth_provider.dart';
import 'table_selection_screen.dart';
import 'messaging_screen.dart';
import 'table_provider.dart';

class WaiterDashboardScreen extends ConsumerStatefulWidget {
  const WaiterDashboardScreen({super.key});

  @override
  ConsumerState<WaiterDashboardScreen> createState() => _WaiterDashboardScreenState();
}

class _WaiterDashboardScreenState extends ConsumerState<WaiterDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WaiterHomeTab(),
    const TableSelectionScreen(),
    const MessagingScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.table_restaurant),
      label: 'Tables',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.message),
      label: 'Messages',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Auto-refresh tables when switching to the Tables tab
          if (index == 1) {
            ref.invalidate(tablesProvider);
          }
        },
        items: _navigationItems,
      ),
    );
  }
}

class WaiterHomeTab extends ConsumerStatefulWidget {
  const WaiterHomeTab({super.key});

  @override
  ConsumerState<WaiterHomeTab> createState() => _WaiterHomeTabState();
}

class _WaiterHomeTabState extends ConsumerState<WaiterHomeTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authNotifierProvider).user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            _buildWelcomeSection(user, theme),
            const SizedBox(height: 24),
            
            // Quick stats
            _buildQuickStats(theme),
            const SizedBox(height: 24),
            
            // Main actions
            _buildMainActions(theme),
            const SizedBox(height: 24),
            
            // Recent activity
            _buildRecentActivity(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(user, ThemeData theme) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        user?.name ?? 'Waiter',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Ready to serve your customers?',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Tables',
            '3',
            Icons.table_restaurant,
            theme.colorScheme.secondary,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Pending Orders',
            '2',
            Icons.pending_actions,
            theme.colorScheme.tertiary,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Today\'s Tips',
            '\$45',
            Icons.attach_money,
            theme.colorScheme.primary,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              'Order History',
              Icons.history,
              theme.colorScheme.primary,
              'View past orders',
              () => _showComingSoon('Order History'),
              theme,
            ),
            _buildActionCard(
              'Customer Info',
              Icons.people,
              theme.colorScheme.secondary,
              'Manage customer details',
              () => _showComingSoon('Customer Information'),
              theme,
            ),
            _buildActionCard(
              'Inventory Check',
              Icons.inventory,
              theme.colorScheme.tertiary,
              'Check item availability',
              () => _showComingSoon('Inventory Check'),
              theme,
            ),
            _buildActionCard(
              'Daily Report',
              Icons.assessment,
              theme.colorScheme.primary,
              'View daily summary',
              () => _showComingSoon('Daily Report'),
              theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, String subtitle, VoidCallback onTap, ThemeData theme) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              _buildActivityItem(
                'Table 3 order completed',
                '2 minutes ago',
                Icons.check_circle,
                theme.colorScheme.secondary,
                theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outline),
              _buildActivityItem(
                'New customer at Table 5',
                '15 minutes ago',
                Icons.person_add,
                theme.colorScheme.primary,
                theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outline),
              _buildActivityItem(
                'Kitchen notification: Table 2 ready',
                '25 minutes ago',
                Icons.restaurant,
                theme.colorScheme.tertiary,
                theme,
              ),
              Divider(height: 1, color: theme.colorScheme.outline),
              _buildActivityItem(
                'Promotion updated: Happy Hour Special',
                '1 hour ago',
                Icons.local_offer,
                theme.colorScheme.primary,
                theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color, ThemeData theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        time,
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 