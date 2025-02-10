import "package:get_it/get_it.dart";
import "package:paint_car/data/local/user_sp.dart";
import "package:paint_car/data/network/api_client.dart";
import "package:paint_car/data/local/token_sp.dart";
import "package:paint_car/dependencies/services/log_service.dart";
import "package:paint_car/features/auth/cubit/auth_cubit.dart";
import "package:paint_car/features/auth/repo/auth_repo.dart";
import "package:paint_car/features/car/cubit/car_brands_cubit.dart";
import "package:paint_car/features/car/cubit/car_colors_cubit.dart";
import "package:paint_car/features/car/cubit/car_model_years_cubit.dart";
import "package:paint_car/features/car/cubit/car_models_cubit.dart";
import "package:paint_car/features/car/cubit/car_services_cubit.dart";
import "package:paint_car/features/car/cubit/car_workshops_cubit.dart";
import "package:paint_car/features/car/repo/car_brands_repo.dart";
import "package:paint_car/features/car/repo/car_colors_repo.dart";
import "package:paint_car/features/car/repo/car_model_years_repo.dart";
import "package:paint_car/features/car/repo/car_models_repo.dart";
import "package:paint_car/features/car/repo/car_services_repo.dart";
import "package:paint_car/features/car/repo/car_workshops_repo.dart";
import "package:paint_car/features/shared/cubit/user_cubit.dart";
import "package:paint_car/features/shared/repo/user_repo.dart";
import "package:paint_car/features/template/cubit/template_cubit.dart";
import "package:paint_car/features/template/repo/template_repo.dart";
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
  // ! template
  getIt.registerLazySingleton<TemplateRepo>(
    () => TemplateRepo(
      apiClient: getIt(),
      tokenSp: getIt(),
    ),
  );
  getIt.registerFactory<TemplateCubit>(
    () => TemplateCubit(
      templateRepo: getIt(),
    ),
  );
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
  // ! workshops
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
}
