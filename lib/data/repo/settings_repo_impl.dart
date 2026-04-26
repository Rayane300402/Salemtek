import '../../domain/entities/settings.dart';
import '../../domain/repo/settings_repository.dart';
import '../models/settings_model.dart';
import '../sources/settings_local_data_source.dart';

class SettingsRepoImpl implements SettingsRepo {
  final SettingsLocalDataSource localDataSource;

  SettingsRepoImpl(this.localDataSource);

  @override
  Future<AppSettings> getSettings() async {
    final model = await localDataSource.getSettings();
    return model.toEntity();
  }

  @override
  Future<AppSettings> updateSettings(AppSettings settings) async {
    final model = SettingsModel.fromEntity(settings);
    final updated = await localDataSource.updateSettings(model);
    return updated.toEntity();
  }

  @override
  Future<AppSettings> resetSettings() async {
    final reset = await localDataSource.resetSettings();
    return reset.toEntity();
  }
}