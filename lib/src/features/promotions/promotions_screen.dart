import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'promotions_provider.dart';
import 'models/promotion.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../../core/localization/app_localizations.dart';

class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotionsAsync = ref.watch(promotionsNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.promotionsManagement),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(promotionsNotifierProvider.notifier).refreshPromotions();
            },
            tooltip: l10n.refresh,
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
                l10n.errorLoadingPromotions,
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
                child: Text(l10n.retry),
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
    final l10n = AppLocalizations.of(context)!;
    
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
              l10n.noPromotionsYet,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.createYourFirstPromotionToGetStarted,
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
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(promotion.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(promotion.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(context, promotion.isActive ? PromotionStatus.active : PromotionStatus.inactive),
                const SizedBox(width: 8),
                _buildTypeChip(context, promotion.type),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditPromotionDialog(context, promotion);
                break;
              case 'delete':
                _showDeletePromotionDialog(context, promotion);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(l10n.edit),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(l10n.delete),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, PromotionStatus status) {
    final l10n = AppLocalizations.of(context)!;
    
    String label;
    Color color;

    switch (status) {
      case PromotionStatus.active:
        label = l10n.active;
        color = Colors.green;
        break;
      case PromotionStatus.inactive:
        label = l10n.inactive;
        color = Colors.grey;
        break;
      case PromotionStatus.scheduled:
        label = l10n.scheduled;
        color = Colors.blue;
        break;
      case PromotionStatus.expired:
        label = l10n.expired;
        color = Colors.red;
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

  Widget _buildTypeChip(BuildContext context, PromotionType type) {
    final l10n = AppLocalizations.of(context)!;
    
    String label;
    Color color;

    switch (type) {
      case PromotionType.discount:
        label = l10n.discount;
        color = Colors.orange;
        break;
      case PromotionType.chef_special:
        label = l10n.chefSpecial;
        color = Colors.purple;
        break;
      case PromotionType.buyOneGetOne:
        label = l10n.buyOneGetOne;
        color = Colors.blue;
        break;
      case PromotionType.freeItem:
        label = l10n.freeItem;
        color = Colors.green;
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

  void _showCreatePromotionDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.createPromotion),
        content: Text(l10n.createPromotionFormWillBeImplemented),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // Create promotion logic
              Navigator.of(context).pop();
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _showEditPromotionDialog(BuildContext context, Promotion promotion) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editPromotion),
        content: Text(l10n.editPromotionFormWillBeImplemented),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // Save promotion logic
              Navigator.of(context).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showDeletePromotionDialog(BuildContext context, Promotion promotion) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deletePromotion),
        content: Text('${l10n.areYouSureYouWantToDelete} "${promotion.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete promotion logic
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
} 
