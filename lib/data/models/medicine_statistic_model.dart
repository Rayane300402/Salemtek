import '../../domain/entities/medicine_statistic.dart';
import '../../domain/entities/medicine_type.dart';
import '../../domain/entities/statistic_action_type.dart';

class MedicineStatisticModel {
  final String id;
  final String medicineId;
  final MedicineType medicineType;
  final int dosageAmount;
  final StatisticActionType actionType;
  final DateTime actionDate;
  final DateTime dateCreated;

  const MedicineStatisticModel({
    required this.id,
    required this.medicineId,
    required this.medicineType,
    required this.dosageAmount,
    required this.actionType,
    required this.actionDate,
    required this.dateCreated,
  });

  MedicineStatistic toEntity() {
    return MedicineStatistic(
      id: id,
      medicineId: medicineId,
      medicineType: medicineType,
      dosageAmount: dosageAmount,
      actionType: actionType,
      actionDate: actionDate,
      dateCreated: dateCreated,
    );
  }

  factory MedicineStatisticModel.fromEntity(MedicineStatistic statistic) {
    return MedicineStatisticModel(
      id: statistic.id,
      medicineId: statistic.medicineId,
      medicineType: statistic.medicineType,
      dosageAmount: statistic.dosageAmount,
      actionType: statistic.actionType,
      actionDate: statistic.actionDate,
      dateCreated: statistic.dateCreated,
    );
  }

  factory MedicineStatisticModel.fromJson(Map<String, dynamic> json) {
    return MedicineStatisticModel(
      id: json['id'] as String,
      medicineId: json['medicineId'] as String,
      medicineType: MedicineType.values.byName(json['medicineType'] as String),
      dosageAmount: json['dosageAmount'] as int,
      actionType: StatisticActionType.values.byName(
        json['actionType'] as String,
      ),
      actionDate: DateTime.parse(json['actionDate'] as String),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'medicineType': medicineType.name,
      'dosageAmount': dosageAmount,
      'actionType': actionType.name,
      'actionDate': actionDate.toIso8601String(),
      'dateCreated': dateCreated.toIso8601String(),
    };
  }
}