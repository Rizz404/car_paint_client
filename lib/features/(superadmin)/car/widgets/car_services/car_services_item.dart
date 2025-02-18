// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_services/upsert_car_services.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CarServicesItem extends StatefulWidget {
  final CarService service;
  final Function() onDelete;
  final Function() onRefresh;
  const CarServicesItem(
      {super.key,
      required this.service,
      required this.onDelete,
      required this.onRefresh});

  @override
  State<CarServicesItem> createState() => _CarServicesItemState();
}

class _CarServicesItemState extends State<CarServicesItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(UpsertCarServicesPage.route(
          carService: widget.service,
        ))
            .then(
          (_) {
            widget.onRefresh();
          },
        ),
        child: BlocConsumer<CarServicesCubit, BaseState>(
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
                  message: "Car service deleted successfully",
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
                          text: widget.service.name,
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
