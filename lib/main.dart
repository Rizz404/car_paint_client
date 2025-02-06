import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/features/home/cubit/home_cubit.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'dependencies/sl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSL();
  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<HomeCubit>())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
