// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/car/pages/car_models/upsert_car_models.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CarModelsItem extends StatefulWidget {
  final CarModel model;
  final Function() onDelete;
  final Function() onRefresh;
  const CarModelsItem(
      {super.key,
      required this.model,
      required this.onDelete,
      required this.onRefresh});

  @override
  State<CarModelsItem> createState() => _CarModelsItemState();
}

class _CarModelsItemState extends State<CarModelsItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(UpsertCarModelsPage.route(
          carModel: widget.model,
        ))
            .then(
          (_) {
            widget.onRefresh();
          },
        ),
        child: BlocConsumer<CarModelsCubit, BaseState>(
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
                  message: "Car model deleted successfully",
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
                          text: widget.model.name,
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
