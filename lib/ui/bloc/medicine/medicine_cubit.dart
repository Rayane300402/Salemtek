import 'package:bloc/bloc.dart';

import '../../../domain/entities/medicine.dart';
import '../../../domain/usecases/medicine_usecases.dart';
import 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineUseCases useCases;

  MedicineCubit(this.useCases) : super(MedicineState.initial());

  Future<void> load() async {
    emit(
      state.copyWith(
        status: MedicineStatus.loading,
        clearError: true,
      ),
    );

    try {
      final meds = await useCases.getAll();
      emit(
        state.copyWith(
          status: MedicineStatus.success,
          medicines: meds,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MedicineStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> add(Medicine medicine) async {
    try {
      await useCases.add(medicine);
      await load();
    } catch (e) {
      emit(
        state.copyWith(
          status: MedicineStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> update(Medicine medicine) async {
    try {
      await useCases.update(medicine);
      await load();
    } catch (e) {
      emit(
        state.copyWith(
          status: MedicineStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> delete(String id) async {
    try {
      await useCases.delete(id);
      await load();
    } catch (e) {
      emit(
        state.copyWith(
          status: MedicineStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> restore(String id) async {
    try {
      await useCases.restore(id);
      await load();
    } catch (e) {
      emit(
        state.copyWith(
          status: MedicineStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}