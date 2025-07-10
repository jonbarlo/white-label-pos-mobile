import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'auth_validators.dart';
import '../../shared/widgets/message_dialog.dart';
import '../../core/config/env_config.dart';

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
    // Set default values in debug mode for easier testing
    if (EnvConfig.isDebugMode) {
      _emailController = TextEditingController(text: 'user@demo.com');
      _passwordController = TextEditingController(text: 'user123');
      _businessSlugController = TextEditingController(text: 'demo-restaurant');
    } else {
      _emailController = TextEditingController();
      _passwordController = TextEditingController();
      _businessSlugController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _businessSlugController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authNotifierProvider.notifier).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        businessSlug: _businessSlugController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

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
                // Clear the error state after showing dialog
                ref.read(authNotifierProvider.notifier).clearError();
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Semantics(
        label: 'Login form',
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or Brand
                Semantics(
                  label: 'Point of sale system logo',
                  excludeSemantics: true,
                  child: Icon(
                    Icons.point_of_sale,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Business Slug Field
                Semantics(
                  label: 'Business slug input field',
                  textField: true,
                  child: TextFormField(
                    key: const Key('business_slug_field'),
                    controller: _businessSlugController,
                    decoration: const InputDecoration(
                      labelText: 'Business Slug',
                      hintText: 'Enter your business slug',
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: AuthValidators.validateBusinessSlug,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.organizationName],
                  ),
                ),
                const SizedBox(height: 16),

                // Email Field
                Semantics(
                  label: 'Email address input field',
                  textField: true,
                  child: TextFormField(
                    key: const Key('email_field'),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: AuthValidators.validateEmail,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                Semantics(
                  label: 'Password input field',
                  textField: true,
                  child: TextFormField(
                    key: const Key('password_field'),
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: AuthValidators.validatePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    autofillHints: const [AutofillHints.password],
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                Semantics(
                  label: authState.status == AuthStatus.loading 
                      ? 'Logging in, please wait'
                      : 'Login to your account',
                  button: true,
                  enabled: authState.status != AuthStatus.loading,
                  child: ElevatedButton(
                    onPressed: authState.status == AuthStatus.loading ? null : _handleLogin,
                    child: authState.status == AuthStatus.loading
                        ? Semantics(
                            label: 'Loading indicator',
                            excludeSemantics: true,
                            child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Text('Login'),
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