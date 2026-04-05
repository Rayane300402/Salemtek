import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/theme/palette.dart';
import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../bloc/medicine/medicine_state.dart';
import '../../../components/custom_header.dart';
import '../../../components/medicine_card.dart';

class Cabinet extends StatelessWidget {
  const Cabinet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title:  'Your\nDrug Cabinet',
          onPressed: () {},
          icon: Icons.add,
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final medicines = List.of(state.medicines)
                      ..sort(
                            (a, b) => b.dateCreated.compareTo(a.dateCreated),
                      );

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
                              // TODO: open edit bottom sheet/page later
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
