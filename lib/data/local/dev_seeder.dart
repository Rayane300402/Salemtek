import 'package:sqflite/sqflite.dart';

import '../../domain/entities/medicine_type.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/statistic_action_type.dart';
import '../models/medicine_model.dart';
import '../models/medicine_statistic_model.dart';
import 'database_schema.dart';

class DevSeeder {
  static Future<void> seed(Database db) async {
    final batch = db.batch();

    for (final medicine in _medicines()) {
      batch.insert(
        DbTables.medicines,
        medicine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (final statistic in _statistics()) {
      batch.insert(
        DbTables.statistics,
        statistic.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  static List<MedicineModel> _medicines() {
    final now = DateTime.now();

    return [
      MedicineModel(
        id: '1',
        type: MedicineType.capsule,
        title: 'Benzonatate',
        dosageAmount: 1,
        dosageSingular: 'capsule',
        dosagePlural: 'capsules',
        reason: 'Cough',
        hasNotification: true,
        reminderEvery: 1,
        reminderUnit: ReminderUnit.day,
        startDate: DateTime(2026, 4, 19),
        endDate: DateTime(2026, 5, 19),
        dateCreated: now,
        dateModified: now,
      ),
      MedicineModel(
        id: '2',
        type: MedicineType.pill,
        title: 'Loratadine',
        dosageAmount: 2,
        dosageSingular: 'pill',
        dosagePlural: 'pills',
        reason: 'Allergy',
        hasNotification: true,
        reminderEvery: 4,
        reminderUnit: ReminderUnit.day,
        startDate: DateTime(2026, 4, 19),
        dateCreated: now,
        dateModified: now,
      ),
      MedicineModel(
        id: '3',
        type: MedicineType.injection,
        title: 'Liraglutide',
        dosageAmount: 1,
        dosageSingular: 'injection',
        dosagePlural: 'injections',
        hasNotification: true,
        reminderEvery: 4,
        reminderUnit: ReminderUnit.month,
        startDate: DateTime(2026, 4, 20),
        dateCreated: now,
        dateModified: now,
      ),
    ];
  }

  static List<MedicineStatisticModel> _statistics() {
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
          id: _id(medicineId, action, normalized),
          medicineId: medicineId,
          medicineType: type,
          dosageAmount: dose,
          actionType: action,
          actionDate: normalized,
          dateCreated: normalized,
        ),
      );
    }

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

  static String _id(
    String medicineId,
    StatisticActionType action,
    DateTime date,
  ) {
    return '${medicineId}_${action.name}_${date.year}-${date.month}-${date.day}';
  }
}
