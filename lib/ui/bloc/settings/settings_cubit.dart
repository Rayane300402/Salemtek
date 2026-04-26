import 'package:bloc/bloc.dart';
import '../../../domain/repo/medicine_repository.dart';
import '../../../domain/usecases/settings_usecases.dart';
import '../medicine/medicine_cubit.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsUseCases settingsUseCases;
  final MedicineRepository medicineRepo;
  final MedicineCubit medicineCubit;

  SettingsCubit({
    required this.settingsUseCases,
    required this.medicineRepo,
    required this.medicineCubit,
  }) : super(SettingsState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading, clearError: true));
    try {
      final settings = await settingsUseCases.get();
      emit(state.copyWith(
        status: SettingsStatus.success,
        settings: settings,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void goToRoot() {
    emit(state.copyWith(section: SettingsViewSection.root));
  }

  void goToData() {
    emit(state.copyWith(section: SettingsViewSection.data));
  }

  void goToNotification() {
    emit(state.copyWith(section: SettingsViewSection.notification));
  }

  Future<void> toggleNotifications(bool value) async {
    final updated = state.settings.copyWith(
      notificationsEnabled: value,
    );
    final saved = await settingsUseCases.update(updated);
    emit(state.copyWith(settings: saved));
  }

  Future<void> toggleExcessiveReminders(bool value) async {
    final updated = state.settings.copyWith(
      excessiveRemindersEnabled: value,
    );
    final saved = await settingsUseCases.update(updated);
    emit(state.copyWith(settings: saved));
  }

  Future<void> updateExcessiveReminderMinutes(int value) async {
    final updated = state.settings.copyWith(
      excessiveReminderMinutes: value,
    );
    final saved = await settingsUseCases.update(updated);
    emit(state.copyWith(settings: saved));
  }

  Future<void> restoreData() async {
    await medicineRepo.restoreAllMedicines();
    await medicineCubit.load();
  }

  Future<void> hardReset() async {
    await medicineRepo.hardDeleteAllMedicines();
    await settingsUseCases.reset();
    await medicineCubit.load();

    final resetSettings = await settingsUseCases.get();
    emit(state.copyWith(
      settings: resetSettings,
      section: SettingsViewSection.root,
    ));
  }
}