import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_provider.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../../shared/widgets/app_image.dart';
import '../../shared/utils/currency_formatter.dart';
import '../business/business_provider.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryProvider.notifier).loadInventoryItems();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventory),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.allItems),
            Tab(text: l10n.lowStock),
            Tab(text: l10n.categories),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllItemsTab(inventoryState),
          _buildLowStockTab(inventoryState),
          _buildCategoriesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAllItemsTab(InventoryState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingInventory,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(inventoryProvider.notifier).loadInventoryItems();
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final items = state.displayItems;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Theme.of(context).textTheme.bodySmall?.color),
            const SizedBox(height: 16),
            Text(
              l10n.noInventoryItemsFound,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addYourFirstItemToGetStarted,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(inventoryProvider.notifier).loadInventoryItems();
      },
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildInventoryItemTile(item);
        },
      ),
    );
  }

  Widget _buildLowStockTab(InventoryState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final lowStockItems = state.lowStockItems;

    if (lowStockItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              l10n.allItemsAreWellStocked,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noLowStockItemsFound,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(inventoryProvider.notifier).loadInventoryItems();
      },
      child: ListView.builder(
        itemCount: lowStockItems.length,
        itemBuilder: (context, index) {
          final item = lowStockItems[index];
          return _buildInventoryItemTile(item);
        },
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        final categoriesAsync = ref.watch(categoriesProvider);

        return categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined, size: 64, color: Theme.of(context).textTheme.bodySmall?.color),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noCategoriesFound,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.categoriesWillAppearHere,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(category.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref.read(inventoryProvider.notifier).filterByCategory(category.name);
                    _tabController.animateTo(0); // Switch to All Items tab
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  l10n.errorLoadingCategories,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(error.toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInventoryItemTile(InventoryItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: AppAvatar(
          imageUrl: item.imageUrl,
          size: 40,
          backgroundColor: _getStockColor(item),
          fallbackIcon: Icons.inventory,
          fallbackIconColor: Colors.white,
        ),
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${item.sku}'),
            Text('Category: ${item.category}'),
            Row(
              children: [
                Text('Stock: ${item.stockQuantity}'),
                if (item.isLowStock) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.warning, color: Colors.orange, size: 16),
                ],
                if (item.isOutOfStock) ...[
                  const SizedBox(width: 8),
                  Text(
                    'Out of Stock',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                              CurrencyFormatter.formatBusinessCurrency(
                                item.price, 
                                ref.watch(currentBusinessCurrencyIdProvider)
                              ),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
                              'Cost: ${CurrencyFormatter.formatBusinessCurrency(item.cost, ref.watch(currentBusinessCurrencyIdProvider))}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        onTap: () {
          _showItemDetailsDialog(item);
        },
        onLongPress: () {
          _showItemOptionsDialog(item);
        },
      ),
    );
  }

  Color _getStockColor(InventoryItem item) {
    if (item.isOutOfStock) return Colors.red;
    if (item.isLowStock) return Colors.orange;
    return Colors.green;
  }

  void _showSearchDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.searchInventory),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.search,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (query) {
            ref.read(inventoryProvider.notifier).searchItems(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              ref.read(inventoryProvider.notifier).clearSearch();
              Navigator.of(context).pop();
            },
            child: Text(l10n.clear),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.filterOptions),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.filterOptionsWillBeImplementedHere),
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

  void _showAddItemDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addNewItem),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.addItemFormWillBeImplementedHere),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement add item functionality
              Navigator.of(context).pop();
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showItemDetailsDialog(InventoryItem item) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${item.sku}'),
            Text('Category: ${item.category}'),
                         Text('Price: ${CurrencyFormatter.formatBusinessCurrency(item.price, ref.watch(currentBusinessCurrencyIdProvider))}'),
             Text('Cost: ${CurrencyFormatter.formatBusinessCurrency(item.cost, ref.watch(currentBusinessCurrencyIdProvider))}'),
            Text('Stock: ${item.stockQuantity}'),
            Text('Min Stock: ${item.minStockLevel}'),
            Text('Max Stock: ${item.maxStockLevel}'),
            if (item.description != null) Text('Description: ${item.description}'),
            if (item.barcode != null) Text('Barcode: ${item.barcode}'),
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

  void _showItemOptionsDialog(InventoryItem item) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Options for ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.editItem),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement edit functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: Text(l10n.updateStock),
              onTap: () {
                Navigator.of(context).pop();
                _showUpdateStockDialog(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(l10n.deleteItem, style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(item);
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

  void _showUpdateStockDialog(InventoryItem item) {
    final l10n = AppLocalizations.of(context)!;
    final stockController = TextEditingController(text: item.stockQuantity.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock for ${item.name}'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.newStockQuantity,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuantity = int.tryParse(stockController.text);
              if (newQuantity != null) {
                ref.read(inventoryProvider.notifier).updateStockLevel(item.id, newQuantity);
              }
              Navigator.of(context).pop();
            },
            child: Text(l10n.update),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(InventoryItem item) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteItem),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(inventoryProvider.notifier).deleteInventoryItem(item.id);
              Navigator.of(context).pop();
            },
            style: AppTheme.neutralButtonStyle,
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
} 
