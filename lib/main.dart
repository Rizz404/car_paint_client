import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/features/auth/cubit/auth_cubit.dart';
import 'package:paint_car/features/auth/pages/login_page.dart';
import 'package:paint_car/features/auth/pages/register_page.dart';
import 'package:paint_car/features/template/cubit/template_cubit.dart';
import 'package:paint_car/ui/config/configuration_theme.dart';
import 'package:paint_car/dependencies/sl.dart';
import 'package:paint_car/ui/simpenan/template_infinite_scroll.dart';

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
      home: const RegisterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
