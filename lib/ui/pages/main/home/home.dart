import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:salemtek/ui/components/global_toast.dart';
import 'package:salemtek/ui/pages/main/home/components/calendar/bloc/calendar_load_cubit.dart';

import '../../../../configs/theme/palette.dart';
import '../../../../domain/entities/medicine.dart';
import '../../../../domain/entities/statistic_action_type.dart';
import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../bloc/medicine/medicine_state.dart';
import '../../../bloc/statistics/statistics_cubit.dart';
import '../../../bloc/statistics/statistics_state.dart';
import '../../../components/custom_header.dart';
import '../../../components/empty_state.dart';
import '../../../components/medicine_card.dart';
import '../create_edit/create_edit_medicine.dart';
import '../home/components/calendar/calendar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _openCreateEditMedicine(
    BuildContext context, {
    required Medicine medicine,
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
    final selectedDate = context.watch<CalendarDayCubit>().state;
    final isToday = _isSameDay(selectedDate, DateTime.now());

    final sectionTitle = isToday
        ? "Today's Reminder"
        : DateFormat('MMMM d').format(selectedDate);

    return Column(
      children: [
        CustomHeader(
          title: 'Your\nDrug Schedule',
          onPressed: () => GlobalToast.show('Notifications coming soon'),
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

                        return BlocBuilder<StatisticsCubit, StatisticsState>(
                          builder: (context, statsState) {
                            final dueMedicines = state.medicines
                                .where((m) => m.isDueOn(selectedDate))
                                .where(
                                  (m) => !statsState.isHandledForDate(
                                    m.id,
                                    selectedDate,
                                  ),
                                )
                                .toList();

                            if (dueMedicines.isEmpty) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: const Center(
                                  child: EmptyState(
                                    title: 'No medicines for this date',
                                  ),
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
                                    onEdit: () {
                                      _openCreateEditMedicine(
                                        context,
                                        medicine: medicine,
                                      );
                                    },
                                    onComplete: () {
                                      context.read<StatisticsCubit>().record(
                                        medicineId: medicine.id,
                                        medicineType: medicine.type,
                                        dosageAmount: medicine.dosageAmount,
                                        actionType:
                                            StatisticActionType.completed,
                                        date: selectedDate,
                                      );

                                      GlobalToast.show('Medicine Completed');
                                    },
                                    onSkip: () {
                                      context.read<StatisticsCubit>().record(
                                        medicineId: medicine.id,
                                        medicineType: medicine.type,
                                        dosageAmount: medicine.dosageAmount,
                                        actionType: StatisticActionType.skipped,
                                        date: selectedDate,
                                      );

                                      GlobalToast.show(
                                        'Medicine Skipped',
                                        isNegative: true,
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          },
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
