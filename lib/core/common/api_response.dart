import 'package:paint_car/core/types/pagination.dart';

sealed class ApiResponse<T> {
  final String message;
  final T? data;

  const ApiResponse({
    required this.message,
    this.data,
  });
}

class ApiSuccess<T> extends ApiResponse<T> {
  const ApiSuccess({
    required super.message,
    required T super.data,
  });
}

class ApiSuccessPagination<T> extends ApiSuccess<T> {
  final Pagination pagination;

  ApiSuccessPagination({
    required super.message,
    required super.data,
    required this.pagination,
  });
}

class ApiError<T> extends ApiResponse<T> {
  final String error;

  const ApiError({
    required super.message,
    this.error = '',
  });
}
