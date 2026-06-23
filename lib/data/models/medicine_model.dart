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

  factory MedicineModel.fromMap(Map<String, Object?> map) {
    return MedicineModel(
      id: map['id'] as String,
      type: MedicineType.values.byName(map['type'] as String),
      title: map['title'] as String,
      dosageAmount: map['dosageAmount'] as int,
      dosageSingular: map['dosageSingular'] as String,
      dosagePlural: map['dosagePlural'] as String,
      reason: map['reason'] as String?,
      hasNotification: (map['hasNotification'] as int) == 1,
      reminderEvery: map['reminderEvery'] as int,
      reminderUnit: ReminderUnit.values.byName(map['reminderUnit'] as String),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: map['endDate'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      dateCreated: DateTime.fromMillisecondsSinceEpoch(
        map['dateCreated'] as int,
      ),
      dateDeleted: map['dateDeleted'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['dateDeleted'] as int),
      dateModified: DateTime.fromMillisecondsSinceEpoch(
        map['dateModified'] as int,
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'dosageAmount': dosageAmount,
      'dosageSingular': dosageSingular,
      'dosagePlural': dosagePlural,
      'reason': reason,
      'hasNotification': hasNotification ? 1 : 0,
      'reminderEvery': reminderEvery,
      'reminderUnit': reminderUnit.name,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'dateDeleted': dateDeleted?.millisecondsSinceEpoch,
      'dateModified': dateModified.millisecondsSinceEpoch,
    };
  }
}