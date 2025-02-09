import 'package:paint_car/core/types/pagination.dart';

class PaginationState<T> {
  final List<T> data;
  final Pagination pagination;
  final int currentPage;
  final bool isLoadingMore;

  PaginationState({
    required this.data,
    required this.pagination,
    required this.currentPage,
    required this.isLoadingMore,
  });
}
