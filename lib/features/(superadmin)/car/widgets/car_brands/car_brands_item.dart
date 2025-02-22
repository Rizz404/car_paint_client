// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_brands/upsert_car_brands_page.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/delete_confirm_dialog.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class CarBrandsItem extends StatefulWidget {
  final CarBrand brand;
  final Function() onDelete;
  final Function() onRefresh;
  const CarBrandsItem(
      {super.key,
      required this.brand,
      required this.onDelete,
      required this.onRefresh});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocConsumer<CarBrandsCubit, BaseState>(
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
            title: "Delete ${brand.name}?",
            description: "Are you sure you want to delete this brand?",
            onDelete: () async {
              await onDelete();
            },
          );
        },
      ),
    );
  }

  @override
  State<CarBrandsItem> createState() => _CarBrandsItemState();
}

class _CarBrandsItemState extends State<CarBrandsItem> {
  late final CarBrand brand;
  @override
  void initState() {
    super.initState();
    brand = widget.brand;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // TODO: DELETE NNTI
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      child: ListTile(
        onTap: () => Navigator.of(context)
            .push(UpsertCarBrandsPage.route(carBrand: brand))
            .then((_) => widget.onRefresh()),
        leading: brand.logo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageNetwork(
                  src: brand.logo!,
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
          text: brand.name,
        ),
        subtitle: brand.country != null ? Text(brand.country!) : null,
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
          onPressed: () => widget._confirmDelete(context),
        ),
      ),
    );
  }
}
