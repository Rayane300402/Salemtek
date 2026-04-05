import 'package:get_it/get_it.dart';
import 'package:salemtek/ui/pages/introduction/bloc/introduction_cubit.dart';

import '../data/repo/medicine_repository_impl.dart' show MedicineRepositoryImpl;
import '../data/sources/medicine_local_datasource.dart';
import '../domain/repo/medicine_repository.dart';
import '../domain/usecases/medicine_usecases.dart';
import '../ui/bloc/medicine/medicine_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  sl.registerLazySingleton<IntroductionCubit>(() => IntroductionCubit());

  sl.registerLazySingleton<MedicineLocalDataSource>(
        () => MedicineLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<MedicineRepository>(
        () => MedicineRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => MedicineUseCases(sl()));

  sl.registerFactory(() => MedicineCubit(sl()));
}