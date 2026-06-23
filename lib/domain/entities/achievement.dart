import '../../configs/assets/achievements.dart';
import 'medicine_type.dart';

enum AchievementRule {
  typeDoses,

  medicineVariety,
}

class Achievement {
  final String id;
  final String title;

  final MedicineType? type;
  final String asset;
  final int threshold;
  final AchievementRule rule;

  final bool secret;

  const Achievement({
    required this.id,
    required this.title,
    required this.type,
    required this.asset,
    required this.threshold,
    this.rule = AchievementRule.typeDoses,
    this.secret = false,
  });

  static const List<Achievement> catalog = [
    Achievement(
      id: 'pill_keeper',
      title: 'Pill Keeper',
      type: MedicineType.pill,
      asset: Achievements.pillKeeper,
      threshold: 20,
    ),
    Achievement(
      id: 'capsule_guardian',
      title: 'Capsule Guardian',
      type: MedicineType.capsule,
      asset: Achievements.capsuleGuardian,
      threshold: 20,
    ),
    Achievement(
      id: 'injection_inspector',
      title: 'Injection Inspector',
      type: MedicineType.injection,
      asset: Achievements.injectionInspector,
      threshold: 20,
    ),
    Achievement(
      id: 'cream_captain',
      title: 'Cream Captain',
      type: MedicineType.cream,
      asset: Achievements.creamCaptain,
      threshold: 20,
    ),
    Achievement(
      id: 'liquid_legend',
      title: 'Liquid Legend',
      type: MedicineType.liquid,
      asset: Achievements.liquidLegend,
      threshold: 20,
    ),
    Achievement(
      id: 'sachet_specialist',
      title: 'Sachet Specialist',
      type: MedicineType.powder,
      asset: Achievements.sachetSpecialist,
      threshold: 20,
    ),
    Achievement(
      id: 'puff_pro',
      title: 'Puff Pro',
      type: MedicineType.inhaler,
      asset: Achievements.puffPro,
      threshold: 20,
    ),
    Achievement(
      id: 'bandage_king',
      title: 'Bandage King',
      type: MedicineType.bandage,
      asset: Achievements.bandageKing,
      threshold: 20,
    ),
    Achievement(
      id: 'drip_master',
      title: 'Drip Master',
      type: MedicineType.drip,
      asset: Achievements.dripMaster,
      threshold: 20,
    ),
    Achievement(
      id: 'drop_doctor',
      title: 'Drop Doctor',
      type: MedicineType.drop,
      asset: Achievements.dropDoctor,
      threshold: 20,
    ),
    Achievement(
      id: 'suppository_sentinel',
      title: 'Suppository Sentinel',
      type: MedicineType.suppository,
      asset: Achievements.suppositorySentinel,
      threshold: 20,
    ),
    Achievement(
      id: 'healer',
      title: 'Healer',
      type: null,
      asset: Achievements.healer,
      threshold: 5,
      rule: AchievementRule.medicineVariety,
      secret: true,
    ),
  ];
}

class AchievementProgress {
  final Achievement achievement;
  final int value;

  const AchievementProgress({
    required this.achievement,
    required this.value,
  });

  bool get isUnlocked => value > achievement.threshold;

  double get progress {
    final goal = achievement.threshold + 1;
    if (goal <= 0) return 0;
    return (value / goal).clamp(0.0, 1.0).toDouble();
  }
}
