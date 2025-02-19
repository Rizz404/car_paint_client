import 'package:flutter/material.dart';
import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/car/pages/user_car_page.dart';
import 'package:paint_car/features/home/home_constants.dart';
import 'package:paint_car/features/home/widgets/actual_link.dart';

import 'package:paint_car/features/home/widgets/main_dropdown.dart';
import 'package:paint_car/features/home/widgets/title_link.dart';
import 'package:paint_car/ui/common/dropdown_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/circle_image_network.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class LeftDrawer extends StatelessWidget {
  LeftDrawer({super.key});

  List<Widget> dropdownUser(
    BuildContext context,
  ) {
    return [
      ListTile(
        leading: const Icon(Icons.car_rental),
        subtitle: const MainText(text: "Your Cars"),
        title: const MainText(text: "Car"),
        onTap: () {
          Navigator.of(context).push(UserCarPage.route());
        },
      ),
      MainDropdown(
        state: DropdownState(
          title: 'Financial',
          items: HomeConstants.financialItemsUser,
          subtitle: 'Finance',
          leadingIcon: Icons.car_rental,
        ),
      ),
      MainDropdown(
        state: DropdownState(
          title: 'Other',
          items: HomeConstants.otherItemsUser,
          subtitle: 'Other',
          leadingIcon: Icons.monetization_on,
        ),
      ),
    ];
  }

  List<Widget> dropdownSuperAdmin() {
    return [
      MainDropdown(
        state: DropdownState(
          title: 'Cars Menu',
          items: HomeConstants.carItemsSuperAdmin,
          subtitle: 'Car',
          leadingIcon: Icons.car_rental,
        ),
      ),
      MainDropdown(
        state: DropdownState(
          title: 'Financial Menu',
          items: HomeConstants.financialItemsSuperAdmin,
          subtitle: 'Financial',
          leadingIcon: Icons.monetization_on,
        ),
      ),
    ];
  }

  List<Widget> dropdownUser2(
    BuildContext context,
  ) {
    return [
      TitleLink(
        text: "Menu Car",
      ),
      ActualLink(
        text: "Your Car",
        onTap: () {
          LogService.i("est");
        },
        leading: Icons.car_rental,
      ),
      const TitleLink(
        text: "Menu Financial",
      ),
      ...HomeConstants.financialItemsUser
          .map(
            (item) => ActualLink(
              text: item['name'],
              onTap: () {
                Navigator.push(context, item['route']());
              },
              leading: Icons.monetization_on,
            ),
          )
          .toList(),
      const TitleLink(
        text: "Menu Other",
      ),
      ...HomeConstants.otherItemsUser
          .map(
            (item) => ActualLink(
              text: item['name'],
              onTap: () {
                Navigator.push(context, item['route']());
              },
              leading: Icons.help,
            ),
          )
          .toList(),
    ];
  }

  List<Widget> dropdownSuperAdmin2(
    BuildContext context,
  ) {
    return [
      const TitleLink(
        text: "Menu Car",
      ),
      ...HomeConstants.carItemsSuperAdmin
          .map(
            (item) => ActualLink(
              text: item['name'],
              onTap: () {
                Navigator.push(context, item['route']());
              },
              leading: Icons.car_rental,
            ),
          )
          .toList(),
      const TitleLink(
        text: "Menu Financial",
      ),
      ...HomeConstants.financialItemsSuperAdmin
          .map(
            (item) => ActualLink(
              text: item['name'],
              onTap: () {
                Navigator.push(context, item['route']());
              },
              leading: Icons.monetization_on,
            ),
          )
          .toList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final role = context.userRole;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    CircleImageNetwork(
                      imageUrl: context.currentUser?.profileImage,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          text: " ${context.currentUser?.username}",
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        MainText(
                          text: " ${context.currentUser?.email}",
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (role == UserRole.USER) ...dropdownUser2(context),
          if (role == UserRole.SUPER_ADMIN) ...dropdownSuperAdmin2(context),
          // if (role == UserRole.USER) ...dropdownUser(context),
          // if (role == UserRole.SUPER_ADMIN) ...dropdownSuperAdmin(),
        ],
      ),
    );
  }
}
