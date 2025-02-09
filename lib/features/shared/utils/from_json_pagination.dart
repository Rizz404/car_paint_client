import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';

PaginatedData<T> fromJsonPagination<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic>) fromMap,
) {
  final items = json['data'] as List<dynamic>;
  final itemsData =
      items.map((e) => fromMap(e as Map<String, dynamic>)).toList();
  final pagination =
      Pagination.fromMap(json['pagination'] as Map<String, dynamic>);
  return PaginatedData<T>(
    items: itemsData,
    pagination: pagination,
  );
}
