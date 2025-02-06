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

class ApiError<T> extends ApiResponse<T> {
  const ApiError({
    required super.message,
  });
}

class ApiNoInternet<T> extends ApiResponse<T> {
  const ApiNoInternet({
    required super.message,
  });
}
