import 'package:bloc/bloc.dart';

import '../../../domain/entities/medicine.dart';
import '../../../domain/usecases/medicine_usecases.dart';
import 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineUseCases useCases;

  MedicineCubit(this.useCases) : super(MedicineState.initial());

  String _completionKey(String medicineId, DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return '${medicineId}_${normalized.toIso8601String()}';
  }

  Future<void> load() async {
    emit(state.copyWith(status: MedicineStatus.loading, clearError: true));

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

  Future<void> delete(String id) async {
    try {
      await useCases.delete(id);
      final medicines = await useCases.getAll();
      emit(
        state.copyWith(status: MedicineStatus.success, medicines: medicines),
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

  void markCompletedForDate(String medicineId, DateTime date) {
    final updated = Set<String>.from(state.completedKeys)
      ..add(_completionKey(medicineId, date));

    emit(state.copyWith(completedKeys: updated));
  }

  void markSkippedForDate(String medicineId, DateTime date) {
    final updated = Set<String>.from(state.skippedKeys)
      ..add(_completionKey(medicineId, date));

    emit(state.copyWith(skippedKeys: updated));
  }

  bool isCompletedForDate(String medicineId, DateTime date) {
    return state.completedKeys.contains(_completionKey(medicineId, date));
  }

  bool isSkippedForDate(String medicineId, DateTime date) {
    return state.skippedKeys.contains(_completionKey(medicineId, date));
  }

  /// True once a medicine has been completed or skipped for [date], so the home
  /// list can stop showing it.
  bool isHandledForDate(String medicineId, DateTime date) {
    return isCompletedForDate(medicineId, date) ||
        isSkippedForDate(medicineId, date);
  }
}
