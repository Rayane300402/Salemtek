import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:salemtek/configs/theme/palette.dart';
import 'bloc/calendar_load_cubit.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final ScrollController _scrollController = ScrollController();

  static const double _itemWidth = 82;
  static const double _itemGap = 12;
  static const double _horizontalPadding = 8;

  List<DateTime> _daysInCurrentMonth() {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0);

    return List.generate(
      lastDay.day,
          (index) => DateTime(now.year, now.month, index + 1),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _scrollToDay(DateTime selectedDay, {bool animated = true}) {
    if (!_scrollController.hasClients) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final itemExtent = _itemWidth + _itemGap;

    final targetIndex = selectedDay.day - 1;

    double offset =
        _horizontalPadding +
            (targetIndex * itemExtent) -
            ((screenWidth - _itemWidth) / 2);

    final max = _scrollController.position.maxScrollExtent;
    if (offset < 0) offset = 0;
    if (offset > max) offset = max;

    if (animated) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedDay = context.read<CalendarDayCubit>().state;
      _scrollToDay(selectedDay, animated: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysInCurrentMonth();

    return SizedBox(
      height: 120,
      child: BlocConsumer<CalendarDayCubit, DateTime>(
        listener: (context, selectedDay) {
          _scrollToDay(selectedDay, animated: true);
        },
        builder: (context, selectedDay) {
          return ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: _itemGap),
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = _isSameDay(day, selectedDay);

              return GestureDetector(
                onTap: () => context.read<CalendarDayCubit>().selectDay(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: _itemWidth,
                  decoration: BoxDecoration(
                    color: isSelected ? Palette.navIcon : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Palette.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEE').format(day),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Palette.text,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}