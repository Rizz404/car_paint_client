// ignore_for_file: unused_import

import 'dart:convert';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarColorsRepo {
  final ApiClient apiClient;
  const CarColorsRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarColor>>> getColors(
    int page,
    int limit,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.get<PaginatedData<CarColor>>(
      ApiConstant.colorsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarColor>(
        json,
        (json) => CarColor.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarColor>> saveColor(
    CarColor carColorCarColor,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.post<CarColor>(
      ApiConstant.colorsPath,
      {
        'name': carColorCarColor.name,
      },
      fromJson: (json) => CarColor.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<CarColor>> updateColor(
    CarColor carColorCarColor,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.patch<CarColor>(
      '${ApiConstant.colorsPath}/${carColorCarColor.id}',
      {
        'id': carColorCarColor.id,
        'name': carColorCarColor.name,
      },
      fromJson: (json) => CarColor.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<void>> deleteColor(
    String id,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.colorsPath}/$id',
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }
}
