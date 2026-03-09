import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salemtek/ui/components/custom_navigation_bar.dart';
import 'package:salemtek/ui/pages/main/cabinet/cabinet.dart';
import 'package:salemtek/ui/pages/main/home/components/calendar/bloc/calendar_load_cubit.dart';
import 'package:salemtek/ui/pages/main/settings/settings.dart';
import 'package:salemtek/ui/pages/main/statistics/statistics.dart';
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

  void onDestinationSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarDayCubit(),
      child: Scaffold(
        body: SafeArea(child: pages[currentIndex]),
        bottomNavigationBar: CustomNavigationBar(currentIndex: currentIndex, onDestinationSelected: onDestinationSelected)
      ),
    );
  }
}
