import 'package:flutter/material.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

void fileValidatorSize(
  BuildContext context,
  int fileSize,
) {
  if (fileSize > 5 * 1024 * 1024) {
    SnackBarUtil.showSnackBar(
      context: context,
      message: "Image size must be less than 5MB",
      type: SnackBarType.error,
    );
    return;
  }
}
