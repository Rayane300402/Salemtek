import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salemtek/ui/pages/main/create_edit/components/medicine_notification.dart';
import 'package:salemtek/ui/pages/main/create_edit/components/medicine_reason_field.dart';

import '../../../../../configs/theme/palette.dart';
import '../../../../../domain/entities/medicine.dart';
import '../../../../domain/entities/reminder.dart';
import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../components/global_toast.dart';
import 'components/medicine_date_field.dart';
import 'components/medicine_dosage_field.dart';
import 'components/medicine_name_field.dart';
import 'components/medicine_type_carousel.dart';
import 'models/dosage_option.dart';
import '../../../../domain/entities/medicine_type.dart';
import 'models/notification_option.dart';

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
  DateTime? startDate;
  DateTime? endDate;
  late DosageOption selectedDosage;

  MedicineType selectedType = MedicineType.pill;
  NotificationOption selectedNotification = NotificationOption.everyDay;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController customNotificationController =
  TextEditingController(text: '2');

  @override
  void initState() {
    super.initState();

    // Default medicine type
    selectedType = MedicineType.pill;

    // Default dosage for selected type
    selectedDosage = selectedType.dosageOptions.first;

    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    nameController.dispose();
    customNotificationController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  ReminderUnit _reminderUnitFromOption() {
    switch (selectedNotification) {
      case NotificationOption.everyDay:
      case NotificationOption.everyXDays:
        return ReminderUnit.day;

      case NotificationOption.everyWeek:
      case NotificationOption.everyXWeeks:
        return ReminderUnit.week;

      case NotificationOption.everyMonth:
      case NotificationOption.everyXMonths:
        return ReminderUnit.month;

    }
  }

  int _reminderEveryFromOption() {
    switch (selectedNotification) {

      case NotificationOption.everyDay:
      case NotificationOption.everyWeek:
      case NotificationOption.everyMonth:
        return 1;

      case NotificationOption.everyXDays:
      case NotificationOption.everyXWeeks:
      case NotificationOption.everyXMonths:
        final value = int.tryParse(customNotificationController.text.trim());
        return value == null || value <= 0 ? 1 : value;
    }
  }

  Future<void> _createMedicine() async {
    final title = nameController.text.trim();

    if (title.isEmpty) {
      GlobalToast.show(
        'Medicine name is required',
        isNegative: true,
      );
      return;
    }

    final now = DateTime.now();

    final medicine = Medicine(
      id: now.microsecondsSinceEpoch.toString(),
      type: selectedType,
      title: title,
      dosageAmount: selectedDosage.value,
      dosageSingular: selectedDosage.singularLabel,
      dosagePlural: selectedDosage.pluralLabel,
      reason: reasonController.text.trim().isEmpty
          ? null
          : reasonController.text.trim(),
      hasNotification: true,
      reminderEvery: _reminderEveryFromOption(),
      reminderUnit: _reminderUnitFromOption(),
      startDate: startDate!,
      endDate: endDate,
      dateCreated: now,
      dateDeleted: null,
      dateModified: now,
    );

    await context.read<MedicineCubit>().add(medicine);

    if (!mounted) return;

    GlobalToast.show('Medicine Created');
    Navigator.pop(context);
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
                    selectedDosage = type.dosageOptions.first;
                  });
                },
              ),

              const SizedBox(height: 42),

              MedicineNameField(
                type: selectedType,
                controller: nameController,
              ),

              const SizedBox(height: 30,),

              MedicineReasonField(controller: reasonController),

              const SizedBox(height: 30,),

              MedicineNotificationField(
                selectedOption: selectedNotification,
                customValueController: customNotificationController,
                onOptionChanged: (option) {
                  setState(() {
                    selectedNotification = option;
                  });
                },
              ),

              const SizedBox(height: 30,),

              MedicineDosageField(
                type: selectedType,
                selectedDosage: selectedDosage,
                onChanged: (dosage) {
                  setState(() {
                    selectedDosage = dosage;
                  });
                },
              ),

              const SizedBox(height: 30),

              MedicineDateField(
                startDate: startDate,
                endDate: endDate,
                onStartDateChanged: (date) {
                  setState(() {
                    startDate = date;

                    if (endDate != null && endDate!.isBefore(date)) {
                      endDate = null;
                    }
                  });
                },
                onEndDateChanged: (date) {
                  setState(() {
                    endDate = date;
                  });
                },
              ),


              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.isEditing ? () => Navigator.pop(context) : _createMedicine,
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