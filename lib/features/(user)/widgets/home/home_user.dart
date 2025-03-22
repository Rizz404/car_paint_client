import 'package:flutter/material.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/features/(user)/widgets/home/banner_slider.dart';
import 'package:paint_car/features/(user)/widgets/home/list_style_welcome.dart';
import 'package:paint_car/features/(user)/widgets/home/service_section.dart';
import 'package:paint_car/ui/extension/padding.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key, required this.onRetry});
  final Future<void> Function() onRetry;
  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  // buttonOrder() {
  //   return StateHandler<UserCarCubit, PaginationState<UserCar>>(
  //     onRetry: () => widget.onRetry(),
  //     onSuccess: (context, data, message) {
  //       final cars = data.data;
  //       return MainElevatedButton(
  //         onPressed: () {
  //           if (cars.isEmpty) {
  //             SnackBarUtil.showSnackBar(
  //               context: context,
  //               message: "Harus input mobil dulu untuk order",
  //               type: SnackBarType.warning,
  //             );
  //             Navigator.of(context).push(UserCarPage.route());
  //             return;
  //           }

  //           Navigator.of(context).push(UserWorkshopsPage.route());
  //         },
  //         text: "Order Disini",
  //       );
  //     },
  //   );
  // }
  // buttonOrder() {
  //   return MainElevatedButton(
  //     onPressed: () {
  //       Navigator.of(context).push(UserWorkshopsPage.route());
  //     },
  //     text: "Order Disini",
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const NotificationScreen(),
              //       ),
              //     );
              //   },
              //   child: const Text('ke notif screen'),
              // ),
              ListStyleWelcome(
                user: context.currentUser,
              ),
              const BannerSlider(),
              ServiceSection(
                onRetry: widget.onRetry,
                user: context.currentUser,
              ),
            ],
          ),
        ),
      ).paddingSymmetric(vertical: 24),
    );
  }
}
