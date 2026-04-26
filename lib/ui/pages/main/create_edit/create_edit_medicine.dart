import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../../../../../domain/entities/medicine.dart';
import 'components/medicine_name_field.dart';
import 'components/medicine_type_carousel.dart';
import 'models/medicine_type.dart';

class CreateEditMedicine extends StatefulWidget {
  final Medicine? medicine;

  const CreateEditMedicine({
    super.key,
    this.medicine,
  });

  bool get isEditing => medicine != null;

  @override
  State<CreateEditMedicine> createState() => _CreateEditMedicineState();
}

class _CreateEditMedicineState extends State<CreateEditMedicine> {
  MedicineType selectedType = MedicineType.pill;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 45,
            left: 28,
            right: 28,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MedicineTypeCarousel(
                selected: selectedType,
                onChanged: (type) {
                  setState(() {
                    selectedType = type;
                  });
                },
              ),

              const SizedBox(height: 42),

              MedicineNameField(
                type: selectedType,
                controller: nameController,
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(widget.isEditing ? 'Update' : 'Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}