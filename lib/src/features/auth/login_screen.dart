import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'auth_validators.dart';
import '../../shared/widgets/message_dialog.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../../core/config/env_config.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _businessSlugController;

  @override
  void initState() {
    super.initState();
    // Remove default values; all fields start empty
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _businessSlugController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _businessSlugController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    debugPrint('🔵 LoginScreen: _handleLogin() called');
    if (_formKey.currentState!.validate()) {
      debugPrint('🔵 LoginScreen: Form validation passed');
      debugPrint('🔵 LoginScreen: Email: ${_emailController.text.trim()}');
      debugPrint('🔵 LoginScreen: Business Slug: ${_businessSlugController.text.trim()}');
      debugPrint('🔵 LoginScreen: Password length: ${_passwordController.text.length}');
      
      await ref.read(authNotifierProvider.notifier).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        businessSlug: _businessSlugController.text.trim(),
      );
      debugPrint('🔵 LoginScreen: Login call completed');
    } else {
      debugPrint('🔴 LoginScreen: Form validation failed');
    }
  }

  // Add this to the _LoginScreenState class:
  final List<Map<String, String>> _testUsers = [
    {
      'label': 'Marco Rossi (Owner) - Kitchen Manager',
      'email': 'marco@italiandelight.com',
      'password': 'Password123',
      'role': 'owner',
    },
    {
      'label': 'Sofia Bianchi (Manager) - Floor Manager',
      'email': 'sofia@italiandelight.com',
      'password': 'Password123',
      'role': 'manager',
    },
    {
      'label': 'Giuseppe Verdi (Waitstaff) - Section A',
      'email': 'giuseppe@italiandelight.com',
      'password': 'Password123',
      'role': 'waitstaff',
    },
    {
      'label': 'Maria Esposito (Waitstaff) - Section B',
      'email': 'maria@italiandelight.com',
      'password': 'Password123',
      'role': 'waitstaff',
    },
    {
      'label': 'Antonio Romano (Cashier) - Front Counter',
      'email': 'antonio@italiandelight.com',
      'password': 'Password123',
      'role': 'cashier',
    },
    {
      'label': 'Elena Conti (Viewer) - Reports Only',
      'email': 'elena@italiandelight.com',
      'password': 'Password123',
      'role': 'viewer',
    },
    {
      'label': 'Carlo Moretti (Admin) - System Admin',
      'email': 'carlo@italiandelight.com',
      'password': 'Password123',
      'role': 'admin',
    },
  ];
  String? _selectedTestUserLabel;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    // Show error dialog when login fails
    if (authState.status == AuthStatus.error && authState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        MessageDialogExtension.showError(
          context,
          title: 'Login Failed',
          message: authState.errorMessage!,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authNotifierProvider.notifier).clearError();
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
    }

    return Scaffold(
      body: isWideScreen ? _buildWideLayout(context) : _buildMobileLayout(context),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        // Left side - Illustration
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background decorative elements
                Positioned(
                  top: 50,
                  right: 50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                // Main illustration
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // POS illustration
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Counter/desk
                            Positioned(
                              bottom: 40,
                              left: 20,
                              right: 20,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            // Staff figure
                            Positioned(
                              bottom: 50,
                              left: 50,
                              child: Container(
                                width: 40,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            // Customer figure
                            Positioned(
                              bottom: 50,
                              right: 50,
                              child: Container(
                                width: 40,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            // Plant decoration
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                width: 30,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(
                                  Icons.local_florist,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Welcome to White Label POS',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your complete point of sale solution\nfor modern businesses',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Theme toggle in top right
                Positioned(
                  top: 20,
                  right: 20,
                  child: const ThemeToggleButton(),
                ),
              ],
            ),
          ),
        ),
        // Right side - Login form
        Expanded(
          flex: 1,
          child: _buildLoginForm(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: _buildLoginForm(context),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Icon(
                  Icons.point_of_sale,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                
                // Welcome text
                Text(
                  'Welcome Back :)',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'To keep connected with us please login with your personal information',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Business Slug Field
                TextFormField(
                  controller: _businessSlugController,
                  decoration: InputDecoration(
                    labelText: 'Business Slug',
                    hintText: 'Enter your business slug',
                    prefixIcon: const Icon(Icons.business),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: AuthValidators.validateBusinessSlug,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: AuthValidators.validateEmail,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: AuthValidators.validatePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 24),

                // Test User Dropdown (for prototype, only in debug mode)
                if (EnvConfig.isDebugMode) ...[
                  DropdownButtonFormField<String>(
                    value: _selectedTestUserLabel,
                    decoration: InputDecoration(
                      labelText: 'Quick Login (Test User)',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    items: _testUsers.map((user) => DropdownMenuItem<String>(
                      value: user['label'],
                      child: Text(user['label']!),
                    )).toList(),
                    onChanged: (label) {
                      setState(() {
                        _selectedTestUserLabel = label;
                        final user = _testUsers.firstWhere((u) => u['label'] == label);
                        _emailController.text = user['email']!;
                        _passwordController.text = user['password']!;
                        _businessSlugController.text = 'italian-delight';
                      });
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 16),
                ],

                // Login Button
                ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading ? null : () {
                    debugPrint('🔵 LoginScreen: Login button pressed');
                    _handleLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Login Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 