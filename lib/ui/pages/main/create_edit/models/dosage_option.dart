import '../../../../../domain/entities/medicine_type.dart';

class DosageOption {
  final int value;
  final String singularLabel;
  final String pluralLabel;

  const DosageOption({
    required this.value,
    required this.singularLabel,
    required this.pluralLabel,
  });

  String get label => value == 1
      ? '$value $singularLabel'
      : '$value $pluralLabel';

  @override
  bool operator ==(Object other) {
    return other is DosageOption &&
        other.value == value &&
        other.singularLabel == singularLabel &&
        other.pluralLabel == pluralLabel;
  }

  @override
  int get hashCode => Object.hash(value, singularLabel, pluralLabel);
}

extension MedicineTypeDosageX on MedicineType {
  String get dosageSingular {
    switch (this) {
      case MedicineType.pill:
        return 'pill';
      case MedicineType.capsule:
        return 'capsule';
      case MedicineType.cream:
        return 'application';
      case MedicineType.injection:
        return 'injection';
      case MedicineType.bandage:
        return 'bandage';
      case MedicineType.drip:
        return 'session';
      case MedicineType.drop:
        return 'drop';
      case MedicineType.inhaler:
        return 'puff';
      case MedicineType.liquid:
        return 'mL';
      case MedicineType.powder:
        return 'sachet';
      case MedicineType.suppository:
        return 'suppository';
    }
  }

  String get dosagePlural {
    switch (this) {
      case MedicineType.pill:
        return 'pills';
      case MedicineType.capsule:
        return 'capsules';
      case MedicineType.cream:
        return 'applications';
      case MedicineType.injection:
        return 'injections';
      case MedicineType.bandage:
        return 'bandages';
      case MedicineType.drip:
        return 'sessions';
      case MedicineType.drop:
        return 'drops';
      case MedicineType.inhaler:
        return 'puffs';
      case MedicineType.liquid:
        return 'mL';
      case MedicineType.powder:
        return 'sachets';
      case MedicineType.suppository:
        return 'suppositories';
    }
  }

  int get maxDosageAmount {
    switch (this) {
      case MedicineType.pill:
      case MedicineType.capsule:
      case MedicineType.suppository:
        return 10;

      case MedicineType.injection:
      case MedicineType.drip:
        return 5;

      case MedicineType.inhaler:
        return 12;

      case MedicineType.powder:
        return 10;

      case MedicineType.bandage:
      case MedicineType.cream:
        return 10;

      case MedicineType.drop:
        return 20;

      case MedicineType.liquid:
        return 100;
    }
  }

  List<DosageOption> get dosageOptions {
    return List.generate(maxDosageAmount, (index) {
      final value = index + 1;

      return DosageOption(
        value: value,
        singularLabel: dosageSingular,
        pluralLabel: dosagePlural,
      );
    });
  }
}