import "package:get_it/get_it.dart";
import "package:paint_car/data/network/api_client.dart";
import "package:paint_car/data/local/token_sp.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;

final getIt = GetIt.instance;

initializeSL() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Register services
  getIt.registerSingleton<TokenLocal>(TokenLocal(sharedPreferences));
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(client: getIt(), tokenSp: getIt()));
}
