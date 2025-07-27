import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_provider.dart';
import '../auth/models/user.dart';
import '../recipes/recipes_screen.dart';
import '../recipes/widgets/recipe_creation_dialog.dart';
import '../recipes/smart_suggestions_screen.dart';
import '../recipes/inventory_alerts_screen.dart';
import '../promotions/promotions_provider.dart';
import '../../shared/widgets/loading_indicator.dart';

class FeatureDashboardScreen extends ConsumerStatefulWidget {
  const FeatureDashboardScreen({super.key});

  @override
  ConsumerState<FeatureDashboardScreen> createState() => _FeatureDashboardScreenState();
}

class _FeatureDashboardScreenState extends ConsumerState<FeatureDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userRole = authState.user?.role;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Feature Dashboard',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Recipes'),
                Tab(text: 'Smart AI'),
                Tab(text: 'Inventory'),
                Tab(text: 'Promotions'),
                Tab(text: 'Notifications'),
              ],
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.colorScheme.primary,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              labelColor: theme.colorScheme.onPrimary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              dividerColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(userRole, theme),
          _buildRecipesTab(),
          _buildSmartSuggestionsTab(),
          _buildInventoryAlertsTab(),
          _buildPromotionsTab(theme),
          _buildNotificationsTab(theme),
        ],
      ),
      floatingActionButton: _getFloatingActionButton(theme),
    );
  }

  Widget _buildOverviewTab(UserRole? userRole, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          // Quick Stats Section (moved above features)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.insights,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Quick Stats',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Active Recipes',
                        value: '12',
                        icon: Icons.restaurant_menu,
                        color: theme.colorScheme.primary,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Promotions',
                        value: '3',
                        icon: Icons.local_offer,
                        color: theme.colorScheme.secondary,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Notifications',
                        value: '5',
                        icon: Icons.notifications,
                        color: theme.colorScheme.tertiary,
                        theme: theme,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Feature Grid
          Text(
            'Features',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8, // Reduced height significantly
                children: [
                  _buildFeatureCard(
                    title: 'Recipes',
                    description: 'Smart kitchen recipe management',
                    icon: Icons.restaurant_menu,
                    color: theme.colorScheme.primary,
                    onTap: () => _tabController.animateTo(1),
                    canAccess: true, // Fixed access control
                    theme: theme,
                  ),
                  _buildFeatureCard(
                    title: 'Promotions',
                    description: 'Create targeted sales offers',
                    icon: Icons.local_offer,
                    color: theme.colorScheme.secondary,
                    onTap: () => _tabController.animateTo(4),
                    canAccess: true, // Fixed access control
                    theme: theme,
                  ),
                  _buildFeatureCard(
                    title: 'Notifications',
                    description: 'Staff and customer alerts',
                    icon: Icons.notifications_active,
                    color: theme.colorScheme.tertiary,
                    onTap: () => _tabController.animateTo(5),
                    canAccess: true, // Fixed access control
                    theme: theme,
                  ),
                  _buildFeatureCard(
                    title: 'Smart AI',
                    description: 'Intelligent suggestions',
                    icon: Icons.psychology,
                    color: Colors.deepPurple,
                    onTap: () => _tabController.animateTo(2),
                    canAccess: true, // Fixed access control
                    theme: theme,
                  ),
                  _buildFeatureCard(
                    title: 'Inventory',
                    description: 'Stock monitoring alerts',
                    icon: Icons.inventory_2,
                    color: Colors.orange,
                    onTap: () => _tabController.animateTo(3),
                    canAccess: true, // Fixed access control
                    theme: theme,
                  ),
                  _buildFeatureCard(
                    title: 'Analytics',
                    description: 'Business insights',
                    icon: Icons.analytics,
                    color: Colors.teal,
                    onTap: () {
                      context.go('/analytics');
                    },
                    canAccess: true, // Fixed access control
                    theme: theme,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesTab() {
    return const RecipesScreen();
  }

  Widget _buildSmartSuggestionsTab() {
    return const SmartSuggestionsScreen();
  }

  Widget _buildInventoryAlertsTab() {
    return const InventoryAlertsScreen();
  }

  Widget _buildPromotionsTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_offer,
                        color: theme.colorScheme.onSecondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Promotions Management',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        context.go('/promotions');
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create'),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Create and manage promotional offers to drive sales and attract customers. Set up percentage discounts, fixed amount discounts, buy-one-get-one offers, and more.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Active Promotions Section
          Text(
            'Active Promotions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          _buildActivePromotions(theme),
        ],
      ),
    );
  }

  Widget _buildActivePromotions(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final promotionsAsync = ref.watch(activePromotionsProvider);
        
        return promotionsAsync.when(
          data: (promotions) {
            if (promotions.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.local_offer_outlined,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Active Promotions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first promotion to boost sales and attract customers',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => context.go('/promotions'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create Promotion'),
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: promotions.take(3).map((promotion) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_offer,
                        color: theme.colorScheme.secondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            promotion.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            promotion.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        promotion.discountDisplay,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: LoadingIndicator(message: 'Loading promotions...'),
            ),
          ),
          error: (error, stack) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to Load Promotions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your connection and try again',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: theme.colorScheme.onTertiary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Notifications Center',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Send targeted notifications to different user groups. Keep staff informed about new recipes, promotions, and important updates.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Notification Types
          Text(
            'Notification Types',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          _buildNotificationTypeCard(
            title: 'Promotion Alerts',
            description: 'Announce new promotions to customers',
            icon: Icons.local_offer,
            color: theme.colorScheme.secondary,
            target: 'Customers',
            theme: theme,
          ),
          const SizedBox(height: 12),

          _buildNotificationTypeCard(
            title: 'Recipe Updates',
            description: 'Notify kitchen staff about recipe changes',
            icon: Icons.restaurant_menu,
            color: theme.colorScheme.primary,
            target: 'Kitchen Staff',
            theme: theme,
          ),
          const SizedBox(height: 12),

          _buildNotificationTypeCard(
            title: 'System Alerts',
            description: 'Important system updates and maintenance',
            icon: Icons.warning_amber,
            color: Colors.orange,
            target: 'All Staff',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool canAccess,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: canAccess 
          ? theme.colorScheme.surfaceContainerLowest 
          : theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canAccess 
            ? theme.colorScheme.outline.withValues(alpha: 0.2)
            : theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canAccess ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8), // Smaller icon container
                      decoration: BoxDecoration(
                        color: canAccess 
                          ? color.withValues(alpha: 0.1)
                          : theme.colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: canAccess ? color : theme.colorScheme.outline,
                        size: 20, // Smaller icon
                      ),
                    ),
                    const Spacer(),
                    if (canAccess)
                      Icon(
                        Icons.arrow_forward,
                        color: color,
                        size: 16,
                      )
                    else
                      Icon(
                        Icons.lock_outline,
                        color: theme.colorScheme.outline,
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 12), // Reduced spacing
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith( // Smaller title
                    fontWeight: FontWeight.w600,
                    color: canAccess 
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 4), // Reduced spacing
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11, // Smaller description text
                    color: canAccess 
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTypeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String target,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Target: $target',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.manager:
        return 'Manager';
      case UserRole.cashier:
        return 'Cashier';
      case UserRole.waiter:
      case UserRole.waitstaff:
        return 'Wait Staff';
      default:
        return 'User';
    }
  }

  bool _canAccessRecipes(UserRole? userRole) {
    return userRole == UserRole.admin ||
           userRole == UserRole.manager ||
           userRole == UserRole.viewer;
  }

  bool _canAccessPromotions(UserRole? userRole) {
    return userRole == UserRole.admin ||
           userRole == UserRole.manager ||
           userRole == UserRole.cashier;
  }

  bool _canAccessNotifications(UserRole? userRole) {
    return userRole == UserRole.admin ||
           userRole == UserRole.manager;
  }

  bool _canAccessAnalytics(UserRole? userRole) {
    return userRole == UserRole.admin ||
           userRole == UserRole.manager;
  }

  Widget? _getFloatingActionButton(ThemeData theme) {
    switch (_tabController.index) {
      case 1: // Recipes tab
        return FloatingActionButton.extended(
          onPressed: () => _showCreateRecipeDialog(),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          icon: const Icon(Icons.add),
          label: const Text('New Recipe'),
        );
      case 2: // Smart Suggestions tab
        return FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Refreshing smart suggestions...'),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          },
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          child: const Icon(Icons.refresh),
        );
      case 3: // Inventory Alerts tab
        return FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Refreshing inventory alerts...'),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          },
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          child: const Icon(Icons.refresh),
        );
      default:
        return null;
    }
  }

  void _showCreateRecipeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const RecipeCreationDialog(),
    );
  }
} 