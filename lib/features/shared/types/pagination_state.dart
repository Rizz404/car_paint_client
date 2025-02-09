import 'package:paint_car/core/types/pagination.dart';

class PaginationState<T> {
  final List<T> brands;
  final Pagination pagination;
  final int currentPage;
  final bool isLoadingMore;

  PaginationState({
    required this.brands,
    required this.pagination,
    required this.currentPage,
    required this.isLoadingMore,
  });
}
