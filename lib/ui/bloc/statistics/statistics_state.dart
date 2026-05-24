import '../../../domain/entities/medicine_statistic.dart';
import '../../../domain/entities/medicine_type.dart';

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
  final MedicineType? selectedMedicineType;
  final StatisticsTimeFilterType timeFilterType;
  final DateTime selectedDate;

  final int completedCount;
  final int skippedCount;
  final double completionRate;

  final int streak;
  final double consistency;

  final String? errorMessage;

  const StatisticsState({
    required this.status,
    required this.statistics,
    required this.selectedMedicineType,
    required this.timeFilterType,
    required this.selectedDate,
    required this.completedCount,
    required this.skippedCount,
    required this.completionRate,
    required this.streak,
    required this.consistency,
    this.errorMessage,
  });

  factory StatisticsState.initial() {
    final now = DateTime.now();

    return StatisticsState(
      status: StatisticsStatus.initial,
      statistics: const [],
      selectedMedicineType: null,
      timeFilterType: StatisticsTimeFilterType.month,
      selectedDate: DateTime(now.year, now.month),
      completedCount: 0,
      skippedCount: 0,
      completionRate: 0,
      streak: 0,
      consistency: 0,
      errorMessage: null,
    );
  }

  StatisticsState copyWith({
    StatisticsStatus? status,
    List<MedicineStatistic>? statistics,
    MedicineType? selectedMedicineType,
    StatisticsTimeFilterType? timeFilterType,
    DateTime? selectedDate,
    int? completedCount,
    int? skippedCount,
    double? completionRate,
    int? streak,
    double? consistency,
    String? errorMessage,
    bool clearMedicineTypeFilter = false,
    bool clearError = false,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      statistics: statistics ?? this.statistics,
      selectedMedicineType: clearMedicineTypeFilter
          ? null
          : selectedMedicineType ?? this.selectedMedicineType,
      timeFilterType: timeFilterType ?? this.timeFilterType,
      selectedDate: selectedDate ?? this.selectedDate,
      completedCount: completedCount ?? this.completedCount,
      skippedCount: skippedCount ?? this.skippedCount,
      completionRate: completionRate ?? this.completionRate,
      streak: streak ?? this.streak,
      consistency: consistency ?? this.consistency,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}