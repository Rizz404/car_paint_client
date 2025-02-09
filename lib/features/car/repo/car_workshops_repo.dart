import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarWorkshopsRepo {
  final ApiClient apiClient;
  const CarWorkshopsRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarWorkshop>>> getWorkshops(
    int page,
    int limit,
  ) async {
    final result = await apiClient.get<PaginatedData<CarWorkshop>>(
      ApiConstant.workshopsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarWorkshop>(
        json,
        (json) => CarWorkshop.fromMap(json),
      ),
    );
    return result;
  }

  Future<ApiResponse<CarWorkshop>> saveWorkshop(
    CarWorkshop carWorkshopCarWorkshop,
  ) async {
    final result = await apiClient.post<CarWorkshop>(
      ApiConstant.workshopsPath,
      {
        "name": carWorkshopCarWorkshop.name,
        "email": carWorkshopCarWorkshop.email,
        "phoneNumber": carWorkshopCarWorkshop.phoneNumber,
        "address": carWorkshopCarWorkshop.address,
        "latitude": carWorkshopCarWorkshop.latitude,
        "longitude": carWorkshopCarWorkshop.longitude,
      },
      fromJson: (json) => CarWorkshop.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarWorkshop>> updateWorkshop(
    CarWorkshop carWorkshopCarWorkshop,
  ) async {
    final result = await apiClient.patch<CarWorkshop>(
      '${ApiConstant.workshopsPath}/${carWorkshopCarWorkshop.id}',
      {
        "id": carWorkshopCarWorkshop.id,
        "name": carWorkshopCarWorkshop.name,
        "email": carWorkshopCarWorkshop.email,
        "phoneNumber": carWorkshopCarWorkshop.phoneNumber,
        "address": carWorkshopCarWorkshop.address,
        "latitude": carWorkshopCarWorkshop.latitude,
        "longitude": carWorkshopCarWorkshop.longitude,
      },
      fromJson: (json) => CarWorkshop.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<void>> deleteWorkshop(String id) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.workshopsPath}/$id',
    );
    return result;
  }
}
