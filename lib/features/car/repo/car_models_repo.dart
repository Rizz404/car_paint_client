import 'dart:convert';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarModelsRepo {
  final ApiClient apiClient;
  const CarModelsRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarModel>>> getModels(
    int page,
    int limit,
  ) async {
    final result = await apiClient.get<PaginatedData<CarModel>>(
      ApiConstant.modelsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarModel>(
        json,
        (json) => CarModel.fromMap(json),
      ),
    );
    return result;
  }

  Future<ApiResponse<CarModel>> saveModel(
    CarModel carModelCarModel,
  ) async {
    final result = await apiClient.post<CarModel>(
      ApiConstant.modelsPath,
      {
        'name': carModelCarModel.name,
        'carBrandId': carModelCarModel.carBrandId,
      },
      fromJson: (json) => CarModel.fromMap(json),
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<List<CarModel>>> saveManyModels(
    List<CarModel> carModelCarModels,
  ) async {
    final result = await apiClient.post<List<CarModel>>(
      ApiConstant.multipleModelsPath,
      {
        'models': jsonEncode(carModelCarModels.map((e) => e.toMap()).toList()),
      },
      fromJson: (json) =>
          (json as List).map((e) => CarModel.fromMap(e)).toList(),
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<CarModel>> updateModel(
    CarModel carModelCarModel,
  ) async {
    final result = await apiClient.patch<CarModel>(
      '${ApiConstant.modelsPath}/${carModelCarModel.id}',
      {
        'name': carModelCarModel.name,
        'carBrandId': carModelCarModel.carBrandId,
      },
      fromJson: (json) => CarModel.fromMap(json),
    );
    return await handleApiResponse(result, isGet: false);
  }

  Future<ApiResponse<void>> deleteModel(String id) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.modelsPath}/$id',
    );
    return result;
  }
}
