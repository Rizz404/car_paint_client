import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          color: CustomColors.secondaryBlue,
        ),
      ),
    );
  }
}
