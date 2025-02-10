import 'dart:convert';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_model_years.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarModelYearsRepo {
  final ApiClient apiClient;
  const CarModelYearsRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarModelYears>>> getModelYears(
    int page,
    int limit,
  ) async {
    final result = await apiClient.get<PaginatedData<CarModelYears>>(
      ApiConstant.carModelYearsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarModelYears>(
        json,
        (json) => CarModelYears.fromMap(json),
      ),
    );
    return result;
  }

  Future<ApiResponse<CarModelYears>> saveModel(
    CarModelYears carModelYears,
  ) async {
    final result = await apiClient.post<CarModelYears>(
      ApiConstant.carModelYearsPath,
      {
        'carModelId': carModelYears.carModelId,
        'year': carModelYears.year,
      },
      fromJson: (json) => CarModelYears.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarModelYears>> updateModel(
    CarModelYears carModelYears,
  ) async {
    final result = await apiClient.patch<CarModelYears>(
      '${ApiConstant.carModelYearsPath}/${carModelYears.id}',
      {
        'id': carModelYears.id,
        'carModelId': carModelYears.carModelId,
        'year': carModelYears.year,
      },
      fromJson: (json) => CarModelYears.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<void>> deleteModel(String id) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.carModelYearsPath}/$id',
    );
    return result;
  }
}
