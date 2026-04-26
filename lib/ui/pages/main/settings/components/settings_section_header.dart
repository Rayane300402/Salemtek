import 'package:flutter/material.dart';
import '../../../../../configs/theme/palette.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new, color: Palette.text),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Palette.text,
          ),
        ),
      ],
    );
  }
}