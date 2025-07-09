import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'auth_validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _businessSlugController = TextEditingController();

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

                // Error Message
                if (authState.errorMessage != null)
                  Semantics(
                    label: 'Error message: ${authState.errorMessage}',
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).colorScheme.error.withOpacity(0.3)),
                      ),
                      child: Text(
                        authState.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

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