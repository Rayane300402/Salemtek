import 'package:bloc/bloc.dart';

import '../../../domain/entities/medicine_statistic.dart';
import '../../../domain/entities/medicine_type.dart';
import '../../../domain/entities/statistic_action_type.dart';
import '../../../domain/usecases/statistics_usecases.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsUseCases useCases;

  StatisticsCubit(this.useCases) : super(StatisticsState.initial());

  Future<void> load() async {
    emit(state.copyWith(
      status: StatisticsStatus.loading,
      clearError: true,
    ));

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
      emit(state.copyWith(
        status: StatisticsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void changeMedicineTypeFilter(MedicineType? type) {
    final computed = _computeState(
      statistics: state.statistics,
      selectedMedicineType: type,
      timeFilterType: state.timeFilterType,
      selectedDate: state.selectedDate,
    );

    emit(computed.copyWith(
      status: StatisticsStatus.success,
      clearMedicineTypeFilter: type == null,
    ));
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

    return StatisticsState(
      status: StatisticsStatus.success,
      statistics: statistics,
      selectedMedicineType: selectedMedicineType,
      timeFilterType: timeFilterType,
      selectedDate: selectedDate,
      completedCount: completedCount,
      skippedCount: skippedCount,
      completionRate: completionRate,
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
}