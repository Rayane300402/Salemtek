import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:salemtek/configs/theme/theme.dart';
import 'package:salemtek/ui/bloc/medicine/medicine_cubit.dart';
import 'package:salemtek/ui/pages/introduction/introductions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salemtek/utils/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(directory.path),
  );

  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MedicineCubit>()..load(),
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: IntroPage(),
      ),
    );
  }
}

