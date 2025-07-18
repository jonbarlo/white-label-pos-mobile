import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/bottom_navigation.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        // Remove hardcoded colors - let theme handle it
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewMessageDialog(context),
            tooltip: 'New Message',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions
          _buildQuickActions(context),
          
          // Messages List
          Expanded(
            child: _buildMessagesList(context),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context,
              'Kitchen',
              Icons.restaurant,
              theme.colorScheme.tertiary,
              () => _showKitchenChat(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              'Manager',
              Icons.person,
              theme.colorScheme.primary,
              () => _showManagerChat(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              'Staff',
              Icons.people,
              theme.colorScheme.secondary,
              () => _showStaffChat(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    final theme = Theme.of(context);
    
    // Mock messages data
    final messages = [
      _createMockMessage('Kitchen', 'Order #123 ready for pickup', '2 min ago', true, theme.colorScheme.tertiary),
      _createMockMessage('Manager', 'Table A1 needs attention', '5 min ago', false, theme.colorScheme.primary),
      _createMockMessage('Staff', 'Break time in 10 minutes', '15 min ago', false, theme.colorScheme.secondary),
      _createMockMessage('Kitchen', 'Special request for Table B2', '20 min ago', false, theme.colorScheme.tertiary),
      _createMockMessage('Manager', 'Daily briefing at 4 PM', '1 hour ago', false, theme.colorScheme.primary),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageCard(context, message);
      },
    );
  }

  Map<String, dynamic> _createMockMessage(String sender, String content, String time, bool isUnread, Color color) {
    return {
      'sender': sender,
      'content': content,
      'time': time,
      'isUnread': isUnread,
      'color': color,
    };
  }

  Widget _buildMessageCard(BuildContext context, Map<String, dynamic> message) {
    final theme = Theme.of(context);
    final sender = message['sender'] as String;
    final content = message['content'] as String;
    final time = message['time'] as String;
    final isUnread = message['isUnread'] as bool;
    final color = message['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread ? color : theme.colorScheme.outline.withOpacity(0.3),
          width: isUnread ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showMessageDetails(context, message),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Sender Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getSenderIcon(sender), color: color, size: 20),
              ),
              
              const SizedBox(width: 16),
              
              // Message Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          sender,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUnread ? color : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Action Icon
              Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSenderIcon(String sender) {
    switch (sender.toLowerCase()) {
      case 'kitchen':
        return Icons.restaurant;
      case 'manager':
        return Icons.person;
      case 'staff':
        return Icons.people;
      default:
        return Icons.message;
    }
  }

  void _showMessageDetails(BuildContext context, Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getSenderIcon(message['sender']), color: message['color']),
            const SizedBox(width: 8),
            Text(message['sender']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['content'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message['time'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _replyToMessage(context, message);
            },
            child: const Text('Reply'),
          ),
        ],
      ),
    );
  }

  void _showNewMessageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Recipient',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'kitchen', child: Text('Kitchen')),
                DropdownMenuItem(value: 'manager', child: Text('Manager')),
                DropdownMenuItem(value: 'staff', child: Text('Staff')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message sent!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showKitchenChat(BuildContext context) {
    final theme = Theme.of(context);
    _showChatDialog(context, 'Kitchen', theme.colorScheme.tertiary);
  }

  void _showManagerChat(BuildContext context) {
    final theme = Theme.of(context);
    _showChatDialog(context, 'Manager', theme.colorScheme.primary);
  }

  void _showStaffChat(BuildContext context) {
    final theme = Theme.of(context);
    _showChatDialog(context, 'Staff', theme.colorScheme.secondary);
  }

  void _showChatDialog(BuildContext context, String recipient, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getSenderIcon(recipient), color: color),
            const SizedBox(width: 8),
            Text('Chat with $recipient'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('Chat messages will appear here'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Send message
                    },
                  ),
                ),
              ),
            ],
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

  void _replyToMessage(BuildContext context, Map<String, dynamic> message) {
    _showChatDialog(context, message['sender'], message['color']);
  }
} 