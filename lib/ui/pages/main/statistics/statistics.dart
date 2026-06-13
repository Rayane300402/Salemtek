import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/theme/palette.dart';
import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../bloc/medicine/medicine_state.dart';
import '../../../bloc/statistics/statistics_cubit.dart';
import '../../../bloc/statistics/statistics_state.dart';
import '../../../components/empty_state.dart';
import 'components/achievements_section.dart';
import 'components/progress_chart.dart';
import 'components/progress_section.dart';
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
                    return BlocBuilder<MedicineCubit, MedicineState>(
                      builder: (context, medicineState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.hasNoData)
                              const EmptyState(
                                title: 'No statistics yet',
                                message:
                                    'Complete or skip a medicine on the home '
                                    'page to start tracking your progress.',
                              )
                            else ...[
                              Row(
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
                                      value:
                                          '${state.consistency.toStringAsFixed(0)}%',
                                      label: 'Consistency',
                                      color: Palette.primary,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 35),

                              ProgressSection(
                                percentage: state.consistency,
                                medicines: medicineState.medicines,
                              ),

                              const SizedBox(height: 28),

                              ProgressChart(
                                data: state.chartData,
                                medicines: medicineState.medicines,
                                timeFilterType: state.timeFilterType,
                              ),
                            ],

                            const SizedBox(height: 40),

                            AchievementsSection(
                              achievements: state.achievements,
                            ),
                          ],
                        );
                      },
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
