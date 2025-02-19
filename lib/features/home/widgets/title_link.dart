import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class TitleLink extends StatelessWidget {
  const TitleLink({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MainText(
        text: text,
        extent: const Medium(),
      ),
    );
  }
}
