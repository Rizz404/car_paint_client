// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_model_year_color/upsert_car_model_year_color_.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CarModelYearColorItem extends StatefulWidget {
  final CarModelYearColor model;
  final Function() onDelete;
  final Function() onRefresh;

  const CarModelYearColorItem(
      {super.key,
      required this.model,
      required this.onDelete,
      required this.onRefresh});

  @override
  State<CarModelYearColorItem> createState() => _CarModelYearColorItemState();
}

class _CarModelYearColorItemState extends State<CarModelYearColorItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(UpsertCarModelYearColor.route(
          carModelYearColor: widget.model,
        ))
            .then(
          (_) {
            widget.onRefresh();
          },
        ),
        child: BlocConsumer<CarModelYearColorCubit, BaseState>(
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
                        child: Column(
                          children: [
                            MainText(
                              text: widget.model.carModelYear!.year.toString(),
                            ),
                            MainText(
                              text: widget.model.color!.name.toString(),
                            ),
                          ],
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
