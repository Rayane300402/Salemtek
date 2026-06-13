import '../../configs/assets/achievements.dart';
import 'medicine_type.dart';

/// How an achievement is unlocked.
enum AchievementRule {
  /// Number of completions for [Achievement.type] must exceed the threshold.
  /// Counts completions (times taken), not dosage amount — taking 2 pills in
  /// one go is still one completion.
  typeDoses,

  /// The number of distinct medicine types the user has completed must be
  /// greater than the threshold (e.g. Healer: more than 5 types).
  medicineVariety,
}

/// An achievement and the rule that unlocks it. Display [title] intentionally
/// matches the asset filename so names never diverge.
class Achievement {
  final String id;
  final String title;

  /// The medicine type this rewards, or null for general achievements.
  final MedicineType? type;
  final String asset;
  final int threshold;
  final AchievementRule rule;

  /// Secret achievements stay hidden in the UI until they are unlocked.
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

  /// Every achievement we ship — one per MedicineType plus the secret Healer.
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

/// An achievement paired with the user's current progress value.
///
/// [value] is doses-of-type for [AchievementRule.typeDoses] and distinct
/// completed types for [AchievementRule.medicineVariety].
class AchievementProgress {
  final Achievement achievement;
  final int value;

  const AchievementProgress({
    required this.achievement,
    required this.value,
  });

  // Both rules unlock at "more than threshold".
  bool get isUnlocked => value > achievement.threshold;

  double get progress {
    final goal = achievement.threshold + 1;
    if (goal <= 0) return 0;
    return (value / goal).clamp(0.0, 1.0).toDouble();
  }
}
