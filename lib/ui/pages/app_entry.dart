import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salemtek/ui/pages/introduction/bloc/introduction_cubit.dart';
import 'package:salemtek/ui/pages/introduction/introductions.dart';
import 'package:salemtek/ui/pages/main/main.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final introCompleted = context.watch<IntroductionCubit>().state;

    if (introCompleted) {
      return const Main();
    }

    return const IntroPage();
  }
}