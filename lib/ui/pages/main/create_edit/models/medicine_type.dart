import 'package:salemtek/configs/assets/pills.dart';

enum MedicineType {
  pill,
  capsule,
  cream,
  injection,
  bandage,
  drip,
  drop,
  inhaler,
  liquid,
  powder,
  suppository
}

extension MedicineTypeX on MedicineType {
  String get asset {
    switch (this) {
      case MedicineType.pill:
        return Pills.pill;
      case MedicineType.capsule:
        return Pills.capsule;
      case MedicineType.cream:
        return Pills.capsule;
      case MedicineType.injection:
        return Pills.syringe;
      case MedicineType.bandage:
        return Pills.bandage;
      case MedicineType.drip:
        return Pills.drip;
      case MedicineType.drop:
        return Pills.drop;
      case MedicineType.inhaler:
        return Pills.inhaler;
      case MedicineType.liquid:
        return Pills.liquid;
      case MedicineType.powder:
        return Pills.powder;
      case MedicineType.suppository:
        return Pills.suppository;
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
      case MedicineType.bandage:
        return 'Bandage';
      case MedicineType.drip:
        return 'IV Drip';
      case MedicineType.drop:
        return 'Drops';
      case MedicineType.inhaler:
        return 'Inhaler';
      case MedicineType.liquid:
        return 'Liquid';
      case MedicineType.powder:
        return 'Powder';
      case MedicineType.suppository:
        return 'Suppository';
    }
  }
}