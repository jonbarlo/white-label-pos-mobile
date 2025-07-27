import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'promotions_provider.dart';
import 'models/promotion.dart';
import '../../shared/widgets/theme_toggle_button.dart';

class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(promotionsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions Management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(promotionsNotifierProvider.notifier).refreshPromotions();
            },
            tooltip: 'Refresh',
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: promotionsAsync.when(
        data: (promotions) => _buildPromotionsList(context, promotions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading promotions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(promotionsNotifierProvider.notifier).refreshPromotions();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePromotionDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPromotionsList(BuildContext context, List<Promotion> promotions) {
    if (promotions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No promotions yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first promotion to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        final promotion = promotions[index];
        return _buildPromotionCard(context, promotion);
      },
    );
  }

  Widget _buildPromotionCard(BuildContext context, Promotion promotion) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    promotion.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(promotion.isActive ? PromotionStatus.active : PromotionStatus.inactive),
              ],
            ),
            const SizedBox(height: 8),
            if (promotion.description.isNotEmpty) ...[
              Text(
                promotion.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                _buildTypeChip(promotion.type),
                const SizedBox(width: 8),
                _buildDiscountChip(promotion),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(promotion.startDate)} - ${_formatDate(promotion.endDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (promotion.maxUsesPerCustomer != null) ...[
                  Icon(Icons.inventory, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${promotion.usedQuantity}/${promotion.maxUsesPerCustomer} used',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _showEditPromotionDialog(context, promotion);
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    _showDeleteConfirmation(context, promotion);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(PromotionStatus status) {
    Color color;
    String label;
    
    switch (status) {
      case PromotionStatus.active:
        color = Colors.green;
        label = 'Active';
        break;
      case PromotionStatus.inactive:
        color = Colors.grey;
        label = 'Inactive';
        break;
      case PromotionStatus.scheduled:
        color = Colors.blue;
        label = 'Scheduled';
        break;
      case PromotionStatus.expired:
        color = Colors.red;
        label = 'Expired';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTypeChip(PromotionType type) {
    Color color;
    String label;
    
    switch (type) {
      case PromotionType.discount:
        color = Colors.blue;
        label = 'Discount';
        break;
      case PromotionType.chef_special:
        color = Colors.orange;
        label = 'Chef Special';
        break;
      case PromotionType.buyOneGetOne:
        color = Colors.purple;
        label = 'BOGO';
        break;
      case PromotionType.freeItem:
        color = Colors.green;
        label = 'Free Item';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDiscountChip(Promotion promotion) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Text(
        promotion.discountDisplay,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showCreatePromotionDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement create promotion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Promotion'),
        content: const Text('Create promotion dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement create promotion
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditPromotionDialog(BuildContext context, Promotion promotion) {
    // TODO: Implement edit promotion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Promotion'),
        content: Text('Edit promotion dialog for: ${promotion.name}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement edit promotion
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Promotion promotion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Promotion'),
        content: Text('Are you sure you want to delete "${promotion.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete promotion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 