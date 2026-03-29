import 'package:flutter/material.dart';
import 'package:salemtek/domain/entities/medicine.dart';

import '../../configs/theme/palette.dart';
import '../../domain/entities/reminder.dart';


class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  const MedicineCard({super.key, required this.medicine});

  String _formatReminder() {
    final unit = switch (medicine.reminderUnit) {
      ReminderUnit.day => medicine.reminderEvery == 1 ? 'day' : 'days',
      ReminderUnit.week => medicine.reminderEvery == 1 ? 'week' : 'weeks',
      ReminderUnit.month => medicine.reminderEvery == 1 ? 'month' : 'months',
      ReminderUnit.year => medicine.reminderEvery == 1 ? 'year' : 'years',
    };

    return 'Every ${medicine.reminderEvery} $unit';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127,
      width: double.infinity,
      decoration: BoxDecoration(
        color:  Palette.secondary,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Center(
              child: Image.asset(
                medicine.imagePath,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Palette.text,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  medicine.dosage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Palette.text.withValues(alpha: 0.65),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      size: 18,
                      color: Palette.text,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatReminder(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Palette.text,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.more_vert,
              size: 28,
              color: Palette.text,
            ),
          ),
        ],
      ),
    );
  }
}
