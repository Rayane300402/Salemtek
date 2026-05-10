import '../../domain/entities/medicine.dart';
import '../../domain/entities/medicine_type.dart';
import '../../domain/entities/reminder.dart';

class MedicineModel {
  final String id;
  final MedicineType type;
  final String title;

  final int dosageAmount;
  final String dosageSingular;
  final String dosagePlural;

  final String? reason;

  final bool hasNotification;
  final int reminderEvery;
  final ReminderUnit reminderUnit;

  final DateTime startDate;
  final DateTime? endDate;
  final DateTime dateCreated;
  final DateTime? dateDeleted;
  final DateTime dateModified;

  const MedicineModel({
    required this.id,
    required this.type,
    required this.title,
    required this.dosageAmount,
    required this.dosageSingular,
    required this.dosagePlural,
    this.reason,
    required this.hasNotification,
    required this.reminderEvery,
    required this.reminderUnit,
    required this.startDate,
    this.endDate,
    required this.dateCreated,
    this.dateDeleted,
    required this.dateModified,
  });

  Medicine toEntity() {
    return Medicine(
      id: id,
      type: type,
      title: title,
      dosageAmount: dosageAmount,
      dosageSingular: dosageSingular,
      dosagePlural: dosagePlural,
      reason: reason,
      hasNotification: hasNotification,
      reminderEvery: reminderEvery,
      reminderUnit: reminderUnit,
      startDate: startDate,
      endDate: endDate,
      dateCreated: dateCreated,
      dateDeleted: dateDeleted,
      dateModified: dateModified,
    );
  }

  factory MedicineModel.fromEntity(Medicine medicine) {
    return MedicineModel(
      id: medicine.id,
      type: medicine.type,
      title: medicine.title,
      dosageAmount: medicine.dosageAmount,
      dosageSingular: medicine.dosageSingular,
      dosagePlural: medicine.dosagePlural,
      reason: medicine.reason,
      hasNotification: medicine.hasNotification,
      reminderEvery: medicine.reminderEvery,
      reminderUnit: medicine.reminderUnit,
      startDate: medicine.startDate,
      endDate: medicine.endDate,
      dateCreated: medicine.dateCreated,
      dateDeleted: medicine.dateDeleted,
      dateModified: medicine.dateModified,
    );
  }

  MedicineModel copyWith({
    String? id,
    MedicineType? type,
    String? title,
    int? dosageAmount,
    String? dosageSingular,
    String? dosagePlural,
    String? reason,
    bool? hasNotification,
    int? reminderEvery,
    ReminderUnit? reminderUnit,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? dateCreated,
    DateTime? dateDeleted,
    DateTime? dateModified,
    bool clearReason = false,
    bool clearEndDate = false,
    bool clearDateDeleted = false,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      dosageAmount: dosageAmount ?? this.dosageAmount,
      dosageSingular: dosageSingular ?? this.dosageSingular,
      dosagePlural: dosagePlural ?? this.dosagePlural,
      reason: clearReason ? null : (reason ?? this.reason),
      hasNotification: hasNotification ?? this.hasNotification,
      reminderEvery: reminderEvery ?? this.reminderEvery,
      reminderUnit: reminderUnit ?? this.reminderUnit,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      dateCreated: dateCreated ?? this.dateCreated,
      dateDeleted: clearDateDeleted ? null : (dateDeleted ?? this.dateDeleted),
      dateModified: dateModified ?? this.dateModified,
    );
  }

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] as String,
      type: MedicineType.values.byName(json['type'] as String),
      title: json['title'] as String,
      dosageAmount: json['dosageAmount'] as int,
      dosageSingular: json['dosageSingular'] as String,
      dosagePlural: json['dosagePlural'] as String,
      reason: json['reason'] as String?,
      hasNotification: json['hasNotification'] as bool,
      reminderEvery: json['reminderEvery'] as int,
      reminderUnit: ReminderUnit.values.byName(json['reminderUnit'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateDeleted: json['dateDeleted'] != null
          ? DateTime.parse(json['dateDeleted'] as String)
          : null,
      dateModified: DateTime.parse(json['dateModified'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'dosageAmount': dosageAmount,
      'dosageSingular': dosageSingular,
      'dosagePlural': dosagePlural,
      'reason': reason,
      'hasNotification': hasNotification,
      'reminderEvery': reminderEvery,
      'reminderUnit': reminderUnit.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateDeleted': dateDeleted?.toIso8601String(),
      'dateModified': dateModified.toIso8601String(),
    };
  }
}