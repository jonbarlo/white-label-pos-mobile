import 'package:flutter/material.dart';
import '../../shared/widgets/theme_toggle_button.dart';

class BarScreen extends StatelessWidget {
  const BarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar Orders'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: const Center(
        child: Text('This is the Bar screen for viewer users.'),
      ),
    );
  }
} 