class DbTables {
  static const medicines = 'medicines';
  static const statistics = 'statistics';
  static const settings = 'settings';
}

const settingsRowId = 0;

const _createMedicines = '''
CREATE TABLE ${DbTables.medicines} (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  dosageAmount INTEGER NOT NULL,
  dosageSingular TEXT NOT NULL,
  dosagePlural TEXT NOT NULL,
  reason TEXT,
  hasNotification INTEGER NOT NULL,
  reminderEvery INTEGER NOT NULL,
  reminderUnit TEXT NOT NULL,
  startDate INTEGER NOT NULL,
  endDate INTEGER,
  dateCreated INTEGER NOT NULL,
  dateDeleted INTEGER,
  dateModified INTEGER NOT NULL
);
''';

const _createStatistics = '''
CREATE TABLE ${DbTables.statistics} (
  id TEXT PRIMARY KEY,
  medicineId TEXT NOT NULL,
  medicineType TEXT NOT NULL,
  dosageAmount INTEGER NOT NULL,
  actionType TEXT NOT NULL,
  actionDate INTEGER NOT NULL,
  dateCreated INTEGER NOT NULL
);
''';

const _createSettings = '''
CREATE TABLE ${DbTables.settings} (
  id INTEGER PRIMARY KEY,
  notificationsEnabled INTEGER NOT NULL,
  excessiveRemindersEnabled INTEGER NOT NULL,
  excessiveReminderMinutes INTEGER NOT NULL
);
''';

const _createIndexes = [
  'CREATE INDEX idx_medicines_dateDeleted ON ${DbTables.medicines} (dateDeleted);',
  'CREATE INDEX idx_statistics_actionDate ON ${DbTables.statistics} (actionDate);',
  'CREATE INDEX idx_statistics_medicineId ON ${DbTables.statistics} (medicineId);',
];

const createSchemaStatements = [
  _createMedicines,
  _createStatistics,
  _createSettings,
  ..._createIndexes,
];
