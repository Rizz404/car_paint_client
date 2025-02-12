import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class DeleteConfirmDialog extends StatefulWidget {
  final String title;
  final String description;
  final Function() onDelete;

  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onDelete,
  });

  @override
  State<DeleteConfirmDialog> createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<DeleteConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: MainText(
        text: widget.title,
        extent: const Medium(),
      ),
      content: MainText(
        text: widget.description,
        maxLines: 2,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const MainText(
            text: "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await widget.onDelete();
          },
          child: MainText(
            text: "Delete",
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
