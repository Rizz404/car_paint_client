import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class UserOrdersRepo {
  final ApiClient apiClient;
  const UserOrdersRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<Orders>>> getOrders(
    int page,
    int limit,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.get<PaginatedData<Orders>>(
      ApiConstant.ordersUserPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<Orders>(
        json,
        (json) => Orders.fromMap(json),
      ),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }

  Future<ApiResponse<Transactions>> createOrder(
    CancelToken cancelToken,
    String userCarId,
    String paymentMethodId,
    String workshopId,
    String? note,
    List<String> carServices,
  ) async {
    final result = await apiClient.post<Transactions>(
      ApiConstant.ordersPath,
      fromJson: (json) => Transactions.fromMap(json),
      {
        'userCarId': userCarId,
        'paymentMethodId': paymentMethodId,
        'workshopId': workshopId,
        'note': note,
        'carServices': carServices.map((id) => {'carServiceId': id}).toList(),
      },
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result);
  }
}
