import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/build_pagination_params.dart';
import 'package:paint_car/features/shared/utils/from_json_pagination.dart';

class TransactionsRepo {
  final ApiClient apiClient;
  const TransactionsRepo({required this.apiClient});

  Future<ApiResponse<PaginatedData<Transactions>>> getModels(
    int page,
    int limit,
  ) async {
    final result = await apiClient.get<PaginatedData<Transactions>>(
      ApiConstant.transactionsPath,
      queryParameters: buildPaginationParams(page, limit),
      fromJson: (json) => fromJsonPagination<Transactions>(
        json,
        (json) => Transactions.fromMap(json),
      ),
    );
    return result;
  }
}
