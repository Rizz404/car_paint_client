// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:paint_car/features/(user)/paint/pages/user_detail_vehicle_paint.dart';
import 'package:paint_car/features/(user)/service/widgets/card_choose_service.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_text.dart';

// ! design example
class UserChooseServicePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserChooseServicePage());
  const UserChooseServicePage({super.key});

  @override
  State<UserChooseServicePage> createState() => _UserChooseServicePageState();
}

class _UserChooseServicePageState extends State<UserChooseServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Pilih Layanan"),
      body: SingleChildScrollView(
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainText(
              text: "Mau Cat Apa Hari Ini Sob?",
              extent: Medium(),
            ),
            GestureDetector(
              onTap: () {},
              child: Column(
                spacing: 16,
                children: [
                  CardChooseService(
                    imageAsset: "assets/images/car/red_car.png",
                    title: "Mobil",
                    onTap: () {
                      Navigator.of(context).push(
                        UserDetailVehiclePaintPage.route(),
                      );
                    },
                  ),
                  // CardChooseService(
                  //   imageAsset: "assets/images/motorcycle/red_motorcycle.png",
                  //   title: "Motor",
                  //   onTap: () {},
                  //   isDisabled: true,
                  // ),
                ],
              ),
            )
          ],
        )
            .paddingSymmetric(
              horizontal: 16,
            )
            .paddingOnly(top: 16),
      ),
    );
  }
}
