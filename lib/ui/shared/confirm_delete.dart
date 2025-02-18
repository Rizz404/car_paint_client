import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

void confirmDelete({
  required BuildContext context,
  required Function() onDelete,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const MainText(
        text: "Delete Brand",
        extent: Medium(),
      ),
      content:
          const MainText(text: "Are you sure you want to delete this brand?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const MainText(text: "Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Successfully deleted",
              type: SnackBarType.success,
            );
          },
          child: MainText(
            text: "Delete",
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    ),
  );
}
