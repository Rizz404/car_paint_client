import 'package:paint_car/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocal {
  final SharedPreferences _prefs;

  UserLocal(this._prefs);

  UserWithProfile? getUser() {
    final userJson = _prefs.getString('user_profile');
    if (userJson == null) return null;
    return UserWithProfile.fromJson(userJson);
  }

  Future<bool> saveUser(UserWithProfile user) {
    final userJson = user.toJson();
    return _prefs.setString('user_profile', userJson);
  }

  Future<bool> removeUser() => _prefs.remove('user_profile');
}
