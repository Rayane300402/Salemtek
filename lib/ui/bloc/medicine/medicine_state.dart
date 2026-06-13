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
  final Set<String> skippedKeys;
  final String? errorMessage;

  const MedicineState({
    required this.status,
    required this.medicines,
    required this.completedKeys,
    required this.skippedKeys,
    this.errorMessage,
  });

  factory MedicineState.initial() {
    return const MedicineState(
      status: MedicineStatus.initial,
      medicines: [],
      completedKeys: {},
      skippedKeys: {},
      errorMessage: null,
    );
  }

  MedicineState copyWith({
    MedicineStatus? status,
    List<Medicine>? medicines,
    Set<String>? completedKeys,
    Set<String>? skippedKeys,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MedicineState(
      status: status ?? this.status,
      medicines: medicines ?? this.medicines,
      completedKeys: completedKeys ?? this.completedKeys,
      skippedKeys: skippedKeys ?? this.skippedKeys,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}