import '../../domain/entities/medicine.dart';
import '../../domain/repo/medicine_repository.dart';
import '../models/medicine_model.dart';
import '../sources/medicine_local_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource localDataSource;

  MedicineRepositoryImpl(this.localDataSource);

  @override
  Future<List<Medicine>> getAllMedicines({
    bool includeDeleted = false,
  }) async {
    final models = await localDataSource.getAllMedicines(
      includeDeleted: includeDeleted,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Medicine> addMedicine(Medicine medicine) async {
    final model = MedicineModel.fromEntity(medicine);
    return (await localDataSource.addMedicine(model)).toEntity();
  }

  @override
  Future<Medicine> updateMedicine(Medicine medicine) async {
    final model = MedicineModel.fromEntity(medicine);
    return (await localDataSource.updateMedicine(model)).toEntity();
  }

  @override
  Future<void> deleteMedicine(String id, {bool softDelete = true}) {
    return localDataSource.deleteMedicine(id, softDelete: softDelete);
  }

  @override
  Future<void> restoreMedicine(String id) {
    return localDataSource.restoreMedicine(id);
  }
}