import '../../../domain/entities/medicine_statistic.dart';

enum StatisticsStatus {
  initial,
  loading,
  success,
  error,
}

enum StatisticsTimeFilterType {
  month,
  year,
  lifetime,
}

class StatisticsState {
  final StatisticsStatus status;
  final List<MedicineStatistic> statistics;
  final String? selectedMedicineId;
  final StatisticsTimeFilterType timeFilterType;
  final DateTime selectedDate;
  final int completedCount;
  final int skippedCount;
  final double completionRate;
  final String? errorMessage;

  const StatisticsState({
    required this.status,
    required this.statistics,
    required this.selectedMedicineId,
    required this.timeFilterType,
    required this.selectedDate,
    required this.completedCount,
    required this.skippedCount,
    required this.completionRate,
    this.errorMessage,
  });

  factory StatisticsState.initial() {
    final now = DateTime.now();

    return StatisticsState(
      status: StatisticsStatus.initial,
      statistics: const [],
      selectedMedicineId: null,
      timeFilterType: StatisticsTimeFilterType.month,
      selectedDate: DateTime(now.year, now.month),
      completedCount: 0,
      skippedCount: 0,
      completionRate: 0,
      errorMessage: null,
    );
  }

  StatisticsState copyWith({
    StatisticsStatus? status,
    List<MedicineStatistic>? statistics,
    String? selectedMedicineId,
    StatisticsTimeFilterType? timeFilterType,
    DateTime? selectedDate,
    int? completedCount,
    int? skippedCount,
    double? completionRate,
    String? errorMessage,
    bool clearMedicineFilter = false,
    bool clearError = false,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      statistics: statistics ?? this.statistics,
      selectedMedicineId: clearMedicineFilter
          ? null
          : selectedMedicineId ?? this.selectedMedicineId,
      timeFilterType: timeFilterType ?? this.timeFilterType,
      selectedDate: selectedDate ?? this.selectedDate,
      completedCount: completedCount ?? this.completedCount,
      skippedCount: skippedCount ?? this.skippedCount,
      completionRate: completionRate ?? this.completionRate,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}