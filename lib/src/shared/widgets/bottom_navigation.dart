import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(context),
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_restaurant),
          label: 'Tables',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Floor Plan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    if (location.contains('/dashboard')) {
      return 0;
    } else if (location.contains('/tables')) {
      return 1;
    } else if (location.contains('/floor-plan')) {
      return 2;
    } else if (location.contains('/messages')) {
      return 3;
    } else if (location.contains('/profile')) {
      return 4;
    }
    
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/tables');
        break;
      case 2:
        context.go('/floor-plan-viewer');
        break;
      case 3:
        context.go('/messages');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
} 