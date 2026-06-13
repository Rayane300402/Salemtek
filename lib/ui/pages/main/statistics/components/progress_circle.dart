import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';

class ProgressCircle extends StatelessWidget {
  final double percentage;

  const ProgressCircle({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final safePercentage = percentage.clamp(0, 100).toDouble();

    return Container(
      width: 125,
      height: 125,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Palette.primary.withValues(alpha: 0.55),
      ),
      child: Text(
        '${safePercentage.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Palette.secondary,
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
