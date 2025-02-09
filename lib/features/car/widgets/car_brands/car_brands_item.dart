// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/pages/car_brands/upsert_car_brands_page.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CarBrandsItem extends StatefulWidget {
  final CarBrand brand;
  final Function() onDelete;
  final Function() onRefresh;
  const CarBrandsItem(
      {super.key,
      required this.brand,
      required this.onDelete,
      required this.onRefresh});

  @override
  State<CarBrandsItem> createState() => _CarBrandsItemState();
}

class _CarBrandsItemState extends State<CarBrandsItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(UpsertCarBrandsPage.route(
          carBrand: widget.brand,
        ))
            .then(
          (_) {
            widget.onRefresh();
          },
        ),
        child: BlocConsumer<CarBrandsCubit, BaseState>(
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
                  message: "Car brand deleted successfully",
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
                  children: [
                    Text(widget.brand.name),
                    IconButton(
                        onPressed: () {
                          widget.onDelete();
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
                Image.network(
                  widget.brand.logo!,
                  fit: BoxFit.contain,
                  headers: const {"Cache-Control": "max-age=604800"},
                  cacheHeight: 100,
                  height: 100,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    // TODO: REPLACE AMA PLACEHOLDER IMAGE DARI PT
                    return Image.asset(
                      "assets/images/placeholder-image-general.webp",
                      fit: BoxFit.contain,
                      height: 100,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
