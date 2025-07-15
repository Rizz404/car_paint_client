// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/dependencies/services/socket.dart';
import 'package:paint_car/features/(admin)/cubit/admin_orders_cubit.dart';
import 'package:paint_car/features/(guest)/auth/cubit/auth_cubit.dart';
import 'package:paint_car/features/(guest)/auth/pages/login_page.dart';
import 'package:paint_car/features/(guest)/auth/wrapper/auth_wrapper.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_model_years_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_workshops_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_services/car_services_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_workshops/car_workshops_page.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/e_tickets_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/history_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/orders_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/transactions_cubit.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_history_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_transactions_cubit.dart';
import 'package:paint_car/features/(user)/financial/user_e_tickets_cubit.dart';
import 'package:paint_car/features/(user)/profile/cubit/profile_cubit.dart';
import 'package:paint_car/features/(user)/workshop/cubit/user_workshops_cubit.dart';
import 'package:paint_car/features/cubit/notification_cubit.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'package:paint_car/features/shared/cubit/theme_cubit.dart';
import 'package:paint_car/features/shared/cubit/theme_state.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/ui/config/configuration_theme.dart';
import 'package:paint_car/dependencies/sl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestAndroidNotificationPermission() async {
  // Cek status izin notifikasi
  if (await Permission.notification.isDenied) {
    // Meminta izin notifikasi
    await Permission.notification.request();
  }
}

Future<void> requestNotificationPermissions() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Untuk iOS
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  // Untuk Android 13 (API level 33) dan di atasnya menggunakan permission_handler
  await requestAndroidNotificationPermission();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  await initializeSL();
  await requestNotificationPermissions();

  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => getIt<NotificationCubit>(),
        // ),
        // ! SUPERADMIN
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserCubit>()..getUserLocal(),
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
        // BlocProvider(
        //   create: (context) => getIt<CarModelYearsCubit>(),
        // ),

        // BlocProvider(
        //   create: (context) => getIt<CarModelYearColorCubit>(),
        // ),
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
        BlocProvider(
          create: (context) => getIt<HistoryCubit>(),
        ),
        // ! USER
        // BlocProvider(
        //   create: (context) => getIt<UserCarCubit>(),
        // ),
        BlocProvider(
          create: (context) => getIt<UserWorkshopCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserOrdersCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserTransactionsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserHistoryCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserETicketsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProfileCubit>(),
        ),
        // ! ADMIN
        BlocProvider(
          create: (context) => getIt<AdminOrdersCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ThemeCubit>()..initializeTheme(),
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
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Nikken Paint',
          theme: themeState.themeData,
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
