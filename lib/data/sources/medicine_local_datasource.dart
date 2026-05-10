import '../../domain/entities/medicine_type.dart';
import '../../domain/entities/reminder.dart';
import '../models/medicine_model.dart';

abstract class MedicineLocalDataSource {
  Future<List<MedicineModel>> getAllMedicines({bool includeDeleted = false});
  Future<MedicineModel> addMedicine(MedicineModel medicine);
  Future<MedicineModel> updateMedicine(MedicineModel medicine);
  Future<void> deleteMedicine(String id, {bool softDelete = true});
  Future<void> restoreMedicine(String id);
  Future<void> restoreAllMedicines();
  Future<void> hardDeleteAllMedicines();
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final List<MedicineModel> _medicines = [
    MedicineModel(
      id: '1',
      type: MedicineType.capsule,
      title: 'Benzonatate',
      dosageAmount: 1,
      dosageSingular: 'capsule',
      dosagePlural: 'capsules',
      reason: 'Cough',
      hasNotification: true,
      reminderEvery: 1,
      reminderUnit: ReminderUnit.day,
      startDate: DateTime(2026, 4, 19),
      endDate: DateTime(2026, 5, 19),
      dateCreated: DateTime.now(),
      dateDeleted: null,
      dateModified: DateTime.now(),
    ),
    MedicineModel(
      id: '2',
      type: MedicineType.pill,
      title: 'Loratadine',
      dosageAmount: 2,
      dosageSingular: 'pill',
      dosagePlural: 'pills',
      reason: 'Allergy',
      hasNotification: true,
      reminderEvery: 4,
      reminderUnit: ReminderUnit.day,
      startDate: DateTime(2026, 4, 19),
      endDate: null,
      dateCreated: DateTime.now(),
      dateDeleted: null,
      dateModified: DateTime.now(),
    ),
    MedicineModel(
      id: '3',
      type: MedicineType.injection,
      title: 'Liraglutide',
      dosageAmount: 1,
      dosageSingular: 'injection',
      dosagePlural: 'injections',
      reason: null,
      hasNotification: true,
      reminderEvery: 4,
      reminderUnit: ReminderUnit.month,
      startDate: DateTime(2026, 4, 20),
      endDate: null,
      dateCreated: DateTime.now(),
      dateDeleted: null,
      dateModified: DateTime.now(),
    ),
  ];
  @override
  Future<List<MedicineModel>> getAllMedicines({
    bool includeDeleted = false,
  }) async {
    return includeDeleted
        ? List<MedicineModel>.from(_medicines)
        : _medicines.where((m) => m.dateDeleted == null).toList();
  }

  @override
  Future<MedicineModel> addMedicine(MedicineModel medicine) async {
    _medicines.add(medicine);
    return medicine;
  }

  @override
  Future<MedicineModel> updateMedicine(MedicineModel medicine) async {
    final index = _medicines.indexWhere((m) => m.id == medicine.id);
    if (index == -1) {
      throw Exception('Medicine not found');
    }
    _medicines[index] = medicine;
    return medicine;
  }

  @override
  Future<void> deleteMedicine(String id, {bool softDelete = true}) async {
    final index = _medicines.indexWhere((m) => m.id == id);
    if (index == -1) return;

    if (softDelete) {
      _medicines[index] = _medicines[index].copyWith(
        dateDeleted: DateTime.now(),
        dateModified: DateTime.now(),
      );
    } else {
      _medicines.removeAt(index);
    }
  }

  @override
  Future<void> restoreMedicine(String id) async {
    final index = _medicines.indexWhere((m) => m.id == id);
    if (index == -1) return;

    _medicines[index] = _medicines[index].copyWith(
      clearDateDeleted: true,
      dateModified: DateTime.now(),
    );
  }

  @override
  Future<void> restoreAllMedicines() async {
    for (var i = 0; i < _medicines.length; i++) {
      if (_medicines[i].dateDeleted != null) {
        _medicines[i] = _medicines[i].copyWith(
          clearDateDeleted: true,
          dateModified: DateTime.now(),
        );
      }
    }
  }

  @override
  Future<void> hardDeleteAllMedicines() async {
    _medicines.clear();
  }


}