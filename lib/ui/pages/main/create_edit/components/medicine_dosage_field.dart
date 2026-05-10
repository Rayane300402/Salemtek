import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../models/dosage_option.dart';
import '../models/medicine_type.dart';

class MedicineDosageField extends StatelessWidget {
  final MedicineType type;
  final DosageOption selectedDosage;
  final ValueChanged<DosageOption> onChanged;

  const MedicineDosageField({
    super.key,
    required this.type,
    required this.selectedDosage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = type.dosageOptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dosage',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Palette.text,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 72,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22),
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
          child: Row(
            children: [
              const Icon(
                Icons.medication,
                size: 30,
                color: Palette.text,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DosageOption>(
                    menuMaxHeight: 300,
                    value: selectedDosage,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 34,
                      color: Palette.text,
                    ),
                    dropdownColor: Palette.secondary,
                    borderRadius: BorderRadius.circular(24),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Palette.text,
                    ),
                    items: options.map((option) {
                      return DropdownMenuItem<DosageOption>(
                        value: option,
                        child: Text(option.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) onChanged(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}