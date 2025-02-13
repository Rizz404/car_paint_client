// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/car/pages/upsert_user_car_page.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/delete_confirm_dialog.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class UserCarItem extends StatefulWidget {
  final UserCar userCar;
  final Function() onDelete;
  final Function() onRefresh;
  const UserCarItem(
      {super.key,
      required this.userCar,
      required this.onDelete,
      required this.onRefresh});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocConsumer<UserCarCubit, BaseState>(
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
            title: "Delete ${userCar.licensePlate}?",
            description: "Are you sure you want to delete this userCar?",
            onDelete: () async {
              await onDelete();
            },
          );
        },
      ),
    );
  }

  @override
  State<UserCarItem> createState() => _UserCarItemState();
}

class _UserCarItemState extends State<UserCarItem> {
  late final UserCar userCar;
  @override
  void initState() {
    super.initState();
    userCar = widget.userCar;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // TODO: DELETE NNTI
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .push(UpsertUserCarPage.route(userCar: userCar))
            .then((_) => widget.onRefresh()),
        leading: userCar.carImages?.first != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageNetwork(
                  src: userCar.carImages!.first!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image),
              ),
        title: MainText(
          text: userCar.licensePlate,
        ),
        // subtitle: userCar.country != null ? Text(userCar.country!) : null,
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
          onPressed: () => widget._confirmDelete(context),
        ),
      ),
    );
  }
}
