import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/string_extensions.dart';

/// Custom text field widget with consistent styling
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? helperText;
  final String? errorText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.focusNode,
    this.helperText,
    this.errorText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
            ),
            filled: true,
            fillColor: widget.enabled 
                ? theme.colorScheme.surface 
                : theme.colorScheme.surface.withValues(alpha: 0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.defaultPadding,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }
}

/// Predefined text field types
class AppTextFieldType {
  static AppTextField email({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return AppTextField(
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      validator: validator ?? _emailValidator,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }

  static AppTextField password({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return AppTextField(
      label: label ?? 'Password',
      hint: hint ?? 'Enter your password',
      controller: controller,
      obscureText: true,
      validator: validator ?? _passwordValidator,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.lock_outlined),
    );
  }

  static AppTextField phone({
    String? label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return AppTextField(
      label: label ?? 'Phone',
      hint: hint ?? 'Enter your phone number',
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: validator ?? _phoneValidator,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.phone_outlined),
    );
  }

  static AppTextField search({
    String? hint,
    TextEditingController? controller,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return AppTextField(
      hint: hint ?? 'Search...',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefixIcon: const Icon(Icons.search),
    );
  }

  // Validation functions
  static String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    if (!value.isEmail) {
      return AppConstants.invalidEmailMessage;
    }
    return null;
  }

  static String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    if (value.length < 8) {
      return AppConstants.invalidPasswordMessage;
    }
    return null;
  }

  static String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.requiredFieldMessage;
    }
    if (!value.isPhone) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
} 