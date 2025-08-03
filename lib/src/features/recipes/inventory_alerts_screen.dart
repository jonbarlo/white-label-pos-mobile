import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_provider.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';
import '../promotions/promotions_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import '../business/business_provider.dart';
import '../../core/localization/app_localizations.dart';

class InventoryAlertsScreen extends ConsumerStatefulWidget {
  const InventoryAlertsScreen({super.key});

  @override
  ConsumerState<InventoryAlertsScreen> createState() => _InventoryAlertsScreenState();
}

class _InventoryAlertsScreenState extends ConsumerState<InventoryAlertsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(inventoryAlertsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.inventoryAlerts,
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
              tabs: [
                Tab(text: l10n.allAlerts),
                Tab(text: l10n.expiringItems),
                Tab(text: l10n.underperforming),
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
          _buildAllAlertsTab(alertsAsync),
          _buildExpiringItemsTab(alertsAsync),
          _buildUnderperformingItemsTab(alertsAsync),
        ],
      ),
      // Removed floating action button - inventory alerts should not have cooking/promotion actions
    );
  }

  Widget _buildAllAlertsTab(AsyncValue<List<InventoryAlert>> alertsAsync) {
    final l10n = AppLocalizations.of(context);
    
    return alertsAsync.when(
      data: (alerts) {
        if (alerts.isEmpty) {
          return Center(
            child: Text(l10n.noInventoryAlertsAvailable),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];
            return _buildAlertCard(alert);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('${l10n.error}: $error'),
      ),
    );
  }

  Widget _buildExpiringItemsTab(AsyncValue<List<InventoryAlert>> alertsAsync) {
    final l10n = AppLocalizations.of(context);
    
    return alertsAsync.when(
      data: (alerts) {
        final expiringAlerts = alerts.where((alert) =>
            alert.title.toLowerCase().contains('expiring') ||
            alert.message.toLowerCase().contains('expiring')
        ).toList();

        if (expiringAlerts.isEmpty) {
          return Center(
            child: Text(l10n.noExpiringItemsAlerts),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: expiringAlerts.length,
          itemBuilder: (context, index) {
            final alert = expiringAlerts[index];
            return _buildAlertCard(alert);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('${l10n.error}: $error'),
      ),
    );
  }

  Widget _buildUnderperformingItemsTab(AsyncValue<List<InventoryAlert>> alertsAsync) {
    final l10n = AppLocalizations.of(context);
    
    return alertsAsync.when(
      data: (alerts) {
        final underperformingAlerts = alerts.where((alert) =>
            alert.title.toLowerCase().contains('underperforming') ||
            alert.message.toLowerCase().contains('turnover')
        ).toList();

        if (underperformingAlerts.isEmpty) {
          return Center(
            child: Text(l10n.noUnderperformingItemsAlerts),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: underperformingAlerts.length,
          itemBuilder: (context, index) {
            final alert = underperformingAlerts[index];
            return _buildAlertCard(alert);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('${l10n.error}: $error'),
      ),
    );
  }

  Widget _buildAlertCard(InventoryAlert alert) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: alert.urgencyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getAlertIcon(alert),
                    color: alert.urgencyColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: alert.urgencyColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: alert.urgencyColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          alert.urgencyText,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: alert.urgencyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              alert.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (alert.itemName != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${l10n.item}: ${alert.itemName}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(alert.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _viewDetails(alert),
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: Text(l10n.viewDetails),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _cookRecipe(InventoryAlert alert) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cookRecipe),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.cookRecipeUsing}: ${alert.itemName ?? l10n.unknownItem}'),
            const SizedBox(height: 16),
            const Text(l10n.thisWill),
            Text('• ${l10n.consumeInventoryItems}'),
            Text('• ${l10n.reduceWaste}'),
            Text('• ${l10n.createChefSpecialPromotion}'),
            const SizedBox(height: 16),
            const Text(l10n.availableRecipes),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<SmartRecipeSuggestion>>(
                future: ref.read(smartRecipeRepositoryProvider).getSmartRecipeSuggestions(
                  includeExpiringItems: true,
                  includeUnderperformingItems: true,
                  limit: 5,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${l10n.errorLoadingRecipes}: ${snapshot.error}'),
                    );
                  }
                  
                  final suggestions = snapshot.data ?? [];
                  
                  if (suggestions.isEmpty) {
                    return Center(
                      child: Text(l10n.noRecipeSuggestionsAvailable),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return ListTile(
                        title: Text(suggestion.recipe.name),
                        subtitle: Text('${l10n.potentialSavings}: ${CurrencyFormatter.formatCRC(suggestion.potentialSavings)}'),
                        trailing: Text(
                          suggestion.urgencyLevel.name.toUpperCase(),
                          style: TextStyle(
                            color: suggestion.urgencyLevel == UrgencyLevel.high 
                              ? Colors.red 
                              : suggestion.urgencyLevel == UrgencyLevel.medium 
                                ? Colors.orange 
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _showCookRecipeWithPromotionDialog(suggestion);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(l10n.quantityToCook),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.quantity,
                hintText: '1',
              ),
              controller: TextEditingController(text: '1'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _createPromotion(InventoryAlert alert) {
    // This method is now replaced by _showCreatePromotionDialog which has proper form fields
    _showCreatePromotionDialog();
  }

  Future<void> _executeCookRecipe(SmartRecipeSuggestion suggestion, {
    required String promotionType,
    required String promotionName,
    required String promotionDescription,
    required String discountType,
    required double discountValue,
    required int promotionExpiresInHours,
    required int quantity,
  }) async {
    try {
      final repository = ref.read(smartRecipeRepositoryProvider);
      
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text('${l10n.cookingRecipe}...'),
            ],
          ),
        ),
      );
      
      // Cook recipe with promotion parameters
      final result = await repository.cookRecipe(
        suggestion.recipe.id,
        quantity,
        promotionType: promotionType,
        promotionName: promotionName,
        promotionDescription: promotionDescription,
        discountType: discountType,
        discountValue: discountValue,
        promotionExpiresInHours: promotionExpiresInHours,
      );
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${l10n.recipeCookedSuccessfully}!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.recipe}: ${suggestion.recipe.name}'),
              const SizedBox(height: 8),
              if (result['cookingResult'] != null) ...[
                Text('${l10n.quantityCooked}: ${result['cookingResult']['quantity']?.toString() ?? '0'}'),
                Text('${l10n.costSavings}: ${CurrencyFormatter.formatCRC(result['cookingResult']['costSavings'] ?? 0.0)}'),
                Text('${l10n.wasteReduction}: ${result['cookingResult']['wasteReduction']?.toString() ?? '0'} ${l10n.items}'),
              ],
              const SizedBox(height: 8),
              if (result['createdPromotion'] != null) ...[
                const Text('${l10n.promotionCreated}:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${l10n.name}: ${result['createdPromotion']['name']}'),
                Text('${l10n.type}: ${result['createdPromotion']['type'] ?? l10n.na}'),
                Text('${l10n.discount}: ${result['createdPromotion']['discountValue']}%'),
                const SizedBox(height: 4),
                const Text('${l10n.quantityTracking}:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${l10n.totalQuantity}: ${result['createdPromotion']['totalQuantity']?.toString() ?? '0'}'),
                Text('${l10n.usedQuantity}: ${result['createdPromotion']['usedQuantity']?.toString() ?? '0'}'),
                Text('${l10n.remaining}: ${result['createdPromotion']['remainingQuantity']?.toString() ?? '0'}'),
                Text('${l10n.status}: ${result['createdPromotion']['status'] ?? l10n.unknown}'),
                Text('${l10n.expires}: ${result['createdPromotion']['expiresAt'] ?? l10n.unknown}'),
              ],
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Refresh the alerts
                ref.invalidate(inventoryAlertsProvider);
              },
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.error),
          content: Text('${l10n.failedToCookRecipe}: $e'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }
  }

  void _executeCreatePromotion(InventoryAlert alert, String type, double value) async {
    try {
      final repository = ref.read(smartRecipeRepositoryProvider);
      
      // Create promotion name based on the alert
      final promotionName = '${l10n.specialOffer}: ${alert.itemName ?? l10n.selectedItems}';
      
      // Set expiration to end of day
      final expiresAt = DateTime.now().add(const Duration(days: 7));
      
      final result = await repository.createPromotion(
        name: promotionName,
        type: 'discount',
        discountType: type,
        discountValue: value,
        expiresAt: expiresAt,
        itemIds: alert.itemId != null ? [alert.itemId!] : null,
        description: '${l10n.promotionCreatedFromInventoryAlert}: ${alert.message}',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.successfullyCreatedPromotion}: ${result['name'] ?? promotionName}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Refresh the alerts to show updated inventory
      ref.invalidate(inventoryAlertsProvider);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorCreatingPromotion}: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showQuickActionsDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.quickActions),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Colors.green),
              title: Text(l10n.cookRecipe),
              subtitle: Text(l10n.useExpiringItemsToCreateDishes),
              onTap: () {
                Navigator.of(context).pop();
                _showCookRecipeDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.orange),
              title: Text(l10n.createPromotion),
              subtitle: Text(l10n.createSpecialOffersForItems),
              onTap: () {
                Navigator.of(context).pop();
                _showCreatePromotionDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: Colors.blue),
              title: Text(l10n.viewAnalytics),
              subtitle: Text(l10n.checkCookingHistoryAndMetrics),
              onTap: () {
                Navigator.of(context).pop();
                _showAnalyticsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.purple),
              title: Text(l10n.cookingHistory),
              subtitle: Text(l10n.viewRecentCookingActivities),
              onTap: () {
                Navigator.of(context).pop();
                _showCookingHistoryDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showCookRecipeDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cookRecipe),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.selectARecipeToCookUsingExpiringItems),
            const SizedBox(height: 16),
            const Text(l10n.thisFeatureWill),
            Text('• ${l10n.automaticallySelectRecipesUsingExpiringItems}'),
            Text('• ${l10n.consumeInventoryAndReduceWaste}'),
            Text('• ${l10n.createCustomizablePromotions}'),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: FutureBuilder<List<SmartRecipeSuggestion>>(
                future: ref.read(smartRecipeRepositoryProvider).getSmartRecipeSuggestions(
                  includeExpiringItems: true,
                  includeUnderperformingItems: true,
                  limit: 10,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('${l10n.error}: ${snapshot.error}'));
                  }
                  
                  final suggestions = snapshot.data ?? [];
                  
                  if (suggestions.isEmpty) {
                    return Center(child: Text(l10n.noRecipeSuggestionsAvailable));
                  }
                  
                  return ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(suggestion.recipe.name),
                          subtitle: Text(suggestion.recipe.description ?? l10n.noDescription),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showCookRecipeWithPromotionDialog(suggestion);
                            },
                            child: Text(l10n.cook),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showCookRecipeWithPromotionDialog(SmartRecipeSuggestion suggestion) {
    final nameController = TextEditingController(text: '${l10n.chefSpecial}: ${suggestion.recipe.name}');
    final descriptionController = TextEditingController(text: '${l10n.freshlyPrepared} ${suggestion.recipe.name.toLowerCase()} ${l10n.usingPremiumIngredients}');
    final discountValueController = TextEditingController(text: '25');
    final expiresHoursController = TextEditingController(text: '48');
    final quantityController = TextEditingController(text: '1');
    String selectedPromotionType = 'chef_special';
    String selectedDiscountType = 'percentage';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('${l10n.cook} ${suggestion.recipe.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.cookRecipeUsing}: ${suggestion.recipe.name}'),
                const SizedBox(height: 16),
                const Text(l10n.thisWill),
                Text('• ${l10n.consumeInventoryItems}'),
                Text('• ${l10n.reduceWaste}'),
                Text('• ${l10n.createPromotionWithQuantityTracking}'),
                const SizedBox(height: 16),
                const Text(l10n.recipeConfiguration),
                const SizedBox(height: 8),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.quantityToCook,
                    hintText: '1',
                    helperText: l10n.thisWillCreateAPromotionWithTheSameQuantity,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(l10n.promotionConfiguration),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.promotionName,
                    hintText: '${l10n.eG} ${l10n.chefSpecial}: ${l10n.trufflePizza}',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.promotionDescription,
                    hintText: l10n.descriptionOfThePromotion,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.promotionType,
                  ),
                  value: selectedPromotionType,
                  items: const [
                    DropdownMenuItem(value: 'chef_special', child: Text(l10n.chefSpecial)),
                    DropdownMenuItem(value: 'discount', child: Text(l10n.discount)),
                    DropdownMenuItem(value: 'bogo', child: Text(l10n.buyOneGetOne)),
                    DropdownMenuItem(value: 'flash_sale', child: Text(l10n.flashSale)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPromotionType = value ?? 'chef_special';
                    });
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.discountType,
                  ),
                  value: selectedDiscountType,
                  items: const [
                    DropdownMenuItem(value: 'percentage', child: Text(l10n.percentageDiscount)),
                    DropdownMenuItem(value: 'fixed', child: Text(l10n.fixedAmountOff)),
                    DropdownMenuItem(value: 'free_item', child: Text(l10n.freeItem)),
                    DropdownMenuItem(value: 'bogo', child: Text(l10n.buyOneGetOne)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDiscountType = value ?? 'percentage';
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: discountValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: selectedDiscountType == 'percentage' ? l10n.discountPercentage : l10n.discountAmount,
                    hintText: selectedDiscountType == 'percentage' ? '25' : '5.00',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: expiresHoursController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.promotionExpiresInHours,
                    hintText: '48',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();
                final discountValue = double.tryParse(discountValueController.text) ?? 25.0;
                final expiresHours = int.tryParse(expiresHoursController.text) ?? 48;
                final quantity = int.tryParse(quantityController.text) ?? 1;
                
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.pleaseEnterAPromotionName)),
                  );
                  return;
                }
                
                if (quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.quantityMustBeGreaterThan0)),
                  );
                  return;
                }
                
                Navigator.of(context).pop();
                await _executeCookRecipe(
                  suggestion,
                  quantity: quantity,
                  promotionType: selectedPromotionType,
                  promotionName: name,
                  promotionDescription: description,
                  discountType: selectedDiscountType,
                  discountValue: discountValue,
                  promotionExpiresInHours: expiresHours,
                );
              },
              child: Text(l10n.cookRecipe),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePromotionDialog() {
    final nameController = TextEditingController();
    final valueController = TextEditingController(text: '20');
    String selectedDiscountType = 'percentage';
    String selectedPromotionType = 'discount';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.createPromotion),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.createAPromotionForExpiringOrUnderperformingItems),
              const SizedBox(height: 16),
              const Text(l10n.thisFeatureWill),
              Text('• ${l10n.createTargetedPromotions}'),
              Text('• ${l10n.helpMoveInventory}'),
              Text('• ${l10n.increaseSalesAndReduceWaste}'),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.promotionName,
                  hintText: '${l10n.eG} ${l10n.flashSale} - 20% Off',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.promotionType,
                ),
                value: selectedPromotionType,
                items: const [
                  DropdownMenuItem(value: 'discount', child: Text(l10n.discount)),
                  DropdownMenuItem(value: 'chef_special', child: Text(l10n.chefSpecial)),
                  DropdownMenuItem(value: 'bogo', child: Text(l10n.buyOneGetOne)),
                  DropdownMenuItem(value: 'flash_sale', child: Text(l10n.flashSale)),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedPromotionType = value ?? 'discount';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.discountType,
                ),
                value: selectedDiscountType,
                items: const [
                  DropdownMenuItem(value: 'percentage', child: Text(l10n.percentageDiscount)),
                  DropdownMenuItem(value: 'fixed', child: Text(l10n.fixedAmountOff)),
                  DropdownMenuItem(value: 'buyOneGetOne', child: Text(l10n.buyOneGetOne)),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedDiscountType = value ?? 'percentage';
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: selectedDiscountType == 'percentage' ? l10n.percentage : l10n.amount,
                  hintText: selectedDiscountType == 'percentage' ? '20' : '5.00',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final value = double.tryParse(valueController.text) ?? 0.0;
                
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pleaseEnterAPromotionName),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (value <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pleaseEnterAValidDiscountValue),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                Navigator.of(context).pop();
                
                // Create promotion directly using the repository
                try {
                  final repository = ref.read(smartRecipeRepositoryProvider);
                  final expiresAt = DateTime.now().add(const Duration(days: 7));
                  
                  final result = await repository.createPromotion(
                    name: name,
                    type: selectedPromotionType,
                    discountType: selectedDiscountType,
                    discountValue: value,
                    expiresAt: expiresAt,
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.successfullyCreatedPromotion}: ${result['name'] ?? name}'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  
                  // Refresh the alerts
                  ref.invalidate(inventoryAlertsProvider);
                  
                  // Refresh promotions to show the newly created promotion
                  ref.invalidate(activePromotionsProvider);
                  ref.invalidate(promotionsNotifierProvider);
                  
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.errorCreatingPromotion}: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.createPromotion),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalyticsDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cookingAnalytics),
        content: SizedBox(
          width: double.maxFinite,
          child: FutureBuilder<Map<String, dynamic>>(
            future: ref.read(smartRecipeRepositoryProvider).getCookingAnalytics(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('${l10n.errorLoadingAnalytics}: ${snapshot.error}'),
                  ],
                );
              }
              
              final analytics = snapshot.data ?? {};
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnalyticsCard(
                    l10n.totalRecipesCooked,
                    '${analytics['totalRecipesCooked'] ?? 0}',
                    Icons.restaurant_menu,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildAnalyticsCard(
                    l10n.wasteReduced,
                    CurrencyFormatter.formatCRC(analytics['wasteReduced'] ?? 0.0),
                    Icons.recycling,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildAnalyticsCard(
                    l10n.costSavings,
                    CurrencyFormatter.formatCRC(analytics['costSavings'] ?? 0.0),
                    Icons.savings,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildAnalyticsCard(
                    l10n.promotionsCreated,
                    '${analytics['promotionsCreated'] ?? 0}',
                    Icons.local_offer,
                    Colors.purple,
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCookingHistoryDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cookingHistory),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: ref.read(smartRecipeRepositoryProvider).getCookingHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('${l10n.errorLoadingHistory}: ${snapshot.error}'),
                  ],
                );
              }
              
              final history = snapshot.data ?? [];
              
              if (history.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, color: Colors.grey, size: 48),
                      const SizedBox(height: 16),
                      Text(l10n.noCookingHistoryYet),
                      Text('${l10n.startCookingRecipesToSeeYourHistoryHere}'),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final entry = history[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.restaurant_menu, color: Colors.green),
                      title: Text(entry['recipeName'] ?? l10n.unknownRecipe),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${l10n.quantity}: ${entry['quantity'] ?? 0}'),
                          Text('${l10n.date}: ${_formatHistoryDate(entry['createdAt'])}'),
                        ],
                      ),
                      trailing: Text(
                        CurrencyFormatter.formatCRC(entry['costSavings'] ?? 0.0),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  String _formatHistoryDate(dynamic dateValue) {
    final l10n = AppLocalizations.of(context);
    if (dateValue == null) return l10n.unknownDate;
    
    try {
      final date = DateTime.parse(dateValue.toString());
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return l10n.invalidDate;
    }
  }

  void _viewDetails(InventoryAlert alert) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.message),
            const SizedBox(height: 8),
            if (alert.itemName != null) Text('${l10n.item}: ${alert.itemName}'),
            Text('${l10n.created}: ${_formatDate(alert.createdAt)}'),
            Text('${l10n.urgency}: ${alert.urgencyText}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  IconData _getAlertIcon(InventoryAlert alert) {
    // Use title to determine icon type
    final title = alert.title.toLowerCase();
    if (title.contains('expiring') || title.contains('expire')) {
      return Icons.warning_amber;
    } else if (title.contains('low') || title.contains('stock')) {
      return Icons.inventory_2;
    } else if (title.contains('overstock') || title.contains('excess')) {
      return Icons.inventory;
    } else if (title.contains('expired') || title.contains('spoiled')) {
      return Icons.block;
    } else {
      return Icons.notifications;
    }
  }
} 