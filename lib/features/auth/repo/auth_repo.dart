import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/local/token_sp.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/dependencies/services/log_service.dart';

class AuthRepo {
  final ApiClient apiClient;
  final TokenLocal tokenSp;
  const AuthRepo({required this.apiClient, required this.tokenSp});

  Future<ApiResponse<void>> register(
      String username, String email, String password) async {
    try {
      final result = await apiClient.post<void>(
        ApiConstant.registerPath,
        {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      if (result is ApiError) {
        return ApiError(message: result.message, errors: result.errors);
      }
      return ApiSuccess(message: result.message);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  Future<ApiResponse<void>> login(String email, String password) async {
    try {
      final result = await apiClient.post<String>(
        ApiConstant.loginPath,
        {
          'email': email,
          'password': password,
        },
        fromJson: (json) => json['newAccessToken'] as String,
      );
      if (result is ApiError) {
        return ApiError(
            message: result.message,
            errors: (result as ApiError<String>).errors);
      }

      await tokenSp.saveToken(result.data as String);

      return ApiSuccess(message: result.message, data: null);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }
}
