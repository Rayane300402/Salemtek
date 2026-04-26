import '../../../domain/entities/settings.dart';

enum SettingsViewSection {
  root,
  data,
  notification,
}

enum SettingsStatus {
  initial,
  loading,
  success,
  error,
}

class SettingsState {
  final SettingsStatus status;
  final SettingsViewSection section;
  final AppSettings settings;
  final String? errorMessage;

  const SettingsState({
    required this.status,
    required this.section,
    required this.settings,
    this.errorMessage,
  });

  factory SettingsState.initial() {
    return SettingsState(
      status: SettingsStatus.initial,
      section: SettingsViewSection.root,
      settings: AppSettings.defaults(),
      errorMessage: null,
    );
  }

  SettingsState copyWith({
    SettingsStatus? status,
    SettingsViewSection? section,
    AppSettings? settings,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      section: section ?? this.section,
      settings: settings ?? this.settings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}