import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/navigation_service.dart';
import '../../core/theme/theme_provider.dart';
import '../../shared/widgets/app_image.dart';
import '../auth/models/user.dart';
import '../auth/auth_provider.dart';
import 'admin_menu_provider.dart';
import 'models/admin_menu_item.dart';

class AdminMenuManagementScreen extends ConsumerStatefulWidget {
  const AdminMenuManagementScreen({super.key});

  @override
  ConsumerState<AdminMenuManagementScreen> createState() => _AdminMenuManagementScreenState();
}

class _AdminMenuManagementScreenState extends ConsumerState<AdminMenuManagementScreen> {
  String? _selectedBusinessId;
  String? _selectedCategoryId;
  String _searchQuery = '';
  bool _showAvailableOnly = true;

  @override
  void initState() {
    super.initState();
    // Don't load businesses by default - wait for user to select one
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only load categories when a business is selected
    });
  }

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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => NavigationService.goBack(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Management',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: () {
              ref.invalidate(adminBusinessesProvider);
              ref.invalidate(adminCategoriesProvider);
              ref.invalidate(adminMenuProvider);
            },
            tooltip: 'Refresh Data',
          ),
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
      body: Column(
        children: [
          _buildFilters(theme),
          Expanded(
            child: _buildContent(theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateMenuItemDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Menu Item'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Selection
          _buildBusinessSelector(theme),
          const SizedBox(height: 12),
          
          // Search Field
          _buildSearchField(theme),
          const SizedBox(height: 12),
          
          // Category Filter
          _buildCategoryFilter(theme),
          const SizedBox(height: 12),
          
          // Availability Filter and Clear Button
          Row(
            children: [
              _buildAvailabilityFilter(theme),
              const Spacer(),
              _buildClearFiltersButton(theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessSelector(ThemeData theme) {
    final businessesAsync = ref.watch(adminBusinessesProvider);
    
    return businessesAsync.when(
      data: (businesses) {
        return DropdownButtonFormField<String>(
          value: _selectedBusinessId ?? 'select', // Default to 'select' value
          decoration: InputDecoration(
            labelText: 'Select Business',
            prefixIcon: const Icon(Icons.business),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: 'select',
              child: Text('Select One Business'),
            ),
            ...businesses.map((business) => DropdownMenuItem<String>(
              value: business.id.toString(),
              child: Text(business.name),
            )),
          ],
          onChanged: (value) {
            setState(() {
              _selectedBusinessId = value == 'select' ? null : value;
            });
            
            // Load categories and menu items when a business is selected
            if (value != null && value != 'select') {
              ref.read(adminMenuProvider.notifier).loadCategories(businessId: int.parse(value));
              ref.read(adminMenuProvider.notifier).loadMenuItems(
                businessId: value,
                categoryId: _selectedCategoryId,
                search: _searchQuery,
                availableOnly: _showAvailableOnly,
              );
            } else {
              // Clear categories and menu items when "Select One Business" is chosen
              ref.invalidate(adminCategoriesProvider);
              ref.invalidate(adminMenuProvider);
            }
          },
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (error, stack) => Text('Error loading businesses: $error'),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search menu items...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                  // Call provider method to reload with cleared search
                  if (_selectedBusinessId != null) {
                    ref.read(adminMenuProvider.notifier).loadMenuItems(
                      businessId: _selectedBusinessId,
                      categoryId: _selectedCategoryId,
                      search: '',
                      availableOnly: _showAvailableOnly,
                    );
                  }
                },
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
        // Call provider method to reload with new search
        if (_selectedBusinessId != null) {
          ref.read(adminMenuProvider.notifier).loadMenuItems(
            businessId: _selectedBusinessId,
            categoryId: _selectedCategoryId,
            search: value,
            availableOnly: _showAvailableOnly,
          );
        }
      },
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    final categoriesAsync = ref.watch(adminCategoriesProvider);
    
    return categoriesAsync.when(
      data: (categories) {
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          decoration: InputDecoration(
            labelText: 'Category',
            prefixIcon: const Icon(Icons.category),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Categories'),
            ),
            ...categories.map((category) => DropdownMenuItem<String>(
              value: category.id.toString(),
              child: Text(category.name),
            )),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
            // Call provider method to reload with new category
            if (_selectedBusinessId != null) {
              ref.read(adminMenuProvider.notifier).loadMenuItems(
                businessId: _selectedBusinessId,
                categoryId: value,
                search: _searchQuery,
                availableOnly: _showAvailableOnly,
              );
            }
          },
        );
      },
      loading: () => const SizedBox(
        width: 120,
        child: LinearProgressIndicator(),
      ),
      error: (error, stack) => const SizedBox(
        width: 120,
        child: Text('Error'),
      ),
    );
  }

  Widget _buildAvailabilityFilter(ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _showAvailableOnly,
          onChanged: (value) {
            setState(() {
              _showAvailableOnly = value ?? true;
            });
            // Call provider method to reload with new availability filter
            if (_selectedBusinessId != null) {
              ref.read(adminMenuProvider.notifier).loadMenuItems(
                businessId: _selectedBusinessId,
                categoryId: _selectedCategoryId,
                search: _searchQuery,
                availableOnly: value ?? true,
              );
            }
          },
        ),
        Text(
          'Available Only',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildClearFiltersButton(ThemeData theme) {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _selectedBusinessId = null;
          _selectedCategoryId = null;
          _searchQuery = '';
          _showAvailableOnly = true;
        });
        // Invalidate providers to clear data
        ref.invalidate(adminCategoriesProvider);
        ref.invalidate(adminMenuProvider);
      },
      icon: const Icon(Icons.clear_all),
      label: const Text('Clear Filters'),
    );
  }

  Widget _buildContent(ThemeData theme) {
    // Show message when no business is selected
    if (_selectedBusinessId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Select a Business',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please select a business from the dropdown above to view and manage menu items.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final menuItemsAsync = ref.watch(adminMenuProvider);
    
    return menuItemsAsync.when(
      data: (menuItems) {
        if (menuItems.isEmpty) {
          return _buildEmptyState(theme);
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(adminMenuProvider);
          },
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItemCard(theme, item);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Menu Items',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(adminMenuProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No menu items found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or add a new menu item.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemCard(ThemeData theme, AdminMenuItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: item.imageUrl != null && item.imageUrl!.isNotEmpty
            ? AppThumbnail(
                imageUrl: item.imageUrl,
                size: 50,
                fallbackIcon: Icons.restaurant,
                backgroundColor: theme.colorScheme.primaryContainer,
                fallbackIconColor: theme.colorScheme.onPrimaryContainer,
              )
            : CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.restaurant,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
        title: Text(
          item.name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${item.price.toStringAsFixed(2)}'),
            Text('Category ID: ${item.categoryId}'),
            Row(
              children: [
                Text(item.isAvailable ? 'Available' : 'Unavailable'),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.isAvailable 
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.isAvailable ? '✓' : '✗',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: item.isAvailable 
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditMenuItemDialog(context, item);
                break;
              case 'delete':
                _showDeleteMenuItemDialog(context, item);
                break;
              case 'toggle':
                _toggleMenuItemAvailability(item);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(item.isAvailable ? Icons.visibility_off : Icons.visibility),
                  const SizedBox(width: 8),
                  Text(item.isAvailable ? 'Make Unavailable' : 'Make Available'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateMenuItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _CreateMenuItemDialog(),
    );
  }

  void _showEditMenuItemDialog(BuildContext context, AdminMenuItem item) {
    showDialog(
      context: context,
      builder: (context) => _EditMenuItemDialog(item: item),
    );
  }

  void _showDeleteMenuItemDialog(BuildContext context, AdminMenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "${item.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(adminMenuProvider.notifier).deleteMenuItem(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menu item deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting menu item: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleMenuItemAvailability(AdminMenuItem item) async {
    try {
      await ref.read(adminMenuProvider.notifier).toggleMenuItemAvailability(
        item.id,
        !item.isAvailable,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menu item ${item.isAvailable ? 'made unavailable' : 'made available'} successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating menu item availability: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _CreateMenuItemDialog extends ConsumerStatefulWidget {
  const _CreateMenuItemDialog();

  @override
  ConsumerState<_CreateMenuItemDialog> createState() => _CreateMenuItemDialogState();
}

class _CreateMenuItemDialogState extends ConsumerState<_CreateMenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String? _selectedBusinessId;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Get the currently selected business from the notifier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedBusinessId = ref.read(adminMenuProvider.notifier).selectedBusinessId;
      if (selectedBusinessId != null) {
        setState(() {
          _selectedBusinessId = selectedBusinessId.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessesAsync = ref.watch(adminBusinessesProvider);
    
    // Get the currently selected business ID
    final selectedBusinessId = ref.watch(adminMenuProvider.notifier).selectedBusinessId;

    return AlertDialog(
      title: const Text('Create Menu Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              businessesAsync.when(
                data: (businesses) {
                  // Find the currently selected business
                  final selectedBusiness = businesses.firstWhere(
                    (business) => business.id == selectedBusinessId,
                    orElse: () => businesses.first,
                  );
                  
                  return DropdownButtonFormField<String>(
                    value: selectedBusiness.id.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Business',
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: businesses.map((business) => DropdownMenuItem<String>(
                      value: business.id.toString(),
                      child: Text(business.name),
                    )).toList(),
                    onChanged: null, // Make it read-only
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(height: 16),
              // Load categories for the selected business
              selectedBusinessId != null
                  ? FutureBuilder<List<AdminCategory>>(
                      future: ref.read(adminMenuRepositoryProvider).getCategories(businessId: selectedBusinessId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        
                        if (snapshot.hasError) {
                          return Text('Error loading categories: ${snapshot.error}');
                        }
                        
                        final categories = snapshot.data ?? [];
                        
                        return DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category),
                          ),
                          items: categories.map((category) => DropdownMenuItem<String>(
                            value: category.id.toString(),
                            child: Text(category.name),
                          )).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                        );
                      },
                    )
                  : const Text('Please select a business first'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createMenuItem,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createMenuItem() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);
      final imageUrl = _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null;
      
      // Get the selected business ID from the notifier
      final selectedBusinessId = ref.read(adminMenuProvider.notifier).selectedBusinessId;
      if (selectedBusinessId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a business first'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final businessId = selectedBusinessId;
      final categoryId = int.parse(_selectedCategoryId!);

      ref.read(adminMenuProvider.notifier).createMenuItem(
        name: name,
        description: description,
        price: price,
        businessId: businessId,
        categoryId: categoryId,
        imageUrl: imageUrl,
      ).then((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menu item created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating menu item: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }
}

class _EditMenuItemDialog extends ConsumerStatefulWidget {
  final AdminMenuItem item;

  const _EditMenuItemDialog({required this.item});

  @override
  ConsumerState<_EditMenuItemDialog> createState() => _EditMenuItemDialogState();
}

class _EditMenuItemDialogState extends ConsumerState<_EditMenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;
  late String? _selectedBusinessId;
  late String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _descriptionController = TextEditingController(text: widget.item.description);
    _priceController = TextEditingController(text: widget.item.price.toString());
    _imageUrlController = TextEditingController(text: widget.item.imageUrl ?? '');
    _selectedBusinessId = widget.item.businessId.toString();
    _selectedCategoryId = widget.item.categoryId.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessesAsync = ref.watch(adminBusinessesProvider);

    return AlertDialog(
      title: const Text('Edit Menu Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              businessesAsync.when(
                data: (businesses) => DropdownButtonFormField<String>(
                  value: _selectedBusinessId,
                  decoration: const InputDecoration(
                    labelText: 'Business',
                    prefixIcon: Icon(Icons.business),
                  ),
                  items: businesses.map((business) => DropdownMenuItem<String>(
                    value: business.id.toString(),
                    child: Text(business.name),
                  )).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a business';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedBusinessId = value;
                    });
                  },
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(height: 16),
              // Load categories for the item's business specifically
              FutureBuilder<List<AdminCategory>>(
                future: ref.read(adminMenuRepositoryProvider).getCategories(businessId: widget.item.businessId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  }
                  
                  if (snapshot.hasError) {
                    return Text('Error loading categories: ${snapshot.error}');
                  }
                  
                  final categories = snapshot.data ?? [];
                  
                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: categories.map((category) => DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(category.name),
                    )).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateMenuItem,
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _updateMenuItem() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);
      final imageUrl = _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null;
      final businessId = int.parse(_selectedBusinessId!);
      final categoryId = int.parse(_selectedCategoryId!);

      try {
        await ref.read(adminMenuProvider.notifier).updateMenuItem(
          id: widget.item.id,
          name: name,
          description: description,
          price: price,
          businessId: businessId,
          categoryId: categoryId,
          imageUrl: imageUrl,
        );
        
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menu item updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating menu item: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 