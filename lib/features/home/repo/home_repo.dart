import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/data/network/api_client.dart';

class HomeRepo {
  final ApiClient apiClient;
  const HomeRepo({required this.apiClient});

  Future<ApiResponse<List<CarBrand>>> getBrands() async {
    try {
      final result = await apiClient.get<List<CarBrand>>(
        ApiConstant.brandsPath,
        fromJson: (json) {
          final brandsList = json['data'] as List<dynamic>;
          return brandsList
              .map((e) => CarBrand.fromMap(e as Map<String, dynamic>))
              .toList();
        },
      );
      return result;
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }
}
