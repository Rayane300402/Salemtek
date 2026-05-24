import 'medicine_type.dart';
import 'statistic_action_type.dart';

class MedicineStatistic {
  final String id;
  final String medicineId;
  final MedicineType medicineType;
  final int dosageAmount;
  final StatisticActionType actionType;
  final DateTime actionDate;
  final DateTime dateCreated;

  const MedicineStatistic({
    required this.id,
    required this.medicineId,
    required this.medicineType,
    required this.dosageAmount,
    required this.actionType,
    required this.actionDate,
    required this.dateCreated,
  });
}