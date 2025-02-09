import 'package:paint_car/data/local/token_sp.dart';
import 'package:paint_car/data/local/user_sp.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/services/log_service.dart';

class UserRepo {
  final UserLocal userSp;
  final TokenLocal tokenSp;
  const UserRepo(
    this.userSp,
    this.tokenSp,
  );

  Future<UserWithProfile?> getUserLocal() async {
    try {
      return userSp.getUser();
    } catch (e) {
      // TODO: DELETE LATERR

      LogService.e("Error dari repo: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await tokenSp.removeToken();
      await userSp.removeUser();
    } catch (e) {
      // TODO: DELETE LATERR

      LogService.e("Error dari repo: $e");
    }
  }
}
