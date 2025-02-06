import 'package:paint_car/core/types/pagination.dart';

class PaginatedData<T> {
  final List<T> items;
  final Pagination pagination;

  PaginatedData({
    required this.items,
    required this.pagination,
  });
}
