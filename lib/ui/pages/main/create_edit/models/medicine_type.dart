enum MedicineType {
  pill,
  capsule,
  cream,
  injection,
}

extension MedicineTypeX on MedicineType {
  String get asset {
    switch (this) {
      case MedicineType.pill:
        return 'assets/imgs/pills/pill.png';
      case MedicineType.capsule:
        return 'assets/imgs/pills/capsule.png';
      case MedicineType.cream:
        return 'assets/imgs/pills/cream.png';
      case MedicineType.injection:
        return 'assets/imgs/pills/syringe.png';
    }
  }

  String get label {
    switch (this) {
      case MedicineType.pill:
        return 'Pill';
      case MedicineType.capsule:
        return 'Capsule';
      case MedicineType.cream:
        return 'Cream';
      case MedicineType.injection:
        return 'Injection';
    }
  }
}