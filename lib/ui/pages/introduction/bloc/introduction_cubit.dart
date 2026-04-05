import 'package:hydrated_bloc/hydrated_bloc.dart';

class IntroductionCubit extends HydratedCubit<bool> {
  IntroductionCubit() : super(false);

  void completeIntro() => emit(true);

  void resetIntro() => emit(false);

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json['completed'] as bool? ?? false;
  }

  @override
  Map<String, dynamic>? toJson(bool state) {
    return {'completed': state};
  }
}