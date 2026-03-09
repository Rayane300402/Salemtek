import 'package:hydrated_bloc/hydrated_bloc.dart';

class CalendarDayCubit extends Cubit<DateTime> {
  CalendarDayCubit() : super(_today());

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void selectDay(DateTime day) {
    emit(DateTime(day.year, day.month, day.day));
  }

  void resetToToday() {
    emit(_today());
  }
}