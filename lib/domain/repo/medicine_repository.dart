import '../entities/medicine.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> getAllMedicines({bool includeDeleted = false});
  Future<Medicine> addMedicine(Medicine medicine);
  Future<Medicine> updateMedicine(Medicine medicine);
  Future<void> deleteMedicine(String id, {bool softDelete = true});
  Future<void> restoreMedicine(String id);
  Future<void> restoreAllMedicines();
  Future<void> hardDeleteAllMedicines();
}