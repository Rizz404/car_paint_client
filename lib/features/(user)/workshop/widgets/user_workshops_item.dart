// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_detail_workshops_page.dart';
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
    return Card(
        margin: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0), // TODO: DELETE NNTI
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              UserDetailWorkshopsPage.route(workshop: workshop),
            );
          },
          title: MainText(
            text: workshop.name,
          ),
          subtitle: workshop.distance != null ? Text(workshop.distance!) : null,
        ));
  }
}
