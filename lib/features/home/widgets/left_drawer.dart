import 'package:flutter/material.dart';
import 'package:paint_car/features/home/home_constants.dart';

import 'package:paint_car/features/home/widgets/main_dropdown.dart';
import 'package:paint_car/ui/common/dropdown_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class LeftDrawer extends StatelessWidget {
  LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: MainText(
              text: 'Admin Drawer Header',
              extent: const Large(),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          MainDropdown(
            state: DropdownState(
              title: 'Cars Menu',
              items: HomeConstants.carItems,
              subtitle: 'Car',
              leadingIcon: Icons.car_rental,
            ),
          ),
          MainDropdown(
            state: DropdownState(
              title: 'Financial Menu',
              items: HomeConstants.financialItems,
              subtitle: 'Car',
              leadingIcon: Icons.monetization_on,
            ),
          ),
        ],
      ),
    );
  }
}
