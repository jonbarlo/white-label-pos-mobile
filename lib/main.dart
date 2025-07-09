import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/main_app.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/config/env_config.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment configuration
  await EnvConfig.initialize();
  
  runApp(
    const ProviderScope(
      child: WhiteLabelPOSApp(),
    ),
  );
}

class WhiteLabelPOSApp extends StatelessWidget {
  const WhiteLabelPOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: EnvConfig.appName,
      theme: AppTheme.lightTheme,
      home: const MainApp(),
      debugShowCheckedModeBanner: EnvConfig.isDebugMode,
    );
  }
}
