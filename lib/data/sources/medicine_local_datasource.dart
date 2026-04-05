import '../../domain/entities/reminder.dart';
import '../models/medicine_model.dart';

abstract class MedicineLocalDataSource {
  Future<List<MedicineModel>> getAllMedicines({bool includeDeleted = false});
  Future<MedicineModel> addMedicine(MedicineModel medicine);
  Future<MedicineModel> updateMedicine(MedicineModel medicine);
  Future<void> deleteMedicine(String id, {bool softDelete = true});
  Future<void> restoreMedicine(String id);
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final List<MedicineModel> _medicines = [
    MedicineModel(
      id: '1',
      imagePath: 'assets/imgs/pills/capsule.png',
      title: 'Benzonatate',
      dosage: '100 mg, 1 capsule',
      reason: 'Cough',
      reminderEvery: 1,
      reminderUnit: ReminderUnit.day,
      startDate: DateTime(2026, 4, 8),
      endDate: DateTime(2026, 3, 14),
      dateCreated: DateTime.now(),
      dateDeleted: null,
      dateModified: DateTime.now(),
    ),
    MedicineModel(
      id: '2',
      imagePath: 'assets/imgs/pills/pill.png',
      title: 'Loratadine',
      dosage: '10 mg, 2 pills',
      reason: 'Allergy',
      reminderEvery: 4,
      reminderUnit: ReminderUnit.day,
      startDate: DateTime(2026, 4, 6),
      endDate: null,
      dateCreated: DateTime.now(),
      dateDeleted: null,
      dateModified: DateTime.now(),
    ),
    MedicineModel(
      id: '3',
      imagePath: 'assets/imgs/pills/syringe.png',
      title: 'Liraglutide',
      dosage: '3 mg, 1 injection',
      reason: null,
      reminderEvery: 4,
      reminderUnit: ReminderUnit.month,
      startDate: DateTime(2026, 4, 5),
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
}