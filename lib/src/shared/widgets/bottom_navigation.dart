import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(context),
      onTap: (index) => _onTap(context, index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          label: l10n.dashboard,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.table_restaurant),
          label: l10n.tables,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: l10n.floorPlan,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.message),
          label: l10n.messages,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n.profile,
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
