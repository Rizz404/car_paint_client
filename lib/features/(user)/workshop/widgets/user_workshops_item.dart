// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_detail_workshops_page.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class UserWorkshopsItem extends StatefulWidget {
  final CarWorkshop workshop;
  final Function() onRefresh;
  const UserWorkshopsItem(
      {super.key, required this.workshop, required this.onRefresh});

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
    // old() {
    //   return ListTile(
    //     onTap: () {
    //       Navigator.of(context).push(
    //         UserDetailWorkshopsPage.route(workshop: workshop),
    //       );
    //     },
    //     title: MainText(
    //       text: workshop.name,
    //     ),
    //     subtitle: workshop.distance != null ? Text(workshop.distance!) : null,
    //   );
    // }

    return Material(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              UserDetailWorkshopsPage.route(workshop: workshop),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              const ImageNetwork(
                src:
                    "https://i.pinimg.com/736x/b6/53/c1/b653c128eb1017e5983388c6fc3e9bf1.jpg",
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
                  ),
                  MainText(
                    text: workshop.address,
                    maxLines: 2,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                        ),
                        MainText(text: workshop.distance ?? 'N/A')
                      ],
                    ),
                  )
                ],
              ))
            ],
          ).paddingAll(8)),
    ).paddingSymmetric(vertical: 8, horizontal: 16);
  }
}
