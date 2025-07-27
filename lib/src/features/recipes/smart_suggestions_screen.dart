import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_provider.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';
import '../promotions/promotions_provider.dart';

class SmartSuggestionsScreen extends ConsumerStatefulWidget {
  const SmartSuggestionsScreen({super.key});

  @override
  ConsumerState<SmartSuggestionsScreen> createState() => _SmartSuggestionsScreenState();
}

class _SmartSuggestionsScreenState extends ConsumerState<SmartSuggestionsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingSuggestionsAsync = ref.watch(pendingSuggestionsProvider);
    final cookedSuggestionsAsync = ref.watch(cookedSuggestionsProvider);
    final allSuggestionsAsync = ref.watch(allSuggestionsProvider);
    final wastePreventionAsync = ref.watch(wastePreventionSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Recipe Suggestions'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Cooked'),
            Tab(text: 'All'),
            Tab(text: 'Waste Prevention'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingTab(pendingSuggestionsAsync),
          _buildCookedTab(cookedSuggestionsAsync),
          _buildAllTab(allSuggestionsAsync),
          _buildWastePreventionTab(wastePreventionAsync),
        ],
      ),
    );
  }

  Widget _buildPendingTab(AsyncValue<List<SmartRecipeSuggestion>> suggestionsAsync) {
    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return const Center(
            child: Text('No pending suggestions available'),
          );
        }

        // Group by urgency level
        final highUrgency = suggestions.where((s) => s.urgencyLevel == UrgencyLevel.high).toList();
        final mediumUrgency = suggestions.where((s) => s.urgencyLevel == UrgencyLevel.medium).toList();
        final lowUrgency = suggestions.where((s) => s.urgencyLevel == UrgencyLevel.low).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (highUrgency.isNotEmpty) ...[
              _buildUrgencySection('High Urgency', highUrgency, Colors.red),
              const SizedBox(height: 16),
            ],
            if (mediumUrgency.isNotEmpty) ...[
              _buildUrgencySection('Medium Urgency', mediumUrgency, Colors.orange),
              const SizedBox(height: 16),
            ],
            if (lowUrgency.isNotEmpty) ...[
              _buildUrgencySection('Low Urgency', lowUrgency, Colors.green),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildCookedTab(AsyncValue<List<SmartRecipeSuggestion>> suggestionsAsync) {
    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return const Center(
            child: Text('No cooked suggestions available'),
          );
        }

        // Sort by creation date (most recent first)
        final sortedSuggestions = List<SmartRecipeSuggestion>.from(suggestions)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = sortedSuggestions[index];
            return _buildCookedSuggestionCard(suggestion);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildAllTab(AsyncValue<List<SmartRecipeSuggestion>> suggestionsAsync) {
    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return const Center(
            child: Text('No suggestions available'),
          );
        }

        // Sort by potential savings
        final sortedSuggestions = List<SmartRecipeSuggestion>.from(suggestions)
          ..sort((a, b) => b.potentialSavings.compareTo(a.potentialSavings));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = sortedSuggestions[index];
            return _buildSuggestionCard(suggestion);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildWastePreventionTab(AsyncValue<Map<String, dynamic>> wastePreventionAsync) {
    return wastePreventionAsync.when(
      data: (data) {
        final summary = data['summary'] as Map<String, dynamic>? ?? {};
        final suggestions = data['suggestions'] as List<dynamic>? ?? [];
        
        // Extract expiring items from suggestions
        final allExpiringItems = <Map<String, dynamic>>[];
        for (final suggestion in suggestions) {
          final suggestionData = suggestion as Map<String, dynamic>;
          final expiringItems = suggestionData['expiringItems'] as List<dynamic>? ?? [];
          allExpiringItems.addAll(expiringItems.map((item) => item as Map<String, dynamic>));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              _buildWastePreventionSummaryCard(summary),
              const SizedBox(height: 24),
              
              // Expiring Items Section
              if (allExpiringItems.isNotEmpty) ...[
                _buildWastePreventionExpiringItemsSection(allExpiringItems),
                const SizedBox(height: 24),
              ],
              
              // Recipe Suggestions Section
              if (suggestions.isNotEmpty) ...[
                _buildWastePreventionSuggestionsSection(suggestions),
              ] else ...[
                _buildWastePreventionNoSuggestionsCard(),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading waste prevention data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(wastePreventionSuggestionsProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyTab(AsyncValue<List<SmartRecipeSuggestion>> suggestionsAsync) {
    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return const Center(
            child: Text('No smart recipe suggestions available'),
          );
        }

        // Group by urgency level
        final highUrgency = suggestions.where((s) => s.urgencyLevel == UrgencyLevel.high).toList();
        final mediumUrgency = suggestions.where((s) => s.urgencyLevel == UrgencyLevel.medium).toList();
        final lowUrgency = suggestions.where((s) => s.urgencyLevel == UrgencyLevel.low).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (highUrgency.isNotEmpty) ...[
              _buildUrgencySection('High Urgency', highUrgency, Colors.red),
              const SizedBox(height: 16),
            ],
            if (mediumUrgency.isNotEmpty) ...[
              _buildUrgencySection('Medium Urgency', mediumUrgency, Colors.orange),
              const SizedBox(height: 16),
            ],
            if (lowUrgency.isNotEmpty) ...[
              _buildUrgencySection('Low Urgency', lowUrgency, Colors.green),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildSavingsTab(AsyncValue<List<SmartRecipeSuggestion>> suggestionsAsync) {
    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return const Center(
            child: Text('No smart recipe suggestions available'),
          );
        }

        // Sort by potential savings
        final sortedSuggestions = List<SmartRecipeSuggestion>.from(suggestions)
          ..sort((a, b) => b.potentialSavings.compareTo(a.potentialSavings));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = sortedSuggestions[index];
            return _buildSuggestionCard(suggestion);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildUrgencySection(String title, List<SmartRecipeSuggestion> suggestions, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...suggestions.map((suggestion) => _buildSuggestionCard(suggestion)),
      ],
    );
  }

  Widget _buildSuggestionCard(SmartRecipeSuggestion suggestion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    suggestion.recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: suggestion.urgencyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: suggestion.urgencyColor),
                  ),
                  child: Text(
                    suggestion.urgencyText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: suggestion.urgencyColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              suggestion.recipe.description,
              style: const TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildMetricChip(
                  'Confidence',
                  '${(suggestion.confidenceScore * 100).toInt()}%',
                  Colors.blue,
                ),
                _buildMetricChip(
                  'Potential Savings',
                  '\$${suggestion.potentialSavings.toStringAsFixed(2)}',
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              suggestion.reasoning,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (suggestion.matchingIngredients.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Matching Ingredients: ${suggestion.matchingIngredients.map((i) => i.name).join(', ')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: suggestion.canBeCooked ? () => _cookRecipe(suggestion) : null,
                    icon: Icon(
                      suggestion.canBeCooked ? Icons.restaurant_menu : Icons.check_circle,
                      size: 16,
                    ),
                    label: Text(suggestion.canBeCooked ? 'Cook Recipe' : 'Already Cooked'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: suggestion.canBeCooked ? Colors.green : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _createPromotion(suggestion),
                    icon: const Icon(Icons.local_offer, size: 16),
                    label: const Text('Create Promotion'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildMetricChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCookedSuggestionCard(SmartRecipeSuggestion suggestion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    suggestion.recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Text(
                    'COOKED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              suggestion.recipe.description,
              style: const TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildMetricChip(
                  'Confidence',
                  '${(suggestion.confidenceScore * 100).toInt()}%',
                  Colors.blue,
                ),
                _buildMetricChip(
                  'Potential Savings',
                  '\$${suggestion.potentialSavings.toStringAsFixed(2)}',
                  Colors.green,
                ),
                _buildMetricChip(
                  'Cooked On',
                  '${suggestion.createdAt.day}/${suggestion.createdAt.month}/${suggestion.createdAt.year}',
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              suggestion.reasoning,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (suggestion.matchingIngredients.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Ingredients Used: ${suggestion.matchingIngredients.map((i) => i.name).join(', ')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            // Show cooked status instead of action buttons
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Recipe Cooked Successfully',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cookRecipe(SmartRecipeSuggestion suggestion) {
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

  void _createPromotion(SmartRecipeSuggestion suggestion) {
    final nameController = TextEditingController(text: 'Chef\'s Special: ${suggestion.recipe.name}');
    final valueController = TextEditingController(text: '15');
    String selectedType = 'percentage';
    String selectedPromotionType = 'discount';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Create Promotion for ${suggestion.recipe.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Create a promotion to help move inventory:'),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Promotion Name',
                  hintText: 'e.g., Chef\'s Special - 15% Off',
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
                value: selectedType,
                items: const [
                  DropdownMenuItem(value: 'percentage', child: Text('Percentage Discount')),
                  DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount Off')),
                  DropdownMenuItem(value: 'buyOneGetOne', child: Text('Buy One Get One')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value ?? 'percentage';
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: selectedType == 'percentage' ? 'Percentage (%)' : 'Amount (\$)',
                  hintText: selectedType == 'percentage' ? '15' : '5.00',
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
              onPressed: () {
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
                _executeCreatePromotion(suggestion, name, selectedPromotionType, selectedType, value);
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

  Future<void> _executeCookRecipe(SmartRecipeSuggestion suggestion, {
    required int quantity,
    required String promotionType,
    required String promotionName,
    required String promotionDescription,
    required String discountType,
    required double discountValue,
    required int promotionExpiresInHours,
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
                Text('Cost Savings: \$${result['cookingResult']['costSavings']?.toStringAsFixed(2) ?? '0.00'}'),
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
                // Refresh the suggestions
                ref.invalidate(smartRecipeSuggestionsProvider);
                
                // Refresh promotions to show the newly created promotion
                ref.invalidate(activePromotionsProvider);
                ref.invalidate(promotionsNotifierProvider);
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

  void _executeCreatePromotion(SmartRecipeSuggestion suggestion, String name, String promotionType, String discountType, double value) async {
    try {
      final repository = ref.read(smartRecipeRepositoryProvider);
      
      // Set expiration to 7 days from now
      final expiresAt = DateTime.now().add(const Duration(days: 7));
      
      final result = await repository.createPromotion(
        name: name,
        type: promotionType,
        discountType: discountType,
        discountValue: value,
        expiresAt: expiresAt,
        itemIds: suggestion.matchingIngredients.map((item) => item.id).toList(),
        description: 'Promotion created from smart recipe suggestion: ${suggestion.recipe.name}',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully created promotion: ${result['name'] ?? name}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Refresh the suggestions to show updated data
      ref.invalidate(smartRecipeSuggestionsProvider);
      
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
  }

  // Waste Prevention Helper Methods
  Widget _buildWastePreventionSummaryCard(Map<String, dynamic> summary) {
    final totalExpiringItems = summary['totalExpiringItems']?.toInt() ?? 0;
    final potentialWasteValue = summary['potentialWasteValue']?.toDouble() ?? 0.0;
    final suggestionsCount = summary['suggestionsGenerated']?.toInt() ?? 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Waste Prevention Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Text(
                        'HIGH URGENCY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildWastePreventionMetric(
                    'Expiring Items',
                    totalExpiringItems.toString(),
                    Icons.inventory,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildWastePreventionMetric(
                    'Potential Waste',
                    '\$${potentialWasteValue.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildWastePreventionMetric(
                    'Suggestions',
                    suggestionsCount.toString(),
                    Icons.restaurant_menu,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWastePreventionMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWastePreventionExpiringItemsSection(List<Map<String, dynamic>> expiringItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expiring Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...expiringItems.map((item) {
          final name = item['itemName']?.toString() ?? 'Unknown Item';
          final daysToExpiry = item['daysToExpiry']?.toInt() ?? 0;
          final stock = item['currentStock']?.toDouble() ?? 0.0;
          final value = item['potentialWaste']?.toDouble() ?? 0.0;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getDaysToExpiryColor(daysToExpiry),
                child: Text(
                  daysToExpiry.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(name),
              subtitle: Text('Stock: ${stock.toStringAsFixed(1)} units'),
              trailing: Text(
                '\$${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildWastePreventionSuggestionsSection(List<dynamic> suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recipe Suggestions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...suggestions.map((suggestion) {
          final suggestionData = suggestion as Map<String, dynamic>;
          final recipeName = suggestionData['recipeName']?.toString() ?? 'Unknown Recipe';
          final urgencyLevel = suggestionData['urgency']?.toString() ?? 'low';
          final expiringItems = suggestionData['expiringItems'] as List<dynamic>? ?? [];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getUrgencyColor(urgencyLevel).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _getUrgencyColor(urgencyLevel)),
                        ),
                        child: Text(
                          urgencyLevel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getUrgencyColor(urgencyLevel),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (expiringItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Uses: ${expiringItems.map((item) => item['itemName']).join(', ')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement cook recipe functionality
                          },
                          icon: const Icon(Icons.restaurant_menu, size: 16),
                          label: const Text('Cook Recipe'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement create promotion functionality
                          },
                          icon: const Icon(Icons.local_offer, size: 16),
                          label: const Text('Create Promotion'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildWastePreventionNoSuggestionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Waste Prevention Needed!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All inventory items are well-managed with no immediate waste concerns.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgencyLevel) {
    switch (urgencyLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getDaysToExpiryColor(int daysToExpiry) {
    if (daysToExpiry <= 1) return Colors.red;
    if (daysToExpiry <= 3) return Colors.orange;
    if (daysToExpiry <= 7) return Colors.yellow;
    return Colors.green;
  }
} 