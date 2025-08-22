import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_detail_workshops_page.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class UserWorkshopsItem extends StatefulWidget {
  final CarWorkshop workshop;
  final Function() onRefresh;
  final VehicleData? vehicleData;
  final List<String> carServices;
  final String carModelColorId;

  final String carColorId;
  final String carModelId;
  final double totalPrice;
  final int totalAllServices;
  final List<File> carColors;

  const UserWorkshopsItem({
    super.key,
    required this.workshop,
    required this.onRefresh,
    this.vehicleData,
    required this.carColors,
    required this.carModelId,
    required this.carColorId,
    required this.carModelColorId,
    required this.carServices,
    required this.totalPrice,
    required this.totalAllServices,
  });

  @override
  State<UserWorkshopsItem> createState() => _UserWorkshopsItemState();
}

class _UserWorkshopsItemState extends State<UserWorkshopsItem> {
  late final CarWorkshop workshop;
  @override
  void initState() {
    super.initState();
    workshop = widget.workshop;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.adaptivePrimaryCard,
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            UserDetailWorkshopsPage.route(
              workshop: workshop,
              vehicleData: widget.vehicleData,
              carServices: widget.carServices,
              carModelId: widget.carModelId,
              carColorId: widget.carColorId,
              carModelColorId: widget.carModelColorId,
              totalPrice: widget.totalPrice,
              totalAllServices: widget.totalAllServices,
              carColors: widget.carColors,
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Image.asset(
              "assets/images/workshop/automotive.png",
              width: 90,
              height: 90,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  MainText(
                    text: workshop.name,
                    maxLines: 2,
                    extent: const Medium(),
                    color: context.adaptiveTextColor,
                  ),
                  MainText(
                    text: workshop.address,
                    color: context.adaptiveSecondaryTextColor,
                    maxLines: 2,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on,
                            size: 16,
                            color: context.adaptiveSecondaryTextColor),
                        MainText(
                            text: workshop.distance ?? 'N/A',
                            color: context.adaptiveSecondaryTextColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).paddingAll(8),
      ),
    ).paddingSymmetric(vertical: 8, horizontal: 16);
  }
}
