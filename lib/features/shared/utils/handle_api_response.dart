import 'package:paint_car/core/common/api_response.dart';

Future<ApiResponse<T>> handleApiResponse<T>(
  ApiResponse<T> result, {
  bool isGet = true,
}) async {
  if (result is ApiError) {
    if (isGet) {
      return ApiError(message: result.message);
    }
    // ! ini kalo error pas bukan get, dari zod
    return ApiError(
      message: result.message,
      errors: (result as ApiError).errors,
    );
  }
  if (result is ApiNoInternet) {
    return ApiNoInternet(message: result.message);
  }
  // ! gausah return ApiSuccess, karena udah di handle
  return result;
}
