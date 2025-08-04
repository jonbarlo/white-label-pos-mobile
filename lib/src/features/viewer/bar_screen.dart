import 'package:flutter/material.dart';
import '../../shared/widgets/theme_toggle_button.dart';
import '../../core/localization/app_localizations.dart';

class BarScreen extends StatelessWidget {
  const BarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.barScreen),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Center(
        child: Text(l10n.barScreen),
      ),
    );
  }
} 
