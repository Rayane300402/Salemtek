import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/theme.dart';
import 'package:salemtek/ui/pages/introduction/introductions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: IntroPage(),
    );
  }
}

