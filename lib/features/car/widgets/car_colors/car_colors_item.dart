// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/car/pages/car_colors/upsert_car_colors.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/main_text.dart';
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

  @override
  State<CarColorsItem> createState() => _CarColorsItemState();
}

class _CarColorsItemState extends State<CarColorsItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(UpsertCarColorsPage.route(
          carColor: widget.color,
        ))
            .then(
          (_) {
            widget.onRefresh();
          },
        ),
        child: BlocConsumer<CarColorsCubit, BaseState>(
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
                  message: "Car color deleted successfully",
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
                          text: widget.color.name,
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
