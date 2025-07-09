import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/auth/auth_provider.dart';
import 'package:white_label_pos_mobile/src/features/auth/data/repositories/auth_repository_impl.dart' as auth_repo_impl;
import 'package:white_label_pos_mobile/src/features/auth/models/user.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/loading_widget.dart';
import 'package:white_label_pos_mobile/src/shared/widgets/error_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  bool _editing = false;
  bool _loading = false;
  String? _error;

  void _startEdit(String name, String email) {
    setState(() {
      _editing = true;
      _name = name;
      _email = email;
      _error = null;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() { _loading = true; _error = null; });
    
    try {
      final result = await ref.read(auth_repo_impl.authRepositoryProvider).updateProfile(
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
          const SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green),
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
    final notifier = ref.read(authNotifierProvider.notifier);
    await notifier.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, size: 48, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                if (!_editing) ...[
                  Text(user.name, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(user.email, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    onPressed: () => _startEdit(user.name, user.email),
                  ),
                ] else ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                          onSaved: (v) => _name = v,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: _email,
                          decoration: const InputDecoration(labelText: 'Email'),
                          enabled: false,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveProfile,
                                child: const Text('Save'),
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
                          AppErrorWidget(message: _error),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: Text('Role: ${user.role.displayName}'),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text('Joined: ${user.createdAt.toLocal().toString().split(' ').first}'),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                  onPressed: _logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 