import 'dart:convert';
import 'dart:io';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class UserCarRepo {
  final ApiClient apiClient;
  const UserCarRepo({required this.apiClient});

  static const String keyImageFile = 'carImages';

  Future<ApiResponse<PaginatedData<UserCar>>> getUserCars(
    int page,
    int limit,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.get<PaginatedData<UserCar>>(
      ApiConstant.userCarsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<UserCar>(
        json,
        (json) => UserCar.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<UserCar>> saveUserCar(
    UserCar userCar,
    List<File> imageFiles,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.post<UserCar>(
      ApiConstant.userCarsPath,
      {
        'carModelYearColorId': userCar.carModelYearColorId,
        'licensePlate': userCar.licensePlate,
      },
      isMultiPart: true,
      imageFiles: imageFiles,
      keyImageFile: keyImageFile,
      fromJson: (json) => UserCar.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<UserCar>> updateUserCar(
    UserCar userCar,
    List<File>? imageFiles,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.patch<UserCar>(
      '${ApiConstant.userCarsPath}/${userCar.id}',
      {
        'id': userCar.id,
        'carModelYearColorId': userCar.carModelYearColorId,
        'licensePlate': userCar.licensePlate,
      },
      isMultiPart: true,
      imageFiles: imageFiles,
      keyImageFile: keyImageFile,
      fromJson: (json) => UserCar.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<void>> deleteUserCar(
    String id,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.userCarsPath}/$id',
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }
}
