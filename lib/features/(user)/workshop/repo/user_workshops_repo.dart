// ignore_for_file: unused_import

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class UserWorkshopsRepo {
  final ApiClient apiClient;
  const UserWorkshopsRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarWorkshop>>> getNearestWorkshop(
    int page,
    int limit,
    double latitude,
    double longitude,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.post<PaginatedData<CarWorkshop>>(
      "${ApiConstant.workshopsPath}/nearest",
      queryParameters: buildPaginationParams(page, limit),
      {
        'latitude': latitude,
        'longitude': longitude,
      },
      fromJson: (json) => fromJsonPagination<CarWorkshop>(
        json,
        (json) => CarWorkshop.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<PaginatedData<CarWorkshop>>> getWorkshops(
    int page,
    int limit,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.get<PaginatedData<CarWorkshop>>(
      ApiConstant.workshopsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarWorkshop>(
        json,
        (json) => CarWorkshop.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarWorkshop>> saveWorkshop(
    CarWorkshop carWorkshop,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.post<CarWorkshop>(
      ApiConstant.workshopsPath,
      {
        'name': carWorkshop.name,
      },
      fromJson: (json) => CarWorkshop.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<CarWorkshop>> updateWorkshop(
    CarWorkshop carWorkshop,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.patch<CarWorkshop>(
      '${ApiConstant.workshopsPath}/${carWorkshop.id}',
      {
        'id': carWorkshop.id,
        'name': carWorkshop.name,
      },
      fromJson: (json) => CarWorkshop.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<void>> deleteWorkshop(
    String id,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.workshopsPath}/$id',
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }
}
