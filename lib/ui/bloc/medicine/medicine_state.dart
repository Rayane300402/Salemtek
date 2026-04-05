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
  final Set<String> completedKeys;
  final String? errorMessage;

  const MedicineState({
    required this.status,
    required this.medicines,
    required this.completedKeys,
    this.errorMessage,
  });

  factory MedicineState.initial() {
    return const MedicineState(
      status: MedicineStatus.initial,
      medicines: [],
      completedKeys: {},
      errorMessage: null,
    );
  }

  MedicineState copyWith({
    MedicineStatus? status,
    List<Medicine>? medicines,
    Set<String>? completedKeys,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MedicineState(
      status: status ?? this.status,
      medicines: medicines ?? this.medicines,
      completedKeys: completedKeys ?? this.completedKeys,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}