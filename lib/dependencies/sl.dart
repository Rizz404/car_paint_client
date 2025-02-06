import "package:get_it/get_it.dart";
import "package:paint_car/data/network/api_client.dart";
import "package:paint_car/data/local/token_sp.dart";
import "package:paint_car/dependencies/services/log_service.dart";
import "package:paint_car/features/template/cubit/template_cubit.dart";
import "package:paint_car/features/template/repo/template_repo.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;

final getIt = GetIt.instance;

initializeSL() async {
  getIt.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  getIt.registerSingleton<LogService>(LogService());
  getIt.registerSingleton<TokenLocal>(TokenLocal(getIt()));
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(client: getIt(), tokenSp: getIt()));
  getIt.registerLazySingleton<TemplateRepo>(
      () => TemplateRepo(apiClient: getIt()));
  getIt.registerFactory<TemplateCubit>(
      () => TemplateCubit(templateRepo: getIt()));
}
