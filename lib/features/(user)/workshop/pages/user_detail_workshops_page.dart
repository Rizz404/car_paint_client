import 'package:flutter/material.dart';
import 'package:paint_car/data/models/car_workshop.dart';

class UserDetailWorkshopsPage extends StatefulWidget {
  final CarWorkshop? workshop;
  static route({
    CarWorkshop? workshop,
  }) =>
      MaterialPageRoute(
        builder: (_) => UserDetailWorkshopsPage(
          workshop: workshop,
        ),
      );
  const UserDetailWorkshopsPage({super.key, required this.workshop});

  @override
  State<UserDetailWorkshopsPage> createState() =>
      _UserDetailWorkshopsPageState();
}

class _UserDetailWorkshopsPageState extends State<UserDetailWorkshopsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workshop!.name),
      ),
      body: Center(
        child: Text('UserDetailWorkshopsPage'),
      ),
    );
  }
}
