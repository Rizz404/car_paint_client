import "package:get_it/get_it.dart";
import "package:paint_car/data/local/user_sp.dart";
import "package:paint_car/data/network/api_client.dart";
import "package:paint_car/data/local/token_sp.dart";
import "package:paint_car/dependencies/services/log_service.dart";
import "package:paint_car/features/(guest)/auth/cubit/auth_cubit.dart";
import "package:paint_car/features/(guest)/auth/repo/auth_repo.dart";
import "package:paint_car/features/(superadmin)/car/cubit/car_brands_cubit.dart";
import "package:paint_car/features/(superadmin)/car/cubit/car_colors_cubit.dart";
import "package:paint_car/features/(superadmin)/car/cubit/car_model_year_color_cubit.dart";
import "package:paint_car/features/(superadmin)/car/cubit/car_model_years_cubit.dart";
import "package:paint_car/features/(superadmin)/car/cubit/car_models_cubit.dart";
import "package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart";
import "package:paint_car/features/(superadmin)/car/cubit/car_workshops_cubit.dart";
import "package:paint_car/features/(superadmin)/car/repo/car_brands_repo.dart";
import "package:paint_car/features/(superadmin)/car/repo/car_colors_repo.dart";
import "package:paint_car/features/(superadmin)/car/repo/car_model_year_color_repo.dart";
import "package:paint_car/features/(superadmin)/car/repo/car_model_years_repo.dart";
import "package:paint_car/features/(superadmin)/car/repo/car_models_repo.dart";
import "package:paint_car/features/(superadmin)/car/repo/car_services_repo.dart";
import "package:paint_car/features/(superadmin)/car/repo/car_workshops_repo.dart";
import "package:paint_car/features/(superadmin)/financial/cubit/e_tickets_cubit.dart";
import "package:paint_car/features/(superadmin)/financial/cubit/history_cubit.dart";
import "package:paint_car/features/(superadmin)/financial/cubit/orders_cubit.dart";
import "package:paint_car/features/(superadmin)/financial/cubit/payment_method_cubit.dart";
import "package:paint_car/features/(superadmin)/financial/cubit/transactions_cubit.dart";
import "package:paint_car/features/(superadmin)/financial/repo/e_tickets_repo.dart";
import "package:paint_car/features/(superadmin)/financial/repo/history_repo.dart";
import "package:paint_car/features/(superadmin)/financial/repo/orders_repo.dart";
import "package:paint_car/features/(superadmin)/financial/repo/payment_method_repo.dart";
import "package:paint_car/features/(superadmin)/financial/repo/transactions_repo.dart";
import "package:paint_car/features/(user)/car/cubit/user_car_cubit.dart";
import "package:paint_car/features/(user)/car/repo/user_car_repo.dart";
import "package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart";
import "package:paint_car/features/(user)/financial/cubit/user_transactions_cubit.dart";
import "package:paint_car/features/(user)/financial/repo/user_orders_repo.dart";
import "package:paint_car/features/(user)/financial/repo/user_transactions_repo.dart";
import "package:paint_car/features/(user)/workshop/cubit/user_workshops_cubit.dart";
import "package:paint_car/features/(user)/workshop/repo/user_workshops_repo.dart";
import "package:paint_car/features/shared/cubit/user_cubit.dart";
import "package:paint_car/features/shared/repo/user_repo.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;

final getIt = GetIt.instance;

initializeSL() async {
  // !
  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  getIt.registerSingleton<LogService>(LogService());
  getIt.registerSingleton<TokenLocal>(TokenLocal(getIt()));
  getIt.registerSingleton<UserLocal>(UserLocal(getIt()));
  //  !
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(client: getIt(), tokenSp: getIt()),
  );

  // ! GUEST

  // ! user
  getIt.registerLazySingleton<UserRepo>(
    () => UserRepo(
      getIt(),
      getIt(),
    ),
  );
  getIt.registerFactory<UserCubit>(
    () => UserCubit(
      userRepo: getIt(),
    ),
  );
  // ! auth
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(
      apiClient: getIt(),
      tokenSp: getIt(),
      userSp: getIt(),
    ),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepo: getIt()));
  // ! USER
  getIt.registerLazySingleton<UserCarRepo>(
    () => UserCarRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<UserCarCubit>(
    () => UserCarCubit(
      userCarRepo: getIt(),
    ),
  );
  getIt.registerLazySingleton<UserWorkshopsRepo>(
    () => UserWorkshopsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<UserWorkshopCubit>(
    () => UserWorkshopCubit(
      userWorkshopRepo: getIt(),
    ),
  );
  getIt.registerLazySingleton<UserOrdersRepo>(
    () => UserOrdersRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<UserOrdersCubit>(
    () => UserOrdersCubit(
      userOrdersRepo: getIt(),
    ),
  );
  getIt.registerLazySingleton<UserTransactionsRepo>(
    () => UserTransactionsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<UserTransactionsCubit>(
    () => UserTransactionsCubit(
      userTransactionsRepo: getIt(),
    ),
  );

  // ! SUPERADMIN

  // ! brands
  getIt.registerLazySingleton<CarBrandsRepo>(
    () => CarBrandsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<CarBrandsCubit>(
    () => CarBrandsCubit(
      carBrandsRepo: getIt(),
    ),
  );
  // ! models
  getIt.registerLazySingleton<CarModelsRepo>(
    () => CarModelsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<CarModelsCubit>(
    () => CarModelsCubit(
      carModelsRepo: getIt(),
    ),
  );
  // ! services
  getIt.registerLazySingleton<CarServicesRepo>(
    () => CarServicesRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<CarServicesCubit>(
    () => CarServicesCubit(
      carServicesRepo: getIt(),
    ),
  );
  // ! workshops
  getIt.registerLazySingleton<CarWorkshopsRepo>(
    () => CarWorkshopsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<CarWorkshopsCubit>(
    () => CarWorkshopsCubit(
      carWorkshopsRepo: getIt(),
    ),
  );
  // ! car colors
  getIt.registerLazySingleton<CarColorsRepo>(
    () => CarColorsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<CarColorsCubit>(
    () => CarColorsCubit(
      carColorsRepo: getIt(),
    ),
  );
  // ! car model years
  getIt.registerLazySingleton<CarModelYearsRepo>(
    () => CarModelYearsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<CarModelYearsCubit>(
    () => CarModelYearsCubit(
      carModelYearsRepo: getIt(),
    ),
  );
  getIt.registerLazySingleton<CarModelYearColorRepo>(
    () => CarModelYearColorRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<CarModelYearColorCubit>(
    () => CarModelYearColorCubit(
      carModelYearColorRepo: getIt(),
    ),
  );
  // ! e ticket
  getIt.registerLazySingleton<ETicketRepo>(
    () => ETicketRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<ETicketCubit>(
    () => ETicketCubit(
      eTicketRepo: getIt(),
    ),
  );
  // ! orders
  getIt.registerLazySingleton<OrdersRepo>(
    () => OrdersRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(
      ordersRepo: getIt(),
    ),
  );
  // ! payment method
  getIt.registerLazySingleton<PaymentMethodRepo>(
    () => PaymentMethodRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<PaymentMethodCubit>(
    () => PaymentMethodCubit(
      paymentMethodRepo: getIt(),
    ),
  );
  // ! transactions
  getIt.registerLazySingleton<TransactionsRepo>(
    () => TransactionsRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<TransactionsCubit>(
    () => TransactionsCubit(
      transactionsRepo: getIt(),
    ),
  );
  // ! transactions
  getIt.registerLazySingleton<HistoryRepo>(
    () => HistoryRepo(
      apiClient: getIt(),
    ),
  );
  getIt.registerFactory<HistoryCubit>(
    () => HistoryCubit(
      historyRepo: getIt(),
    ),
  );
}
