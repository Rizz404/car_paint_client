import 'dart:convert';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarModelYearColorRepo {
  final ApiClient apiClient;
  const CarModelYearColorRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarModelYearColor>>> getModels(
    int page,
    int limit,
  ) async {
    final result = await apiClient.get<PaginatedData<CarModelYearColor>>(
      ApiConstant.carModelYearColorsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarModelYearColor>(
        json,
        (json) => CarModelYearColor.fromMap(json),
      ),
    );
    return result;
  }

  Future<ApiResponse<CarModelYearColor>> saveModel(
    CarModelYearColor carModelYearColor,
  ) async {
    final result = await apiClient.post<CarModelYearColor>(
      ApiConstant.carModelYearColorsPath,
      {
        'carModelYearId': carModelYearColor.carModelYearId,
        'colorId': carModelYearColor.colorId,
      },
      fromJson: (json) => CarModelYearColor.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarModelYearColor>> updateModel(
    CarModelYearColor carModelYearColor,
  ) async {
    final result = await apiClient.patch<CarModelYearColor>(
      '${ApiConstant.carModelYearColorsPath}/${carModelYearColor.id}',
      {
        'id': carModelYearColor.id,
        'carModelYearId': carModelYearColor.carModelYearId,
        'colorId': carModelYearColor.colorId,
      },
      fromJson: (json) => CarModelYearColor.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<void>> deleteModel(String id) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.carModelYearColorsPath}/$id',
    );
    return result;
  }
}
