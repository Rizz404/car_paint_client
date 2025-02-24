import 'dart:convert';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarServicesRepo {
  final ApiClient apiClient;
  const CarServicesRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarService>>> getServices(
    int page,
    int limit,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.get<PaginatedData<CarService>>(
      ApiConstant.servicesPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarService>(
        json,
        (json) => CarService.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarService>> saveService(
    CarService carService,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.post<CarService>(
      ApiConstant.servicesPath,
      {
        'name': carService.name,
        'price': int.parse(carService.price),
      },
      fromJson: (json) => CarService.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<List<CarService>>> saveManyServices(
    List<CarService> carServices,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.post<List<CarService>>(
      ApiConstant.multipleServicesPath,
      {
        'services': jsonEncode(carServices.map((e) => e.toMap()).toList()),
      },
      fromJson: (json) =>
          (json as List).map((e) => CarService.fromMap(e)).toList(),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<CarService>> updateService(
    CarService carService,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.patch<CarService>(
      '${ApiConstant.servicesPath}/${carService.id}',
      {
        'id': carService.id,
        'price': carService.price,
        'name': carService.name,
      },
      fromJson: (json) => CarService.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<void>> deleteService(
    String id,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.servicesPath}/$id',
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }
}
