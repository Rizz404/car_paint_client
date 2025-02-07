import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/ui/utils/show_error_form_snackbar.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

typedef RetryCallback = void Function();
typedef SuccessCallback = void Function();

void handleFormListenerState({
  required BuildContext context,
  required dynamic state,
  required RetryCallback onRetry,
  required SuccessCallback onSuccess,
}) {
  if (state is BaseSuccessState) {
    onSuccess();
  }

  if (state is BaseErrorState) {
    showFormErrorSnackbar(
      context,
      state,
    );
  }

  if (state is BaseNoInternetState) {
    SnackBarUtil.showSnackBar(
      context: context,
      message: state.message ?? ApiConstant.noInternetConnection,
      type: SnackBarType.noInternet,
      action: SnackBarAction(
        label: "Retry",
        onPressed: onRetry,
      ),
    );
  }
}
