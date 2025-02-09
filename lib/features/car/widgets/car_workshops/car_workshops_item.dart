// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_workshops_cubit.dart';
import 'package:paint_car/features/car/pages/car_workshops/upsert_car_workshops.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CarWorkshopsItem extends StatefulWidget {
  final CarWorkshop workshop;
  final Function() onDelete;
  final Function() onRefresh;
  const CarWorkshopsItem(
      {super.key,
      required this.workshop,
      required this.onDelete,
      required this.onRefresh});

  @override
  State<CarWorkshopsItem> createState() => _CarWorkshopsItemState();
}

class _CarWorkshopsItemState extends State<CarWorkshopsItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(UpsertCarWorkshopsPage.route(
          carWorkshop: widget.workshop,
        ))
            .then(
          (_) {
            widget.onRefresh();
          },
        ),
        child: BlocConsumer<CarWorkshopsCubit, BaseState>(
          listener: (context, state) {
            handleFormListenerState(
              context: context,
              state: state,
              onRetry: () {
                widget.onDelete();
              },
              onSuccess: () {
                SnackBarUtil.showSnackBar(
                  context: context,
                  message: "Car workshop deleted successfully",
                  type: SnackBarType.success,
                );
                Navigator.pop(context);
              },
            );
          },
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: SizedBox(
                        height: 100,
                        child: MainText(
                          text: widget.workshop.name,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          widget.onDelete();
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
