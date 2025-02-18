sealed class ApiResponse<T> {
  final String? message;
  final T? data;

  const ApiResponse({
    this.message,
    this.data,
  });
}

class ApiSuccess<T> extends ApiResponse<T> {
  const ApiSuccess({
    super.message,
    super.data,
  });
}

class ApiError<T> extends ApiResponse<T> {
  final dynamic errors;

  const ApiError({
    required super.message,
    this.errors,
  });
}

class ApiNoInternet<T> extends ApiResponse<T> {
  const ApiNoInternet({
    required super.message,
  });
}
