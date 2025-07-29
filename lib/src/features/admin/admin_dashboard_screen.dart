import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme_provider.dart';
import '../auth/models/user.dart';
import '../auth/auth_provider.dart';
import 'admin_dashboard_config.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    
    // Check if user is admin
    if (authState.user?.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Access Denied'),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This feature is only available to system administrators.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'System Administration',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeModeProvider);
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                  size: 24,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(theme),
            const SizedBox(height: 8),
            _buildQuickStatsSection(theme),
            const SizedBox(height: 8),
            _buildBusinessManagementSection(theme),
            const SizedBox(height: 8),
            _buildMenuManagementSection(theme),
            const SizedBox(height: 8),
            _buildInventoryManagementSection(theme),
            const SizedBox(height: 8),
            _buildUserManagementSection(theme),
            const SizedBox(height: 8),
            _buildSystemSettingsSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 32,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Administration',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Multi-tenant POS Management',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Manage all businesses, menus, inventory, and system settings from one centralized dashboard.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Overview',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AdminDashboardConfig.sectionSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * (AdminDashboardConfig.cardWidthPercentage / 100);
            final cardHeight = cardWidth; // Square cards
            
            return Wrap(
              spacing: AdminDashboardConfig.cardSpacing,
              runSpacing: AdminDashboardConfig.cardSpacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    theme,
                    'Total Businesses',
                    '12',
                    Icons.business,
                    Colors.blue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    theme,
                    'Active Users',
                    '156',
                    Icons.people,
                    Colors.green,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    theme,
                    'Menu Items',
                    '1,247',
                    Icons.restaurant_menu,
                    Colors.orange,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    theme,
                    'Total Sales',
                    '\$45.2K',
                    Icons.attach_money,
                    Colors.purple,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: AdminDashboardConfig.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminDashboardConfig.cardBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(AdminDashboardConfig.cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AdminDashboardConfig.iconContainerPadding),
              decoration: BoxDecoration(
                color: color.withValues(alpha: AdminDashboardConfig.iconBackgroundOpacity * 255),
                borderRadius: BorderRadius.circular(AdminDashboardConfig.iconBorderRadius),
              ),
              child: Icon(
                icon,
                color: color,
                size: AdminDashboardConfig.statCardIconSize,
              ),
            ),
            const SizedBox(height: AdminDashboardConfig.iconToTextSpacing),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: AdminDashboardConfig.statCardValueFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AdminDashboardConfig.titleToDescriptionSpacing),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: AdminDashboardConfig.statCardTitleFontSize,
              ),
              textAlign: TextAlign.center,
              maxLines: AdminDashboardConfig.titleMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessManagementSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Management',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AdminDashboardConfig.sectionSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * (AdminDashboardConfig.cardWidthPercentage / 100);
            final cardHeight = cardWidth; // Square cards
            
            return Wrap(
              spacing: AdminDashboardConfig.cardSpacing,
              runSpacing: AdminDashboardConfig.cardSpacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Manage Businesses',
                    'Create, edit, and manage all businesses',
                    Icons.business,
                    Colors.blue,
                    () => context.go('/admin/businesses'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Business Analytics',
                    'View performance metrics and reports',
                    Icons.analytics,
                    Colors.green,
                    () => context.go('/admin/business-analytics'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Business Settings',
                    'Configure business-specific settings',
                    Icons.settings,
                    Colors.orange,
                    () => context.go('/admin/business-settings'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Business Users',
                    'Manage users across all businesses',
                    Icons.people,
                    Colors.purple,
                    () => context.go('/admin/business-users'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuManagementSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Management',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AdminDashboardConfig.sectionSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * (AdminDashboardConfig.cardWidthPercentage / 100);
            final cardHeight = cardWidth; // Square cards
            
            return Wrap(
              spacing: AdminDashboardConfig.cardSpacing,
              runSpacing: AdminDashboardConfig.cardSpacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Menu Items',
                    'CRUD operations for all menu items',
                    Icons.restaurant_menu,
                    Colors.orange,
                    () => context.go('/admin/menu-management'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Categories',
                    'Manage menu categories',
                    Icons.category,
                    Colors.teal,
                    () => context.go('/admin/categories'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'PDF Menu Generation',
                    'Generate professional PDF menus',
                    Icons.picture_as_pdf,
                    Colors.red,
                    () => context.go('/admin/pdf-menu-generation'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Menu Templates',
                    'Create and manage menu templates',
                    Icons.copy,
                    Colors.indigo,
                    () => context.go('/admin/menu-templates'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Menu Analytics',
                    'Menu performance and insights',
                    Icons.insights,
                    Colors.pink,
                    () => context.go('/admin/menu-analytics'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildInventoryManagementSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inventory Management',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AdminDashboardConfig.sectionSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * (AdminDashboardConfig.cardWidthPercentage / 100);
            final cardHeight = cardWidth; // Square cards
            
            return Wrap(
              spacing: AdminDashboardConfig.cardSpacing,
              runSpacing: AdminDashboardConfig.cardSpacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Inventory Items',
                    'Manage all inventory items',
                    Icons.inventory,
                    Colors.red,
                    () => context.go('/admin/inventory'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Stock Management',
                    'Track and manage stock levels',
                    Icons.assessment,
                    Colors.amber,
                    () => context.go('/admin/stock-management'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Suppliers',
                    'Manage suppliers and vendors',
                    Icons.local_shipping,
                    Colors.cyan,
                    () => context.go('/admin/suppliers'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Inventory Reports',
                    'Generate inventory reports',
                    Icons.report,
                    Colors.brown,
                    () => context.go('/admin/inventory-reports'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserManagementSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Management',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AdminDashboardConfig.sectionSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * (AdminDashboardConfig.cardWidthPercentage / 100);
            final cardHeight = cardWidth; // Square cards
            
            return Wrap(
              spacing: AdminDashboardConfig.cardSpacing,
              runSpacing: AdminDashboardConfig.cardSpacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'System Users',
                    'Manage all system users',
                    Icons.people,
                    Colors.blue,
                    () => context.go('/admin/users'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Roles & Permissions',
                    'Configure user roles and permissions',
                    Icons.security,
                    Colors.green,
                    () => context.go('/admin/roles'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'User Activity',
                    'Monitor user activity and logs',
                    Icons.timeline,
                    Colors.orange,
                    () => context.go('/admin/user-activity'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Access Control',
                    'Manage access and security',
                    Icons.lock,
                    Colors.red,
                    () => context.go('/admin/access-control'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSystemSettingsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AdminDashboardConfig.sectionSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * (AdminDashboardConfig.cardWidthPercentage / 100);
            final cardHeight = cardWidth; // Square cards
            
            return Wrap(
              spacing: AdminDashboardConfig.cardSpacing,
              runSpacing: AdminDashboardConfig.cardSpacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'System Configuration',
                    'Configure system-wide settings',
                    Icons.settings,
                    Colors.grey,
                    () => context.go('/admin/system-config'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'Backup & Restore',
                    'Manage system backups',
                    Icons.backup,
                    Colors.indigo,
                    () => context.go('/admin/backup'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'System Logs',
                    'View system logs and errors',
                    Icons.list_alt,
                    Colors.orange,
                    () => context.go('/admin/logs'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFeatureCard(
                    theme,
                    'API Management',
                    'Manage API keys and endpoints',
                    Icons.api,
                    Colors.purple,
                    () => context.go('/admin/api-management'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    ThemeData theme,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: AdminDashboardConfig.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminDashboardConfig.cardBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AdminDashboardConfig.cardBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(AdminDashboardConfig.cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AdminDashboardConfig.iconContainerPadding),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: AdminDashboardConfig.iconBackgroundOpacity * 255),
                  borderRadius: BorderRadius.circular(AdminDashboardConfig.iconBorderRadius),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: AdminDashboardConfig.featureCardIconSize,
                ),
              ),
              const SizedBox(height: AdminDashboardConfig.iconToTextSpacing),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AdminDashboardConfig.featureCardTitleFontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: AdminDashboardConfig.titleMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AdminDashboardConfig.titleToDescriptionSpacing),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: AdminDashboardConfig.featureCardDescriptionFontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: AdminDashboardConfig.descriptionMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 