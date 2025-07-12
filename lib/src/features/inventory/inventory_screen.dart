import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/inventory/inventory_provider.dart';
import 'package:white_label_pos_mobile/src/features/inventory/models/inventory_item.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/theme_toggle_button.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Items'),
            Tab(text: 'Low Stock'),
            Tab(text: 'Categories'),
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
              'Error loading inventory',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(inventoryProvider.notifier).loadInventoryItems();
              },
              child: const Text('Retry'),
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
              'No inventory items found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first item to get started',
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
              'All items are well stocked',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'No low stock items found',
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
                      'No categories found',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Categories will appear here',
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
                  'Error loading categories',
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
        leading: CircleAvatar(
          backgroundColor: _getStockColor(item),
          child: Text(
            item.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
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
              '\$${item.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Cost: \$${item.cost.toStringAsFixed(2)}',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Inventory'),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by name, SKU, or barcode...',
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
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter options will be implemented here'),
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

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add item form will be implemented here'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement add item functionality
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showItemDetailsDialog(InventoryItem item) {
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
            Text('Price: \$${item.price.toStringAsFixed(2)}'),
            Text('Cost: \$${item.cost.toStringAsFixed(2)}'),
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
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showItemOptionsDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Options for ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Item'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement edit functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Update Stock'),
              onTap: () {
                Navigator.of(context).pop();
                _showUpdateStockDialog(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Item', style: TextStyle(color: Colors.red)),
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
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStockDialog(InventoryItem item) {
    final stockController = TextEditingController(text: item.stockQuantity.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock for ${item.name}'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'New Stock Quantity',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuantity = int.tryParse(stockController.text);
              if (newQuantity != null) {
                ref.read(inventoryProvider.notifier).updateStockLevel(item.id, newQuantity);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(inventoryProvider.notifier).deleteInventoryItem(item.id);
              Navigator.of(context).pop();
            },
            style: AppTheme.neutralButtonStyle,
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 