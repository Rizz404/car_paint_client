import 'package:flutter/material.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/car/pages/user_car_page.dart';
import 'package:paint_car/features/(user)/widgets/home/card_link_section.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_workshops_page.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key, required this.onRetry});
  final Future<void> Function() onRetry;

  firstService() {
    return StateHandler<UserCarCubit, PaginationState<UserCar>>(
      onRetry: () => onRetry(),
      onSuccess: (context, data, message) {
        final cars = data.data;
        return CardLinkSection(
          text: "Order Here",
          onTap: () {
            if (cars.isEmpty) {
              SnackBarUtil.showSnackBar(
                context: context,
                message: "Harus input mobil dulu untuk order",
                type: SnackBarType.warning,
              );
              Navigator.of(context).push(UserCarPage.route());
              return;
            }
            Navigator.of(context).push(UserWorkshopsPage.route());
          },
        );
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
          text: "Services",
          extent: Large(),
        ),
        firstService(),
      ],
    );
  }
}
