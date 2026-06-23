import 'dart:math';

import 'package:bloc/bloc.dart';

import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/medicine_statistic.dart';
import '../../../domain/entities/medicine_type.dart';
import '../../../domain/entities/statistic_action_type.dart';
import '../../../domain/usecases/statistics_usecases.dart';
import 'statistics_chart_data.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsUseCases useCases;

  StatisticsCubit(this.useCases) : super(StatisticsState.initial());

  static const _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  Future<void> load() async {
    emit(
      state.copyWith(
        status: StatisticsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final statistics = await useCases.getAll();

      final computed = _computeState(
        statistics: statistics,
        selectedMedicineType: state.selectedMedicineType,
        timeFilterType: state.timeFilterType,
        selectedDate: state.selectedDate,
      );

      emit(computed.copyWith(status: StatisticsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: StatisticsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void changeMedicineTypeFilter(MedicineType? type) {
    final computed = _computeState(
      statistics: state.statistics,
      selectedMedicineType: type,
      timeFilterType: state.timeFilterType,
      selectedDate: state.selectedDate,
    );

    emit(
      computed.copyWith(
        status: StatisticsStatus.success,
        clearMedicineTypeFilter: type == null,
      ),
    );
  }

  void changeTimeFilter({
    required StatisticsTimeFilterType type,
    required DateTime date,
  }) {
    final normalizedDate = DateTime(date.year, date.month);

    final computed = _computeState(
      statistics: state.statistics,
      selectedMedicineType: state.selectedMedicineType,
      timeFilterType: type,
      selectedDate: normalizedDate,
    );

    emit(computed.copyWith(status: StatisticsStatus.success));
  }

  Future<void> refresh() async {
    await load();
  }

  Future<void> record({
    required String medicineId,
    required MedicineType medicineType,
    required int dosageAmount,
    required StatisticActionType actionType,
    required DateTime date,
  }) async {
    final actionDate = DateTime(date.year, date.month, date.day);

    final statistic = MedicineStatistic(
      id: '${medicineId}_${actionType.name}_'
          '${actionDate.year}-${actionDate.month}-${actionDate.day}',
      medicineId: medicineId,
      medicineType: medicineType,
      dosageAmount: dosageAmount,
      actionType: actionType,
      actionDate: actionDate,
      dateCreated: DateTime.now(),
    );

    await useCases.add(statistic);
    await load();
  }

  StatisticsState _computeState({
    required List<MedicineStatistic> statistics,
    required MedicineType? selectedMedicineType,
    required StatisticsTimeFilterType timeFilterType,
    required DateTime selectedDate,
  }) {
    final filtered = _applyFilters(
      statistics: statistics,
      selectedMedicineType: selectedMedicineType,
      timeFilterType: timeFilterType,
      selectedDate: selectedDate,
    );

    final completedCount = filtered
        .where((s) => s.actionType == StatisticActionType.completed)
        .length;

    final skippedCount = filtered
        .where((s) => s.actionType == StatisticActionType.skipped)
        .length;

    final total = completedCount + skippedCount;

    final completionRate = total == 0 ? 0.0 : completedCount / total * 100;

    final streak = _calculateStreak(filtered);

    final consistency = completionRate;

    final chartData = _computeChartData(
      filtered: filtered,
      timeFilterType: timeFilterType,
      selectedDate: selectedDate,
    );

    final achievements = _computeAchievements(statistics);

    final handledKeys = <String>{
      for (final s in statistics)
        StatisticsState.handledKey(s.medicineId, s.actionDate),
    };

    return StatisticsState(
      status: StatisticsStatus.success,
      statistics: statistics,
      filteredStatistics: filtered,
      selectedMedicineType: selectedMedicineType,
      timeFilterType: timeFilterType,
      selectedDate: selectedDate,
      completedCount: completedCount,
      skippedCount: skippedCount,
      completionRate: completionRate,
      streak: streak,
      consistency: consistency,
      chartData: chartData,
      achievements: achievements,
      handledKeys: handledKeys,
    );
  }

  List<MedicineStatistic> _applyFilters({
    required List<MedicineStatistic> statistics,
    required MedicineType? selectedMedicineType,
    required StatisticsTimeFilterType timeFilterType,
    required DateTime selectedDate,
  }) {
    return statistics.where((statistic) {
      if (selectedMedicineType != null &&
          statistic.medicineType != selectedMedicineType) {
        return false;
      }

      final actionDate = statistic.actionDate;

      switch (timeFilterType) {
        case StatisticsTimeFilterType.month:
          return actionDate.year == selectedDate.year &&
              actionDate.month == selectedDate.month;

        case StatisticsTimeFilterType.year:
          return actionDate.year == selectedDate.year;

        case StatisticsTimeFilterType.lifetime:
          return true;
      }
    }).toList();
  }

  int _calculateStreak(List<MedicineStatistic> statistics) {
    final completedDates = statistics
        .where((s) => s.actionType == StatisticActionType.completed)
        .map(
          (s) => DateTime(
            s.actionDate.year,
            s.actionDate.month,
            s.actionDate.day,
          ),
        )
        .toSet();

    if (completedDates.isEmpty) return 0;

    final today = DateTime.now();
    var current = DateTime(today.year, today.month, today.day);

    var streak = 0;

    while (completedDates.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }

  StatChartData _computeChartData({
    required List<MedicineStatistic> filtered,
    required StatisticsTimeFilterType timeFilterType,
    required DateTime selectedDate,
  }) {
    final completed = filtered
        .where((s) => s.actionType == StatisticActionType.completed)
        .toList();

    if (completed.isEmpty) return StatChartData.empty();

    final int bucketCount;
    final List<String> labels;
    final int Function(DateTime) bucketOf;

    switch (timeFilterType) {
      case StatisticsTimeFilterType.month:
        final days =
            DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
        bucketCount = days;
        labels = List.generate(days, (i) => '${i + 1}');
        bucketOf = (d) => d.day - 1;

      case StatisticsTimeFilterType.year:
        bucketCount = 12;
        labels = List.of(_monthAbbr);
        bucketOf = (d) => d.month - 1;

      case StatisticsTimeFilterType.lifetime:
        final years = completed.map((s) => s.actionDate.year);
        final minYear = years.reduce(min);
        final maxYear = years.reduce(max);
        bucketCount = maxYear - minYear + 1;
        labels = List.generate(bucketCount, (i) => '${minYear + i}');
        bucketOf = (d) => d.year - minYear;
    }

    final valuesByMedicine = <String, List<double>>{};
    final typeByMedicine = <String, MedicineType>{};

    for (final s in completed) {
      final values = valuesByMedicine.putIfAbsent(
        s.medicineId,
        () => List<double>.filled(bucketCount, 0),
      );
      typeByMedicine[s.medicineId] = s.medicineType;

      final index = bucketOf(s.actionDate);
      if (index >= 0 && index < bucketCount) {
        values[index] += 1;
      }
    }

    var rawMax = 0.0;
    final series = <StatChartSeries>[];

    valuesByMedicine.forEach((medicineId, values) {
      for (final v in values) {
        if (v > rawMax) rawMax = v;
      }
      series.add(
        StatChartSeries(
          medicineId: medicineId,
          medicineType: typeByMedicine[medicineId]!,
          values: values,
        ),
      );
    });

    final maxY = rawMax <= 5 ? 5.0 : (rawMax / 5).ceil() * 5.0;

    return StatChartData(xLabels: labels, series: series, maxY: maxY);
  }

  List<AchievementProgress> _computeAchievements(
    List<MedicineStatistic> statistics,
  ) {
    final completedByType = <MedicineType, int>{};
    var completedTotal = 0;

    for (final s in statistics) {
      if (s.actionType == StatisticActionType.completed) {
        completedTotal++;
        completedByType[s.medicineType] =
            (completedByType[s.medicineType] ?? 0) + 1;
      }
    }

    final distinctTypes = completedByType.length;

    return Achievement.catalog.map((achievement) {
      final value = switch (achievement.rule) {
        AchievementRule.typeDoses => achievement.type == null
            ? completedTotal
            : completedByType[achievement.type] ?? 0,
        AchievementRule.medicineVariety => distinctTypes,
      };

      return AchievementProgress(achievement: achievement, value: value);
    }).toList();
  }
}
