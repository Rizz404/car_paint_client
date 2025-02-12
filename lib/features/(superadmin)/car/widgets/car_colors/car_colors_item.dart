// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_colors/upsert_car_colors.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/delete_confirm_dialog.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/format_date.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CarColorsItem extends StatefulWidget {
  final CarColor color;
  final Function() onDelete;
  final Function() onRefresh;
  const CarColorsItem(
      {super.key,
      required this.color,
      required this.onDelete,
      required this.onRefresh});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocConsumer<CarColorsCubit, BaseState>(
        listener: (context, state) {
          handleFormListenerState(
            context: context,
            state: state,
            onRetry: () {
              onDelete();
            },
            onSuccess: () {
              Navigator.pop(context);
            },
          );
        },
        builder: (context, state) {
          return DeleteConfirmDialog(
            title: "Delete ${color.name}?",
            description: "Are you sure you want to delete this color?",
            onDelete: () async {
              await onDelete();
            },
          );
        },
      ),
    );
  }

  @override
  State<CarColorsItem> createState() => _CarColorsItemState();
}

class _CarColorsItemState extends State<CarColorsItem> {
  late final CarColor color;
  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // TODO: DELETE NNTI
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .push(UpsertCarColorsPage.route(carColor: color))
            .then((_) => widget.onRefresh()),
        title: MainText(
          text: color.name,
        ),
        subtitle: color.createdAt != null
            ? MainText(
                text:
                    "Created at: ${FormatDate.createdAt(color.createdAt!.toString())}",
              )
            : null,
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
          onPressed: () => widget._confirmDelete(context),
        ),
      ),
    );
  }
}
