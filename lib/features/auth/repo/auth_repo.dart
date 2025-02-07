import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/local/token_sp.dart';
import 'package:paint_car/data/local/user_sp.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class AuthRepo {
  final ApiClient apiClient;
  final UserLocal userSp;
  final TokenLocal tokenSp;
  const AuthRepo({
    required this.apiClient,
    required this.tokenSp,
    required this.userSp,
  });

  Future<ApiResponse<void>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final result = await apiClient.post<void>(
        ApiConstant.registerPath,
        {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      return await handleApiResponse(result);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  Future<ApiResponse<void>> login(String email, String password) async {
    try {
      final result = await apiClient.post<UserWithProfile>(
        ApiConstant.loginPath,
        {
          'email': email,
          'password': password,
        },
        fromJson: (json) {
          return UserWithProfile.fromMap(json);
        },
      );

      if (result is ApiSuccess) {
        await tokenSp.saveToken(result.data?.newAccessToken ?? "");
        if (result.data == null) {
          return const ApiError(message: ApiConstant.unknownError);
        }
        await userSp.saveUser(result.data!);
      }

      return await handleApiResponse(result);
    } catch (e) {
      LogService.e(e.toString());
      return ApiError(message: e.toString());
    }
  }
}
