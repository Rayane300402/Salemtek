import 'package:get_it/get_it.dart';
import 'package:salemtek/ui/pages/introduction/bloc/introduction_cubit.dart';

import '../data/repo/medicine_repository_impl.dart' show MedicineRepositoryImpl;
import '../data/repo/settings_repo_impl.dart';
import '../data/sources/medicine_local_datasource.dart';
import '../data/sources/settings_local_data_source.dart';
import '../domain/repo/medicine_repository.dart';
import '../domain/repo/settings_repository.dart';
import '../domain/usecases/medicine_usecases.dart';
import '../domain/usecases/settings_usecases.dart';
import '../ui/bloc/medicine/medicine_cubit.dart';
import '../ui/bloc/settings/settings_cubit.dart';

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

  // sl.registerFactory(() => MedicineCubit(sl()));

  sl.registerLazySingleton<MedicineCubit>(
        () => MedicineCubit(sl())..load(),
  );

  sl.registerLazySingleton<SettingsLocalDataSource>(
        () => SettingsLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<SettingsRepo>(
        () => SettingsRepoImpl(sl()),
  );

  sl.registerLazySingleton<SettingsUseCases>(
        () => SettingsUseCases(sl()),
  );

  sl.registerFactory<SettingsCubit>(
        () => SettingsCubit(
      settingsUseCases: sl(),
      medicineRepo: sl(),
      medicineCubit: sl<MedicineCubit>(),
    )..load(),
  );
}