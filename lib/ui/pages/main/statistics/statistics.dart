import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/theme/palette.dart';
import '../../../bloc/statistics/statistics_cubit.dart';
import '../../../bloc/statistics/statistics_state.dart';
import 'components/statistics_header.dart';
import 'components/summary_card.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StatisticsHeader(),

        const SizedBox(height: 20),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Palette.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 30,
                  right: 30,
                  bottom: 40,
                ),
                child: BlocBuilder<StatisticsCubit, StatisticsState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            value: '${state.streak}',
                            label: 'Streak',
                            color: Palette.navIcon,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SummaryCard(
                            value: '${state.consistency.toStringAsFixed(0)}%',
                            label: 'Consistency',
                            color: Palette.primary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}