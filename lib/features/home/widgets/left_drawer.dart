import 'package:flutter/material.dart';
import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/car/pages/user_car_page.dart';
import 'package:paint_car/features/home/home_constants.dart';

import 'package:paint_car/features/home/widgets/main_dropdown.dart';
import 'package:paint_car/ui/common/dropdown_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

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
            child: MainText(
              text: role == UserRole.USER ? 'User' : "Admin",
              extent: const Large(),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          if (role == UserRole.USER) ...dropdownUser(context),
          if (role == UserRole.SUPER_ADMIN) ...dropdownSuperAdmin(),
        ],
      ),
    );
  }
}
