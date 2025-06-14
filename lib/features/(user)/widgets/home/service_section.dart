import 'package:flutter/material.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/features/(user)/profile/pages/profile_page.dart';
import 'package:paint_car/features/(user)/service/pages/user_choose_service_page.dart';
import 'package:paint_car/features/(user)/widgets/home/card_link_section.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key, required this.onRetry, this.user});
  final UserWithProfile? user;

  final Future<void> Function() onRetry;

  firstService(
    BuildContext context,
  ) {
    return CardLinkSection(
      text: "Order Disini",
      onTap: () {
        // ! BEKAS REVISI

        if (user?.userProfile?.phoneNumber == null) {
          SnackBarUtil.showSnackBar(
            context: context,
            message: "Harus input nomor telepon dulu untuk order",
            type: SnackBarType.warning,
          );
          if (user == null) return;

          Navigator.of(context).push(
            ProfilePage.route(user: user!),
          );
          return;
        }
        // ! BEKAS REVISI
        // Navigator.of(context).push(UserWorkshopsPage.route());
        Navigator.of(context).push(UserChooseServicePage.route());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        const MainText(
          text: "Layanan",
          extent: Large(),
        ),
        firstService(context),
      ],
    );
  }
}
