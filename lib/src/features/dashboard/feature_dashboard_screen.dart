import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../auth/models/user.dart';
import '../recipes/recipes_screen.dart';
import '../recipes/widgets/recipe_creation_dialog.dart';
import '../recipes/smart_suggestions_screen.dart';
import '../recipes/inventory_alerts_screen.dart';
import '../recipes/smart_recipe_provider.dart';
import '../promotions/widgets/promotion_banner.dart';
import '../notifications/models/notification.dart';
import '../../core/services/navigation_service.dart';

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
    print('🔍 DEBUG: FeatureDashboardScreen build called');
    final authState = ref.watch(authNotifierProvider);
    final userRole = authState.user?.role;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Recipes'),
            Tab(text: 'Smart Suggestions'),
            Tab(text: 'Inventory Alerts'),
            Tab(text: 'Promotions'),
            Tab(text: 'Notifications'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(userRole),
          _buildRecipesTab(),
          _buildSmartSuggestionsTab(),
          _buildInventoryAlertsTab(),
          _buildPromotionsTab(),
          _buildNotificationsTab(),
        ],
      ),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget _buildOverviewTab(UserRole? userRole) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to the Recipe & Promotion System!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Role: ${userRole?.name ?? 'Unknown'}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This dashboard showcases the new features available in your POS system. '
                    'Explore recipes, promotions, and notifications to enhance your restaurant operations.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Feature cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildFeatureCard(
                title: 'Recipes',
                description: 'Manage kitchen recipes and instructions',
                icon: Icons.restaurant_menu,
                color: Colors.green,
                onTap: () => _tabController.animateTo(1),
                canAccess: _canAccessRecipes(userRole),
              ),
              _buildFeatureCard(
                title: 'Promotions',
                description: 'Create and manage promotional offers',
                icon: Icons.local_offer,
                color: Colors.orange,
                onTap: () => _tabController.animateTo(2),
                canAccess: _canAccessPromotions(userRole),
              ),
              _buildFeatureCard(
                title: 'Notifications',
                description: 'Send notifications to staff and customers',
                icon: Icons.notifications,
                color: Colors.blue,
                onTap: () => _tabController.animateTo(3),
                canAccess: _canAccessNotifications(userRole),
              ),
              _buildFeatureCard(
                title: 'Analytics',
                description: 'View performance metrics and reports',
                icon: Icons.analytics,
                color: Colors.purple,
                onTap: () {
                  // TODO: Navigate to analytics
                },
                canAccess: _canAccessAnalytics(userRole),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Stats',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Active Recipes',
                          value: '12',
                          icon: Icons.restaurant_menu,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Active Promotions',
                          value: '3',
                          icon: Icons.local_offer,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Pending Notifications',
                          value: '5',
                          icon: Icons.notifications,
                          color: Colors.blue,
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
    );
  }

  Widget _buildRecipesTab() {
    print('🔍 DEBUG: Building recipes tab');
    return const RecipesScreen();
  }

  Widget _buildSmartSuggestionsTab() {
    return const SmartSuggestionsScreen();
  }

  Widget _buildInventoryAlertsTab() {
    return const InventoryAlertsScreen();
  }

  Widget _buildPromotionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.orange, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Promotions Management',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create and manage promotional offers to drive sales and attract customers. '
                    'Set up percentage discounts, fixed amount discounts, buy-one-get-one offers, and more.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Sample promotion banners
          Text(
            'Sample Promotion Banners',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Mock promotions for demonstration
          _buildMockPromotions(),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications, color: Colors.blue, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        'Notifications Center',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Send targeted notifications to different user groups. '
                    'Keep staff informed about new recipes, promotions, and important updates.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Notification types
          Text(
            'Notification Types',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildNotificationTypeCard(
            title: 'Promotion Notifications',
            description: 'Announce new promotions to customers',
            icon: Icons.local_offer,
            color: Colors.orange,
            target: 'customers',
          ),
          const SizedBox(height: 16),

          _buildNotificationTypeCard(
            title: 'Recipe Updates',
            description: 'Notify kitchen staff about recipe changes',
            icon: Icons.restaurant_menu,
            color: Colors.green,
            target: 'kitchen',
          ),
          const SizedBox(height: 16),

          _buildNotificationTypeCard(
            title: 'System Alerts',
            description: 'Important system updates and maintenance',
            icon: Icons.warning,
            color: Colors.red,
            target: 'all',
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
  }) {
    return Card(
      child: InkWell(
        onTap: canAccess ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const Spacer(),
                  if (!canAccess)
                    Icon(Icons.lock, color: Colors.grey, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (canAccess)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Tap to explore',
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: color, size: 16),
                  ],
                ),
            ],
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
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
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMockPromotions() {
    // Mock promotion data for demonstration
    final mockPromotions = [
      {
        'name': 'Happy Hour Special',
        'description': '50% off all drinks from 4-6 PM',
        'type': 'percentage',
        'discount': '50% OFF',
        'uses': 45,
      },
      {
        'name': 'Weekend Brunch',
        'description': 'Free coffee with any breakfast item',
        'type': 'freeItem',
        'discount': 'FREE COFFEE',
        'uses': 23,
      },
      {
        'name': 'Student Discount',
        'description': r'$5 off orders over $25 with student ID',
        'type': 'fixed',
        'discount': '\$5 OFF',
        'uses': 67,
      },
    ];

    return Column(
      children: mockPromotions.map((promo) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.local_offer,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        promo['discount'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${promo['uses']} uses',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotificationTypeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String target,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Target: $target',
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.grey[400]),
          ],
        ),
      ),
    );
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

  Widget? _getFloatingActionButton() {
    switch (_tabController.index) {
      case 1: // Recipes tab
        return FloatingActionButton(
          onPressed: () => _showCreateRecipeDialog(),
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white),
        );
      case 2: // Smart Suggestions tab
        return FloatingActionButton(
          onPressed: () {
            // TODO: Refresh smart suggestions when provider is generated
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Refreshing smart suggestions...')),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.refresh, color: Colors.white),
        );
      case 3: // Inventory Alerts tab
        return FloatingActionButton(
          onPressed: () {
            // TODO: Refresh inventory alerts when provider is generated
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Refreshing inventory alerts...')),
            );
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.refresh, color: Colors.white),
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