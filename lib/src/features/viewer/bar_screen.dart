import 'package:flutter/material.dart';

class BarScreen extends StatelessWidget {
  const BarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bar Orders')),
      body: const Center(
        child: Text('This is the Bar screen for viewer users.'),
      ),
    );
  }
} 