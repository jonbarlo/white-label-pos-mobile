import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_provider.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';
import '../promotions/promotions_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import '../business/business_provider.dart';

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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Inventory Alerts',
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
                Tab(text: 'All Alerts'),
                Tab(text: 'Expiring Items'),
                Tab(text: 'Underperforming'),
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
    return alertsAsync.when(
      data: (alerts) {
        if (alerts.isEmpty) {
          return const Center(
            child: Text('No inventory alerts available'),
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
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildExpiringItemsTab(AsyncValue<List<InventoryAlert>> alertsAsync) {
    return alertsAsync.when(
      data: (alerts) {
        final expiringAlerts = alerts.where((alert) => 
          alert.title.toLowerCase().contains('expiring') ||
          alert.message.toLowerCase().contains('expiring')
        ).toList();

        if (expiringAlerts.isEmpty) {
          return const Center(
            child: Text('No expiring items alerts'),
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
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildUnderperformingItemsTab(AsyncValue<List<InventoryAlert>> alertsAsync) {
    return alertsAsync.when(
      data: (alerts) {
        final underperformingAlerts = alerts.where((alert) => 
          alert.title.toLowerCase().contains('underperforming') ||
          alert.message.toLowerCase().contains('turnover')
        ).toList();

        if (underperformingAlerts.isEmpty) {
          return const Center(
            child: Text('No underperforming items alerts'),
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
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildAlertCard(InventoryAlert alert) {
    final theme = Theme.of(context);
    
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
                  'Item: ${alert.itemName}',
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
                  label: const Text('View Details'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cook Recipe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cook recipe using: ${alert.itemName ?? 'Unknown Item'}'),
            const SizedBox(height: 16),
            const Text('This will:'),
            const Text('• Consume inventory items'),
            const Text('• Reduce waste'),
            const Text('• Create a Chef\'s Special promotion'),
            const SizedBox(height: 16),
            const Text('Available Recipes:'),
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
                      child: Text('Error loading recipes: ${snapshot.error}'),
                    );
                  }
                  
                  final suggestions = snapshot.data ?? [];
                  
                  if (suggestions.isEmpty) {
                    return const Center(
                      child: Text('No recipe suggestions available'),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return ListTile(
                        title: Text(suggestion.recipe.name),
                        subtitle: Text('Potential savings: ${CurrencyFormatter.formatCRC(suggestion.potentialSavings)}'),
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
            const Text('Quantity to cook:'),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity',
                hintText: '1',
              ),
              controller: TextEditingController(text: '1'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
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
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Cooking recipe...'),
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
          title: const Text('Recipe Cooked Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recipe: ${suggestion.recipe.name}'),
              const SizedBox(height: 8),
              if (result['cookingResult'] != null) ...[
                Text('Quantity Cooked: ${result['cookingResult']['quantity']?.toString() ?? '0'}'),
                Text('Cost Savings: ${CurrencyFormatter.formatCRC(result['cookingResult']['costSavings'] ?? 0.0)}'),
                Text('Waste Reduction: ${result['cookingResult']['wasteReduction']?.toString() ?? '0'} items'),
              ],
              const SizedBox(height: 8),
              if (result['createdPromotion'] != null) ...[
                const Text('Promotion Created:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Name: ${result['createdPromotion']['name']}'),
                Text('Type: ${result['createdPromotion']['type'] ?? 'N/A'}'),
                Text('Discount: ${result['createdPromotion']['discountValue']}%'),
                const SizedBox(height: 4),
                const Text('Quantity Tracking:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Total Quantity: ${result['createdPromotion']['totalQuantity']?.toString() ?? '0'}'),
                Text('Used Quantity: ${result['createdPromotion']['usedQuantity']?.toString() ?? '0'}'),
                Text('Remaining: ${result['createdPromotion']['remainingQuantity']?.toString() ?? '0'}'),
                Text('Status: ${result['createdPromotion']['status'] ?? 'Unknown'}'),
                Text('Expires: ${result['createdPromotion']['expiresAt'] ?? 'Unknown'}'),
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
              child: const Text('OK'),
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
          title: const Text('Error'),
          content: Text('Failed to cook recipe: $e'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
      final promotionName = 'Special Offer: ${alert.itemName ?? 'Selected Items'}';
      
      // Set expiration to end of day
      final expiresAt = DateTime.now().add(const Duration(days: 7));
      
      final result = await repository.createPromotion(
        name: promotionName,
        type: 'discount',
        discountType: type,
        discountValue: value,
        expiresAt: expiresAt,
        itemIds: alert.itemId != null ? [alert.itemId!] : null,
        description: 'Promotion created from inventory alert: ${alert.message}',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully created promotion: ${result['name'] ?? promotionName}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Refresh the alerts to show updated inventory
      ref.invalidate(inventoryAlertsProvider);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating promotion: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showQuickActionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Colors.green),
              title: const Text('Cook Recipe'),
              subtitle: const Text('Use expiring items to create dishes'),
              onTap: () {
                Navigator.of(context).pop();
                _showCookRecipeDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.orange),
              title: const Text('Create Promotion'),
              subtitle: const Text('Create special offers for items'),
              onTap: () {
                Navigator.of(context).pop();
                _showCreatePromotionDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: Colors.blue),
              title: const Text('View Analytics'),
              subtitle: const Text('Check cooking history and metrics'),
              onTap: () {
                Navigator.of(context).pop();
                _showAnalyticsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.purple),
              title: const Text('Cooking History'),
              subtitle: const Text('View recent cooking activities'),
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
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCookRecipeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cook Recipe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select a recipe to cook using expiring items:'),
            const SizedBox(height: 16),
            const Text('This feature will:'),
            const Text('• Automatically select recipes using expiring items'),
            const Text('• Consume inventory and reduce waste'),
            const Text('• Create customizable promotions'),
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
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  
                  final suggestions = snapshot.data ?? [];
                  
                  if (suggestions.isEmpty) {
                    return const Center(child: Text('No recipe suggestions available'));
                  }
                  
                  return ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(suggestion.recipe.name),
                          subtitle: Text(suggestion.recipe.description ?? 'No description'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showCookRecipeWithPromotionDialog(suggestion);
                            },
                            child: const Text('Cook'),
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
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCookRecipeWithPromotionDialog(SmartRecipeSuggestion suggestion) {
    final nameController = TextEditingController(text: 'Chef\'s Special: ${suggestion.recipe.name}');
    final descriptionController = TextEditingController(text: 'Freshly prepared ${suggestion.recipe.name.toLowerCase()} using premium ingredients');
    final discountValueController = TextEditingController(text: '25');
    final expiresHoursController = TextEditingController(text: '48');
    final quantityController = TextEditingController(text: '1');
    String selectedPromotionType = 'chef_special';
    String selectedDiscountType = 'percentage';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Cook ${suggestion.recipe.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cook recipe using: ${suggestion.recipe.name}'),
                const SizedBox(height: 16),
                const Text('This will:'),
                const Text('• Consume inventory items'),
                const Text('• Reduce waste'),
                const Text('• Create a promotion with quantity tracking'),
                const SizedBox(height: 16),
                const Text('Recipe Configuration:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantity to Cook',
                    hintText: '1',
                    helperText: 'This will create a promotion with the same quantity',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Promotion Configuration:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Promotion Name',
                    hintText: 'e.g., Chef\'s Special: Truffle Pizza',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Promotion Description',
                    hintText: 'Description of the promotion',
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Promotion Type',
                  ),
                  value: selectedPromotionType,
                  items: const [
                    DropdownMenuItem(value: 'chef_special', child: Text('Chef\'s Special')),
                    DropdownMenuItem(value: 'discount', child: Text('Discount')),
                    DropdownMenuItem(value: 'bogo', child: Text('Buy One Get One')),
                    DropdownMenuItem(value: 'flash_sale', child: Text('Flash Sale')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPromotionType = value ?? 'chef_special';
                    });
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Discount Type',
                  ),
                  value: selectedDiscountType,
                  items: const [
                    DropdownMenuItem(value: 'percentage', child: Text('Percentage Discount')),
                    DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount Off')),
                    DropdownMenuItem(value: 'free_item', child: Text('Free Item')),
                    DropdownMenuItem(value: 'bogo', child: Text('Buy One Get One')),
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
                    labelText: selectedDiscountType == 'percentage' ? 'Discount Percentage (%)' : 'Discount Amount (\$)',
                    hintText: selectedDiscountType == 'percentage' ? '25' : '5.00',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: expiresHoursController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Promotion Expires In (Hours)',
                    hintText: '48',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
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
                    const SnackBar(content: Text('Please enter a promotion name')),
                  );
                  return;
                }
                
                if (quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quantity must be greater than 0')),
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
              child: const Text('Cook Recipe'),
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
          title: const Text('Create Promotion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Create a promotion for expiring or underperforming items:'),
              const SizedBox(height: 16),
              const Text('This feature will:'),
              const Text('• Create targeted promotions'),
              const Text('• Help move inventory'),
              const Text('• Increase sales and reduce waste'),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Promotion Name',
                  hintText: 'e.g., Flash Sale - 20% Off',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Promotion Type',
                ),
                value: selectedPromotionType,
                items: const [
                  DropdownMenuItem(value: 'discount', child: Text('Discount')),
                  DropdownMenuItem(value: 'chef_special', child: Text('Chef\'s Special')),
                  DropdownMenuItem(value: 'bogo', child: Text('Buy One Get One')),
                  DropdownMenuItem(value: 'flash_sale', child: Text('Flash Sale')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedPromotionType = value ?? 'discount';
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Discount Type',
                ),
                value: selectedDiscountType,
                items: const [
                  DropdownMenuItem(value: 'percentage', child: Text('Percentage Discount')),
                  DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount Off')),
                  DropdownMenuItem(value: 'buyOneGetOne', child: Text('Buy One Get One')),
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
                  labelText: selectedDiscountType == 'percentage' ? 'Percentage (%)' : 'Amount (\$)',
                  hintText: selectedDiscountType == 'percentage' ? '20' : '5.00',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final value = double.tryParse(valueController.text) ?? 0.0;
                
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a promotion name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (value <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid discount value'),
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
                      content: Text('Successfully created promotion: ${result['name'] ?? name}'),
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
                      content: Text('Error creating promotion: $e'),
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
              child: const Text('Create Promotion'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalyticsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cooking Analytics'),
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
                    Text('Error loading analytics: ${snapshot.error}'),
                  ],
                );
              }
              
              final analytics = snapshot.data ?? {};
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnalyticsCard(
                    'Total Recipes Cooked',
                    '${analytics['totalRecipesCooked'] ?? 0}',
                    Icons.restaurant_menu,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildAnalyticsCard(
                    'Waste Reduced',
                    CurrencyFormatter.formatCRC(analytics['wasteReduced'] ?? 0.0),
                    Icons.recycling,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildAnalyticsCard(
                    'Cost Savings',
                    CurrencyFormatter.formatCRC(analytics['costSavings'] ?? 0.0),
                    Icons.savings,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildAnalyticsCard(
                    'Promotions Created',
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
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cooking History'),
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
                    Text('Error loading history: ${snapshot.error}'),
                  ],
                );
              }
              
              final history = snapshot.data ?? [];
              
              if (history.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, color: Colors.grey, size: 48),
                      SizedBox(height: 16),
                      Text('No cooking history yet'),
                      Text('Start cooking recipes to see your history here'),
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
                      title: Text(entry['recipeName'] ?? 'Unknown Recipe'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${entry['quantity'] ?? 0}'),
                          Text('Date: ${_formatHistoryDate(entry['createdAt'])}'),
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
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatHistoryDate(dynamic dateValue) {
    if (dateValue == null) return 'Unknown date';
    
    try {
      final date = DateTime.parse(dateValue.toString());
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  void _viewDetails(InventoryAlert alert) {
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
            if (alert.itemName != null) Text('Item: ${alert.itemName}'),
            Text('Created: ${_formatDate(alert.createdAt)}'),
            Text('Urgency: ${alert.urgencyText}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
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