import '../../domain/entities/medicine_type.dart';
import '../../domain/entities/statistic_action_type.dart';
import '../models/medicine_statistic_model.dart';

abstract class StatisticsLocalDataSource {
  Future<List<MedicineStatisticModel>> getAllStatistics();
  Future<MedicineStatisticModel> addStatistic(
    MedicineStatisticModel statistic,
  );
  Future<void> clearAllStatistics();
}

/// In-memory statistics store that emulates the future SQLite `statistics`
/// table. Seeded with a realistic dummy history so the stats page renders
/// like the design while we are still on dummy data.
class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  final List<MedicineStatisticModel> _statistics = _seed();

  @override
  Future<List<MedicineStatisticModel>> getAllStatistics() async {
    return List<MedicineStatisticModel>.from(_statistics);
  }

  @override
  Future<MedicineStatisticModel> addStatistic(
    MedicineStatisticModel statistic,
  ) async {
    // Idempotent: one record per medicine/date/action (matches the planned
    // unique constraint in SQLite). Re-adding the same key replaces it.
    final index = _statistics.indexWhere((s) => s.id == statistic.id);
    if (index == -1) {
      _statistics.add(statistic);
    } else {
      _statistics[index] = statistic;
    }
    return statistic;
  }

  @override
  Future<void> clearAllStatistics() async {
    _statistics.clear();
  }

  // ---------------------------------------------------------------------------
  // Dummy seed
  // ---------------------------------------------------------------------------

  /// Stable composite id so seeded and live records never duplicate for the
  /// same medicine + date + action.
  static String seedId(
    String medicineId,
    StatisticActionType action,
    DateTime date,
  ) {
    return '${medicineId}_${action.name}_${date.year}-${date.month}-${date.day}';
  }

  static List<MedicineStatisticModel> _seed() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = <MedicineStatisticModel>[];

    void add(
      String medicineId,
      MedicineType type,
      int dose,
      StatisticActionType action,
      DateTime date,
    ) {
      final normalized = DateTime(date.year, date.month, date.day);
      stats.add(
        MedicineStatisticModel(
          id: seedId(medicineId, action, normalized),
          medicineId: medicineId,
          medicineType: type,
          dosageAmount: dose,
          actionType: action,
          actionDate: normalized,
          dateCreated: normalized,
        ),
      );
    }

    // Medicine 1 — Benzonatate (capsule, daily) for the last 95 days.
    // Mostly completed; the most recent 10 days are all completed so the
    // streak reads ~10, then a skip every 8 days before that.
    for (int i = 0; i < 95; i++) {
      final date = today.subtract(Duration(days: i));
      final isSkip = i >= 10 && (i - 10) % 8 == 0;
      add(
        '1',
        MedicineType.capsule,
        1,
        isSkip ? StatisticActionType.skipped : StatisticActionType.completed,
        date,
      );
    }

    // Medicine 2 — Loratadine (pill, every 4 days) for the last ~130 days.
    for (int i = 0; i < 130; i += 4) {
      final date = today.subtract(Duration(days: i));
      final isSkip = i != 0 && i % 16 == 0;
      add(
        '2',
        MedicineType.pill,
        2,
        isSkip ? StatisticActionType.skipped : StatisticActionType.completed,
        date,
      );
    }

    // Medicine 3 — Liraglutide (injection, monthly) for the last 4 months.
    // Anchored to past dates so no dummy dose lands in the future.
    for (int m = 0; m < 4; m++) {
      add(
        '3',
        MedicineType.injection,
        1,
        StatisticActionType.completed,
        today.subtract(Duration(days: 30 * m + 5)),
      );
    }

    return stats;
  }
}
