import 'package:flutter/material.dart';
import 'package:salemtek/ui/pages/main/cabinet/cabinet.dart';
import 'package:salemtek/ui/pages/main/settings/settings.dart';
import 'package:salemtek/ui/pages/main/statistics/statistics.dart';

import '../../../configs/theme/palette.dart';
import 'home/home.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    Home(),
    Cabinet(),
    Statistics(),
    Settings(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTabTapped,
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
      ),
    );
  }
}
