import '../entities/settings.dart';
import '../repo/settings_repository.dart';

class SettingsUseCases {
  final SettingsRepo repo;

  SettingsUseCases(this.repo);

  Future<AppSettings> get() => repo.getSettings();

  Future<AppSettings> update(AppSettings settings) {
    return repo.updateSettings(settings);
  }

  Future<AppSettings> reset() => repo.resetSettings();
}