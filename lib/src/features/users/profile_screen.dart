import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/loading_widget.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/error_widget.dart';
import 'package:white_label_pos_mobile/src/core/config/env_config.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../../shared/widgets/app_image.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _phone;
  bool _editing = false;
  bool _loading = false;
  String? _error;

  void _startEdit(String name, String email) {
    setState(() {
      _editing = true;
      _name = name;
      _email = email;
      _phone = '+1 (555) 123-4567'; // Mock phone number
      _error = null;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() { _loading = true; _error = null; });
    
    try {
      final result = await ref.read(authRepositoryProvider).updateProfile(
        firstName: _name,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );
      
      setState(() { _loading = false; });
      if (result.isSuccess) {
        setState(() { _editing = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
        );
      } else {
        setState(() { _error = result.errorMessage; });
      }
    } catch (e) {
      setState(() { 
        _loading = false; 
        _error = e.toString();
      });
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final notifier = ref.read(authNotifierProvider.notifier);
      await notifier.logout();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    // Handle different auth states
    if (_loading) return const LoadingWidget(message: 'Saving...');
    
    switch (authState.status) {
      case AuthStatus.loading:
        return const LoadingWidget(message: 'Loading profile...');
      case AuthStatus.error:
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(
            child: AppErrorWidget(
              message: authState.errorMessage ?? 'Failed to load profile',
              actionText: 'Retry',
              onActionPressed: () {
                ref.read(authNotifierProvider.notifier).checkAuthStatus();
              },
            ),
          ),
        );
      case AuthStatus.unauthenticated:
        return const Scaffold(
          body: Center(
            child: AppErrorWidget(message: 'Please log in to view your profile'),
          ),
        );
      case AuthStatus.initial:
        return const LoadingWidget(message: 'Initializing...');
      case AuthStatus.authenticated:
        break; // Continue to show the profile
    }

    final user = authState.user;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: AppErrorWidget(message: 'User data not available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        actions: [
          const ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Header Card
                _buildProfileHeaderCard(context, theme, user),
                const SizedBox(height: 24),
                
                // Personal Information Card
                _buildPersonalInfoCard(context, theme, user),
                const SizedBox(height: 16),
                
                // Work Information Card
                _buildWorkInfoCard(context, theme, user),
                const SizedBox(height: 16),
                
                // Quick Stats Card
                _buildQuickStatsCard(context, theme),
                const SizedBox(height: 16),
                
                // Account Settings Card
                _buildAccountSettingsCard(context, theme),
                const SizedBox(height: 16),
                
                // Support & Help Card
                _buildSupportCard(context, theme),
                const SizedBox(height: 24),
                
                // Logout Button
                _buildLogoutButton(context, theme),
                
                if (EnvConfig.isDebugMode) ...[
                  const SizedBox(height: 16),
                  _buildDebugButton(context, theme),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(BuildContext context, ThemeData theme, User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Avatar
            Stack(
              children: [
                AppAvatar(
                  imageUrl: null,
                  size: 100,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  fallbackIcon: Icons.person,
                  fallbackIconColor: theme.colorScheme.primary,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: theme.colorScheme.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Name and Email
            if (!_editing) ...[
              Text(
                user.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profile'),
                    onPressed: () => _startEdit(user.name, user.email),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text('Change Photo'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Photo upload coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ] else ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _name,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                      onSaved: (v) => _name = v,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      onSaved: (v) => _phone = v,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            child: const Text('Save Changes'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _editing = false),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: theme.colorScheme.error, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: TextStyle(color: theme.colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, ThemeData theme, User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Personal Information',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', user.name, Icons.person_outline),
            _buildInfoRow('Email', user.email, Icons.email_outlined),
            _buildInfoRow('Phone', '+1 (555) 123-4567', Icons.phone_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkInfoCard(BuildContext context, ThemeData theme, User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Work Information',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Role', user.role.displayName, Icons.badge_outlined),
            _buildInfoRow('Employee ID', 'WST-001', Icons.credit_card_outlined),
            _buildInfoRow('Department', 'Front of House', Icons.business_outlined),
            _buildInfoRow('Hire Date', 'March 15, 2024', Icons.calendar_today_outlined),
            _buildInfoRow('Status', 'Active', Icons.check_circle_outline, 
              valueColor: theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: theme.colorScheme.tertiary),
                const SizedBox(width: 8),
                Text(
                  'Quick Stats',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatItem('Orders', '1,247', 'This Month', Icons.receipt_long)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatItem('Tables', '89', 'This Week', Icons.table_restaurant)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatItem('Tips', '\$2,340', 'This Month', Icons.attach_money)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingsCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Account Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsItem('Change Password', Icons.lock_outline, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password change coming soon!')),
              );
            }),
            _buildSettingsItem('Notification Settings', Icons.notifications_outlined, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings coming soon!')),
              );
            }),
            _buildSettingsItem('Theme Settings', Icons.palette_outlined, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings coming soon!')),
              );
            }),
            _buildSettingsItem('Privacy & Security', Icons.security_outlined, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon!')),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Support & Help',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsItem('Help Center', Icons.help_outline, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help center coming soon!')),
              );
            }),
            _buildSettingsItem('Contact Support', Icons.phone_outlined, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact support coming soon!')),
              );
            }),
            _buildSettingsItem('Training Materials', Icons.school_outlined, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Training materials coming soon!')),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: _logout,
      ),
    );
  }

  Widget _buildDebugButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.clear_all),
        label: const Text('Clear Stored Data (Debug)'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(color: theme.colorScheme.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Clear All Data'),
              content: const Text('This will clear all stored data and log you out. This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                  child: const Text('Clear Data'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            final repository = ref.read(authRepositoryProvider);
            await repository.clearStoredAuth();
            await _logout();
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String subtitle, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
} 