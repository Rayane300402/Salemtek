import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salemtek/ui/pages/main/create_edit/create_edit_medicine.dart';

import '../../../../configs/theme/palette.dart';
import '../../../../domain/entities/medicine.dart';
import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../bloc/medicine/medicine_state.dart';
import '../../../components/custom_header.dart';
import '../../../components/medicine_card.dart';

class Cabinet extends StatelessWidget {
  const Cabinet({super.key});

  void _openCreateEditMedicine(
      BuildContext context, {
        Medicine? medicine,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.86,
          child: CreateEditMedicine(medicine: medicine),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title: 'Your\nDrug Cabinet',
          icon: Icons.add,
          onPressed: () => _openCreateEditMedicine(context),
          onSearchPressed: () {
            // todo work on it
          },
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Palette.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
                child: BlocBuilder<MedicineCubit, MedicineState>(
                  builder: (context, state) {
                    if (state.status == MedicineStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final medicines = List.of(state.medicines)
                      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

                    if (medicines.isEmpty) {
                      return const Center(
                        child: Text(
                          'No medicines yet',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }

                    return Column(
                      children: medicines.map((medicine) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: MedicineCard(
                            medicine: medicine,
                            showCompleteAction: false,
                            enableDelete: true,
                            onSecondaryAction: () {
                              _openCreateEditMedicine(
                                context,
                                medicine: medicine,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}