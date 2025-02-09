import 'dart:io';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class CarBrandsRepo {
  final ApiClient apiClient;
  const CarBrandsRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<CarBrand>>> getBrands(
    int page,
    int limit,
  ) async {
    final result = await apiClient.get<PaginatedData<CarBrand>>(
      ApiConstant.brandsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<CarBrand>(
        json,
        (json) => CarBrand.fromMap(json),
      ),
    );
    return result;
  }

  Future<ApiResponse<CarBrand>> saveBrand(
    CarBrand carBrand,
    File imageFile,
  ) async {
    final result = await apiClient.post<CarBrand>(
      ApiConstant.brandsPath,
      {
        'name': carBrand.name,
        'country': carBrand.country,
      },
      isMultiPart: true,
      imageFile: imageFile,
      fromJson: (json) => CarBrand.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<CarBrand>> updateBrand(
    CarBrand carBrand,
    File? imageFile,
  ) async {
    final result = await apiClient.patch<CarBrand>(
      '${ApiConstant.brandsPath}/${carBrand.id}',
      {
        'name': carBrand.name,
        'country': carBrand.country,
      },
      isMultiPart: true,
      imageFile: imageFile,
      fromJson: (json) => CarBrand.fromMap(json),
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<void>> deleteBrand(String id) async {
    final result = await apiClient.delete<void>(
      '${ApiConstant.brandsPath}/$id',
    );
    return result;
  }
}
