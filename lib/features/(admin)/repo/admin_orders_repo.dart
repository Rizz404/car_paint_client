import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class AdminOrdersRepo {
  final ApiClient apiClient;
  const AdminOrdersRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<Orders>>> getOrders(
    int page,
    int limit,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.get<PaginatedData<Orders>>(
      ApiConstant.ordersPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<Orders>(
        json,
        (json) => Orders.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<Orders>> cancelOrder(
    CancelToken cancelToken,
    String orderId,
  ) async {
    final result = await apiClient.patch<Orders>(
      "${ApiConstant.ordersCancel}/$orderId",
      {},
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }
}
