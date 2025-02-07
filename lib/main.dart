import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/features/auth/cubit/auth_cubit.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/features/template/cubit/template_cubit.dart';
import 'package:paint_car/ui/config/configuration_theme.dart';
import 'package:paint_car/dependencies/sl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSL();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<TemplateCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ConfigurationTheme.colorScheme,
        useMaterial3: true,
        appBarTheme: ConfigurationTheme.appBarTheme(context),
        textTheme: ConfigurationTheme.textTheme,
        elevatedButtonTheme: ConfigurationTheme.elevatedButtonTheme,
        fontFamilyFallback: ['Poppins'],
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
