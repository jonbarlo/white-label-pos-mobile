import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/recipes/smart_recipe_provider.dart';
import 'package:white_label_pos_mobile/src/features/recipes/models/smart_recipe_suggestion.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Alerts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Alerts'),
            Tab(text: 'Expiring Items'),
            Tab(text: 'Underperforming'),
          ],
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
                    alert.title,
                    style: const TextStyle(
                      fontSize: 16,
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
                    color: alert.urgencyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: alert.urgencyColor),
                  ),
                  child: Text(
                    alert.urgencyText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: alert.urgencyColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              alert.message,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (alert.itemName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Item: ${alert.itemName}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Created: ${_formatDate(alert.createdAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
} 