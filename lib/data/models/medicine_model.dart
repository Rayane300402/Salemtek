import '../../domain/entities/medicine.dart';
import '../../domain/entities/reminder.dart';

class MedicineModel {
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

  const MedicineModel({
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

  /// 🔁 Convert Model → Entity
  Medicine toEntity() {
    return Medicine(
      id: id,
      imagePath: imagePath,
      title: title,
      dosage: dosage,
      reason: reason,
      reminderEvery: reminderEvery,
      reminderUnit: reminderUnit,
      startDate: startDate,
      endDate: endDate,
      dateCreated: dateCreated,
      dateDeleted: dateDeleted,
      dateModified: dateModified,
    );
  }

  /// 🔁 Convert Entity → Model
  factory MedicineModel.fromEntity(Medicine medicine) {
    return MedicineModel(
      id: medicine.id,
      imagePath: medicine.imagePath,
      title: medicine.title,
      dosage: medicine.dosage,
      reason: medicine.reason,
      reminderEvery: medicine.reminderEvery,
      reminderUnit: medicine.reminderUnit,
      startDate: medicine.startDate,
      endDate: medicine.endDate,
      dateCreated: medicine.dateCreated,
      dateDeleted: medicine.dateDeleted,
      dateModified: medicine.dateModified,
    );
  }

  /// 🧬 Copy (for updates)
  MedicineModel copyWith({
    String? id,
    String? imagePath,
    String? title,
    String? dosage,
    String? reason,
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
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      dosage: dosage ?? this.dosage,
      reason: clearReason ? null : (reason ?? this.reason),
      reminderEvery: reminderEvery ?? this.reminderEvery,
      reminderUnit: reminderUnit ?? this.reminderUnit,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      dateCreated: dateCreated ?? this.dateCreated,
      dateDeleted: clearDateDeleted ? null : (dateDeleted ?? this.dateDeleted),
      dateModified: dateModified ?? this.dateModified,
    );
  }

  /// 🔜 Future (SQLite / JSON support)
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      imagePath: json['imagePath'],
      title: json['title'],
      dosage: json['dosage'],
      reason: json['reason'],
      reminderEvery: json['reminderEvery'],
      reminderUnit: json['reminderUnit'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      dateCreated: DateTime.parse(json['dateCreated']),
      dateDeleted: json['dateDeleted'] != null
          ? DateTime.parse(json['dateDeleted'])
          : null,
      dateModified: DateTime.parse(json['dateModified']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'dosage': dosage,
      'reason': reason,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateDeleted': dateDeleted?.toIso8601String(),
      'dateModified': dateModified.toIso8601String(),
    };
  }
}