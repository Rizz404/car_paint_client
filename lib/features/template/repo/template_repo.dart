import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/local/token_sp.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/data/network/api_client.dart';

class TemplateRepo {
  final ApiClient apiClient;
  final TokenLocal tokenSp;
  const TemplateRepo({required this.apiClient, required this.tokenSp});

  Future<ApiResponse<PaginatedData<CarBrand>>> getBrands(
    int page,
    int limit,
  ) async {
    try {
      final result = await apiClient.get<PaginatedData<CarBrand>>(
        ApiConstant.brandsPath,
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
        fromJson: (json) {
          // ! ngambil data dari json['data']
          final brands = json['data'] as List<dynamic>;
          final items = brands
              .map((e) => CarBrand.fromMap(e as Map<String, dynamic>))
              .toList();
          final pagination =
              Pagination.fromMap(json['pagination'] as Map<String, dynamic>);
          return PaginatedData<CarBrand>(
            items: items,
            pagination: pagination,
          );
        },
      );
      return result;
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  Future<ApiResponse<String?>> getToken() async {
    try {
      return ApiSuccess(
        data: tokenSp.getToken(),
      );
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      await tokenSp.removeToken();
      return const ApiSuccess();
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }
}
