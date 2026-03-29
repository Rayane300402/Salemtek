import '../entities/medicine.dart';
import '../repo/medicine_repository.dart';

class MedicineUseCases {
  final MedicineRepository repository;

  MedicineUseCases(this.repository);

  Future<List<Medicine>> getAll({bool includeDeleted = false}) {
    return repository.getAllMedicines(includeDeleted: includeDeleted);
  }

  Future<Medicine> add(Medicine medicine) {
    return repository.addMedicine(medicine);
  }

  Future<Medicine> update(Medicine medicine) {
    return repository.updateMedicine(medicine);
  }

  Future<void> delete(String id, {bool softDelete = true}) {
    return repository.deleteMedicine(id, softDelete: softDelete);
  }

  Future<void> restore(String id) {
    return repository.restoreMedicine(id);
  }
}