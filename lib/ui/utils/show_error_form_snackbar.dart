import 'package:flutter/material.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

void showFormErrorSnackbar(BuildContext context, BaseErrorState state) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  String errorMsg = state.message ?? "Unknown Error";

  if (state.errors != null &&
      state.errors is List &&
      (state.errors as List).isNotEmpty) {
    final errorList = state.errors as List;
    List<String> messages = [];

    for (var error in errorList) {
      if (error is Map && error['message'] != null) {
        messages.add(error['message'].toString().trim());
      }
    }

    if (messages.isNotEmpty) {
      errorMsg = messages.join(" | ");
    }
  }

  // ngapus semua \n
  errorMsg = errorMsg.replaceAll("\n", " ");

  SnackBarUtil.showSnackBar(
    context: context,
    message: "Error: $errorMsg",
    type: SnackBarType.error,
  );
}
