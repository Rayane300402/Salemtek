enum NotificationOption {
  none,
  everyDay,
  everyXDays,
  everyWeek,
  everyXWeeks,
  everyMonth,
  everyXMonths,
}

extension NotificationOptionX on NotificationOption {
  String get label {
    switch (this) {
      case NotificationOption.none:
        return 'None';
      case NotificationOption.everyDay:
        return 'Every day';
      case NotificationOption.everyXDays:
        return 'Every X days';
      case NotificationOption.everyWeek:
        return 'Every week';
      case NotificationOption.everyXWeeks:
        return 'Every X weeks';
      case NotificationOption.everyMonth:
        return 'Every month';
      case NotificationOption.everyXMonths:
        return 'Every X months';
    }
  }

  bool get needsCustomValue {
    switch (this) {
      case NotificationOption.everyXDays:
      case NotificationOption.everyXWeeks:
      case NotificationOption.everyXMonths:
        return true;
      default:
        return false;
    }
  }

  String get customUnitLabel {
    switch (this) {
      case NotificationOption.everyXDays:
        return 'days';
      case NotificationOption.everyXWeeks:
        return 'weeks';
      case NotificationOption.everyXMonths:
        return 'months';
      default:
        return '';
    }
  }
}