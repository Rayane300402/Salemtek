import 'package:sqflite/sqflite.dart';

import '../local/database_schema.dart';
import '../models/medicine_statistic_model.dart';

abstract class StatisticsLocalDataSource {
  Future<List<MedicineStatisticModel>> getAllStatistics();
  Future<MedicineStatisticModel> addStatistic(
    MedicineStatisticModel statistic,
  );
  Future<void> clearAllStatistics();
}

class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  final Database db;

  StatisticsLocalDataSourceImpl(this.db);

  @override
  Future<List<MedicineStatisticModel>> getAllStatistics() async {
    final rows = await db.query(
      DbTables.statistics,
      orderBy: 'actionDate DESC',
    );
    return rows.map(MedicineStatisticModel.fromMap).toList();
  }

  @override
  Future<MedicineStatisticModel> addStatistic(
    MedicineStatisticModel statistic,
  ) async {
    await db.insert(
      DbTables.statistics,
      statistic.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return statistic;
  }

  @override
  Future<void> clearAllStatistics() async {
    await db.delete(DbTables.statistics);
  }
}
