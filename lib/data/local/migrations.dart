import 'package:sqflite/sqflite.dart';

const Map<int, List<String>> kMigrations = {};

Future<void> runMigrations(Database db, int oldVersion, int newVersion) async {
  for (var version = oldVersion + 1; version <= newVersion; version++) {
    final steps = kMigrations[version];
    if (steps == null) continue;

    final batch = db.batch();
    for (final statement in steps) {
      batch.execute(statement);
    }
    await batch.commit(noResult: true);
  }
}
