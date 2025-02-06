import 'package:flutter/material.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';

void showErrorSnackBar(BuildContext context, BaseErrorState state) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  String errorMsg = state.message ?? "Unknown Error";

  if (state.errors != null &&
      state.errors is List &&
      (state.errors as List).isNotEmpty) {
    final errorList = state.errors as List;
    errorMsg = "";
    for (var error in errorList) {
      if (error['message'] != null) {
        errorMsg += "${error['message']}\n";
      }
    }
    errorMsg = errorMsg.trim();
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMsg),
    ),
  );
}
