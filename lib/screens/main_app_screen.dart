import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/screens/home_screen.dart';
import 'package:daily_reset/screens/stats_screen.dart';
import 'package:daily_reset/screens/settings_screen.dart';
import 'package:daily_reset/screens/programs_screen.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    ProgramsScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainNavigationState>();

    return Scaffold(
      body: _screens[appState.currentIndex],
      bottomNavigationBar: NavigationBar(
        key: const Key('main_navigation_bar'),
        selectedIndex: appState.currentIndex,
        onDestinationSelected: (index) {
          appState.setIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Programs',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: KeyedSubtree(
              key: Key('main_nav_settings'),
              child: Icon(Icons.settings_outlined),
            ),
            selectedIcon: KeyedSubtree(
              key: Key('main_nav_settings_selected'),
              child: Icon(Icons.settings),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// Simple app-wide navigation state so that theme rebuilds do not reset
/// the currently selected bottom navigation tab.
class MainNavigationState extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int value) {
    if (value == _currentIndex) return;
    _currentIndex = value;
    notifyListeners();
  }
}
