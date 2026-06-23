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

  factory MedicineStatisticModel.fromMap(Map<String, Object?> map) {
    return MedicineStatisticModel(
      id: map['id'] as String,
      medicineId: map['medicineId'] as String,
      medicineType: MedicineType.values.byName(map['medicineType'] as String),
      dosageAmount: map['dosageAmount'] as int,
      actionType: StatisticActionType.values.byName(
        map['actionType'] as String,
      ),
      actionDate: DateTime.fromMillisecondsSinceEpoch(map['actionDate'] as int),
      dateCreated: DateTime.fromMillisecondsSinceEpoch(
        map['dateCreated'] as int,
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'medicineId': medicineId,
      'medicineType': medicineType.name,
      'dosageAmount': dosageAmount,
      'actionType': actionType.name,
      'actionDate': actionDate.millisecondsSinceEpoch,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
    };
  }
}