import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_model_color.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarModelColorRepo {
  final ApiClient apiClient;
  const CarModelColorRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarModelColor>>> getCarModelColors(
    int page,
    int limit,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.get<PaginatedData<CarModelColor>>(
      ApiConstant.carModelColorsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarModelColor>(
        json,
        (json) => CarModelColor.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<PaginatedData<CarModelColor>>> getCarModelColorsByModelId(
    int page,
    int limit,
    CancelToken cancelToken,
    String modelId,
  ) async {
    final result = await apiClient.get<PaginatedData<CarModelColor>>(
      "${ApiConstant.carModelColorsByCarModelIdPath}/$modelId",
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarModelColor>(
        json,
        (json) => CarModelColor.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarModelColor>> saveModel(
    CarModelColor carModelColor,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.post<CarModelColor>(
      ApiConstant.carModelColorsPath,
      {
        'carModelId': carModelColor.carModelId,
        'colorId': carModelColor.colorId,
      },
      fromJson: (json) => CarModelColor.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<CarModelColor>> updateModel(
    CarModelColor carModelColor,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.patch<CarModelColor>(
      '${ApiConstant.carModelColorsPath}/${carModelColor.id}',
      {
        'id': carModelColor.id,
        'colorId': carModelColor.colorId,
        'carModelId': carModelColor.carModelId,
      },
      fromJson: (json) => CarModelColor.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<void>> deleteModel(
    String id,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.carModelColorsPath}/$id',
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }
}
