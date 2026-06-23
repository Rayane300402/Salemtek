import 'package:sqflite/sqflite.dart';

import '../local/database_schema.dart';
import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<SettingsModel> updateSettings(SettingsModel settings);
  Future<SettingsModel> resetSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final Database db;

  SettingsLocalDataSourceImpl(this.db);

  static const _defaults = SettingsModel(
    notificationsEnabled: true,
    excessiveRemindersEnabled: false,
    excessiveReminderMinutes: 10,
  );

  Future<SettingsModel> _save(SettingsModel settings) async {
    await db.insert(
      DbTables.settings,
      {...settings.toMap(), 'id': settingsRowId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return settings;
  }

  @override
  Future<SettingsModel> getSettings() async {
    final rows = await db.query(
      DbTables.settings,
      where: 'id = ?',
      whereArgs: [settingsRowId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return _save(_defaults);
    }
    return SettingsModel.fromMap(rows.first);
  }

  @override
  Future<SettingsModel> updateSettings(SettingsModel settings) {
    return _save(settings);
  }

  @override
  Future<SettingsModel> resetSettings() {
    return _save(_defaults);
  }
}
