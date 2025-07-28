import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/bottom_navigation.dart';
import '../promotions/promotions_provider.dart';
import '../promotions/models/promotion.dart';

class WaitstaffDashboardScreen extends ConsumerWidget {
  const WaitstaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waitstaff Dashboard'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
                 child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // Promotions Section
             _buildPromotionsSection(context, ref),
             const SizedBox(height: 20),
             
             // Quick Stats Cards
             _buildQuickStatsSection(context),
             const SizedBox(height: 20),
             
             // Quick Actions
             _buildQuickActionsSection(context),
             const SizedBox(height: 20),
             
             // Today's Schedule
             _buildTodayScheduleSection(context),
             const SizedBox(height: 20),
             
             // Recent Activity
             _buildRecentActivitySection(context),
           ],
         ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Today\'s Overview', theme),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCompactStatCard(
                context,
                'Active Tables',
                '8',
                Icons.table_restaurant,
                theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildCompactStatCard(
                context,
                'Reservations',
                '12',
                Icons.schedule,
                theme.colorScheme.tertiary,
              ),
              const SizedBox(width: 8),
              _buildCompactStatCard(
                context,
                'Orders Pending',
                '3',
                Icons.pending,
                theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              _buildCompactStatCard(
                context,
                'Available',
                '5',
                Icons.check_circle,
                theme.colorScheme.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Quick Actions', theme),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCompactActionCard(
                context,
                'View Tables',
                Icons.table_restaurant,
                theme.colorScheme.primary,
                () => context.go('/tables'),
              ),
              const SizedBox(width: 8),
              _buildCompactActionCard(
                context,
                'Floor Plan',
                Icons.map,
                theme.colorScheme.secondary,
                () => context.go('/floor-plan-viewer'),
              ),
              const SizedBox(width: 8),
              _buildCompactActionCard(
                context,
                'Messages',
                Icons.message,
                theme.colorScheme.tertiary,
                () => context.go('/messages'),
              ),
              const SizedBox(width: 8),
              _buildCompactActionCard(
                context,
                'Reservations',
                Icons.schedule,
                theme.colorScheme.primary,
                () => context.go('/reservations'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionsSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activePromotionsAsync = ref.watch(activePromotionsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSectionHeader('Active Promotions', theme),
            ),
            activePromotionsAsync.when(
              data: (promotions) => promotions.isNotEmpty 
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${promotions.length} active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        
        activePromotionsAsync.when(
          data: (promotions) {
            if (promotions.isEmpty) {
              return _buildNoPromotionsState(context);
            }
            
            // Find high-priority promotions (ending soon or high inventory)
            final highPriorityPromotions = promotions.where((p) => _isHighPriority(p)).toList();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority Promotion Alert - show if there are high priority promotions
                if (highPriorityPromotions.isNotEmpty) ...[
                  _buildPromotionAlert(context, highPriorityPromotions.first),
                  const SizedBox(height: 12),
                ],
                
                // Active Promotions Grid
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: promotions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final promotion = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(right: index < promotions.length - 1 ? 8 : 0),
                        child: _buildPromotionCard(
                          context,
                          promotion,
                          isPriority: _isHighPriority(promotion),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Promotion Actions
                Row(
                  children: [
                    Expanded(
                      child: _buildPromotionActionButton(
                        context,
                        'View All Promotions',
                        Icons.list_alt,
                        theme.colorScheme.primary,
                        () => context.go('/promotions'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPromotionActionButton(
                        context,
                        'Sales Tips',
                        Icons.lightbulb_outline,
                        theme.colorScheme.secondary,
                        () => _showSalesTipsDialog(context, promotions),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => _buildPromotionsLoading(context),
          error: (error, stack) => _buildPromotionsError(context, ref),
        ),
      ],
    );
  }

  bool _isHighPriority(Promotion promotion) {
    final now = DateTime.now();
    final daysUntilExpiry = promotion.endDate.difference(now).inDays;
    
    // High priority if:
    // 1. Ending within 3 days
    // 2. Chef's special (usually for high inventory items)
    // 3. High usage already (popular item)
    return daysUntilExpiry <= 3 || 
           promotion.type == PromotionType.chef_special ||
           (promotion.maxUsesPerCustomer != null && 
            promotion.usedQuantity > (promotion.maxUsesPerCustomer! * 0.7));
  }

  Widget _buildPromotionAlert(BuildContext context, Promotion promotion) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.campaign,
              color: theme.colorScheme.onPrimary,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priority Alert: ${promotion.name}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  _getPriorityReason(promotion),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Mark as acknowledged - could implement local storage for this
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
            ),
            child: Text(
              'Got it',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPriorityReason(Promotion promotion) {
    final now = DateTime.now();
    final daysUntilExpiry = promotion.endDate.difference(now).inDays;
    
    if (daysUntilExpiry <= 1) {
      return 'Expires tomorrow! Actively promote to all customers.';
    } else if (daysUntilExpiry <= 3) {
      return 'Expires in $daysUntilExpiry days. Focus on promoting this offer.';
    } else if (promotion.type == PromotionType.chef_special) {
      return 'Chef\'s special - high inventory item. Suggest as today\'s featured dish.';
    } else if (promotion.maxUsesPerCustomer != null && 
               promotion.usedQuantity > (promotion.maxUsesPerCustomer! * 0.7)) {
      return 'Popular promotion! Limited quantities remaining - create urgency.';
    }
    
    return 'High priority promotion - actively recommend to customers.';
  }

  Widget _buildPromotionCard(
    BuildContext context,
    Promotion promotion, {
    required bool isPriority,
  }) {
    final theme = Theme.of(context);
    final color = _getPromotionColor(promotion.type, theme);
    
    return IntrinsicWidth(
      child: Container(
        constraints: const BoxConstraints(minWidth: 160, maxWidth: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPriority 
              ? color.withValues(alpha: 0.4)
              : color.withValues(alpha: 0.2),
            width: isPriority ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(_getPromotionIcon(promotion.type), color: color, size: 16),
                ),
                const Spacer(),
                if (isPriority)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'PRIORITY',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              promotion.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              promotion.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                promotion.discountDisplay,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '💡 ${_getSalesTip(promotion)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPromotionColor(PromotionType type, ThemeData theme) {
    switch (type) {
      case PromotionType.discount:
        return theme.colorScheme.primary;
      case PromotionType.chef_special:
        return theme.colorScheme.secondary;
      case PromotionType.buyOneGetOne:
        return theme.colorScheme.tertiary;
      case PromotionType.freeItem:
        return theme.colorScheme.error;
    }
  }

  IconData _getPromotionIcon(PromotionType type) {
    switch (type) {
      case PromotionType.discount:
        return Icons.percent;
      case PromotionType.chef_special:
        return Icons.set_meal;
      case PromotionType.buyOneGetOne:
        return Icons.group;
      case PromotionType.freeItem:
        return Icons.card_giftcard;
    }
  }

  String _getSalesTip(Promotion promotion) {
    switch (promotion.type) {
      case PromotionType.discount:
        return 'Mention the discount when taking orders - great for price-conscious customers';
      case PromotionType.chef_special:
        return 'Present as today\'s featured dish - perfect for adventurous diners';
      case PromotionType.buyOneGetOne:
        return 'Ideal for groups and sharing - suggest for parties of 2 or more';
      case PromotionType.freeItem:
        return 'Highlight the free item value - excellent upsell opportunity';
    }
  }

  Widget _buildNoPromotionsState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 48,
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No Active Promotions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check with management for upcoming promotions',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionsLoading(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading promotions...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionsError(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 32,
            color: theme.colorScheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 8),
          Text(
            'Unable to load promotions',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => ref.invalidate(activePromotionsProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSalesTipsDialog(BuildContext context, List<Promotion> promotions) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Sales Tips'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'General Sales Techniques:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Lead with benefits, not features'),
              const Text('• Create urgency for limited-time offers'),
              const Text('• Suggest pairings and upsells naturally'),
              const Text('• Read customer preferences and adapt'),
              const SizedBox(height: 16),
              const Text(
                'Active Promotion Tips:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...promotions.map((promotion) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• ${promotion.name}: ${_getSalesTip(promotion)}'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Recent Activity', theme),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                context,
                'Table A1 seated - 4 guests',
                '2 minutes ago',
                Icons.people,
                theme.colorScheme.secondary,
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              _buildActivityItem(
                context,
                'Table B3 order completed',
                '5 minutes ago',
                Icons.check_circle,
                theme.colorScheme.primary,
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              _buildActivityItem(
                context,
                'Reservation for Table C2',
                '10 minutes ago',
                Icons.schedule,
                theme.colorScheme.tertiary,
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              _buildActivityItem(
                context,
                'Table D1 cleared',
                '15 minutes ago',
                Icons.cleaning_services,
                theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String time, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                  ),
                ),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayScheduleSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Today\'s Schedule', theme),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildScheduleItem(
                context,
                '12:00 PM',
                'Lunch Rush - Monitor Tables A1-A5',
                'High Priority',
                theme.colorScheme.error,
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              _buildScheduleItem(
                context,
                '2:00 PM',
                'Break Time',
                'Regular',
                theme.colorScheme.secondary,
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              _buildScheduleItem(
                context,
                '6:00 PM',
                'Dinner Service - All Tables',
                'High Priority',
                theme.colorScheme.error,
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
              _buildScheduleItem(
                context,
                '9:00 PM',
                'Closing Duties',
                'Regular',
                theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(BuildContext context, String time, String task, String priority, Color color) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                  ),
                ),
                Text(
                  priority,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
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