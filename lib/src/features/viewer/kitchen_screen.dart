import 'package:flutter/material.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Orders')),
      body: const Center(
        child: Text('This is the Kitchen screen for viewer users.'),
      ),
    );
  }
} 