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
}