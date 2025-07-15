import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'messaging_provider.dart';

class MessagingScreen extends ConsumerStatefulWidget {
  const MessagingScreen({super.key});

  @override
  ConsumerState<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends ConsumerState<MessagingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          // Tab bar for message types
          Container(
            color: theme.colorScheme.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: theme.colorScheme.onPrimary,
              labelColor: theme.colorScheme.onPrimary,
              unselectedLabelColor: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
              tabs: const [
                Tab(text: 'Messages'),
                Tab(text: 'Promotions'),
                Tab(text: 'Quick Actions'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMessagesTab(),
                _buildPromotionsTab(),
                _buildQuickActionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    final messagesAsync = ref.watch(messagesProvider);
    
    return Column(
      children: [
        // Message input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // Messages list
        Expanded(
          child: messagesAsync.when(
            data: (messages) {
              if (messages.isEmpty) {
                return const Center(
                  child: Text('No messages yet'),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageCard(messages[index]);
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading messages',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(messagesProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    final theme = Theme.of(context);
    final isUnread = !(message['isRead'] ?? false);
    final messageType = message['type'] ?? 'staff';
    final sender = message['sender'] ?? 'Unknown';
    final content = message['content'] ?? '';
    final timestamp = DateTime.tryParse(message['timestamp'] ?? '') ?? DateTime.now();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUnread ? 2 : 1,
      color: isUnread 
          ? theme.colorScheme.primary.withValues(alpha: 0.05)
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getMessageTypeColorFromString(messageType),
          child: Icon(
            _getMessageTypeIconFromString(messageType),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(content),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(timestamp),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMessageAction(value, message),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'mark_read',
              child: Row(
                children: [
                  Icon(Icons.mark_email_read),
                  SizedBox(width: 8),
                  Text('Mark as Read'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'reply',
              child: Row(
                children: [
                  Icon(Icons.reply),
                  SizedBox(width: 8),
                  Text('Reply'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionsTab() {
    final promotionsAsync = ref.watch(activePromotionsProvider);
    
    return Column(
      children: [
        // Active promotions header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.local_offer,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Active Promotions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              promotionsAsync.when(
                data: (promotions) => Text(
                  '${promotions.length} active',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        
        // Promotions list
        Expanded(
          child: promotionsAsync.when(
            data: (promotions) {
              if (promotions.isEmpty) {
                return const Center(
                  child: Text('No promotions available'),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: promotions.length,
                itemBuilder: (context, index) {
                  return _buildPromotionCard(promotions[index]);
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading promotions',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(activePromotionsProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildQuickActionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildQuickActionCard(
                  'Call Kitchen',
                  Icons.restaurant,
                  Colors.orange,
                  () => _callKitchen(),
                ),
                _buildQuickActionCard(
                  'Call Manager',
                  Icons.person,
                  Colors.blue,
                  () => _callManager(),
                ),
                _buildQuickActionCard(
                  'Emergency',
                  Icons.emergency,
                  Colors.red,
                  () => _emergencyCall(),
                ),
                _buildQuickActionCard(
                  'Table Status',
                  Icons.table_restaurant,
                  Colors.green,
                  () => _checkTableStatus(),
                ),
                _buildQuickActionCard(
                  'Inventory Check',
                  Icons.inventory,
                  Colors.purple,
                  () => _checkInventory(),
                ),
                _buildQuickActionCard(
                  'Daily Report',
                  Icons.assessment,
                  Colors.teal,
                  () => _viewDailyReport(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      // Send message using the provider
      ref.read(sendMessageProvider((
        content: _messageController.text.trim(),
        type: 'staff',
        recipientId: null,
        tableId: null,
      )).future).then((_) {
        _messageController.clear();
        ref.invalidate(messagesProvider);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  void _handleMessageAction(String action, Map<String, dynamic> message) {
    final messageId = message['id']?.toString() ?? '';
    
    switch (action) {
      case 'mark_read':
        ref.read(markMessageAsReadProvider(messageId).future).then((_) {
          ref.invalidate(messagesProvider);
        });
        break;
      case 'reply':
        _messageController.text = 'Re: ${message['content'] ?? ''}';
        _tabController.animateTo(0);
        break;
      case 'delete':
        ref.read(deleteMessageProvider(messageId).future).then((_) {
          ref.invalidate(messagesProvider);
        });
        break;
    }
  }

  void _callKitchen() {
    ref.read(callKitchenProvider.future).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calling kitchen...'),
          backgroundColor: Colors.orange,
        ),
      );
    });
  }

  void _callManager() {
    ref.read(callManagerProvider.future).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calling manager...'),
          backgroundColor: Colors.blue,
        ),
      );
    });
  }

  void _emergencyCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Call'),
        content: const Text('Are you sure you want to make an emergency call?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(emergencyCallProvider.future).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Emergency call initiated'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _checkTableStatus() {
    Navigator.of(context).pop(); // Go back to table selection
  }

  void _checkInventory() {
    ref.read(inventoryStatusProvider.future).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checking inventory...'),
          backgroundColor: Colors.purple,
        ),
      );
    });
  }

  void _viewDailyReport() {
    ref.read(dailyReportProvider.future).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening daily report...'),
          backgroundColor: Colors.teal,
        ),
      );
    });
  }

  Color _getMessageTypeColorFromString(String type) {
    switch (type.toLowerCase()) {
      case 'kitchen':
        return Colors.orange;
      case 'management':
        return Colors.blue;
      case 'customer':
        return Colors.green;
      case 'staff':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getMessageTypeIconFromString(String type) {
    switch (type.toLowerCase()) {
      case 'kitchen':
        return Icons.restaurant;
      case 'management':
        return Icons.person;
      case 'customer':
        return Icons.table_restaurant;
      case 'staff':
        return Icons.people;
      default:
        return Icons.message;
    }
  }

  Widget _buildPromotionCard(Map<String, dynamic> promotion) {
    final theme = Theme.of(context);
    final isExpired = DateTime.tryParse(promotion['validUntil'] ?? '')?.isBefore(DateTime.now()) ?? false;
    final isActive = promotion['isActive'] ?? false;
    final title = promotion['title'] ?? '';
    final description = promotion['description'] ?? '';
    final discount = promotion['discount'] ?? '';
    final category = promotion['category'] ?? '';
    final validUntil = DateTime.tryParse(promotion['validUntil'] ?? '') ?? DateTime.now();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isActive ? 2 : 1,
      color: isExpired 
          ? Colors.grey[100]
          : isActive 
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  child: Text(
                    isActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    discount,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.category,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Valid until ${_formatDate(validUntil)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}

enum MessageType { kitchen, management, customer, staff }

class Message {
  final int id;
  final String sender;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  bool isRead;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
}

class Promotion {
  final int id;
  final String title;
  final String description;
  final String discount;
  final DateTime validUntil;
  final bool isActive;
  final String category;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.validUntil,
    required this.isActive,
    required this.category,
  });
} 