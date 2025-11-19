import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:paint_car/features/(admin)/cubit/admin_orders_cubit.dart';
import 'package:paint_car/features/(guest)/auth/cubit/auth_cubit.dart';
import 'package:paint_car/features/(guest)/auth/wrapper/auth_wrapper.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_workshops_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/e_tickets_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/history_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/orders_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/transactions_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_history_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_transactions_cubit.dart';
import 'package:paint_car/features/(user)/financial/user_e_tickets_cubit.dart';
import 'package:paint_car/features/(user)/profile/cubit/profile_cubit.dart';
import 'package:paint_car/features/(user)/workshop/cubit/user_workshops_cubit.dart';
import 'package:paint_car/features/shared/cubit/theme_cubit.dart';
import 'package:paint_car/features/shared/cubit/theme_state.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/dependencies/sl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestAndroidNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> requestNotificationPermissions() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  await requestAndroidNotificationPermission();
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  await initializeSL();

  runApp(
    MultiBlocProvider(
      providers: [
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _removeSplashScreen();
  }

  Future<void> _removeSplashScreen() async {
    // Atur durasi splash screen di sini (dalam detik)
    // Ganti angka 3 dengan durasi yang Anda inginkan
    await Future.delayed(const Duration(seconds: 2));

    // Hapus splash screen setelah durasi selesai
    FlutterNativeSplash.remove();
  }

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
