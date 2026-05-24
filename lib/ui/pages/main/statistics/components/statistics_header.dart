import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../configs/theme/palette.dart';
import '../../../../../domain/entities/medicine_type.dart';
import '../../../../bloc/statistics/statistics_cubit.dart';
import '../../../../bloc/statistics/statistics_state.dart';

class StatisticsTimeOption {
  final StatisticsTimeFilterType type;
  final DateTime date;
  final String label;

  const StatisticsTimeOption({
    required this.type,
    required this.date,
    required this.label,
  });
}

class StatisticsHeader extends StatelessWidget {
  const StatisticsHeader({super.key});

  String _medicineTypeLabel(StatisticsState state) {
    return state.selectedMedicineType?.label ?? 'All medicine';
  }

  String _timeLabel(StatisticsState state) {
    switch (state.timeFilterType) {
      case StatisticsTimeFilterType.month:
        return DateFormat('MMMM, yyyy').format(state.selectedDate);

      case StatisticsTimeFilterType.year:
        return DateFormat('yyyy').format(state.selectedDate);

      case StatisticsTimeFilterType.lifetime:
        return 'Lifetime';
    }
  }

  List<StatisticsTimeOption> _timeOptions() {
    final now = DateTime.now();
    final options = <StatisticsTimeOption>[];

    if (now.month == 1) {
      options.add(
        StatisticsTimeOption(
          type: StatisticsTimeFilterType.year,
          date: DateTime(now.year),
          label: '${now.year}',
        ),
      );

      options.add(
        StatisticsTimeOption(
          type: StatisticsTimeFilterType.year,
          date: DateTime(now.year - 1),
          label: '${now.year - 1}',
        ),
      );
    } else {
      for (int month = now.month; month >= 1; month--) {
        final date = DateTime(now.year, month);

        options.add(
          StatisticsTimeOption(
            type: StatisticsTimeFilterType.month,
            date: date,
            label: DateFormat('MMMM, yyyy').format(date),
          ),
        );
      }

      options.add(
        StatisticsTimeOption(
          type: StatisticsTimeFilterType.year,
          date: DateTime(now.year),
          label: '${now.year}',
        ),
      );
    }

    options.add(
      StatisticsTimeOption(
        type: StatisticsTimeFilterType.lifetime,
        date: now,
        label: 'Lifetime',
      ),
    );

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        final cubit = context.read<StatisticsCubit>();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PopupMenuButton<MedicineType?>(
                      padding: EdgeInsets.zero,
                      color: Palette.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onSelected: (type) {
                        cubit.changeMedicineTypeFilter(type);
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<MedicineType?>(
                            value: null,
                            child: Text('All medicine'),
                          ),
                          ...MedicineType.values.map(
                                (type) => PopupMenuItem<MedicineType?>(
                              value: type,
                              child: Text(type.label),
                            ),
                          ),
                        ];
                      },
                      child: _HeaderDropdownText(
                        _medicineTypeLabel(state),
                      ),
                    ),

                    const SizedBox(height: 10),

                    PopupMenuButton<StatisticsTimeOption>(
                      padding: EdgeInsets.zero,
                      color: Palette.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onSelected: (option) {
                        cubit.changeTimeFilter(
                          type: option.type,
                          date: option.date,
                        );
                      },
                      itemBuilder: (context) {
                        return _timeOptions()
                            .map(
                              (option) => PopupMenuItem<StatisticsTimeOption>(
                            value: option,
                            child: Text(option.label),
                          ),
                        )
                            .toList();
                      },
                      child: _HeaderDropdownText(
                        _timeLabel(state),
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: cubit.refresh,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 34,
                  color: Palette.text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderDropdownText extends StatelessWidget {
  final String text;

  const _HeaderDropdownText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Palette.text,
              height: 1.05,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 24,
          color: Palette.text,
        ),
      ],
    );
  }
}