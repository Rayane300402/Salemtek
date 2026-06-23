import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';
import 'migrations.dart';

class AppDatabase {
  static const _fileName = 'salemtek.db';
  static const _version = 1;

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, _fileName);

    return openDatabase(
      path,
      version: _version,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        final batch = db.batch();
        for (final statement in createSchemaStatements) {
          batch.execute(statement);
        }
        await batch.commit(noResult: true);
      },
      onUpgrade: runMigrations,
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
