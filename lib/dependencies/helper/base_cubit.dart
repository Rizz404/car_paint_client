import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/core/common/api_response.dart';

Future<void> handleBaseCubit<T>(
  Function(BaseState state) emit,
  Future<ApiResponse<T>> Function() apiCall, {
  Function(T data, String? message)? onSuccess,
  bool withLoading = true,
}) async {
  try {
    if (withLoading) {
      emit(const BaseLoadingState());
    }
    final result = await apiCall();

    switch (result) {
      case ApiSuccess<T> success:
        if (onSuccess != null) {
          onSuccess(
            success.data as T,
            success.message,
          );
        } else {
          emit(BaseSuccessState(success.data, success.message));
        }
        break;
      case ApiError<T> error:
        emit(BaseErrorState(message: error.message, errors: error.errors));
        break;
      case ApiNoInternet noInternet:
        emit(
          BaseNoInternetState(
            noInternet.message ?? ApiConstant.noInternetConnection,
          ),
        );
        break;
    }
  } catch (e) {
    emit(
      BaseErrorState(
        message: 'Unexpected error: $e',
      ),
    );
  }
}
