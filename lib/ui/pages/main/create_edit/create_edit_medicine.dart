import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../../../../../domain/entities/medicine.dart';

class CreateEditMedicine extends StatelessWidget {
  final Medicine? medicine;

  const CreateEditMedicine({
    super.key,
    this.medicine,
  });

  bool get isEditing => medicine != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      child: Center(
        child: Text(
          isEditing ? 'Edit Medicine' : 'Create Medicine',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}