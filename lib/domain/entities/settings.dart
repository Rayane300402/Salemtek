class AppSettings {
  final bool notificationsEnabled;
  final bool excessiveRemindersEnabled;
  final int excessiveReminderMinutes;

  const AppSettings({
    required this.notificationsEnabled,
    required this.excessiveRemindersEnabled,
    required this.excessiveReminderMinutes,
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? excessiveRemindersEnabled,
    int? excessiveReminderMinutes,
  }) {
    return AppSettings(
      notificationsEnabled:
      notificationsEnabled ?? this.notificationsEnabled,
      excessiveRemindersEnabled:
      excessiveRemindersEnabled ?? this.excessiveRemindersEnabled,
      excessiveReminderMinutes:
      excessiveReminderMinutes ?? this.excessiveReminderMinutes,
    );
  }

  factory AppSettings.defaults() {
    return const AppSettings(
      notificationsEnabled: true,
      excessiveRemindersEnabled: false,
      excessiveReminderMinutes: 10,
    );
  }
}