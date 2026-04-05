import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:salemtek/ui/pages/main/home/components/calendar/bloc/calendar_load_cubit.dart';

import '../../../../configs/theme/palette.dart';
import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../bloc/medicine/medicine_state.dart';
import '../../../components/custom_header.dart';
import '../../../components/medicine_card.dart';
import '../home/components/calendar/calendar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<CalendarDayCubit>().state;
    final isToday = _isSameDay(selectedDate, DateTime.now());

    final sectionTitle = isToday
        ? "Today's Reminder"
        : DateFormat('MMMM d').format(selectedDate);

    return Column(
      children: [
        CustomHeader(
          title: 'Your\nDrug Schedule',
          onPressed: () {},
          icon: Icons.notifications_active,
        ),
        const SizedBox(height: 20),
        const Calendar(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sectionTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 25),
                    BlocBuilder<MedicineCubit, MedicineState>(
                      builder: (context, state) {
                        if (state.status == MedicineStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final dueMedicines = state.medicines
                            .where((medicine) => medicine.isDueOn(selectedDate))
                            .where(
                              (medicine) => !context
                                  .read<MedicineCubit>()
                                  .isCompletedForDate(
                                    medicine.id,
                                    selectedDate,
                                  ),
                            )
                            .toList();

                        if (dueMedicines.isEmpty) {
                          return Center(
                            child: Text(
                              'No medicines for this date',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }

                        return Column(
                          children: dueMedicines.map((medicine) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: MedicineCard(
                                medicine: medicine,
                                showCompleteAction: isToday,
                                enableDelete: false,
                                onSecondaryAction: () {
                                  if (isToday) {
                                    context
                                        .read<MedicineCubit>()
                                        .markCompletedForDate(
                                          medicine.id,
                                          selectedDate,
                                        );
                                  } else {
                                    // TODO: open edit bottom sheet/page later
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
