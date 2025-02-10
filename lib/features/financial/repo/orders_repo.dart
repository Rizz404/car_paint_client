import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';

class OrdersRepo {
  final ApiClient apiClient;
  const OrdersRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<Orders>>> getModels(
    int page,
    int limit,
  ) async {
    final result = await apiClient.get<PaginatedData<Orders>>(
      ApiConstant.ordersPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<Orders>(
        json,
        (json) => Orders.fromMap(json),
      ),
    );
    return result;
  }
}
