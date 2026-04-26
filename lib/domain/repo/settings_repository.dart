import '../entities/settings.dart';

abstract class SettingsRepo {
  Future<AppSettings> getSettings();
  Future<AppSettings> updateSettings(AppSettings settings);
  Future<AppSettings> resetSettings();
}