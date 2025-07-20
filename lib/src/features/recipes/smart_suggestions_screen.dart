import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_provider.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsAsync = ref.watch(smartRecipeSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Recipe Suggestions'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'By Urgency'),
            Tab(text: 'By Savings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUrgencyTab(suggestionsAsync),
          _buildSavingsTab(suggestionsAsync),
        ],
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
} 