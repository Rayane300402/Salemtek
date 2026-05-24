import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../../../../../domain/entities/medicine.dart';
import 'medicine_legend.dart';
import 'progress_circle.dart';

class ProgressSection extends StatelessWidget {
  final double percentage;
  final List<Medicine> medicines;

  const ProgressSection({
    super.key,
    required this.percentage,
    required this.medicines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Palette.text,
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          height: 135,
          child: Row(
            children: [
              ProgressCircle(
                percentage: percentage,
              ),

              const SizedBox(width: 26),

              Expanded(
                child: MedicineLegend(
                  medicines: medicines,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}