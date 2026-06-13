import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/medicine_statistic.dart';
import '../../../domain/entities/medicine_type.dart';
import 'statistics_chart_data.dart';

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
  final List<MedicineStatistic> filteredStatistics;
  final MedicineType? selectedMedicineType;
  final StatisticsTimeFilterType timeFilterType;
  final DateTime selectedDate;

  final int completedCount;
  final int skippedCount;
  final double completionRate;

  final int streak;
  final double consistency;

  final StatChartData chartData;
  final List<AchievementProgress> achievements;

  final String? errorMessage;

  const StatisticsState({
    required this.status,
    required this.statistics,
    required this.filteredStatistics,
    required this.selectedMedicineType,
    required this.timeFilterType,
    required this.selectedDate,
    required this.completedCount,
    required this.skippedCount,
    required this.completionRate,
    required this.streak,
    required this.consistency,
    required this.chartData,
    required this.achievements,
    this.errorMessage,
  });

  /// True when there are no recorded statistics at all.
  bool get hasNoData => statistics.isEmpty;

  /// True when statistics exist but none match the active filters.
  bool get hasNoDataForFilter =>
      statistics.isNotEmpty && filteredStatistics.isEmpty;

  factory StatisticsState.initial() {
    final now = DateTime.now();

    return StatisticsState(
      status: StatisticsStatus.initial,
      statistics: const [],
      filteredStatistics: const [],
      selectedMedicineType: null,
      timeFilterType: StatisticsTimeFilterType.month,
      selectedDate: DateTime(now.year, now.month),
      completedCount: 0,
      skippedCount: 0,
      completionRate: 0,
      streak: 0,
      consistency: 0,
      chartData: StatChartData.empty(),
      achievements: const [],
      errorMessage: null,
    );
  }

  StatisticsState copyWith({
    StatisticsStatus? status,
    List<MedicineStatistic>? statistics,
    List<MedicineStatistic>? filteredStatistics,
    MedicineType? selectedMedicineType,
    StatisticsTimeFilterType? timeFilterType,
    DateTime? selectedDate,
    int? completedCount,
    int? skippedCount,
    double? completionRate,
    int? streak,
    double? consistency,
    StatChartData? chartData,
    List<AchievementProgress>? achievements,
    String? errorMessage,
    bool clearMedicineTypeFilter = false,
    bool clearError = false,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      statistics: statistics ?? this.statistics,
      filteredStatistics: filteredStatistics ?? this.filteredStatistics,
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
      chartData: chartData ?? this.chartData,
      achievements: achievements ?? this.achievements,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
