import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../configs/theme/palette.dart';

class MedicineDateField extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  const MedicineDateField({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  String _formatDate(DateTime? date, String fallback) {
    if (date == null) return fallback;
    return DateFormat('MMM d, yyyy').format(date);
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final safeInitialDate =
    startDate != null && !startDate!.isBefore(normalizedToday)
        ? startDate!
        : normalizedToday;

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: normalizedToday,
      lastDate: DateTime(normalizedToday.year + 10),
    );

    if (picked != null) {
      final normalizedPicked = DateTime(
        picked.year,
        picked.month,
        picked.day,
      );

      onStartDateChanged(normalizedPicked);

      if (endDate != null && endDate!.isBefore(normalizedPicked)) {
        onEndDateChanged(null);
      }
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final minimumDate = startDate ?? normalizedToday;

    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? minimumDate,
      firstDate: minimumDate,
      lastDate: DateTime(minimumDate.year + 10),
    );

    if (picked != null) {
      onEndDateChanged(DateTime(picked.year, picked.month, picked.day));
    }
  }

  Widget _dateButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool showClear = false,
  }) {
    return Container(
      height: 72,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(icon, size: 30, color: Palette.text),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Palette.text,
                    ),
                  ),
                ),
                if (showClear)
                  IconButton(
                    onPressed: () => onEndDateChanged(null),
                    icon: const Icon(Icons.close, color: Palette.text),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Palette.text,
          ),
        ),
        const SizedBox(height: 16),
        _dateButton(
          label: _formatDate(startDate, 'Start date'),
          icon: Icons.calendar_month,
          onTap: () => _pickStartDate(context),
        ),
        const SizedBox(height: 18),
        _dateButton(
          label: _formatDate(endDate, 'End date'),
          icon: Icons.calendar_month,
          onTap: () => _pickEndDate(context),
          showClear: endDate != null,
        ),
      ],
    );
  }
}