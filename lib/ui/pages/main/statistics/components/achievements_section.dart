import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../../../../../domain/entities/achievement.dart';

class AchievementsSection extends StatelessWidget {
  final List<AchievementProgress> achievements;

  const AchievementsSection({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((p) => p.isUnlocked).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Palette.text,
          ),
        ),
        const SizedBox(height: 18),
        if (unlocked.isEmpty)
          Text(
            'No achievements yet — keep taking your meds to earn them.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Palette.text.withValues(alpha: 0.6),
            ),
          )
        else
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 18,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
            children: [
              for (final progress in unlocked)
                _AchievementTile(progress: progress),
            ],
          ),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final AchievementProgress progress;

  const _AchievementTile({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Image.asset(
            progress.achievement.asset,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          progress.achievement.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.15,
            color: Palette.text,
          ),
        ),
      ],
    );
  }
}
