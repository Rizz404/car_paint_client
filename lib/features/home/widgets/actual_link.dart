import 'package:flutter/material.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class ActualLink extends StatelessWidget {
  const ActualLink({
    super.key,
    required this.text,
    required this.onTap,
    required this.leading,
  });
  final String text;
  final Function() onTap;
  final IconData leading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: MainText(text: text),
        leading: Icon(leading),
      ),
    );
  }
}
