import 'package:shared_preferences/shared_preferences.dart';

class TokenLocal {
  final SharedPreferences _prefs;

  TokenLocal(this._prefs);

  // Contoh method untuk penyimpanan data
  String? getToken() => _prefs.getString('auth_token');
  Future<bool> saveToken(String token) => _prefs.setString('auth_token', token);
  Future<bool> removeToken() => _prefs.remove('auth_token');

  // Tambahkan method lain sesuai kebutuhan
}
