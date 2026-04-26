import '../../domain/entities/settings.dart';

class SettingsModel {
  final bool notificationsEnabled;
  final bool excessiveRemindersEnabled;
  final int excessiveReminderMinutes;

  const SettingsModel({
    required this.notificationsEnabled,
    required this.excessiveRemindersEnabled,
    required this.excessiveReminderMinutes,
  });

  AppSettings toEntity() {
    return AppSettings(
      notificationsEnabled: notificationsEnabled,
      excessiveRemindersEnabled: excessiveRemindersEnabled,
      excessiveReminderMinutes: excessiveReminderMinutes,
    );
  }

  factory SettingsModel.fromEntity(AppSettings settings) {
    return SettingsModel(
      notificationsEnabled: settings.notificationsEnabled,
      excessiveRemindersEnabled: settings.excessiveRemindersEnabled,
      excessiveReminderMinutes: settings.excessiveReminderMinutes,
    );
  }

  SettingsModel copyWith({
    bool? notificationsEnabled,
    bool? excessiveRemindersEnabled,
    int? excessiveReminderMinutes,
  }) {
    return SettingsModel(
      notificationsEnabled:
      notificationsEnabled ?? this.notificationsEnabled,
      excessiveRemindersEnabled:
      excessiveRemindersEnabled ?? this.excessiveRemindersEnabled,
      excessiveReminderMinutes:
      excessiveReminderMinutes ?? this.excessiveReminderMinutes,
    );
  }
}