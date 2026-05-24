import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salemtek/ui/pages/main/statistics/components/statistics_header.dart';

import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../bloc/medicine/medicine_state.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<MedicineCubit, MedicineState>(
          builder: (context, medicineState) {
            return StatisticsHeader();
          },
        )
      ],
    );;
  }
}
