// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/features/auth/cubit/auth_cubit.dart';
import 'package:paint_car/features/auth/pages/login_page.dart';
import 'package:paint_car/features/auth/wrapper/auth_wrapper.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/car/cubit/car_model_years_cubit.dart';
import 'package:paint_car/features/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/car/cubit/car_workshops_cubit.dart';
import 'package:paint_car/features/car/pages/car_services/car_services_page.dart';
import 'package:paint_car/features/car/pages/car_workshops/car_workshops_page.dart';
import 'package:paint_car/features/financial/cubit/e_tickets_cubit.dart';
import 'package:paint_car/features/financial/cubit/orders_cubit.dart';
import 'package:paint_car/features/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/features/financial/cubit/transactions_cubit.dart';
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
        BlocProvider(
          create: (context) => getIt<CarBrandsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CarModelsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CarServicesCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CarWorkshopsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CarColorsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CarModelYearsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CarModelYearsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CarModelYearColorCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ETicketCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<OrdersCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<PaymentMethodCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<TransactionsCubit>(),
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
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
