import 'package:sqflite/sqflite.dart';

import '../local/database_schema.dart';
import '../models/medicine_model.dart';

abstract class MedicineLocalDataSource {
  Future<List<MedicineModel>> getAllMedicines({bool includeDeleted = false});
  Future<MedicineModel> addMedicine(MedicineModel medicine);
  Future<MedicineModel> updateMedicine(MedicineModel medicine);
  Future<void> deleteMedicine(String id, {bool softDelete = true});
  Future<void> restoreMedicine(String id);
  Future<void> restoreAllMedicines();
  Future<void> hardDeleteAllMedicines();
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final Database db;

  MedicineLocalDataSourceImpl(this.db);

  @override
  Future<List<MedicineModel>> getAllMedicines({
    bool includeDeleted = false,
  }) async {
    final rows = await db.query(
      DbTables.medicines,
      where: includeDeleted ? null : 'dateDeleted IS NULL',
      orderBy: 'dateCreated DESC',
    );
    return rows.map(MedicineModel.fromMap).toList();
  }

  @override
  Future<MedicineModel> addMedicine(MedicineModel medicine) async {
    await db.insert(
      DbTables.medicines,
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return medicine;
  }

  @override
  Future<MedicineModel> updateMedicine(MedicineModel medicine) async {
    final count = await db.update(
      DbTables.medicines,
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
    if (count == 0) {
      throw Exception('Medicine not found');
    }
    return medicine;
  }

  @override
  Future<void> deleteMedicine(String id, {bool softDelete = true}) async {
    if (softDelete) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.update(
        DbTables.medicines,
        {'dateDeleted': now, 'dateModified': now},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      await db.delete(DbTables.medicines, where: 'id = ?', whereArgs: [id]);
    }
  }

  @override
  Future<void> restoreMedicine(String id) async {
    await db.update(
      DbTables.medicines,
      {
        'dateDeleted': null,
        'dateModified': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> restoreAllMedicines() async {
    await db.update(
      DbTables.medicines,
      {
        'dateDeleted': null,
        'dateModified': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'dateDeleted IS NOT NULL',
    );
  }

  @override
  Future<void> hardDeleteAllMedicines() async {
    await db.delete(DbTables.medicines);
  }
}
