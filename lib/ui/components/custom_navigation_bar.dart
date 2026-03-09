import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int)? onDestinationSelected;
  const CustomNavigationBar({super.key, required this.currentIndex, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Dashboard",
        ),
        NavigationDestination(
          icon: Icon(Icons.medical_information_outlined),
          selectedIcon: Icon(Icons.medical_information),
          label: "Messages",
        ),
        NavigationDestination(
          icon: Icon(Icons.pie_chart_outline),
          selectedIcon: Icon(Icons.pie_chart),
          label: "Alerts",
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: "Profile",
        ),
      ],
    );
  }
}
