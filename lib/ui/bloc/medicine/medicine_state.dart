import '../../../domain/entities/medicine.dart';

enum MedicineStatus {
  initial,
  loading,
  success,
  error,
}

class MedicineState {
  final MedicineStatus status;
  final List<Medicine> medicines;
  final String? errorMessage;

  const MedicineState({
    required this.status,
    required this.medicines,
    this.errorMessage,
  });

  factory MedicineState.initial() {
    return const MedicineState(
      status: MedicineStatus.initial,
      medicines: [],
      errorMessage: null,
    );
  }

  MedicineState copyWith({
    MedicineStatus? status,
    List<Medicine>? medicines,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MedicineState(
      status: status ?? this.status,
      medicines: medicines ?? this.medicines,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}