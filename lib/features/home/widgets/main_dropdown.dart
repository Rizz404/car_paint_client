import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/dropdown_state.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class MainDropdown extends StatelessWidget {
  final DropdownState state;

  const MainDropdown({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.only(left: 12),
      leading: Icon(state.leadingIcon),
      subtitle: MainText(
        text: state.subtitle,
      ),
      childrenPadding: const EdgeInsets.only(left: 32),
      title: MainText(
        text: state.title,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      children: state.items.map((subItem) {
        return ListTile(
          title: Text(subItem['name']),
          onTap: () {
            Navigator.push(context, subItem['route']());
          },
        );
      }).toList(),
    );
  }
}
