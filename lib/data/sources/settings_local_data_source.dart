import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel> getSettings();
  Future<SettingsModel> updateSettings(SettingsModel settings);
  Future<SettingsModel> resetSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsModel _settings = const SettingsModel(
    notificationsEnabled: true,
    excessiveRemindersEnabled: false,
    excessiveReminderMinutes: 10,
  );

  @override
  Future<SettingsModel> getSettings() async {
    return _settings;
  }

  @override
  Future<SettingsModel> updateSettings(SettingsModel settings) async {
    _settings = settings;
    return _settings;
  }

  @override
  Future<SettingsModel> resetSettings() async {
    _settings = const SettingsModel(
      notificationsEnabled: true,
      excessiveRemindersEnabled: false,
      excessiveReminderMinutes: 10,
    );
    return _settings;
  }
}