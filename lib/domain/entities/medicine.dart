import 'package:salemtek/domain/entities/reminder.dart';

class Medicine {
  final String id;
  final String imagePath;
  final String title;
  final String dosage;
  final String? reason;
  final int reminderEvery;
  final ReminderUnit reminderUnit;

  final DateTime startDate;
  final DateTime? endDate;
  final DateTime dateCreated;
  final DateTime? dateDeleted;
  final DateTime dateModified;

  const Medicine({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.dosage,
    this.reason,
    required this.reminderEvery,
    required this.reminderUnit,
    required this.startDate,
    this.endDate,
    required this.dateCreated,
    this.dateDeleted,
    required this.dateModified,
  });

  bool get isDeleted => dateDeleted != null;

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  bool isDueOn(DateTime date) {
    final target = _dateOnly(date);
    final start = _dateOnly(startDate);
    final end = endDate == null ? null : _dateOnly(endDate!);

    if (target.isBefore(start)) return false;
    if (end != null && target.isAfter(end)) return false;

    switch (reminderUnit) {
      case ReminderUnit.day:
        final diffInDays = target.difference(start).inDays;
        return diffInDays % reminderEvery == 0;

      case ReminderUnit.week:
        final diffInDays = target.difference(start).inDays;

        if (diffInDays < 0) return false;

        final weekIndex = diffInDays ~/ 7;
        final isSameWeekday = target.weekday == start.weekday;
        return isSameWeekday && weekIndex % reminderEvery == 0;

      case ReminderUnit.month:
        final monthDiff =
            (target.year - start.year) * 12 + (target.month - start.month);

        if (monthDiff < 0 || monthDiff % reminderEvery != 0) return false;
        return target.day == start.day;

      case ReminderUnit.year:
        final yearDiff = target.year - start.year;

        if (yearDiff < 0 || yearDiff % reminderEvery != 0) return false;
        return target.month == start.month && target.day == start.day;
    }
  }
}