import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../models/notification_option.dart';

class MedicineNotificationField extends StatelessWidget {
  final NotificationOption selectedOption;
  final ValueChanged<NotificationOption> onOptionChanged;
  final TextEditingController customValueController;

  const MedicineNotificationField({
    super.key,
    required this.selectedOption,
    required this.onOptionChanged,
    required this.customValueController,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowCustomInput = selectedOption.needsCustomValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notification',
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
                Icons.notifications_active,
                size: 30,
                color: Palette.text,
              ),

              const SizedBox(width: 18),

              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<NotificationOption>(
                    value: selectedOption,
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
                    items: NotificationOption.values.map((option) {
                      return DropdownMenuItem<NotificationOption>(
                        value: option,
                        child: Text(option.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onOptionChanged(value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: shouldShowCustomInput
              ? Padding(
            key: const ValueKey('custom-reminder-input'),
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              width: 210,
              child: Container(
                height: 66,
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    Expanded(
                      child: TextField(
                        controller: customValueController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Palette.text,
                        ),
                        decoration: const InputDecoration(
                          hintText: '2',
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedOption.customUnitLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Palette.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}